from fastapi import FastAPI, Depends, HTTPException, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
import pandas as pd
import pickle
import os
from database import SessionLocal
from models import Prediction

app = FastAPI()

# Enable CORS to allow frontend to access backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Change this to your frontend's URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load trained model
MODEL_PATH = "model.pkl"
if os.path.exists(MODEL_PATH):
    with open(MODEL_PATH, "rb") as file:
        model = pickle.load(file)
else:
    raise Exception("Model file not found!")

# Dependency to get database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Prediction API
@app.post("/predict/")
async def predict(student_id: int, feature1: float, feature2: float, db: Session = Depends(get_db)):
    try:
        input_data = [[feature1, feature2]]  # Modify based on dataset features
        prediction_result = model.predict(input_data)[0]

        # Save prediction in DB
        prediction = Prediction(student_id=student_id, prediction_result=prediction_result)
        db.add(prediction)
        db.commit()

        return {"student_id": student_id, "prediction": prediction_result}
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# Retraining API
@app.post("/retrain/")
async def retrain_model(file: UploadFile = File(...)):
    try:
        df = pd.read_csv(file.file)  # Load uploaded dataset

        # Extract features & labels
        X = df.drop(columns=["target"])  # Modify based on dataset
        y = df["target"]

        # Train a new model
        from sklearn.linear_model import LogisticRegression
        new_model = LogisticRegression()
        new_model.fit(X, y)

        # Save new model
        with open(MODEL_PATH, "wb") as file:
            pickle.dump(new_model, file)

        return {"message": "Model retrained successfully!"}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
