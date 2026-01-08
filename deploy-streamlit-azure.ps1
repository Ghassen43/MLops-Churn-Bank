# Deploy Streamlit App to Azure
$ErrorActionPreference = "Stop"

# Configuration
$RESOURCE_GROUP = "rg-mlops-bank-churn"
$LOCATION = "francecentral"
$ACR_NAME = "mlopsghassen"
$CONTAINER_APP_NAME = "bank-churn-ui"
$CONTAINERAPPS_ENV = "env-mlops-workshop"
$IMAGE_NAME = "bank-churn-streamlit"
$IMAGE_TAG = "v1"
$TARGET_PORT = 8501

Write-Host "`nDeploiement Streamlit App sur Azure`n" -ForegroundColor Cyan

# Check Azure login
Write-Host "Verification du contexte Azure..." -ForegroundColor Yellow
try {
    $account = az account show | ConvertFrom-Json
    Write-Host "Connecte a Azure: $($account.name)" -ForegroundColor Green
} catch {
    Write-Host "Non connecte. Executez 'az login'" -ForegroundColor Red
    exit 1
}

# Get ACR details
Write-Host "`nRecuperation des informations ACR..." -ForegroundColor Yellow
$ACR_LOGIN_SERVER = (az acr show --name $ACR_NAME --query loginServer -o tsv).Trim()
$ACR_USER = (az acr credential show --name $ACR_NAME --query username -o tsv).Trim()
$ACR_PASS = (az acr credential show --name $ACR_NAME --query "passwords[0].value" -o tsv).Trim()
$IMAGE = "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"

Write-Host "ACR Server: $ACR_LOGIN_SERVER" -ForegroundColor Cyan

# Login to ACR
Write-Host "`nConnexion a ACR..." -ForegroundColor Yellow
az acr login --name $ACR_NAME

# Build and Push Streamlit image
Write-Host "`nBuild de l'image Streamlit..." -ForegroundColor Yellow
docker build -f Dockerfile.streamlit -t "${IMAGE_NAME}:${IMAGE_TAG}" .
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"
docker tag "${IMAGE_NAME}:${IMAGE_TAG}" "$ACR_LOGIN_SERVER/${IMAGE_NAME}:latest"
docker push "$ACR_LOGIN_SERVER/${IMAGE_NAME}:${IMAGE_TAG}"
docker push "$ACR_LOGIN_SERVER/${IMAGE_NAME}:latest"
Write-Host "Image pushee dans ACR" -ForegroundColor Green

# Deploy Container App
Write-Host "`nDeploiement de la Container App Streamlit..." -ForegroundColor Yellow
$ErrorActionPreference = "Continue"
$appCheck = az containerapp show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP 2>&1
$ErrorActionPreference = "Stop"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Mise a jour..." -ForegroundColor Yellow
    az containerapp update `
        --name $CONTAINER_APP_NAME `
        --resource-group $RESOURCE_GROUP `
        --image $IMAGE `
        --registry-server $ACR_LOGIN_SERVER `
        --registry-username $ACR_USER `
        --registry-password $ACR_PASS `
        --output none
} else {
    Write-Host "Creation..." -ForegroundColor Yellow
    az containerapp create `
        --name $CONTAINER_APP_NAME `
        --resource-group $RESOURCE_GROUP `
        --environment $CONTAINERAPPS_ENV `
        --image $IMAGE `
        --ingress external `
        --target-port $TARGET_PORT `
        --registry-server $ACR_LOGIN_SERVER `
        --registry-username $ACR_USER `
        --registry-password $ACR_PASS `
        --min-replicas 1 `
        --max-replicas 2 `
        --cpu 1.0 `
        --memory 2.0Gi `
        --output none
}
Write-Host "Container App Streamlit deployee" -ForegroundColor Green

# Get URL
$APP_URL = (az containerapp show `
    --name $CONTAINER_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query properties.configuration.ingress.fqdn -o tsv).Trim()

# Summary
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "DEPLOIEMENT STREAMLIT REUSSI" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "App Name  : $CONTAINER_APP_NAME" -ForegroundColor Cyan
Write-Host "Region    : $LOCATION" -ForegroundColor Cyan
Write-Host "RG        : $RESOURCE_GROUP" -ForegroundColor Cyan
Write-Host "`nURL Streamlit:" -ForegroundColor Yellow
Write-Host "https://$APP_URL" -ForegroundColor White
Write-Host "`nCommandes utiles:" -ForegroundColor Yellow
Write-Host "Logs: az containerapp logs show --name $CONTAINER_APP_NAME --resource-group $RESOURCE_GROUP --follow" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Green

# Test
Write-Host "`nTest de l'application..." -ForegroundColor Yellow
Start-Sleep -Seconds 10
try {
    $response = Invoke-WebRequest -Uri "https://$APP_URL" -Method Get -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "Application Streamlit operationnelle!" -ForegroundColor Green
    }
} catch {
    Write-Host "L'application demarre... Testez manuellement dans quelques secondes." -ForegroundColor Yellow
}

Write-Host "`nDeploiement termine`n" -ForegroundColor Green
Write-Host "Ouvrez: https://$APP_URL dans votre navigateur" -ForegroundColor Cyan
