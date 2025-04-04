from locust import HttpUser, task, between

class PredictorUser(HttpUser):
    wait_time = between(1, 3)

    @task
    def predict(self):
        self.client.post("/predict", json={
            "Age at enrollment": 25,
            "Previous qualification (grade)": 150,
            # Add all other features...
        })