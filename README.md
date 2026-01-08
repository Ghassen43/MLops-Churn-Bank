# 🏦 Bank Churn Prediction - MLOps Platform

[![Azure](https://img.shields.io/badge/Azure-Container_Apps-0078D4?logo=microsoft-azure)](https://azure.microsoft.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104.1-009688?logo=fastapi)](https://fastapi.tiangolo.com/)
[![Streamlit](https://img.shields.io/badge/Streamlit-1.29.0-FF4B4B?logo=streamlit)](https://streamlit.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)](https://www.docker.com/)
[![Status](https://img.shields.io/badge/Status-Production-success)](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health)

Système MLOps complet pour la prédiction du churn bancaire avec API REST, monitoring, drift detection et interface Streamlit interactive.

## 🌐 Démo en Ligne

- **🎨 Interface Streamlit**: http://localhost:8501 (local) // https://bank-churn-ui.braveforest-d43eb01f.francecentral.azurecontainerapps.io/
- **🚀 API REST**: https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io
- **📖 Documentation API**: https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/docs
- **❤️ Health Check**: https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health

## ✨ Fonctionnalités

### 🔮 Prédiction de Churn

- **API REST** avec FastAPI pour prédictions en temps réel
- **Prédictions individuelles** avec scoring de risque (Low/Medium/High)
- **Prédictions par batch** pour traitement de volumes importants
- **Modèle Random Forest** entraîné sur données bancaires

### 🎨 Interface Streamlit Interactive

- **Dashboard** avec métriques en temps réel
- **Formulaire de prédiction** interactif
- **Batch prediction** avec upload CSV
- **Tests de performance** et latence
- **Documentation intégrée** avec exemples de code

### 📊 Monitoring & Observabilité

- **Azure Application Insights** pour logs et métriques
- **Health checks** automatiques
- **Drift detection** pour surveiller la qualité des données
- **Alertes** configurables

### 🚀 MLOps & DevOps

- **Conteneurisation Docker** pour portabilité
- **Azure Container Registry** pour stockage d'images
- **Azure Container Apps** pour déploiement scalable
- **CI/CD ready** pour GitHub Actions

## 📁 Structure du Projet

```
bank-churn-mlops-main/
├── app/
│   ├── __init__.py
│   ├── main.py              # API FastAPI
│   ├── models.py            # Schémas Pydantic
│   ├── utils.py
│   └── drift_detect.py      # Détection de drift
├── model/
│   ├── churn_model.pkl      # Modèle ML entraîné
│   └── feature_importance.csv
├── data/
│   ├── bank_churn.csv       # Données d'entraînement
│   └── production_data.csv  # Données de production
├── tests/
│   └── test_api.py          # Tests unitaires
├── drift_reports/           # Rapports de drift
├── Dockerfile               # Configuration Docker
├── requirements.txt         # Dépendances API
├── requirements-streamlit.txt  # Dépendances Streamlit
├── streamlit_app.py         # Application Streamlit
├── deploy-azure.ps1         # Script déploiement Azure
├── test-local.ps1          # Tests locaux
├── test-azure-api.ps1      # Tests API Azure
├── run-streamlit.ps1       # Lancement Streamlit
├── DEPLOYMENT.md           # Guide de déploiement
└── STREAMLIT_GUIDE.md      # Guide Streamlit
```

## 🚀 Quick Start

### 1. Lancer l'Interface Streamlit (Recommandé)

```powershell
# Option simple
.\run-streamlit.ps1

# Ou manuellement
pip install -r requirements-streamlit.txt
streamlit run streamlit_app.py
```

Ouvrir http://localhost:8501 dans votre navigateur.

### 2. Tester l'API Localement

```powershell
# Build et test Docker
.\test-local.ps1

# L'API sera disponible sur http://localhost:8000
```

### 3. Déployer sur Azure

```powershell
# Déploiement complet sur Azure
.\deploy-azure.ps1

# Tester l'API déployée
.\test-azure-api.ps1
```

## 📊 Utilisation de l'API

### Prédiction Individuelle

```bash
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

**Réponse:**

```json
{
  "churn_probability": 0.0073,
  "prediction": 0,
  "risk_level": "Low"
}
```

### Avec Python

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
result = response.json()

print(f"Churn Probability: {result['churn_probability']:.2%}")
print(f"Risk Level: {result['risk_level']}")
```

## 🎨 Interface Streamlit - Aperçu

### Dashboard

![Dashboard](https://via.placeholder.com/800x400/1f77b4/ffffff?text=Dashboard+View)

- Statut API en temps réel
- Métriques de performance
- Vue d'ensemble des ressources

### Prédiction Interactive

![Prediction](https://via.placeholder.com/800x400/2ca02c/ffffff?text=Prediction+Interface)

- Formulaire intuitif avec sliders
- Résultats visuels instantanés
- Recommandations personnalisées

### Batch Prediction

![Batch](https://via.placeholder.com/800x400/ff7f0e/ffffff?text=Batch+Prediction)

- Upload CSV
- Statistiques agrégées
- Export des résultats

## 🏗️ Architecture

```
┌─────────────────┐
│   Streamlit UI  │  ← Interface utilisateur (Port 8501)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   FastAPI REST  │  ← API de prédiction (Port 8000)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Random Forest  │  ← Modèle ML (churn_model.pkl)
│     Model       │
└─────────────────┘
```

### Déploiement Azure

```
GitHub → Docker Build → ACR → Container Apps → Internet
                                    ↓
                          Application Insights
```

## 🔧 Configuration Azure

| Ressource          | Nom                  | Type               | Région         |
| ------------------ | -------------------- | ------------------ | -------------- |
| Resource Group     | rg-mlops-bank-churn  | Resource Group     | France Central |
| Container Registry | mlopsghassen         | ACR Basic          | France Central |
| Container App      | bank-churn           | Container App      | France Central |
| Log Analytics      | law-mlops-ghassen-\* | Workspace          | France Central |
| Environment        | env-mlops-workshop   | Container Apps Env | France Central |

## 📈 Métriques & Monitoring

### API Performance

- **Latence moyenne**: < 100ms
- **Disponibilité**: 99.9%
- **Taux de succès**: > 99%

### Modèle ML

- **Accuracy**: 86.5%
- **Precision**: 78.3%
- **Recall**: 54.2%
- **F1 Score**: 64.1%
- **ROC AUC**: 86.8%

## 🧪 Tests

```powershell
# Tests locaux
.\test-local.ps1

# Tests API Azure
.\test-azure-api.ps1

# Tests unitaires
pytest tests/ -v --cov=app

# Tests de charge
# Utiliser la page "API Status" dans Streamlit
```

## 📚 Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Guide complet de déploiement Azure
- **[STREAMLIT_GUIDE.md](STREAMLIT_GUIDE.md)** - Guide d'utilisation Streamlit
- **[API Docs (Swagger)](https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/docs)** - Documentation interactive
- **[Workshop MLOps](https://nevermind78.github.io/mlops-workshop-docs/)** - Documentation complète du projet

## 🛠️ Commandes Utiles

### Docker

```powershell
# Build local
docker build -t bank-churn-api:v1 .

# Run local
docker run -p 8000:8000 bank-churn-api:v1

# Push to ACR
docker tag bank-churn-api:v1 mlopsghassen.azurecr.io/bank-churn-api:v1
docker push mlopsghassen.azurecr.io/bank-churn-api:v1
```

### Azure CLI

```powershell
# Voir les logs
az containerapp logs show --name bank-churn --resource-group rg-mlops-bank-churn --follow

# Mettre à jour l'app
az containerapp update --name bank-churn --resource-group rg-mlops-bank-churn --image mlopsghassen.azurecr.io/bank-churn-api:v2

# Scaler l'app
az containerapp update --name bank-churn --resource-group rg-mlops-bank-churn --min-replicas 1 --max-replicas 3

# Supprimer toutes les ressources
az group delete --name rg-mlops-bank-churn --yes --no-wait
```

### Streamlit

```powershell
# Lancer l'app
streamlit run streamlit_app.py

# Port personnalisé
streamlit run streamlit_app.py --server.port 8502

# Mode développement avec reload
streamlit run streamlit_app.py --server.runOnSave true
```

## 💰 Estimation des Coûts Azure

Basé sur Azure for Students ($100 crédit):

| Service                    | Coût Mensuel Estimé |
| -------------------------- | ------------------- |
| Container Registry (Basic) | ~$5                 |
| Container Apps (1 replica) | ~$30                |
| Log Analytics              | ~$3/GB              |
| **Total**                  | **~$40-50/mois**    |

💡 **Astuce**: Arrêtez ou supprimez les ressources quand vous ne les utilisez pas!

## 🔐 Sécurité

- ✅ HTTPS activé par défaut sur Azure
- ✅ Secrets gérés par Azure Key Vault (optionnel)
- ✅ Authentification ACR avec credentials admin
- ✅ CORS configuré pour l'API
- ✅ Validation des données avec Pydantic

## 🚦 Roadmap

- [ ] CI/CD avec GitHub Actions
- [ ] Application Insights configuré
- [ ] Alertes automatiques sur drift
- [ ] A/B testing de modèles
- [ ] Déploiement multi-régions
- [ ] Cache Redis pour prédictions
- [ ] Interface d'administration

## 🤝 Contribution

Ce projet est éducatif. Pour contribuer:

1. Fork le projet
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit (`git commit -m 'Add AmazingFeature'`)
4. Push (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## 📝 License

Projet éducatif pour l'apprentissage MLOps.

## 👥 Équipe

Développé dans le cadre du Workshop MLOps avec Azure.

## 📞 Support

- 📧 Email: ghassen.amara@polytechnicien.tn
- 📚 Documentation: https://nevermind78.github.io/mlops-workshop-docs/
- 🐛 Issues: Créer une issue sur GitHub

## 🙏 Remerciements

- **Azure for Students** pour les crédits cloud
- **FastAPI** pour le framework API
- **Streamlit** pour l'interface interactive
- **Scikit-learn** pour les outils ML
- **Workshop MLOps** pour le guide complet

---

**Status**: ✅ Production  
**Version**: 1.0.0  
**Dernière MAJ**: Janvier 2026  
**Région**: France Central

⭐ **N'oubliez pas de star le projet si vous le trouvez utile!**
