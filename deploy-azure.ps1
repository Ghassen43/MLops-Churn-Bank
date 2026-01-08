# Azure Bank Churn Deployment Script
$ErrorActionPreference = "Stop"

# Configuration
$RESOURCE_GROUP = "rg-mlops-bank-churn"
$LOCATION = "francecentral"
$FALLBACK_LOCATION = "francecentral"
$USERNAME = $env:USERNAME.ToLower() -replace '[^a-z0-9]', ''
$ACR_NAME = "mlops$USERNAME"
$CONTAINER_APP_NAME = "bank-churn"
$CONTAINERAPPS_ENV = "env-mlops-workshop"
$IMAGE_NAME = "bank-churn-api"
$IMAGE_TAG = "v1"
$TARGET_PORT = 8000

Write-Host "`nDeploiement Bank Churn API sur Azure`n" -ForegroundColor Cyan

# Check Azure login
Write-Host "Verification du contexte Azure..." -ForegroundColor Yellow
try {
    $account = az account show | ConvertFrom-Json
    Write-Host "Connecte a Azure: $($account.name)" -ForegroundColor Green
} catch {
    Write-Host "Non connecte. Executez 'az login'" -ForegroundColor Red
    exit 1
}

# Check extensions
Write-Host "`nVerification des extensions..." -ForegroundColor Yellow
$extensions = az extension list | ConvertFrom-Json
if (-not ($extensions | Where-Object { $_.name -eq "containerapp" })) {
    Write-Host "Installation containerapp..." -ForegroundColor Yellow
    az extension add --name containerapp --upgrade --yes --only-show-errors
    Write-Host "Extension installee" -ForegroundColor Green
} else {
    Write-Host "Extension OK" -ForegroundColor Green
}

# Register providers
Write-Host "`nEnregistrement des providers..." -ForegroundColor Yellow
az provider register --namespace Microsoft.ContainerRegistry --wait
az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.Web --wait
az provider register --namespace Microsoft.OperationalInsights --wait
Write-Host "Providers enregistres" -ForegroundColor Green

# Create Resource Group
Write-Host "`nCreation du Resource Group..." -ForegroundColor Yellow
az group create --name $RESOURCE_GROUP --location $LOCATION --output none
Write-Host "Resource Group cree: $RESOURCE_GROUP" -ForegroundColor Green

# Create ACR
Write-Host "`nCreation de l'Azure Container Registry..." -ForegroundColor Yellow
Write-Host "Nom ACR: $ACR_NAME" -ForegroundColor Cyan

$acrCreated = $false
try {
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true --location $LOCATION --output none 2>$null
    $acrCreated = $true
    Write-Host "ACR cree dans $LOCATION" -ForegroundColor Green
} catch {
    Write-Host "Tentative en $FALLBACK_LOCATION..." -ForegroundColor Yellow
    $LOCATION = $FALLBACK_LOCATION
    az acr create --resource-group $RESOURCE_GROUP --name $ACR_NAME --sku Basic --admin-enabled true --location $LOCATION --output none
    $acrCreated = $true
    Write-Host "ACR cree dans $LOCATION" -ForegroundColor Green
}

Start-Sleep -Seconds 5

# Login to ACR
Write-Host "`nConnexion a ACR..." -ForegroundColor Yellow
az acr login --name $ACR_NAME
$ACR_LOGIN_SERVER = (az acr show --name $ACR_NAME --query loginServer -o tsv).Trim()
Write-Host "ACR Server: $ACR_LOGIN_SERVER" -ForegroundColor Cyan

$ACR_USER = (az acr credential show --name $ACR_NAME --query username -o tsv).Trim()
$ACR_PASS = (az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv).Trim()
$IMAGE = "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"

# Build and Push
Write-Host "`nBuild et push de l'image..." -ForegroundColor Yellow
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "$ACR_LOGIN_SERVER/${IMAGE_NAME}:latest"
docker push "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"
docker push "$ACR_LOGIN_SERVER/${IMAGE_NAME}:latest"
Write-Host "Image pushee dans ACR" -ForegroundColor Green

# Create Log Analytics
$LAW_NAME = "law-mlops-$USERNAME-$(Get-Random)"
Write-Host "`nCreation Log Analytics: $LAW_NAME..." -ForegroundColor Yellow
az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --workspace-name $LAW_NAME --location $LOCATION --output none
Start-Sleep -Seconds 10

$LAW_ID = (az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $LAW_NAME --query customerId -o tsv).Trim()
$LAW_KEY = (az monitor log-analytics workspace get-shared-keys --resource-group $RESOURCE_GROUP --workspace-name $LAW_NAME --query primarySharedKey -o tsv).Trim()
Write-Host "Log Analytics cree" -ForegroundColor Green

# Create Container App Environment
Write-Host "`nCreation du Container Apps Environment..." -ForegroundColor Yellow
$ErrorActionPreference = "Continue"
$envCheck = az containerapp env show --name $CONTAINERAPPS_ENV --resource-group $RESOURCE_GROUP 2>&1
$ErrorActionPreference = "Stop"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Environment existe deja" -ForegroundColor Green
} else {
    az containerapp env create --name $CONTAINERAPPS_ENV --resource-group $RESOURCE_GROUP --location $LOCATION --logs-workspace-id $LAW_ID --logs-workspace-key $LAW_KEY --output none
    Write-Host "Environment cree: $CONTAINERAPPS_ENV" -ForegroundColor Green
}

# Deploy Container App
Write-Host "`nDeploiement de la Container App..." -ForegroundColor Yellow
$ErrorActionPreference = "Continue"
$appCheck = az containerapp show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP 2>&1
$ErrorActionPreference = "Stop"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Mise a jour..." -ForegroundColor Yellow
    az containerapp update --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --image $IMAGE --registry-server $ACR_LOGIN_SERVER --registry-username $ACR_USER --registry-password $ACR_PASS --output none
} else {
    Write-Host "Creation..." -ForegroundColor Yellow
    az containerapp create --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --environment $CONTAINERAPPS_ENV --image $IMAGE --ingress external --target-port $TARGET_PORT --registry-server $ACR_LOGIN_SERVER --registry-username $ACR_USER --registry-password $ACR_PASS --min-replicas 1 --max-replicas 1 --output none
}
Write-Host "Container App deployee" -ForegroundColor Green

# Get URL
$APP_URL = (az containerapp show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --query properties.configuration.ingress.fqdn -o tsv).Trim()

# Summary
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "DEPLOIEMENT REUSSI" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "ACR       : $ACR_NAME" -ForegroundColor Cyan
Write-Host "Region    : $LOCATION" -ForegroundColor Cyan
Write-Host "RG        : $RESOURCE_GROUP" -ForegroundColor Cyan
Write-Host "`nURLs:" -ForegroundColor Yellow
Write-Host "API       : https://$APP_URL" -ForegroundColor White
Write-Host "Health    : https://$APP_URL/health" -ForegroundColor White
Write-Host "Docs      : https://$APP_URL/docs" -ForegroundColor White
Write-Host "`nCommandes utiles:" -ForegroundColor Yellow
Write-Host "Logs: az containerapp logs show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor Gray
Write-Host "Supprimer: az group delete --name $RESOURCE_GROUP --yes --no-wait" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Green

# Test API
Write-Host "`nTest de l'API..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
try {
    $response = Invoke-RestMethod -Uri "https://$APP_URL/health" -Method Get
    Write-Host "API operationnelle: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "L'API demarre... Testez manuellement." -ForegroundColor Yellow
}

Write-Host "`nDeploiement termine`n" -ForegroundColor Green
