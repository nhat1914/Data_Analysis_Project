# Meta Business Analysis

A comprehensive end-to-end analytics and machine learning project exploring **Google Maps business reviews** using **PySpark, Pandas, NLP, and Time Series Forecasting**.  
This project integrates data wrangling, visualization, sentiment analysis, and recommender system design — all within a single, production-style workflow.

---

## Project Overview

The **Meta Business Analysis** project demonstrates how large-scale public review data can be transformed into actionable insights.  
It showcases the **full data science pipeline** — from raw data ingestion to forecasting and recommendation generation.

> **Goal:** To analyse online business reviews, extract customer insights, forecast engagement trends, and build data-driven recommendation systems.

### Key Highlights

- Data engineering using **PySpark** for scalable ETL and cleansing  
- Text cleaning, tokenization, and **NLP analysis** of >500K review texts  
- Sentiment tracking and **keyword frequency trends over years**  
- Exploratory visuals — **ratings, peak hours, category heatmaps**  
- **Hybrid recommender system** using content-based + collaborative filtering  
- **Time series forecasting** with ARIMA to predict review activity  
- Deep learning roadmap (LSTM / GRU) for future enhancement  
- Business & reviewer-level behaviour profiling (cosine similarity clusters)

---

## Data Sources

| File | Description |
|------|--------------|
| [`meta-review-business.csv`](https://github.com/tulip-lab/sit742/blob/364d63887a6597c829d11f68091f79e8f70794f8/Jupyter/data/business_review_submission.zip) | Business metadata — categories, ratings, latitude/longitude, hours, URLs |
| [`review.csv`](https://github.com/tulip-lab/sit742/blob/364d63887a6597c829d11f68091f79e8f70794f8/Jupyter/data/business_review_submission.zip) | Review dataset — user IDs, ratings, timestamps, review text |
| `Comprehensive Meta Business Analysis.pdf` | Detailed analytical report & visual documentation |
| `Meta_Business_Analysis.ipynb` | Main Jupyter Notebook implementing all workflows |

> ⚠️ *Do not reuse, redistribute, or reupload these datasets without explicit permission from the author.*

---

## Tech Stack

| Category | Tools / Libraries |
|-----------|------------------|
| **Languages** | Python |
| **Data Processing** | PySpark, Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn |
| **NLP & Sentiment** | NLTK, WordCloud, Vader |
| **Modeling** | Scikit-learn (KNN), Statsmodels (ARIMA) |
| **Environment** | Google Colab / Jupyter Notebook |

---

## Data Wrangling and Modelling

- Ingested raw CSVs using **PySpark SparkSession** for efficient handling.  
- Standardised missing review text (`NaN`, `None`, `nan` → “No Review”).  
- Converted Unix timestamps to human-readable dates (`yyyy-mm-dd`).  
- Merged review and meta tables on `gmap_id` for integrated analysis.

**Meta Data**
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>name</th>
      <th>address</th>
      <th>gmap_id</th>
      <th>description</th>
      <th>latitude</th>
      <th>longitude</th>
      <th>category</th>
      <th>avg_rating</th>
      <th>num_of_reviews</th>
      <th>price</th>
      <th>hours</th>
      <th>MISC</th>
      <th>state</th>
      <th>relative_results</th>
      <th>url</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Bear Creek Cabins &amp; RV Park</td>
      <td>Bear Creek Cabins &amp; RV Park, 3181 Richardson H...</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
      <td>NaN</td>
      <td>61.100644</td>
      <td>-146.214552</td>
      <td>['RV park', 'Cabin rental agency', 'Campground']</td>
      <td>4.5</td>
      <td>18</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>['0x56b6445fd9f9e387:0x6dd3d374ef56431a', '0x5...</td>
      <td>https://www.google.com/maps/place//data=!4m2!3...</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Anchorage Market</td>
      <td>Anchorage Market, 88th Ave, Anchorage, AK 99515</td>
      <td>0x56c8992b5dee7225:0x9f7f4bf151868cf7</td>
      <td>NaN</td>
      <td>61.141435</td>
      <td>-149.868482</td>
      <td>["Farmers' market"]</td>
      <td>4.2</td>
      <td>18</td>
      <td>NaN</td>
      <td>[['Thursday', 'Closed'], ['Friday', '10AM–5PM'...</td>
      <td>{'Service options': ['In-store shopping'], 'Ac...</td>
      <td>Closed ⋅ Opens 10AM Fri</td>
      <td>NaN</td>
      <td>https://www.google.com/maps/place//data=!4m2!3...</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Happy Camper RV</td>
      <td>Happy Camper RV, 1151 N Shenandoah Dr # 4, Pal...</td>
      <td>0x56c8e0455225be87:0xf24828df75e2f8ae</td>
      <td>NaN</td>
      <td>61.591856</td>
      <td>-149.290657</td>
      <td>['RV repair shop']</td>
      <td>4.4</td>
      <td>28</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>{'Accessibility': ['Wheelchair accessible entr...</td>
      <td>NaN</td>
      <td>['0x56c8e104d9929a1d:0x2070ad63defadbf', '0x56...</td>
      <td>https://www.google.com/maps/place//data=!4m2!3...</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Cajun Corner</td>
      <td>Cajun Corner, 302 G St, Anchorage, AK 99501</td>
      <td>0x56c8bdb5d91017cd:0xca19fd9afceed343</td>
      <td>NaN</td>
      <td>61.219378</td>
      <td>-149.895852</td>
      <td>['American restaurant']</td>
      <td>4.5</td>
      <td>24</td>
      <td>NaN</td>
      <td>[['Wednesday', '11AM–2PM'], ['Thursday', '11AM...</td>
      <td>{'Service options': ['Takeout', 'Dine-in', 'De...</td>
      <td>Closed ⋅ Opens 11AM Thu</td>
      <td>NaN</td>
      <td>https://www.google.com/maps/place//data=!4m2!3...</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Alaska General Seafoods</td>
      <td>Alaska General Seafoods, 980 Stedman St, Ketch...</td>
      <td>0x540c251956395673:0x16f5a4fe26c18931</td>
      <td>NaN</td>
      <td>55.336119</td>
      <td>-131.630669</td>
      <td>['Seafood wholesaler', 'Food']</td>
      <td>4.7</td>
      <td>8</td>
      <td>NaN</td>
      <td>[['Wednesday', '7AM–11PM'], ['Thursday', '7AM–...</td>
      <td>NaN</td>
      <td>Open ⋅ Closes 11PM</td>
      <td>['0x540c25a882a72685:0xac5663d19d0a1893', '0x5...</td>
      <td>https://www.google.com/maps/place//data=!4m2!3...</td>
    </tr>
  </tbody>
</table>

**Review Data**
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>user_id</th>
      <th>name</th>
      <th>time</th>
      <th>rating</th>
      <th>text</th>
      <th>pics</th>
      <th>resp</th>
      <th>gmap_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1.091298e+20</td>
      <td>Nicki Gore</td>
      <td>1566331951619</td>
      <td>5</td>
      <td>We always stay here when in Valdez for silver ...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
    </tr>
    <tr>
      <th>1</th>
      <td>1.132409e+20</td>
      <td>Allen Ratliff</td>
      <td>1504917982385</td>
      <td>5</td>
      <td>Great campground for the price. Nice hot unlim...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
    </tr>
    <tr>
      <th>2</th>
      <td>1.130448e+20</td>
      <td>Jonathan Tringali</td>
      <td>1474765901185</td>
      <td>4</td>
      <td>We tent camped here for 2 nights while explori...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
    </tr>
    <tr>
      <th>3</th>
      <td>1.103292e+20</td>
      <td>S Blad</td>
      <td>1472858535682</td>
      <td>4</td>
      <td>This place is just a few miles outside Valdez,...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
    </tr>
    <tr>
      <th>4</th>
      <td>1.089896e+20</td>
      <td>Daniel Formoso</td>
      <td>1529649811341</td>
      <td>5</td>
      <td>Probably the nicest and cleanest campground we...</td>
      <td>NaN</td>
      <td>NaN</td>
      <td>0x56b646ed2220b77f:0xd8975e316de80952</td>
    </tr>
  </tbody>
</table>

## Exploratory Analysis

- Visualised **distribution of ratings** and **hourly review counts**.  
- Created **heatmaps** of review activity by business and time of day.  
- Identified **peak engagement hours** (afternoon/evening) and **weekday trends**.  
- Determined **top-reviewed businesses** and **most active reviewers**.

**_📸 Placeholder for image:_**  
> `![Review Hour Heatmap](images/review_hour_heatmap.png)`  
> `![Average Rating by Hour](images/avg_rating_by_hour.png)`

---

## Natural Language Processing

- Tokenized and cleaned all review text with regex & NLTK stopword filtering.  
- Extracted **top 30 frequent words** across reviews.  
- Generated **WordClouds by year** to visualize changing customer language.  
- Identified **negative sentiment keywords** (`bad`, `rude`, `horrible`, `worst`, `dirty`, `disappointed`).  
- Matched example complaints with their business categories for root-cause insights.

**_📸 Placeholder for image:_**  
> `![Yearly WordClouds](images/wordclouds_by_year.png)`  
> `![Top 30 Words Bar Chart](images/top_words_chart.png)`

---

## Business & Reviewer Insights

- Calculated **unique reviewers per business & category**.  
- Found **Walmart Supercenter**, **McDonald’s**, **Costco**, **Taco Bell** as top-engagement brands.  
- Built **reviewer–business interaction lists** and measured **cosine similarity** between users.  
- Visualised reviewer similarity clusters using heatmaps.

**_📸 Placeholder for image:_**  
> `![User Similarity Heatmap](images/user_similarity_heatmap.png)`

---

## Recommendation System

A **hybrid recommendation engine** combining two strategies:

1. **Content-based Filtering** – ranks categories a user rates highly  
2. **Collaborative Filtering (KNN)** – finds similar users by rating pattern  

**Workflow Summary:**
1. Profile user top categories (≥ 3 reviews each).  
2. Build user–category rating matrix.  
3. Identify similar users via cosine similarity (KNN).  
4. Recommend top 5 new businesses each month (season-aware).

**_📸 Placeholder for image:_**  
> `![Recommendation Workflow](images/recommendation_system_flow.png)`  
> `![Monthly Top 5 Output Table](images/monthly_recommendations.png)`

---

## Time Series Forecasting

- Aggregated review counts into **daily time series (2007–2021)**.  
- Filled missing dates with mean daily count (≈ 163 reviews/day).  
- Performed **additive seasonal decomposition** (weekly + yearly).  
- Conducted grid search on **ARIMA(p,d,q)** models → best = (2, 1, 0).  
- Achieved lowest MAE = **50.29**, showing solid short-term forecasting accuracy.  

**_📸 Placeholder for image:_**  
> `![ARIMA Decomposition Plot](images/arima_decomposition.png)`  
> `![Forecast Plot](images/review_forecast_plot.png)`

---

## Deep Learning Outlook

Outlined the conceptual roadmap to extend forecasting via **LSTM / GRU networks**:
- Sequence framing and time-window encoding  
- Feature normalization (MinMax / Z-score)  
- Model with recurrent layers + dropout  
- Optimized with Adam or RMSProp  
- Early stopping on validation loss  

**_📸 Placeholder for image:_**  
> `![LSTM Architecture Diagram](images/lstm_architecture.png)`

## Key Insights

| Area | Insight |
|------|----------|
| **Customer Behaviour** | Reviews peak on weekends; strong engagement on Saturday & Sunday. |
| **Category Patterns** | Restaurants dominate all engagement metrics. |
| **Negative Feedback Drivers** | Poor service, rude staff, and policy issues dominate low ratings. |
| **Temporal Trends** | Review activity peaked in 2019 and dropped during 2020 lockdowns. |
| **Predictive Power** | ARIMA(2,1,0) accurately captures weekly cyclicality. |
| **Recommendation Value** | Combines user taste + similar user ratings for personalized monthly picks. |

## Project Structure

```
Meta_Business_Analysis/
│
├── Meta_Business_Analysis.ipynb          # Main notebook
├── meta-review-business.csv              # Business metadata
├── review.csv                            # Review dataset
├── Comprehensive Meta Business Analysis.pdf  # Full report & visuals
├── images/                               # [Add screenshots & charts here]
└── README.md                             # Project documentation
```

## Author

**Author:** [Frank Dinh, Mia Pham, Shaun Nguyen]  
**Email:** [dinh.qnhat@gmail.com]  
**Year:** 2025  
**Affiliation:** Independent Data Science Project  

> © 2025 All Rights Reserved.  
> Unauthorized reuse, redistribution, or upload of the datasets is prohibited.

## 🏁 Conclusion

This project exemplifies the **complete data-science pipeline** — from ingestion and processing to advanced analytics, forecasting, and recommendation.  
It highlights practical skills in **data engineering, NLP, visualization, and predictive modeling**, bridging the gap between data and actionable business intelligence.

**_📸 Placeholder for final dashboard or summary visual:_**  
> `![Project Dashboard Summary](images/final_dashboard.png)`
