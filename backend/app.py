import gradio as gr
import numpy as np
import matplotlib.pyplot as plt

from PIL import Image
from pathlib import Path

from tensorflow.keras.models import load_model


# =====================================================
# Configuration
# =====================================================

IMAGE_SIZE = (128, 128)


# =====================================================
# Load CNN Model
# =====================================================

BASE_DIR = Path(__file__).resolve().parent

MODEL_PATH = BASE_DIR / "skin_cnn.keras"


print("=" * 60)
print("🩺 SkinVision AI")
print(f"Loading model from: {MODEL_PATH}")
print("=" * 60)


if not MODEL_PATH.exists():
    raise FileNotFoundError(
        f"Model tidak ditemukan: {MODEL_PATH}"
    )


model = load_model(MODEL_PATH)


print("✅ Model berhasil dimuat")
print("=" * 60)

# =====================================================
# Skin Disease Classes
# =====================================================

CLASSES = [

    "Actinic Keratoses",
    "Basal Cell Carcinoma",
    "Benign Keratosis",
    "Dermatofibroma",
    "Melanoma",
    "Melanocytic Nevi",
    "Vascular Lesions"

]


# =====================================================
# Disease Information
# =====================================================

DISEASE_INFO = {


    "Actinic Keratoses": {

        "emoji": "🟡",

        "description":
        "Actinic Keratoses is a rough, scaly skin lesion caused by long-term exposure to ultraviolet (UV) radiation. It is considered a precancerous condition that may develop into skin cancer.",

        "recommendation":
        "Consult a dermatologist for evaluation. Use sunscreen regularly and protect skin from excessive sunlight."

    },


    "Basal Cell Carcinoma": {

        "emoji": "🔵",

        "description":
        "Basal Cell Carcinoma is the most common type of skin cancer. It usually grows slowly but requires treatment to prevent tissue damage.",

        "recommendation":
        "Seek medical evaluation from a dermatologist for proper diagnosis and treatment."

    },


    "Benign Keratosis": {

        "emoji": "🟢",

        "description":
        "Benign Keratosis is a harmless skin growth that is usually not cancerous.",

        "recommendation":
        "Monitor the lesion. Consult a healthcare professional if changes occur."

    },


    "Dermatofibroma": {

        "emoji": "🟤",

        "description":
        "Dermatofibroma is a benign skin nodule that commonly appears after minor skin injuries.",

        "recommendation":
        "Usually does not require treatment unless it changes or causes discomfort."

    },


    "Melanoma": {

        "emoji": "🔴",

        "description":
        "Melanoma is an aggressive form of skin cancer that can spread quickly if not detected early.",

        "recommendation":
        "Seek immediate professional medical evaluation if melanoma is suspected."

    },


    "Melanocytic Nevi": {

        "emoji": "🟣",

        "description":
        "Melanocytic Nevi are common moles formed by pigment-producing cells. Most are benign.",

        "recommendation":
        "Monitor ABCDE signs: Asymmetry, Border, Color, Diameter, and Evolution."

    },


    "Vascular Lesions": {

        "emoji": "🩷",

        "description":
        "Vascular Lesions are abnormalities involving blood vessels. Many are harmless.",

        "recommendation":
        "Consult a healthcare professional if the lesion grows, bleeds, or becomes painful."

    }

}

# =====================================================
# Image Preprocessing
# =====================================================

def preprocess_image(image: Image.Image):

    image = image.convert("RGB")

    image = image.resize(
        IMAGE_SIZE
    )


    img = np.asarray(
        image,
        dtype=np.float32
    )


    img = img / 255.0


    img = np.expand_dims(
        img,
        axis=0
    )


    return img



# =====================================================
# Probability Chart
# =====================================================

def create_chart(predictions):

    labels = CLASSES

    values = predictions * 100


    fig, ax = plt.subplots(
        figsize=(8, 4)
    )


    bars = ax.barh(
        labels,
        values
    )


    ax.set_xlim(
        0,
        100
    )


    ax.set_xlabel(
        "Confidence (%)"
    )


    ax.set_title(
        "Prediction Probability"
    )


    for bar, value in zip(
        bars,
        values
    ):

        ax.text(
            value + 1,
            bar.get_y() + bar.get_height() / 2,
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


    try:

        # Preprocess image
        img = preprocess_image(image)


        # Model prediction
        predictions = model.predict(
            img,
            verbose=0
        )[0]


        # Get highest probability
        predicted_index = int(
            np.argmax(predictions)
        )


        disease = CLASSES[predicted_index]


        confidence = float(
            predictions[predicted_index] * 100
        )


        disease_info = DISEASE_INFO[disease]


        prediction_text = (

            f"{disease_info['emoji']} {disease}"

        )


        confidence_text = (

            f"{confidence:.2f}%"

        )


        # Top 3 prediction

        top3_indices = np.argsort(
            predictions
        )[::-1][:3]


        top3_text = ""


        for idx in top3_indices:

            top3_text += (

                f"• {CLASSES[idx]} : "
                f"{predictions[idx] * 100:.2f}%\n"

            )


        chart = create_chart(
            predictions
        )


        return (

            prediction_text,

            confidence_text,

            disease_info["description"],

            disease_info["recommendation"],

            top3_text.strip(),

            chart

        )


    except Exception as e:


        return (

            "Prediction Failed",

            "-",

            str(e),

            "Please try another image.",

            "",

            None

        )
    
# =====================================================
# Gradio Application
# =====================================================

with gr.Blocks(
    title="SkinVision AI"
) as demo:


    gr.Markdown(
        """
# 🩺 SkinVision AI

AI-based skin lesion classification using CNN.

Upload an image of a skin lesion to get prediction results.

⚠️ This application is for educational and research purposes only.
"""
    )


    with gr.Row():

        with gr.Column():

            input_image = gr.Image(
                type="pil",
                label="Upload Skin Image"
            )


            predict_button = gr.Button(
                "🔍 Analyze Image",
                variant="primary"
            )


        with gr.Column():

            prediction_output = gr.Textbox(
                label="Prediction"
            )


            confidence_output = gr.Textbox(
                label="Confidence"
            )


    description_output = gr.Textbox(
        label="Disease Description",
        lines=5
    )


    recommendation_output = gr.Textbox(
        label="Recommendation",
        lines=5
    )


    top3_output = gr.Textbox(
        label="Top 3 Predictions",
        lines=5
    )


    chart_output = gr.Plot(
        label="Probability Chart"
    )



    predict_button.click(

        fn=predict,

        inputs=input_image,

        outputs=[

            prediction_output,

            confidence_output,

            description_output,

            recommendation_output,

            top3_output,

            chart_output

        ]

    )

# =====================================================
# Footer
# =====================================================

with demo:

    gr.Markdown(
        """
---

## 📷 Tips for Better Prediction

- ✅ Use a clear image of the skin lesion.
- ✅ Ensure good lighting conditions.
- ✅ Keep the camera focused.
- ✅ Avoid blurry or low-resolution images.
- ✅ Make sure the lesion occupies most of the image.

---

## ⚠️ Medical Disclaimer

This application is intended **only for educational and research purposes**.

The AI model was trained using the **HAM10000 Dataset** and recognizes only **seven categories of skin lesions**.

The prediction result **does not replace professional medical diagnosis**.

Always consult a qualified dermatologist for proper medical evaluation and treatment.

---

### 🚀 Developed With

TensorFlow • CNN • Gradio • Hugging Face Spaces

"""
    )



# =====================================================
# Launch Application
# =====================================================

if __name__ == "__main__":

    demo.launch()