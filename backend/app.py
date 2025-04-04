from flask import Flask, request, jsonify
import pandas as pd
import joblib
import os

app = Flask(__name__)

# Load model with verification
MODEL_PATH = 'models/model.pkl'
SCALER_PATH = 'models/scaler.pkl'

if not all(os.path.exists(p) for p in [MODEL_PATH, SCALER_PATH]):
    raise FileNotFoundError("Model files missing. Run the notebook first!")

model = joblib.load(MODEL_PATH)
scaler = joblib.load(SCALER_PATH)

# ... [keep all existing routes from previous implementation] ...