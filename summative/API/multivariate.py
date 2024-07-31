from fastapi import FastAPI              
from pydantic import BaseModel
import joblib
import numpy as np
from fastapi.middleware.cors import CORSMiddleware
import uvicorn


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

model = joblib.load('multivariate.joblib')
scaler = joblib.load('scaler.joblib')

class Body(BaseModel):
    number_courses: int
    time_study: float

@app.get('/')
def read_root():
    return {"message": "FastAPI by Prince Ndanyuzwe that predicts student marks using time studied and number of courses"}

@app.post('/predict')
def predict(data: Body):
    body = np.array([[
        data.number_courses,
        data.time_study
    ]])

    scaled = scaler.transform(body)
    predicted = model.predict(scaled)
    final_value = predicted[0]

    return {"predicted_marks": final_value}

if __name__ == '__main__':
   uvicorn.run(app, host='127.0.0.1', port=3000)
