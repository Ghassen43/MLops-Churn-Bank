# Bank Churn MLOps - Deployment Success 🎉

## Deployment Summary

Your Bank Churn Prediction API has been successfully deployed to Azure Container Apps!

### Deployment Information

- **Resource Group**: rg-mlops-bank-churn
- **Region**: France Central
- **ACR Name**: mlopsghassen
- **Container App**: bank-churn
- **Status**: ✅ Operational

### API Endpoints

🌐 **Base URL**: `https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io`

| Endpoint           | URL                                                                                                         | Description                   |
| ------------------ | ----------------------------------------------------------------------------------------------------------- | ----------------------------- |
| **Root**           | [/](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/)                           | API information               |
| **Health**         | [/health](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health)               | Health check                  |
| **Prediction**     | [/predict](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/predict)             | Make predictions (POST)       |
| **Batch Predict**  | [/predict/batch](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/predict/batch) | Batch predictions (POST)      |
| **Drift Check**    | [/drift/check](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/drift/check)     | Check data drift (POST)       |
| **Docs (Swagger)** | [/docs](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/docs)                   | Interactive API documentation |
| **ReDoc**          | [/redoc](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/redoc)                 | Alternative documentation     |

## Test Results ✅

All API tests passed successfully:

1. ✅ **Health Check**: API is healthy, model loaded
2. ✅ **Root Endpoint**: Returns API version 1.0.0
3. ✅ **Prediction (Low Risk)**: Probability: 0.0073, Risk: Low
4. ✅ **Prediction (High Risk)**: Probability: 0.3742, Risk: Medium

## Quick Start

### Test with PowerShell

```powershell
# Test the API
.\test-azure-api.ps1

# View logs
az containerapp logs show --name bank-churn --resource-group rg-mlops-bank-churn --follow
```

### Test with cURL

```bash
# Health check
curl https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health

# Make a prediction
curl -X POST "https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "CreditScore": 650,
    "Age": 35,
    "Tenure": 5,
    "Balance": 50000.0,
    "NumOfProducts": 2,
    "HasCrCard": 1,
    "IsActiveMember": 1,
    "EstimatedSalary": 75000.0,
    "Geography_Germany": 0,
    "Geography_Spain": 1
  }'
```

### Test with Python

```python
import requests

url = "https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/predict"

data = {
    "CreditScore": 650,
    "Age": 35,
    "Tenure": 5,
    "Balance": 50000.0,
    "NumOfProducts": 2,
    "HasCrCard": 1,
    "IsActiveMember": 1,
    "EstimatedSalary": 75000.0,
    "Geography_Germany": 0,
    "Geography_Spain": 1
}

response = requests.post(url, json=data)
print(response.json())
```

## Project Structure

```
bank-churn-mlops-main/
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI application
│   ├── models.py            # Pydantic models
│   ├── utils.py
│   └── drift_detect.py      # Drift detection
├── model/
│   └── churn_model.pkl      # Trained model
├── data/
│   ├── bank_churn.csv       # Training data
│   └── production_data.csv  # Production data
├── tests/
│   └── test_api.py          # API tests
├── Dockerfile               # Docker configuration
├── requirements.txt         # Python dependencies
├── deploy-azure.ps1         # Azure deployment script
├── test-local.ps1          # Local testing script
└── test-azure-api.ps1      # Azure API testing script
```

## Management Commands

### View Logs

```powershell
# Real-time logs
az containerapp logs show --name bank-churn --resource-group rg-mlops-bank-churn --follow

# Last 100 lines
az containerapp logs show --name bank-churn --resource-group rg-mlops-bank-churn --tail 100
```

### Update Deployment

```powershell
# Re-run deployment script
.\deploy-azure.ps1

# Or update manually
az containerapp update \
  --name bank-churn \
  --resource-group rg-mlops-bank-churn \
  --image mlopsghassen.azurecr.io/bank-churn-api:v1
```

### Scale Application

```powershell
# Scale to 3 replicas
az containerapp update \
  --name bank-churn \
  --resource-group rg-mlops-bank-churn \
  --min-replicas 1 \
  --max-replicas 3
```

### Monitor Resources

```powershell
# Check app status
az containerapp show --name bank-churn --resource-group rg-mlops-bank-churn

# List all resources in resource group
az resource list --resource-group rg-mlops-bank-churn -o table
```

## Azure Resources Created

| Resource             | Type                       | Purpose                |
| -------------------- | -------------------------- | ---------------------- |
| rg-mlops-bank-churn  | Resource Group             | Contains all resources |
| mlopsghassen         | Container Registry (ACR)   | Stores Docker images   |
| law-mlops-ghassen-\* | Log Analytics Workspace    | Logs and monitoring    |
| env-mlops-workshop   | Container Apps Environment | Runtime environment    |
| bank-churn           | Container App              | Runs the API           |

## Cost Estimation

Based on Azure for Students ($100 credit):

- **Container Registry (Basic)**: ~$5/month
- **Container Apps**: ~$0.000012/second (approximately $30/month for 1 replica)
- **Log Analytics**: ~$2.30/GB ingested
- **Total**: ~$40-50/month

**Note**: Turn off or delete resources when not needed to save credits.

## Clean Up Resources

### Delete Everything

```powershell
# Delete entire resource group (recommended)
az group delete --name rg-mlops-bank-churn --yes --no-wait

# Verify deletion
az group list --output table
```

### Delete Individual Resources

```powershell
# Delete Container App only
az containerapp delete --name bank-churn --resource-group rg-mlops-bank-churn --yes

# Delete ACR only
az acr delete --name mlopsghassen --resource-group rg-mlops-bank-churn --yes
```

## Next Steps

### 1. Set Up CI/CD with GitHub Actions

See [Module 5](https://nevermind78.github.io/mlops-workshop-docs/#sec-module5) in the documentation.

### 2. Add Application Insights

```powershell
# Create Application Insights
az monitor app-insights component create \
  --app bank-churn-insights \
  --location francecentral \
  --resource-group rg-mlops-bank-churn

# Get connection string
$APPINSIGHTS_CONN = az monitor app-insights component show \
  --app bank-churn-insights \
  --resource-group rg-mlops-bank-churn \
  --query connectionString -o tsv

# Update Container App with connection string
az containerapp update \
  --name bank-churn \
  --resource-group rg-mlops-bank-churn \
  --set-env-vars "APPLICATIONINSIGHTS_CONNECTION_STRING=$APPINSIGHTS_CONN"
```

### 3. Implement Monitoring & Alerting

- Set up Azure Monitor alerts
- Configure drift detection schedules
- Monitor API performance metrics

## Troubleshooting

### API Returns 503

```powershell
# Check if model is loaded
az containerapp logs show --name bank-churn --resource-group rg-mlops-bank-churn --tail 50
```

### Can't Access API

```powershell
# Verify ingress is enabled
az containerapp show --name bank-churn --resource-group rg-mlops-bank-churn \
  --query "properties.configuration.ingress"
```

### Deployment Fails

1. Check Azure region restrictions: Use `francecentral`
2. Verify ACR credentials
3. Check Docker image exists in ACR

## Support

- **Documentation**: https://nevermind78.github.io/mlops-workshop-docs/
- **Azure CLI Docs**: https://docs.microsoft.com/cli/azure/
- **FastAPI Docs**: https://fastapi.tiangolo.com/

## License

Educational project for MLOps learning.

---

**Deployment Date**: January 8, 2026
**Status**: ✅ Successfully Deployed
**Environment**: Azure for Students (France Central)
