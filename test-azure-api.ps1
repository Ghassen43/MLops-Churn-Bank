# Test API deployee sur Azure
$APP_URL = "bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io"

Write-Host "`nTest de l'API deployee sur Azure`n" -ForegroundColor Cyan

# Test 1: Health Check
Write-Host "Test 1: Health Check..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://$APP_URL/health" -Method Get
    Write-Host "Status: $($response.status)" -ForegroundColor Green
    Write-Host "Model loaded: $($response.model_loaded)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: $_" -ForegroundColor Red
}

# Test 2: Root endpoint
Write-Host "`nTest 2: Root endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "https://$APP_URL/" -Method Get
    Write-Host "Message: $($response.message)" -ForegroundColor Green
    Write-Host "Version: $($response.version)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: $_" -ForegroundColor Red
}

# Test 3: Prediction
Write-Host "`nTest 3: Prediction..." -ForegroundColor Yellow
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
    $response = Invoke-RestMethod -Uri "https://$APP_URL/predict" -Method Post -Body $customerData -ContentType "application/json"
    Write-Host "Churn probability: $($response.churn_probability)" -ForegroundColor Green
    Write-Host "Prediction: $($response.prediction)" -ForegroundColor Green
    Write-Host "Risk level: $($response.risk_level)" -ForegroundColor Green
} catch {
    Write-Host "Erreur: $_" -ForegroundColor Red
}

# Test 4: High risk customer
Write-Host "`nTest 4: High risk customer..." -ForegroundColor Yellow
$highRiskCustomer = @{
    CreditScore = 400
    Age = 65
    Tenure = 1
    Balance = 0.0
    NumOfProducts = 1
    HasCrCard = 0
    IsActiveMember = 0
    EstimatedSalary = 30000.0
    Geography_Germany = 1
    Geography_Spain = 0
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://$APP_URL/predict" -Method Post -Body $highRiskCustomer -ContentType "application/json"
    Write-Host "Churn probability: $($response.churn_probability)" -ForegroundColor Green
    Write-Host "Risk level: $($response.risk_level)" -ForegroundColor $(if ($response.risk_level -eq "High") {"Red"} else {"Yellow"})
} catch {
    Write-Host "Erreur: $_" -ForegroundColor Red
}

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Tests termines" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nURLs utiles:" -ForegroundColor Yellow
Write-Host "API       : https://$APP_URL" -ForegroundColor White
Write-Host "Health    : https://$APP_URL/health" -ForegroundColor White
Write-Host "Docs      : https://$APP_URL/docs" -ForegroundColor White
Write-Host "ReDoc     : https://$APP_URL/redoc" -ForegroundColor White
Write-Host ""
