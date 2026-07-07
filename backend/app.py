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
        "Actinic Keratoses merupakan kelainan kulit yang ditandai dengan bercak kasar dan bersisik akibat paparan sinar ultraviolet (UV) dalam jangka waktu lama. Kondisi ini termasuk lesi prakanker yang berpotensi berkembang menjadi kanker kulit apabila tidak ditangani.",

        "recommendation":
        "Disarankan untuk berkonsultasi dengan dokter spesialis kulit. Gunakan tabir surya secara rutin dan hindari paparan sinar matahari berlebihan."

    },

    "Basal Cell Carcinoma": {

        "emoji": "🔵",

        "description":
        "Basal Cell Carcinoma adalah jenis kanker kulit yang paling umum terjadi. Penyakit ini biasanya tumbuh secara perlahan, namun tetap memerlukan penanganan medis agar tidak merusak jaringan di sekitarnya.",

        "recommendation":
        "Segera lakukan pemeriksaan ke dokter spesialis kulit untuk mendapatkan diagnosis dan penanganan yang tepat."

    },

    "Benign Keratosis": {

        "emoji": "🟢",

        "description":
        "Benign Keratosis merupakan pertumbuhan jaringan kulit yang bersifat jinak dan umumnya tidak berbahaya. Meskipun demikian, perubahan bentuk atau warna tetap perlu diperhatikan.",

        "recommendation":
        "Lakukan pemantauan secara berkala dan konsultasikan dengan tenaga medis apabila terjadi perubahan pada lesi."

    },

    "Dermatofibroma": {

        "emoji": "🟤",

        "description":
        "Dermatofibroma adalah benjolan kecil pada kulit yang bersifat jinak dan sering muncul setelah cedera ringan, seperti gigitan serangga atau luka kecil.",

        "recommendation":
        "Umumnya tidak memerlukan pengobatan. Namun, segera konsultasikan ke dokter apabila benjolan membesar, berubah warna, atau terasa nyeri."

    },

    "Melanoma": {

        "emoji": "🔴",

        "description":
        "Melanoma merupakan salah satu jenis kanker kulit yang paling berbahaya karena dapat menyebar dengan cepat ke organ tubuh lain apabila tidak terdeteksi sejak dini.",

        "recommendation":
        "Segera lakukan pemeriksaan ke dokter spesialis kulit apabila ditemukan perubahan bentuk, ukuran, atau warna pada tahi lalat maupun lesi kulit."

    },

    "Melanocytic Nevi": {

        "emoji": "🟣",

        "description":
        "Melanocytic Nevi adalah tahi lalat yang terbentuk dari kumpulan sel penghasil pigmen kulit (melanosit). Sebagian besar bersifat jinak, namun tetap perlu dipantau apabila mengalami perubahan.",

        "recommendation":
        "Perhatikan perubahan menggunakan metode ABCDE (Asymmetry, Border, Color, Diameter, dan Evolution). Konsultasikan dengan dokter apabila ditemukan perubahan yang mencurigakan."

    },

    "Vascular Lesions": {

        "emoji": "🩷",

        "description":
        "Vascular Lesions merupakan kelainan pada pembuluh darah yang tampak sebagai bercak atau benjolan berwarna merah hingga keunguan pada kulit. Sebagian besar bersifat jinak.",

        "recommendation":
        "Segera konsultasikan dengan dokter apabila lesi bertambah besar, mudah berdarah, terasa nyeri, atau mengalami perubahan bentuk."

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

# =====================================================
# Probability Chart
# =====================================================

def create_chart(predictions):

    labels = CLASSES

    values = predictions * 100


    fig, ax = plt.subplots(
        figsize=(8, 4)
    )


    ax.barh(
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


    for i, value in enumerate(values):

        ax.text(
            value + 1,
            i,
            f"{value:.2f}%",
            va="center"
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