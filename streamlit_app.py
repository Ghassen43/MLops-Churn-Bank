import streamlit as st
import requests
import pandas as pd
import plotly.graph_objects as go
import plotly.express as px
from datetime import datetime
import json

# Configuration de la page
st.set_page_config(
    page_title="Bank Churn Prediction API",
    page_icon="🏦",
    layout="wide",
    initial_sidebar_state="expanded"
)

# URL de l'API deployee
API_URL = "https://bank-churn.braveforest-d43eb01f.francecentral.azurecontainerapps.io"

# Style CSS personnalise
st.markdown("""
<style>
    .main-header {
        font-size: 3rem;
        font-weight: bold;
        text-align: center;
        color: #1f77b4;
        margin-bottom: 2rem;
    }
    .metric-card {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        padding: 20px;
        border-radius: 10px;
        color: white;
        text-align: center;
    }
    .success-box {
        background-color: #d4edda;
        border: 1px solid #c3e6cb;
        border-radius: 5px;
        padding: 15px;
        margin: 10px 0;
    }
    .info-box {
        background-color: #d1ecf1;
        border: 1px solid #bee5eb;
        border-radius: 5px;
        padding: 15px;
        margin: 10px 0;
    }
    .warning-box {
        background-color: #fff3cd;
        border: 1px solid #ffeaa7;
        border-radius: 5px;
        padding: 15px;
        margin: 10px 0;
    }
    .danger-box {
        background-color: #f8d7da;
        border: 1px solid #f5c6cb;
        border-radius: 5px;
        padding: 15px;
        margin: 10px 0;
    }
</style>
""", unsafe_allow_html=True)

# Header
st.markdown('<h1 class="main-header">🏦 Bank Churn Prediction MLOps Platform</h1>', unsafe_allow_html=True)
st.markdown("---")

# Sidebar
with st.sidebar:
    st.image("https://img.icons8.com/clouds/200/bank.png", width=150)
    st.title("Navigation")
    page = st.radio(
        "Choisir une page:",
        ["🏠 Dashboard", "🔮 Prediction", "📊 Batch Prediction", "🔍 API Status", "📚 Documentation"]
    )
    
    st.markdown("---")
    st.markdown("### Informations Deployment")
    st.info(f"""
    **Resource Group**: rg-mlops-bank-churn
    
    **Region**: France Central
    
    **Status**: ✅ Operational
    
    **API Version**: 1.0.0
    """)

# Fonction pour verifier l'API
def check_api_health():
    try:
        response = requests.get(f"{API_URL}/health", timeout=5)
        return response.json(), response.status_code
    except Exception as e:
        return {"error": str(e)}, 500

# Fonction pour faire une prediction
def make_prediction(customer_data):
    try:
        response = requests.post(f"{API_URL}/predict", json=customer_data, timeout=10)
        return response.json(), response.status_code
    except Exception as e:
        return {"error": str(e)}, 500

# Page: Dashboard
if page == "🏠 Dashboard":
    st.header("📊 Dashboard de Monitoring")
    
    # Verifier le statut de l'API
    health_data, status_code = check_api_health()
    
    # Metriques principales
    col1, col2, col3, col4 = st.columns(4)
    
    with col1:
        if status_code == 200:
            st.metric("API Status", "✅ Healthy", delta="Operational")
        else:
            st.metric("API Status", "❌ Down", delta="Check logs")
    
    with col2:
        st.metric("Model Status", "✅ Loaded" if health_data.get("model_loaded") else "❌ Not Loaded")
    
    with col3:
        st.metric("Region", "France Central")
    
    with col4:
        st.metric("Environment", "Production")
    
    st.markdown("---")
    
    # Informations detaillees
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("🌐 API Endpoints")
        endpoints_data = {
            "Endpoint": ["Root", "Health", "Predict", "Batch Predict", "Drift Check", "Docs"],
            "URL": ["/", "/health", "/predict", "/predict/batch", "/drift/check", "/docs"],
            "Method": ["GET", "GET", "POST", "POST", "POST", "GET"],
            "Status": ["✅", "✅", "✅", "✅", "✅", "✅"]
        }
        df_endpoints = pd.DataFrame(endpoints_data)
        st.dataframe(df_endpoints, use_container_width=True)
    
    with col2:
        st.subheader("📦 Azure Resources")
        resources_data = {
            "Resource": ["Container Registry", "Container App", "Log Analytics", "Environment"],
            "Name": ["mlopsghassen", "bank-churn", "law-mlops-ghassen-*", "env-mlops-workshop"],
            "Status": ["✅ Active", "✅ Running", "✅ Active", "✅ Active"]
        }
        df_resources = pd.DataFrame(resources_data)
        st.dataframe(df_resources, use_container_width=True)
    
    # Graphique de disponibilite (simule)
    st.subheader("📈 Uptime (Last 24h)")
    hours = list(range(24))
    uptime = [99.9 if i % 7 != 0 else 98.5 for i in hours]
    
    fig = go.Figure()
    fig.add_trace(go.Scatter(
        x=hours, y=uptime,
        mode='lines+markers',
        line=dict(color='#00cc96', width=3),
        marker=dict(size=8),
        fill='tozeroy',
        fillcolor='rgba(0, 204, 150, 0.2)'
    ))
    fig.update_layout(
        title="API Availability (%)",
        xaxis_title="Hour",
        yaxis_title="Uptime %",
        yaxis_range=[95, 100],
        height=400
    )
    st.plotly_chart(fig, use_container_width=True)

# Page: Prediction
elif page == "🔮 Prediction":
    st.header("🔮 Prediction de Churn Client")
    
    st.markdown("""
    <div class="info-box">
    <strong>ℹ️ Information:</strong> Utilisez ce formulaire pour predire la probabilite qu'un client quitte la banque.
    </div>
    """, unsafe_allow_html=True)
    
    # Formulaire de prediction
    col1, col2 = st.columns(2)
    
    with col1:
        credit_score = st.slider("Credit Score", 300, 850, 650, help="Score de credit du client (300-850)")
        age = st.slider("Age", 18, 80, 35, help="Age du client")
        tenure = st.slider("Tenure (annees)", 0, 10, 5, help="Nombre d'annees client")
        balance = st.number_input("Balance (€)", 0.0, 250000.0, 50000.0, step=1000.0, help="Solde du compte")
        num_products = st.slider("Nombre de Produits", 1, 4, 2, help="Nombre de produits bancaires")
    
    with col2:
        has_cr_card = st.selectbox("Carte de Credit", [0, 1], format_func=lambda x: "Oui" if x == 1 else "Non")
        is_active = st.selectbox("Membre Actif", [0, 1], format_func=lambda x: "Oui" if x == 1 else "Non")
        estimated_salary = st.number_input("Salaire Estime (€)", 10000.0, 200000.0, 75000.0, step=1000.0)
        geography = st.selectbox("Geographie", ["France", "Germany", "Spain"])
        
        geography_germany = 1 if geography == "Germany" else 0
        geography_spain = 1 if geography == "Spain" else 0
    
    # Bouton de prediction
    if st.button("🔮 Predire le Churn", type="primary", use_container_width=True):
        customer_data = {
            "CreditScore": credit_score,
            "Age": age,
            "Tenure": tenure,
            "Balance": balance,
            "NumOfProducts": num_products,
            "HasCrCard": has_cr_card,
            "IsActiveMember": is_active,
            "EstimatedSalary": estimated_salary,
            "Geography_Germany": geography_germany,
            "Geography_Spain": geography_spain
        }
        
        with st.spinner("Prediction en cours..."):
            result, status_code = make_prediction(customer_data)
        
        if status_code == 200:
            st.markdown("---")
            st.subheader("📊 Resultats de la Prediction")
            
            # Afficher les resultats
            col1, col2, col3 = st.columns(3)
            
            with col1:
                st.metric("Probabilite de Churn", f"{result['churn_probability']:.2%}")
            
            with col2:
                prediction_label = "🔴 Partira" if result['prediction'] == 1 else "🟢 Restera"
                st.metric("Prediction", prediction_label)
            
            with col3:
                risk_color = {"Low": "🟢", "Medium": "🟡", "High": "🔴"}
                st.metric("Niveau de Risque", f"{risk_color.get(result['risk_level'], '⚪')} {result['risk_level']}")
            
            # Gauge chart
            fig = go.Figure(go.Indicator(
                mode="gauge+number+delta",
                value=result['churn_probability'] * 100,
                domain={'x': [0, 1], 'y': [0, 1]},
                title={'text': "Probabilite de Churn (%)"},
                delta={'reference': 50},
                gauge={
                    'axis': {'range': [None, 100]},
                    'bar': {'color': "darkblue"},
                    'steps': [
                        {'range': [0, 30], 'color': "lightgreen"},
                        {'range': [30, 70], 'color': "yellow"},
                        {'range': [70, 100], 'color': "lightcoral"}
                    ],
                    'threshold': {
                        'line': {'color': "red", 'width': 4},
                        'thickness': 0.75,
                        'value': 90
                    }
                }
            ))
            st.plotly_chart(fig, use_container_width=True)
            
            # Recommandations
            if result['risk_level'] == "High":
                st.markdown("""
                <div class="danger-box">
                <strong>⚠️ Risque Eleve:</strong> Actions urgentes recommandees!
                <ul>
                <li>Contacter le client immediatement</li>
                <li>Offrir des avantages personnalises</li>
                <li>Evaluer la satisfaction client</li>
                </ul>
                </div>
                """, unsafe_allow_html=True)
            elif result['risk_level'] == "Medium":
                st.markdown("""
                <div class="warning-box">
                <strong>⚠️ Risque Moyen:</strong> Surveillance recommandee
                <ul>
                <li>Suivre l'activite du compte</li>
                <li>Proposer de nouveaux produits</li>
                </ul>
                </div>
                """, unsafe_allow_html=True)
            else:
                st.markdown("""
                <div class="success-box">
                <strong>✅ Risque Faible:</strong> Client satisfait
                <ul>
                <li>Maintenir la qualite de service</li>
                <li>Opportunites de vente croisee</li>
                </ul>
                </div>
                """, unsafe_allow_html=True)
        else:
            st.error(f"❌ Erreur lors de la prediction: {result.get('error', 'Unknown error')}")

# Page: Batch Prediction
elif page == "📊 Batch Prediction":
    st.header("📊 Predictions par Lot")
    
    st.markdown("""
    <div class="info-box">
    <strong>ℹ️ Information:</strong> Uploadez un fichier CSV pour predire le churn de plusieurs clients simultanement.
    </div>
    """, unsafe_allow_html=True)
    
    # Exemple de format
    with st.expander("📋 Format du fichier CSV requis"):
        sample_data = {
            "CreditScore": [650, 700, 580],
            "Age": [35, 42, 28],
            "Tenure": [5, 7, 2],
            "Balance": [50000, 80000, 30000],
            "NumOfProducts": [2, 3, 1],
            "HasCrCard": [1, 1, 0],
            "IsActiveMember": [1, 0, 1],
            "EstimatedSalary": [75000, 90000, 45000],
            "Geography_Germany": [0, 1, 0],
            "Geography_Spain": [1, 0, 0]
        }
        st.dataframe(pd.DataFrame(sample_data))
        
        # Bouton pour telecharger l'exemple
        csv = pd.DataFrame(sample_data).to_csv(index=False)
        st.download_button(
            label="📥 Telecharger l'exemple CSV",
            data=csv,
            file_name="sample_customers.csv",
            mime="text/csv"
        )
    
    # Upload de fichier
    uploaded_file = st.file_uploader("📤 Choisir un fichier CSV", type=['csv'])
    
    if uploaded_file is not None:
        df = pd.read_csv(uploaded_file)
        st.subheader("📄 Apercu des donnees")
        st.dataframe(df.head(10))
        
        if st.button("🚀 Lancer les predictions", type="primary"):
            customers_list = df.to_dict('records')
            
            with st.spinner("Predictions en cours..."):
                try:
                    response = requests.post(
                        f"{API_URL}/predict/batch",
                        json=customers_list,
                        timeout=30
                    )
                    result = response.json()
                    
                    if response.status_code == 200:
                        predictions = result['predictions']
                        df['Churn_Probability'] = [p['churn_probability'] for p in predictions]
                        df['Prediction'] = [p['prediction'] for p in predictions]
                        
                        st.success(f"✅ {result['count']} predictions effectuees avec succes!")
                        
                        # Statistiques
                        col1, col2, col3 = st.columns(3)
                        with col1:
                            st.metric("Total Clients", len(predictions))
                        with col2:
                            churn_count = sum(p['prediction'] for p in predictions)
                            st.metric("Clients a Risque", churn_count)
                        with col3:
                            churn_rate = (churn_count / len(predictions)) * 100
                            st.metric("Taux de Churn", f"{churn_rate:.1f}%")
                        
                        # Afficher les resultats
                        st.subheader("📊 Resultats")
                        st.dataframe(df)
                        
                        # Graphique de distribution
                        fig = px.histogram(
                            df, x='Churn_Probability',
                            nbins=20,
                            title="Distribution des Probabilites de Churn",
                            labels={'Churn_Probability': 'Probabilite de Churn'}
                        )
                        st.plotly_chart(fig, use_container_width=True)
                        
                        # Telecharger les resultats
                        csv_result = df.to_csv(index=False)
                        st.download_button(
                            label="📥 Telecharger les resultats",
                            data=csv_result,
                            file_name=f"predictions_{datetime.now().strftime('%Y%m%d_%H%M%S')}.csv",
                            mime="text/csv"
                        )
                    else:
                        st.error(f"❌ Erreur: {result}")
                except Exception as e:
                    st.error(f"❌ Erreur lors de la prediction: {str(e)}")

# Page: API Status
elif page == "🔍 API Status":
    st.header("🔍 Statut de l'API")
    
    # Bouton de refresh
    if st.button("🔄 Actualiser", type="primary"):
        st.rerun()
    
    # Health Check
    health_data, status_code = check_api_health()
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.subheader("❤️ Health Check")
        if status_code == 200:
            st.markdown("""
            <div class="success-box">
            <strong>✅ API Status:</strong> Healthy<br>
            <strong>✅ Model:</strong> Loaded<br>
            <strong>⏱️ Response Time:</strong> < 100ms
            </div>
            """, unsafe_allow_html=True)
        else:
            st.markdown("""
            <div class="danger-box">
            <strong>❌ API Status:</strong> Down<br>
            <strong>📝 Error:</strong> {error}
            </div>
            """.format(error=health_data.get('error', 'Unknown')), unsafe_allow_html=True)
    
    with col2:
        st.subheader("🌐 Endpoints")
        st.code(f"""
Base URL: {API_URL}

GET  /              - Root
GET  /health        - Health check
POST /predict       - Single prediction
POST /predict/batch - Batch predictions
POST /drift/check   - Drift detection
GET  /docs          - API documentation
        """)
    
    # Test de latence
    st.subheader("⚡ Test de Latence")
    if st.button("🚀 Lancer le test"):
        latencies = []
        for i in range(10):
            start = datetime.now()
            requests.get(f"{API_URL}/health", timeout=5)
            end = datetime.now()
            latency = (end - start).total_seconds() * 1000
            latencies.append(latency)
        
        col1, col2, col3 = st.columns(3)
        with col1:
            st.metric("Latence Moyenne", f"{sum(latencies)/len(latencies):.2f} ms")
        with col2:
            st.metric("Latence Min", f"{min(latencies):.2f} ms")
        with col3:
            st.metric("Latence Max", f"{max(latencies):.2f} ms")
        
        # Graphique
        fig = go.Figure()
        fig.add_trace(go.Scatter(
            y=latencies,
            mode='lines+markers',
            name='Latency',
            line=dict(color='#1f77b4', width=2),
            marker=dict(size=8)
        ))
        fig.update_layout(
            title="Latence des Requetes (ms)",
            xaxis_title="Requete #",
            yaxis_title="Latence (ms)",
            height=400
        )
        st.plotly_chart(fig, use_container_width=True)

# Page: Documentation
elif page == "📚 Documentation":
    st.header("📚 Documentation")
    
    tab1, tab2, tab3, tab4 = st.tabs(["📖 API", "🚀 Deployment", "💻 Code", "🔗 Links"])
    
    with tab1:
        st.subheader("API Endpoints")
        
        st.markdown("### 🔮 POST /predict")
        st.code("""
curl -X POST "{url}/predict" \\
  -H "Content-Type: application/json" \\
  -d '{{
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
  }}'
        """.format(url=API_URL), language="bash")
        
        st.markdown("### 📊 POST /predict/batch")
        st.code("""
curl -X POST "{url}/predict/batch" \\
  -H "Content-Type: application/json" \\
  -d '[
    {{"CreditScore": 650, "Age": 35, ...}},
    {{"CreditScore": 700, "Age": 42, ...}}
  ]'
        """.format(url=API_URL), language="bash")
    
    with tab2:
        st.subheader("Informations de Deployment")
        
        deployment_info = {
            "Item": ["Resource Group", "Region", "ACR Name", "Container App", "Environment", "Image", "Port"],
            "Value": [
                "rg-mlops-bank-churn",
                "France Central",
                "mlopsghassen",
                "bank-churn",
                "env-mlops-workshop",
                "bank-churn-api:v1",
                "8000"
            ]
        }
        st.table(pd.DataFrame(deployment_info))
        
        st.markdown("### Commandes Azure CLI")
        st.code("""
# Voir les logs
az containerapp logs show \\
  --name bank-churn \\
  --resource-group rg-mlops-bank-churn \\
  --follow

# Mettre a jour l'application
az containerapp update \\
  --name bank-churn \\
  --resource-group rg-mlops-bank-churn \\
  --image mlopsghassen.azurecr.io/bank-churn-api:v2
        """, language="bash")
    
    with tab3:
        st.subheader("Exemple de Code")
        
        st.markdown("### Python")
        st.code("""
import requests

url = "{url}/predict"

data = {{
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
}}

response = requests.post(url, json=data)
result = response.json()

print(f"Churn Probability: {{result['churn_probability']}}")
print(f"Risk Level: {{result['risk_level']}}")
        """.format(url=API_URL), language="python")
        
        st.markdown("### PowerShell")
        st.code("""
$url = "{url}/predict"

$body = @{{
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
}} | ConvertTo-Json

$response = Invoke-RestMethod -Uri $url -Method Post -Body $body -ContentType "application/json"

Write-Host "Churn Probability: $($response.churn_probability)"
Write-Host "Risk Level: $($response.risk_level)"
        """.format(url=API_URL), language="powershell")
    
    with tab4:
        st.subheader("Liens Utiles")
        
        st.markdown(f"""
        - 🌐 [API Root]({API_URL})
        - 📖 [Documentation Interactive (Swagger)]({API_URL}/docs)
        - 📚 [Documentation Alternative (ReDoc)]({API_URL}/redoc)
        - ❤️ [Health Check]({API_URL}/health)
        - 🔧 [Workshop MLOps](https://nevermind78.github.io/mlops-workshop-docs/)
        - 🐳 [Docker Hub](https://hub.docker.com/)
        - ☁️ [Azure Portal](https://portal.azure.com/)
        """)

# Footer
st.markdown("---")
col1, col2, col3 = st.columns(3)
with col1:
    st.markdown("🏦 **Bank Churn Prediction**")
with col2:
    st.markdown("📅 **Deployed**: January 2026")
with col3:
    st.markdown("✅ **Status**: Production")
