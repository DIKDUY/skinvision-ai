from fastapi import FastAPI, UploadFile, File
from fastapi.staticfiles import StaticFiles

from tensorflow.keras.models import load_model

from PIL import Image

import numpy as np
import os

from explain import generate_shap

app = FastAPI(
    title="SkinVision AI API",
    version="1.0"
)

os.makedirs(
    "shap_images",
    exist_ok=True
)

app.mount(
    "/shap",
    StaticFiles(directory="shap_images"),
    name="shap"
)

print("Loading CNN Model...")

model = load_model(
    "model/skin_cnn.keras"
)

print("Model Loaded!")

classes = {
    0: "Actinic Keratoses",
    1: "Basal Cell Carcinoma",
    2: "Benign Keratosis",
    3: "Dermatofibroma",
    4: "Melanoma",
    5: "Melanocytic Nevi",
    6: "Vascular Lesions"
}


@app.get("/")
def home():

    return {
        "status": "success",
        "message": "SkinVision AI API Running"
    }


@app.post("/predict")
async def predict(
    file: UploadFile = File(...)
):

    try:

        image = Image.open(file.file)

        image = image.convert("RGB")

        image = image.resize(
            (128, 128)
        )

        image = np.array(
            image,
            dtype=np.float32
        )

        image = image / 255.0

        image = np.expand_dims(
            image,
            axis=0
        )

        prediction = model.predict(
            image,
            verbose=0
        )

        index = int(
            np.argmax(prediction)
        )

        disease = classes[index]

        confidence = float(
            np.max(prediction)
        )

        shap_path = generate_shap(
            model,
            image
        )

        if shap_path is not None:

            shap_image = "/shap/shap_result.png"

        else:

            shap_image = ""

        return {

            "success": True,

            "disease": disease,

            "confidence": round(
                confidence * 100,
                2
            ),

            "shap_image": shap_image

        }

    except Exception as e:

        return {

            "success": False,

            "error": str(e)

        }