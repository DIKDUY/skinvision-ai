from fastapi import FastAPI, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
from pathlib import Path
import numpy as np

app = FastAPI(title="SkinVision AI API")

# ==========================================
# CORS
# ==========================================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==========================================
# Class Labels
# ==========================================
classes = {
    0: "Actinic Keratoses",
    1: "Basal Cell Carcinoma",
    2: "Benign Keratosis",
    3: "Dermatofibroma",
    4: "Melanoma",
    5: "Melanocytic Nevi",
    6: "Vascular Lesions",
}

# ==========================================
# Load Model
# ==========================================
BASE_DIR = Path(__file__).resolve().parent

model = None


@app.on_event("startup")
def load_model():
    global model

    try:
        from tensorflow.keras.models import load_model

        model_path = BASE_DIR / "model" / "skin_cnn.keras"

        print("=" * 50)
        print("Loading AI Model...")
        print(f"Model Path : {model_path}")

        if not model_path.exists():
            raise FileNotFoundError(f"Model tidak ditemukan: {model_path}")

        model = load_model(model_path)

        print("✅ Model loaded successfully")
        print("=" * 50)

    except Exception as e:
        print("=" * 50)
        print("❌ Model load failed")
        print(e)
        print("=" * 50)
        model = None


# ==========================================
# Home
# ==========================================
@app.get("/")
def home():
    return {
        "status": "API SkinVision running"
    }


# ==========================================
# Health Check
# ==========================================
@app.get("/health")
def health():
    return {
        "status": "ok",
        "model_loaded": model is not None
    }


# ==========================================
# Prediction
# ==========================================
@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    # Validasi file harus berupa gambar
    if not file.content_type or not file.content_type.startswith("image/"):
        return {
            "success": False,
            "error": "File harus berupa gambar."
        }

    try:
        image = Image.open(file.file).convert("RGB")
    except Exception:
        return {
            "success": False,
            "error": "Gagal membaca file gambar."
        }

    image = image.resize((128, 128))

    img = np.array(image, dtype=np.float32) / 255.0
    img = np.expand_dims(img, axis=0)

    if model is None:
        return {
            "success": False,
            "error": "Model not loaded"
        }

    pred = model.predict(img, verbose=0)

    idx = int(np.argmax(pred))

    return {
        "success": True,
        "disease": classes[idx],
        "confidence": float(np.max(pred))
    }