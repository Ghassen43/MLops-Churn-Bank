# Lancer l'application Streamlit
Write-Host "`nLancement de l'application Streamlit...`n" -ForegroundColor Cyan

# Verifier si streamlit est installe
$streamlitInstalled = pip list | Select-String "streamlit"

if (-not $streamlitInstalled) {
    Write-Host "Installation des dependances Streamlit..." -ForegroundColor Yellow
    pip install -r requirements-streamlit.txt
    Write-Host "Installation terminee" -ForegroundColor Green
}

# Lancer l'application
Write-Host "`nOuverture de l'application Streamlit..." -ForegroundColor Green
Write-Host "URL: http://localhost:8501" -ForegroundColor Cyan
Write-Host "`nAppuyez sur Ctrl+C pour arreter l'application`n" -ForegroundColor Yellow

streamlit run streamlit_app.py
