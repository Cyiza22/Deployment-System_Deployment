from sqlalchemy import Column, Integer, String
from database import Base

class Prediction(Base):
    __tablename__ = "predictions"

    id = Column(Integer, primary_key=True, index=True)
    student_id = Column(Integer, unique=True, nullable=False)
    prediction_result = Column(String, nullable=False)
