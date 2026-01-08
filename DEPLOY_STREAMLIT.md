# Guide de Deploiement Streamlit

## Option 1: Streamlit Cloud (Gratuit et Simple) 🌟

### Etape 1: Preparer le projet

1. Creer un fichier `.streamlit/config.toml` :

```bash
mkdir .streamlit
```

Contenu du fichier `.streamlit/config.toml` :

```toml
[server]
headless = true
port = 8501
enableCORS = false

[browser]
gatherUsageStats = false
```

2. Verifier que les fichiers necessaires existent :
   - ✅ `streamlit_app.py`
   - ✅ `requirements-streamlit.txt`

### Etape 2: Pousser sur GitHub

```bash
# Initialiser git (si pas deja fait)
git init
git add .
git commit -m "Add Streamlit app"

# Creer un repo sur GitHub et pousser
git remote add origin https://github.com/votre-username/bank-churn-mlops.git
git push -u origin main
```

### Etape 3: Deployer sur Streamlit Cloud

1. Aller sur https://streamlit.io/cloud
2. Se connecter avec GitHub
3. Cliquer sur "New app"
4. Selectionner :
   - Repository: `votre-username/bank-churn-mlops`
   - Branch: `main`
   - Main file: `streamlit_app.py`
5. Cliquer sur "Deploy!"

✅ Votre app sera accessible a : `https://votre-app.streamlit.app`

---

## Option 2: Azure Container Apps 🚀

### Prerequis

- Azure CLI installe
- Docker en cours d'execution
- Compte Azure actif

### Deploiement

```powershell
# Lancer le script de deploiement
.\deploy-streamlit-azure.ps1
```

Le script va :

1. ✅ Build l'image Docker Streamlit
2. ✅ Push vers Azure Container Registry
3. ✅ Deployer sur Azure Container Apps
4. ✅ Configurer l'ingress externe

### Architecture Azure Finale

```
┌─────────────────────────────────────┐
│   Internet / Utilisateurs           │
└────────────┬────────────────────────┘
             │
     ┌───────┴────────┐
     │                │
┌────▼────┐    ┌─────▼─────┐
│Streamlit│    │  FastAPI  │
│   UI    │───►│    API    │
│ (8501)  │    │  (8000)   │
└─────────┘    └───────────┘
     │              │
     └──────┬───────┘
            │
    ┌───────▼────────┐
    │   Log Analytics│
    │   + Insights   │
    └────────────────┘
```

### URLs Finales

- **Streamlit UI**: `https://bank-churn-ui.[region].azurecontainerapps.io`
- **FastAPI**: `https://bank-churn.[region].azurecontainerapps.io`

---

## Option 3: Heroku (Alternative)

### Etape 1: Creer Procfile

```bash
echo "web: streamlit run streamlit_app.py --server.port=$PORT --server.address=0.0.0.0" > Procfile
```

### Etape 2: Deployer

```bash
# Installer Heroku CLI
# https://devcenter.heroku.com/articles/heroku-cli

# Login
heroku login

# Creer app
heroku create bank-churn-streamlit

# Deployer
git push heroku main

# Ouvrir
heroku open
```

---

## Comparaison des Options

| Feature           | Streamlit Cloud | Azure Container Apps | Heroku            |
| ----------------- | --------------- | -------------------- | ----------------- |
| **Prix**          | Gratuit         | ~$30-40/mois         | Gratuit (limites) |
| **Setup**         | ⭐⭐⭐ Facile   | ⭐⭐ Moyen           | ⭐⭐⭐ Facile     |
| **Performance**   | ⭐⭐ Bon        | ⭐⭐⭐ Excellent     | ⭐⭐ Bon          |
| **Scaling**       | Limite          | Auto-scaling         | Manuel            |
| **Integration**   | GitHub only     | Tout                 | Git               |
| **Custom Domain** | ✅ Oui          | ✅ Oui               | ✅ Oui            |
| **SSL**           | ✅ Auto         | ✅ Auto              | ✅ Auto           |

### Recommandation

- **Demo/Prototype** → Streamlit Cloud ⭐
- **Production avec API Azure** → Azure Container Apps ⭐⭐⭐
- **Petit projet** → Heroku

---

## Verification du Deploiement

### Test Streamlit Cloud

```bash
curl https://votre-app.streamlit.app
```

### Test Azure

```bash
curl https://bank-churn-ui.[region].azurecontainerapps.io
```

### Verifier les logs Azure

```powershell
az containerapp logs show \
  --name bank-churn-ui \
  --resource-group rg-mlops-bank-churn \
  --follow
```

---

## Troubleshooting

### Erreur: Module not found

- Verifier `requirements-streamlit.txt`
- Ajouter les modules manquants

### Erreur: Port deja utilise (local)

```powershell
streamlit run streamlit_app.py --server.port 8502
```

### App ne demarre pas sur Azure

```powershell
# Voir les logs
az containerapp logs show --name bank-churn-ui --resource-group rg-mlops-bank-churn --tail 100

# Redemarrer
az containerapp update --name bank-churn-ui --resource-group rg-mlops-bank-churn
```

### Probleme de connexion a l'API

- Verifier que l'URL de l'API dans `streamlit_app.py` est correcte
- Tester l'API separement: `curl https://bank-churn.[region].azurecontainerapps.io/health`

---

## Securite

### Variables d'environnement (Azure)

```powershell
az containerapp update \
  --name bank-churn-ui \
  --resource-group rg-mlops-bank-churn \
  --set-env-vars "API_URL=https://votre-api.com"
```

Puis dans `streamlit_app.py`:

```python
import os
API_URL = os.getenv("API_URL", "default-url")
```

---

## Mise a jour

### Streamlit Cloud

- Push sur GitHub → Deploiement auto

### Azure

```powershell
# Rebuild et redeploy
.\deploy-streamlit-azure.ps1
```

---

## Cout Azure (avec Streamlit)

| Service                 | Cout/mois     |
| ----------------------- | ------------- |
| FastAPI Container App   | ~$30          |
| Streamlit Container App | ~$30          |
| ACR                     | ~$5           |
| Log Analytics           | ~$3           |
| **TOTAL**               | **~$68/mois** |

💡 **Pour economiser**: Utilisez Streamlit Cloud (gratuit) + Azure pour l'API seulement!

---

## Commandes Rapides

```powershell
# Deployer sur Azure
.\deploy-streamlit-azure.ps1

# Voir les logs
az containerapp logs show --name bank-churn-ui --resource-group rg-mlops-bank-churn --follow

# Scaler
az containerapp update --name bank-churn-ui --resource-group rg-mlops-bank-churn --min-replicas 2 --max-replicas 5

# Supprimer
az containerapp delete --name bank-churn-ui --resource-group rg-mlops-bank-churn --yes
```

---

**Choix recommande**: Azure Container Apps pour coherence avec l'API! 🚀
