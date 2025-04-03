from sklearn.preprocessing import LabelEncoder
import joblib
import pandas as pd

# Load your dataset
df = pd.read_csv("data.csv", sep=';')  # Replace with the path to your dataset

# Create and train the LabelEncoder
label_encoder = LabelEncoder()

# Fit and transform the target column (change 'Target' to your actual column name)
df['Target'] = label_encoder.fit_transform(df['Target'])  # Replace 'Target' with your column name

# Save the trained encoder to a file
joblib.dump(label_encoder, "label_encoder.pkl")

print("LabelEncoder saved as 'label_encoder.pkl'.")
