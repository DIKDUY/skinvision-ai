import gradio as gr
import numpy as np
import matplotlib.pyplot as plt

from PIL import Image
from pathlib import Path

from tensorflow.keras.models import load_model

# =====================================================
# Load CNN Model
# =====================================================

BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "skin_cnn.keras"

print("=" * 60)
print("🩺 SkinVision AI")
print(f"Loading model from: {MODEL_PATH}")
print("=" * 60)

model = load_model(MODEL_PATH)

print("✅ Model loaded successfully!")
print("=" * 60)

# =====================================================
# Skin Disease Classes
# =====================================================

classes = {
    0: "Actinic Keratoses",
    1: "Basal Cell Carcinoma",
    2: "Benign Keratosis",
    3: "Dermatofibroma",
    4: "Melanoma",
    5: "Melanocytic Nevi",
    6: "Vascular Lesions",
}

# =====================================================
# Disease Information
# =====================================================

info = {

    "Actinic Keratoses": {
        "emoji": "🟡",
        "description": "Actinic Keratoses is a rough and scaly skin lesion caused by long-term sun exposure. Although often considered precancerous, early treatment can prevent progression.",
        "recommendation": "Consult a dermatologist for examination and appropriate treatment."
    },

    "Basal Cell Carcinoma": {
        "emoji": "🔵",
        "description": "Basal Cell Carcinoma is the most common form of skin cancer. It usually grows slowly and rarely spreads but should be treated promptly.",
        "recommendation": "Seek medical treatment to prevent further tissue damage."
    },

    "Benign Keratosis": {
        "emoji": "🟢",
        "description": "Benign Keratosis is a non-cancerous skin growth that generally does not require treatment unless symptoms develop.",
        "recommendation": "Monitor the lesion and consult a doctor if any changes occur."
    },

    "Dermatofibroma": {
        "emoji": "🟤",
        "description": "Dermatofibroma is a benign skin nodule that is usually harmless and stable over time.",
        "recommendation": "Medical treatment is usually unnecessary unless the lesion becomes painful or changes."
    },

    "Melanoma": {
        "emoji": "🔴",
        "description": "Melanoma is one of the most dangerous types of skin cancer because it can spread rapidly to other organs if left untreated.",
        "recommendation": "Seek immediate evaluation by a dermatologist or oncologist."
    },

    "Melanocytic Nevi": {
        "emoji": "🟣",
        "description": "Melanocytic Nevi are common moles that are generally benign. Most remain harmless throughout life.",
        "recommendation": "Monitor for changes in size, color, border, or shape."
    },

    "Vascular Lesions": {
        "emoji": "🩷",
        "description": "Vascular Lesions are abnormalities of blood vessels that are often benign but may require evaluation if symptoms appear.",
        "recommendation": "Consult a healthcare professional if the lesion grows, bleeds, or becomes painful."
    }

}

# =====================================================
# Probability Chart
# =====================================================

def create_chart(pred):

    labels = list(classes.values())
    values = pred * 100

    fig, ax = plt.subplots(figsize=(8,4))

    bars = ax.barh(labels, values)

    ax.set_xlim(0,100)
    ax.set_xlabel("Confidence (%)")
    ax.set_title("Prediction Probability")

    for bar, value in zip(bars, values):
        ax.text(
            value + 1,
            bar.get_y() + bar.get_height()/2,
            f"{value:.2f}%",
            va="center",
            fontsize=9
        )

    plt.tight_layout()

    return fig

# =====================================================
# Prediction Function
# =====================================================

def predict(image):

    if image is None:

        return (
            "",
            "",
            "",
            "",
            "",
            None
        )

    image = image.convert("RGB")
    image = image.resize((128,128))

    img = np.array(image,dtype=np.float32)/255.0
    img = np.expand_dims(img,axis=0)

    pred = model.predict(img,verbose=0)[0]

    idx = int(np.argmax(pred))
    disease = classes[idx]

    confidence = float(pred[idx])*100

    data = info[disease]

    prediction = f"{data['emoji']} {disease}"

    confidence_text = f"{confidence:.2f}%"

    top3 = np.argsort(pred)[::-1][:3]

    top3_text = ""

    for i in top3:
        top3_text += f"• {classes[i]} : {pred[i]*100:.2f}%\n"

    chart = create_chart(pred)

    return (

        prediction,

        confidence_text,

        data["description"],

        data["recommendation"],

        top3_text,

        chart

    )

# =====================================================
# User Interface
# =====================================================

with gr.Blocks(
    title="SkinVision AI",
    theme=gr.themes.Soft(),
) as demo:

    gr.Markdown(
        """
# 🩺 SkinVision AI

### AI-Based Skin Disease Classification using Convolutional Neural Network (CNN)

Upload a skin lesion image and click **Analyze Image** to receive the AI prediction.

---
"""
    )

    with gr.Row():

        # ==========================
        # LEFT PANEL
        # ==========================
        with gr.Column(scale=1):

            image = gr.Image(
                type="pil",
                label="📷 Upload Skin Image",
                height=420
            )

            analyze_btn = gr.Button(
                "🔍 Analyze Image",
                variant="primary",
                size="lg"
            )

            clear_btn = gr.Button(
                "🗑️ Clear",
                variant="secondary"
            )

        # ==========================
        # RIGHT PANEL
        # ==========================
        with gr.Column(scale=1):

            prediction = gr.Textbox(
                label="🩺 Prediction",
                interactive=False
            )

            confidence = gr.Textbox(
                label="📊 Confidence (%)",
                interactive=False
            )

            description = gr.Textbox(
                label="📖 Description",
                lines=5,
                interactive=False
            )

            recommendation = gr.Textbox(
                label="💡 Recommendation",
                lines=5,
                interactive=False
            )

            top3 = gr.Textbox(
                label="🏆 Top 3 Predictions",
                lines=4,
                interactive=False
            )

            probability_chart = gr.Plot(
                label="📊 Prediction Probability"
            )

    # ==========================
    # Button Action
    # ==========================

    analyze_btn.click(
        fn=predict,
        inputs=image,
        outputs=[
            prediction,
            confidence,
            description,
            recommendation,
            top3,
            probability_chart
        ]
    )

    clear_btn.click(
        lambda: (
            "",
            "",
            "",
            "",
            "",
            None,
            None
        ),
        outputs=[
            prediction,
            confidence,
            description,
            recommendation,
            top3,
            probability_chart,
            image
        ]
    )

    # ==========================
    # Footer
    # ==========================

    gr.Markdown(
        """
---

## 📷 Tips for Better Prediction

✅ Use a clear image of the skin lesion.

✅ Ensure good lighting.

✅ Keep the camera focused.

✅ Avoid blurry or low-resolution images.

✅ The skin lesion should occupy most of the image.

---

## ⚠️ Medical Disclaimer

This application is intended for educational and research purposes only.

The AI model was trained using the HAM10000 Dataset and recognizes only seven categories of skin lesions.

This application **does not replace professional medical diagnosis**.

Always consult a qualified dermatologist for confirmation.

---

### 🚀 Developed with

**TensorFlow • CNN • Gradio • Hugging Face Spaces**
"""
    )