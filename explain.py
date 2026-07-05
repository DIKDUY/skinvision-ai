import os
import shap
import numpy as np
import matplotlib.pyplot as plt


def generate_shap(model, image):
    """
    Generate SHAP explanation image.

    Parameters
    ----------
    model : tensorflow model
    image : numpy array (1,128,128,3)

    Returns
    -------
    str | None
        path gambar shap
    """

    try:

        os.makedirs("shap_images", exist_ok=True)

        background = np.zeros(
            (1, 128, 128, 3),
            dtype=np.float32
        )

        explainer = shap.GradientExplainer(
            model,
            background
        )

        shap_values = explainer.shap_values(image)

        if isinstance(shap_values, list):
            shap_map = shap_values[0][0]
        else:
            shap_map = shap_values[0]

        heatmap = np.abs(
            shap_map
        ).mean(axis=-1)

        output_path = os.path.join(
            "shap_images",
            "shap_result.png"
        )

        original = image[0]

        fig, ax = plt.subplots(
            figsize=(6, 6)
        )

        ax.imshow(original)

        ax.imshow(
            heatmap,
            cmap="jet",
            alpha=0.45
        )

        ax.set_title(
            "SHAP Explainability"
        )

        ax.axis("off")

        plt.tight_layout()

        plt.savefig(
            output_path,
            dpi=300,
            bbox_inches="tight"
        )

        plt.close(fig)

        return output_path

    except Exception as e:

        print("========== SHAP ERROR ==========")
        print(e)
        print("================================")

        return None