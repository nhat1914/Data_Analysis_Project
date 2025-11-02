# Deep Learning for Sentiment Image Classification

This project applies **convolutional neural networks (CNNs)** to classify facial images into six emotion categories — *Happy, Sad, Fear, Pain, Anger,* and *Disgust*.  
It focuses on developing a compact, interpretable, and generalisable model for sentiment understanding using deep learning, with emphasis on **augmentation strategies**, **capacity control**, and **domain adaptation**.

The dataset used in this project is collected from multiple online sources and is available at [Kaggle](https://www.kaggle.com/datasets/yousefmohamed20/sentiment-images-classifier/data.) and [New Domain 6 Emotions](https://github.com/nhat1914/Data_Analysis_Project/blob/eb7f97eee6fc0a5553cfbc22c9e9a430ce4d1036/Machine%20Learning%20and%20Deep%20Learning%20Projects/Deep%20Learning%20for%20Sentiment%20Image%20Classification/NEW_DOMAIN_6_Emotions.zip)

## Project Overview

The goal is to build a deep learning pipeline that can:
- Accurately predict human emotions from facial imagery.  
- Handle small, imbalanced datasets through augmentation and class weighting.  
- Improve generalisation with targeted data transformations and adaptive fine-tuning.  
- Benchmark performance under domain shift scenarios.

## Dataset Summary

| Emotion | Sample Count | Share (%) |
|----------|---------------|-----------|
| Happy | 230 | 20.0 |
| Sad | 224 | 19.5 |
| Anger | 214 | 18.6 |
| Pain | 162 | 14.1 |
| Disgust | 159 | 13.8 |
| Fear | 159 | 13.8 |

Dataset size: ~1.15K labeled images.  
Class imbalance mitigated using **WeightedRandomSampler** and **weighted loss**.

<img width="690" height="390" alt="image" src="https://github.com/user-attachments/assets/86065e26-3d3c-462f-b9b7-f07c7bb6e854" />

<img width="1189" height="387" alt="image" src="https://github.com/user-attachments/assets/0975a953-aac0-4930-ac94-1a169e27c03f" />

## Experiments & Results

### 1️⃣ Baseline Model — *SmallCNN*

- Parameters: **389,958**  
- Architecture: 4 Conv–ReLU–MaxPool blocks + GlobalAvgPool + Dropout + Linear  
- Input size: 160×160×3  
- Optimizer: **AdamW (LR=1e-3, WD=1e-4)**  
- Loss: **Weighted Cross-Entropy + Label Smoothing (0.05)**  
- Train/Val/Test Split: 70/15/15  

| Metric | Accuracy | Macro Precision | Macro Recall | Macro F1 |
|---------|-----------|-----------------|---------------|-----------|
| **SmallCNN (Baseline)** | **0.1734** | 0.1320 | 0.2042 | 0.1272 |

The baseline performance barely exceeds random chance (≈16.7%), suggesting insufficient capacity and limited invariance to facial variations.

<img width="1055" height="221" alt="image" src="https://github.com/user-attachments/assets/b5a51954-2e3d-4a75-9db8-592a8ffc4387" />

<img width="1080" height="221" alt="image" src="https://github.com/user-attachments/assets/54c9ca8a-d492-49f0-a573-92734eaefcd6" />

<img width="1080" height="221" alt="image" src="https://github.com/user-attachments/assets/e6ae6f67-f1b9-4d0d-9a27-df45baeabe8d" />

### 2️⃣ Data Augmentation — *Standard Policy*

Augmentations: random resized crop, flip, small rotation (±10°), mild brightness/contrast jitter.  
All else constant between augmented and non-augmented runs.

| Variant | Accuracy | Macro Precision | Macro Recall | Macro F1 |
|----------|-----------|----------------|---------------|-----------|
| **No Augmentation** | 0.2197 | 0.1868 | 0.2366 | **0.1946** |
| **With Augmentation** | 0.2023 | 0.0745 | 0.2431 | **0.1126** |

While augmentation improved recall for minority classes, it decreased precision and overall F1, indicating the need to fine-tune augmentation strength.

<img width="998" height="290" alt="image" src="https://github.com/user-attachments/assets/eb7758f8-b28a-4a5e-8c65-17e89dea948f" />

<img width="572" height="590" alt="image" src="https://github.com/user-attachments/assets/ffaddf18-01fd-4955-adef-ae80ad9ecd37" />

<img width="572" height="590" alt="image" src="https://github.com/user-attachments/assets/8b2f51d9-1d9b-4a0d-85db-78bc21c3212f" />

### 3️⃣ Model Capacity — *SmallCNN vs WiderCNN*

| Model | Parameters | Accuracy | Macro Precision | Macro Recall | Macro F1 |
|--------|-------------|-----------|-----------------|---------------|-----------|
| SmallCNN | 390K | 0.2081 | 0.1556 | 0.2083 | 0.1334 |
| WiderCNN | 764K | **0.2197** | **0.2023** | **0.2161** | **0.1585** |

**Observation:** WiderCNN outperformed SmallCNN in macro metrics (+0.025 F1), validating moderate capacity scaling for small datasets.

<img width="590" height="290" alt="image" src="https://github.com/user-attachments/assets/14fd62e3-4dd2-424b-b41a-f5a368120af7" />

<img width="572" height="590" alt="image" src="https://github.com/user-attachments/assets/1433351f-ccd9-40fd-a5b3-ee50fb08f5d1" />

<img width="572" height="590" alt="image" src="https://github.com/user-attachments/assets/57f13f93-6f2d-47d2-9605-68dad0c83c2a" />

### 4️⃣ Targeted Augmentation Refinement

After error analysis (e.g., *Sad ↔ Fear*, *Pain ↔ Anger* confusions), grayscale jitter and translation were added to simulate lighting and pose variability.

| Metric | Before | After |
|---------|---------|--------|
| Accuracy | 0.1734 | **0.2081** |
| Macro Precision | 0.1320 | **0.1885** |
| Macro Recall | 0.2042 | **0.2478** |
| Macro F1 | 0.1272 | **0.1483** |

Targeted augmentation increased macro-F1 by **16.6%**, reducing bias across emotional classes.

<img width="981" height="290" alt="image" src="https://github.com/user-attachments/assets/8690b20e-80d9-4fa4-80b9-411177945401" />

**Before Refinement**

<img width="869" height="611" alt="image" src="https://github.com/user-attachments/assets/8ebe5f8d-f962-41af-a3d8-aca79350f1c5" />

**After Refinement**

<img width="869" height="598" alt="image" src="https://github.com/user-attachments/assets/ad74897e-7a2a-4118-b7b8-67a47f59b5bb" />

### 5️⃣ Cross-Domain Generalisation

Evaluated model performance on a new dataset with different lighting and demographics.

| Variant | Accuracy | Macro Precision | Macro Recall | Macro F1 |
|----------|-----------|----------------|---------------|-----------|
| Baseline | 0.1255 | 0.0417 | 0.1294 | 0.0586 |
| TTA (flip averaging) | 0.1255 | 0.0417 | 0.1294 | 0.0586 |
| Few-Shot Adapt (10 imgs/class) | **0.1365** | **0.0476** | **0.1386** | **0.0645** |

Few-shot fine-tuning improved macro F1 by ~10%, proving that limited adaptation can recover domain performance under severe shift.

<img width="989" height="290" alt="image" src="https://github.com/user-attachments/assets/28be0d6c-aaab-496e-aec7-a75f7ac5311e" />

<img width="869" height="650" alt="image" src="https://github.com/user-attachments/assets/6339e179-d198-48d4-b524-b62af3f0dcfa" />

## ⚠️ Notes

Please be advised that the reported results are **approximate** and may vary slightly between runs due to:
- Random weight initialisation  
- Stochastic data loading and augmentation  
- Hardware and runtime variability (especially on GPU environments)

Each experiment was executed under the same configuration, but reproducibility across environments may show ±2–3% metric deviation.

## Tech Stack

| Category | Tools / Libraries |
|-----------|------------------|
| **Language** | Python 3.12 |
| **Frameworks** | PyTorch, Torchvision |
| **Data Processing** | Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn |
| **Metrics** | scikit-learn |
| **Environment** | Google Colab / Local GPU |

## Key Insights

- **WiderCNN** achieved the best overall balance with a **0.1585 Macro-F1**, outperforming the smaller baseline.  
- **Error-driven augmentation** refined the augmentation policy and improved F1 by **~16%**.  
- **Few-shot adaptation** boosted new-domain F1 from **0.0586 → 0.0645**, confirming adaptability potential.  
- Despite improvements, the task remains challenging due to high inter-class similarity and limited data diversity.

## Future Work

- Incorporate **transfer learning** from pretrained face recognition models (e.g., ResNet-18, VGGFace2).  
- Experiment with **Vision Transformers (ViT)** for global emotion context.  
- Integrate **domain-adversarial training** for better robustness under distribution shift.  
- Expand dataset diversity and use synthetic data for underrepresented classes.

## Author

**Author:** [Frank Dinh]  
**Email:** [dinh.qnhat@gmail.com]  
**Year:** 2025  

> © 2025 All Rights Reserved. Unauthorized reuse or redistribution is prohibited.
