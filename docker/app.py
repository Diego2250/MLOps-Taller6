# src/pipeline/app.py
from fastapi import FastAPI
import joblib
import pandas as pd


app = FastAPI()

# Carga del modelo entrenado
# Asegúrate de montar o copiar pipeline_best.joblib en la imagen
try:
    model = joblib.load("/data/model.joblib")
except Exception:
    model = None

@app.get("/")
def root():
    return {"status": "ok", "msg": "API corriendo 🚀"}

@app.post("/predict")
def predict(features: dict):
    if model is None:
        return {"error": "Modelo no disponible"}
    df = pd.DataFrame([features])
    pred = model.predict(df)[0]
    return {"prediction": int(pred)}