# Test local Docker image
Write-Host "`nTest Local API Bank Churn`n" -ForegroundColor Cyan

$IMAGE_NAME = "bank-churn-api"
$IMAGE_TAG = "v1"
$CONTAINER_NAME = "bank-churn-test"
$PORT = 8000

# Cleanup
Write-Host "Nettoyage..." -ForegroundColor Yellow
docker stop $CONTAINER_NAME 2>$null
docker rm $CONTAINER_NAME 2>$null

# Build
Write-Host "Build de l'image..." -ForegroundColor Yellow
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
if ($LASTEXITCODE -ne 0) {
    Write-Host "Erreur build" -ForegroundColor Red
    exit 1
}

# Run
Write-Host "Demarrage du conteneur..." -ForegroundColor Yellow
docker run -d -p ${PORT}:${PORT} --name $CONTAINER_NAME "${IMAGE_NAME}:${IMAGE_TAG}"
Start-Sleep -Seconds 10

# Test
Write-Host "`nTest de l'API..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/health" -Method Get
    Write-Host "Status: $($response.status)" -ForegroundColor Green
} catch {
    Write-Host "Erreur" -ForegroundColor Red
}

# Predict test
$customerData = @{
    CreditScore = 650
    Age = 35
    Tenure = 5
    Balance = 50000.0
    NumOfProducts = 2
    HasCrCard = 1
    IsActiveMember = 1
    EstimatedSalary = 75000.0
    Geography_Germany = 0
    Geography_Spain = 1
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:${PORT}/predict" -Method Post -Body $customerData -ContentType "application/json"
    Write-Host "Prediction: $($response.churn_probability)" -ForegroundColor Green
} catch {
    Write-Host "Erreur prediction" -ForegroundColor Red
}

Write-Host "`nURLs:" -ForegroundColor Yellow
Write-Host "http://localhost:${PORT}" -ForegroundColor White
Write-Host "http://localhost:${PORT}/docs" -ForegroundColor White

$keep = Read-Host "`nGarder le conteneur? (O/N)"
if ($keep -eq "N" -or $keep -eq "n") {
    docker stop $CONTAINER_NAME
    docker rm $CONTAINER_NAME
    Write-Host "Conteneur arrete" -ForegroundColor Green
}
