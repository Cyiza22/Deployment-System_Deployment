from fastapi import FastAPI
import joblib
import numpy as np
from pydantic import BaseModel

# Load saved models
model = joblib.load("model.pkl")
scaler = joblib.load("scaler.pkl")
label_encoder = joblib.load("label_encoder.pkl")

# Initialize FastAPI app
app = FastAPI()

# Define request structure
class PredictionRequest(BaseModel):
    features: list[float]

# Prediction endpoint
@app.post("/predict")
async def predict(request: PredictionRequest):
    # Preprocess input
    scaled_features = scaler.transform([request.features])
    prediction = model.predict(scaled_features)
    
    # Decode prediction
    predicted_label = label_encoder.inverse_transform(prediction)[0]
    return {"prediction": predicted_label}

# Root endpoint
@app.get("/")
async def root():
    return {"message": "Welcome to the Student Dropout Prediction API"}
