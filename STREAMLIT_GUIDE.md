# 🎨 Application Streamlit - Guide d'Utilisation

## 🚀 Lancement Rapide

### Option 1: Script PowerShell (Recommandé)

```powershell
.\run-streamlit.ps1
```

### Option 2: Commande Manuelle

```powershell
# Activer l'environnement virtuel (si necessaire)
.\.venv\Scripts\Activate.ps1

# Lancer Streamlit
streamlit run streamlit_app.py
```

## 🌐 Accès à l'Application

Une fois lancée, l'application est accessible à :

- **Local**: http://localhost:8501
- **Réseau**: http://10.99.3.116:8501

## 📱 Pages de l'Application

### 1. 🏠 Dashboard

- **Vue d'ensemble** du statut de l'API
- **Métriques en temps réel** (Status API, Model, Region, Environment)
- **Liste des endpoints** disponibles
- **Ressources Azure** déployées
- **Graphique d'uptime** sur 24h

### 2. 🔮 Prediction

- **Formulaire interactif** pour saisir les données client
- **Paramètres ajustables** :
  - Credit Score (300-850)
  - Age (18-80)
  - Tenure (0-10 années)
  - Balance (€)
  - Nombre de produits (1-4)
  - Carte de crédit (Oui/Non)
  - Membre actif (Oui/Non)
  - Salaire estimé (€)
  - Géographie (France/Germany/Spain)
- **Résultats visuels** :
  - Probabilité de churn (%)
  - Prédiction (Partira/Restera)
  - Niveau de risque (Low/Medium/High)
  - Gauge chart interactif
  - Recommandations personnalisées

### 3. 📊 Batch Prediction

- **Upload de fichier CSV** pour prédictions multiples
- **Format d'exemple** téléchargeable
- **Statistiques agrégées** :
  - Total clients analysés
  - Nombre de clients à risque
  - Taux de churn global
- **Visualisations** :
  - Distribution des probabilités
  - Histogrammes
- **Export des résultats** en CSV

### 4. 🔍 API Status

- **Health check en temps réel**
- **Liste complète des endpoints**
- **Test de latence** :
  - Latence moyenne/min/max
  - Graphique de performance
- **Bouton de rafraîchissement**

### 5. 📚 Documentation

4 onglets complets :

- **📖 API** : Exemples de requêtes cURL
- **🚀 Deployment** : Informations Azure, commandes CLI
- **💻 Code** : Exemples Python et PowerShell
- **🔗 Links** : Liens utiles (Swagger, ReDoc, Portal)

## ✨ Fonctionnalités Principales

### Design Moderne

- Interface responsive et intuitive
- Thème avec couleurs professionnelles
- Cards et boxes stylisés
- Icônes explicites

### Visualisations Interactives

- **Plotly** pour les graphiques dynamiques
- Gauge charts pour les probabilités
- Histogrammes de distribution
- Graphiques de latence

### Temps Réel

- Connexion directe à l'API déployée sur Azure
- Rafraîchissement en temps réel
- Tests de performance

### Export de Données

- Téléchargement des résultats en CSV
- Format exemple pour batch prediction
- Horodatage des exports

## 🎯 Cas d'Usage

### 1. Démonstration Client

```
1. Ouvrir le Dashboard pour montrer le statut
2. Aller sur Prediction pour un exemple interactif
3. Utiliser Batch Prediction pour des volumes importants
```

### 2. Tests de Performance

```
1. Aller sur API Status
2. Lancer le test de latence
3. Analyser les métriques
```

### 3. Formation Utilisateurs

```
1. Documentation → API pour apprendre les endpoints
2. Documentation → Code pour voir les exemples
3. Prediction pour tester en pratique
```

## 🔧 Personnalisation

### Modifier l'URL de l'API

Dans `streamlit_app.py`, ligne 14 :

```python
API_URL = "https://votre-nouvelle-url.azurecontainerapps.io"
```

### Ajouter des Métriques

Éditer la section Dashboard pour ajouter de nouveaux KPIs

### Changer le Thème

Créer un fichier `.streamlit/config.toml` :

```toml
[theme]
primaryColor = "#1f77b4"
backgroundColor = "#ffffff"
secondaryBackgroundColor = "#f0f2f6"
textColor = "#262730"
font = "sans serif"
```

## 📊 Exemples de Tests

### Test Simple

1. Aller sur la page **Prediction**
2. Utiliser les valeurs par défaut
3. Cliquer sur "Prédire le Churn"
4. Observer les résultats

### Test Client à Risque

1. Définir :
   - Credit Score: 400
   - Age: 65
   - Tenure: 1
   - Balance: 0
   - NumOfProducts: 1
   - IsActiveMember: Non
2. Prédiction devrait montrer "High Risk"

### Test Batch

1. Télécharger l'exemple CSV
2. L'uploader sur la page Batch Prediction
3. Lancer les prédictions
4. Télécharger les résultats

## 🐛 Dépannage

### L'application ne démarre pas

```powershell
# Réinstaller les dépendances
pip install -r requirements-streamlit.txt

# Vérifier la version Python (3.8+)
python --version
```

### Erreur de connexion à l'API

1. Vérifier que l'API est déployée : https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health
2. Vérifier l'URL dans `streamlit_app.py`
3. Tester avec cURL :

```bash
curl https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/health
```

### Port déjà utilisé

```powershell
# Utiliser un port différent
streamlit run streamlit_app.py --server.port 8502
```

### Erreur de module

```powershell
# Installer le module manquant
pip install nom_du_module
```

## 📦 Dépendances

```
streamlit==1.29.0
plotly==5.18.0
requests==2.31.0
pandas==2.1.3
```

## 🎨 Captures d'Écran

### Dashboard

- Vue d'ensemble avec métriques clés
- Graphique d'uptime
- Liste des endpoints et ressources

### Prediction

- Formulaire avec sliders intuitifs
- Gauge chart coloré
- Recommandations contextuelles

### Batch Prediction

- Upload CSV simple
- Statistiques détaillées
- Export facilité

## 🌟 Avantages

✅ **Interface intuitive** - Aucune connaissance technique requise  
✅ **Visualisations riches** - Comprendre les résultats en un coup d'œil  
✅ **Tests rapides** - Valider l'API en quelques clics  
✅ **Documentation intégrée** - Tout au même endroit  
✅ **Responsive** - Fonctionne sur desktop et tablette  
✅ **Open Source** - Facilement personnalisable

## 🔗 Liens Utiles

- **Streamlit Docs**: https://docs.streamlit.io/
- **Plotly Docs**: https://plotly.com/python/
- **API Documentation**: https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io/docs

## 📝 Notes

- L'application se connecte à l'API en production
- Aucune donnée n'est stockée localement
- Les prédictions sont faites en temps réel
- L'application peut être déployée sur Streamlit Cloud

## 🚀 Déploiement sur Streamlit Cloud (Optionnel)

1. Créer un compte sur https://streamlit.io/cloud
2. Connecter votre repo GitHub
3. Sélectionner `streamlit_app.py`
4. Déployer!

Votre app sera accessible publiquement à une URL Streamlit.

---

**Version**: 1.0.0  
**Date**: January 2026  
**Auteur**: Bank Churn MLOps Team
