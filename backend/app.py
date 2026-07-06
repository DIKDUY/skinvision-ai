import gradio as gr
import numpy as np
from PIL import Image
from pathlib import Path
from tensorflow.keras.models import load_model

# =========================
# Load Model
# =========================
BASE_DIR = Path(__file__).resolve().parent
model_path = BASE_DIR / "skin_cnn.keras"

print(f"Loading model from: {model_path}")

model = load_model(model_path)

# =========================
# Class Labels
# =========================
classes = {
    0: "Actinic Keratoses",
    1: "Basal Cell Carcinoma",
    2: "Benign Keratosis",
    3: "Dermatofibroma",
    4: "Melanoma",
    5: "Melanocytic Nevi",
    6: "Vascular Lesions",
}

# =========================
# Prediction Function
# =========================
def predict(image):
    if image is None:
        return "No image uploaded", 0.0

    image = image.convert("RGB")
    image = image.resize((128, 128))

    img = np.array(image, dtype=np.float32) / 255.0
    img = np.expand_dims(img, axis=0)

    pred = model.predict(img, verbose=0)

    idx = int(np.argmax(pred))
    confidence = float(np.max(pred))

    return classes[idx], confidence

# =========================
# Gradio UI
# =========================
demo = gr.Interface(
    fn=predict,
    inputs=gr.Image(type="pil"),
    outputs=[
        gr.Text(label="Prediction"),
        gr.Number(label="Confidence"),
    ],
    title="SkinVision AI",
    description="AI for skin disease classification using CNN",
)

demo.launch()