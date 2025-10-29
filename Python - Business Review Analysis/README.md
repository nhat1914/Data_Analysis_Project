# Meta Business Analysis

A comprehensive end-to-end analytics and machine learning project exploring **Google Maps business reviews** using **PySpark, Pandas, NLP, and Time Series Forecasting**.  
This project integrates data wrangling, visualization, sentiment analysis, and recommender system design — all within a single, production-style workflow.

## Project Overview

The **Meta Business Analysis** project demonstrates how large-scale public review data can be transformed into actionable insights.  
It showcases the **full data science pipeline** — from raw data ingestion to forecasting and recommendation generation.

**Goal:** To analyse online business reviews, extract customer insights, forecast engagement trends, and build data-driven recommendation systems.

### Key Highlights

- Data engineering using **PySpark** for scalable ETL and cleansing  
- Text cleaning, tokenization, and **NLP analysis** of >500K review texts  
- Sentiment tracking and **keyword frequency trends over years**  
- Exploratory visuals — **ratings, peak hours, category heatmaps**  
- **Hybrid recommender system** using content-based + collaborative filtering  
- **Time series forecasting** with ARIMA to predict review activity  
- Deep learning roadmap (LSTM / GRU) for future enhancement  
- Business & reviewer-level behaviour profiling (cosine similarity clusters)

## Data Sources

| File | Description |
|------|--------------|
| [`meta-review-business.csv`](https://github.com/tulip-lab/sit742/blob/364d63887a6597c829d11f68091f79e8f70794f8/Jupyter/data/business_review_submission.zip) | Business metadata — categories, ratings, latitude/longitude, hours, URLs |
| [`review.csv`](https://github.com/tulip-lab/sit742/blob/364d63887a6597c829d11f68091f79e8f70794f8/Jupyter/data/business_review_submission.zip) | Review dataset — user IDs, ratings, timestamps, review text |
| `Comprehensive Meta Business Analysis.pdf` | Detailed analytical report & visual documentation |
| `Meta_Business_Analysis.ipynb` | Main Jupyter Notebook implementing all workflows |

> ⚠️ *Do not reuse, redistribute, or reupload these datasets without explicit permission from the author.*

## Tech Stack

| Category | Tools / Libraries |
|-----------|------------------|
| **Languages** | Python |
| **Data Processing** | PySpark, Pandas, NumPy |
| **Visualization** | Matplotlib, Seaborn |
| **NLP & Sentiment** | NLTK, WordCloud, Vader |
| **Modeling** | Scikit-learn (KNN), Statsmodels (ARIMA) |
| **Environment** | Google Colab / Jupyter Notebook |

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
      <th>1</th>
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
      <th>2</th>
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
      <th>3</th>
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
      <th>4</th>
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
      <th>5</th>
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
      <th>1</th>
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
      <th>2</th>
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
      <th>3</th>
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
      <th>4</th>
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
      <th>5</th>
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

<img width="868" height="547" alt="image" src="https://github.com/user-attachments/assets/7f83453d-6a8d-43b6-8ecf-4b94ecbc94ba" />

- Created **heatmaps** of review activity by business and time of day.
- 
<img width="1211" height="470" alt="image" src="https://github.com/user-attachments/assets/207676b5-ac10-4e4a-bc29-3d4c169105df" />

- Identified **peak engagement hours** (afternoon/evening) and **weekday trends**.

<img width="855" height="547" alt="image" src="https://github.com/user-attachments/assets/74aaa0e7-1fc8-45ad-a3da-4602e11a6190" />
<img width="630" height="470" alt="image" src="https://github.com/user-attachments/assets/c4e876b9-93af-4ac9-9001-2a8b58231fa6" />

- Determined **top-reviewed businesses**.

<img width="776" height="509" alt="image" src="https://github.com/user-attachments/assets/f8c47798-cb58-4d56-b599-ff6a75f48103" />
<img width="1071" height="701" alt="image" src="https://github.com/user-attachments/assets/741baac6-ab39-49e3-9474-23a9aa372ada" />

## Natural Language Processing

- Tokenized and cleaned all review text with regex & NLTK stopword filtering.  
- Extracted **top 30 frequent words** across reviews.
- Generated **WordClouds by year** to visualize changing customer language.  
- Identified **negative sentiment keywords** (`bad`, `rude`, `horrible`, `worst`, `dirty`, `disappointed`).  
- Matched example complaints with their business categories for root-cause insights.

<img width="160" height="544" alt="image" src="https://github.com/user-attachments/assets/c03be483-8495-4182-8b44-82bb3a76951a" />

<img width="790" height="427" alt="image" src="https://github.com/user-attachments/assets/81406f5a-a3ad-45d8-9bf3-d616cd73c42e" />

## Business & Reviewer Insights

- Calculated **unique reviewers per business & category**.  
- Found **Walmart Supercenter**, **McDonald’s**, **Costco**, **Taco Bell** as top-engagement brands.  
- Built **reviewer–business interaction lists** and measured **cosine similarity** between users.  
- Visualised reviewer similarity clusters using heatmaps.

<img width="893" height="810" alt="image" src="https://github.com/user-attachments/assets/6eb1e631-b861-4ba0-b34a-5fa69497e3f2" />

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

` # Preprocess
  # Work on a copy dataframe to avoid mutating the original dataframe
  df_strategy = join_df_pandas.copy()
  
  # Keep only the required columns for the strategy implemetation
  cols = ["user_id", "gmap_id", "business_name", "category_list", "rating", "review_time"]
  df_strategy = df_strategy[cols]
  
  # Normalise and enforce consistency datatypes
  df_strategy["user_id"] = df_strategy["user_id"].astype(str)
  df_strategy["gmap_id"] = df_strategy["gmap_id"].astype(str)
  # Derive month from review_time column to group data based on each month later
  df_strategy["month"] = df_strategy["review_time"].dt.month.astype(str).str.zfill(2)
  
  #
  def explode_categories(dataframe):
    """
    The function takes a dataframe that includes 'category_list' column, where 'category_list' contains multiple categories inside
    and return a new dataframe with one row per category.
    """
    # Work on a copy dataframe to avoid mutating the original dataframe
    df = dataframe.copy()
  
    def to_list(cats):
      """
      The function converts various possible formats of category_list into a Python list.
      """
      if isinstance(cats, (list, tuple, set)):
      # If v is already list-like, copy or convert it into a Python list
        vals = list(cats)
      else:
      # Otherwise, v will be treated as a string.
        cat = "" if pd.isna(cats) else str(cats).strip() # Check if the cell is NA, fill it with "", else else convert it to string and trim outer whitespace
        # Check whether s looks like a Python list literal
        if cat.startswith("[") and cat.endswith("]"):
          # If s starts with [ and ends with ],  evaluate for Python literals
          parsed = ast.literal_eval(cat)
          # If the result is list-like, copy or convert it into a Python list
          if isinstance(parsed, (list, tuple, set)):
            vals = list(parsed)
          else:
          # Otherwise, split the result based on common delimiters into a Python list
            vals = re.split(r"[,/;|]", cat)
        else:
        # Otherwise, split the result based on common delimiters into a Python list
          vals = re.split(r"[,/;|]", cat)
  
      # Instantiate an empty list that will hold cleaned category strings
      cleaned = []
      # Loop through every value in vals
      for val in vals:
        if val is None:
        # Skip None entries
          continue
        # Convert the value into a string, trim outer whitespace, and convert it to lowercase
        clean = str(val).strip().lower()
        if clean:
        # If the value is not an empty string after cleaning, add it to the cleaned list
          cleaned.append(clean)
      # Reemove any duplicates without changing order, then convert back to list
      return list(dict.fromkeys(cleaned))
  
    # Create a new column called "category" to contain each category value from the cleaned list
    df["category"] = df["category_list"].map(to_list)
    # Return a dataframe with a new "category" column where each category of a business stays in one separate row
    return(df.explode("category").drop(columns=["category_list"]).reset_index(drop=True))
  
  # Step 1
  def top_categories_for_target_user(user_id, top_n=10, min_reviews_per_cat=3):
    """
    The function returns the top categories based on the target user's average ratings.
    The function will first filter the data to only the data of the target user.
    Then the category_list in the filtered dataframe will be exploded so each category has its own row.
    The dataset will then be grouped by category to calculate the average rating and number of ratings for each category.
    The dataset will keep only categories that have number of ratings higher and equal to "min_reviews_per_cat".
    The dataset will be sorted by average rating, then by number of ratings in descending order, and return top "top_n" categories.
    ValueError will be raised if the user has no previous reviews or ratings or no category passes the threshold.
    """
    # Convert user_id to string to match dataframe keys
    id = str(user_id)
    # Keep only rows of the target user
    user_hist = df_strategy[df_strategy["user_id"] ==  id]
    # Raise ValueError if the target user has no reviews or ratings
    if user_hist.empty:
      raise ValueError("This user has no reviews/ratings.")
  
    # Explode categories_list to make each category has its own row
    user_hist_after_explode = explode_categories(user_hist)
  
    # compute the average ratings and number of ratings of each category
    top_cat =(
        user_hist_after_explode.groupby("category", as_index=False)           # group dataset by cateogry
          .agg(avg_rating=("rating","mean"), n_reviews=("rating", "size"))    # compute the average ratings and number of ratings of each category
          .query("n_reviews >= @min_reviews_per_cat")                         # keep categories with enough reviews
          .sort_values(["avg_rating","n_reviews"], ascending=[False, False])  # sort the dataset by average ratings then number of ratings
          .head(top_n)                                                        # take top_n categories
      )
  
    # Raise ValueError if no category meets the threshold
    if top_cat.empty:
      raise ValueError("No categories meet the required ratings threshold for this user.")
    # Return dataframe of top categories with their average ratings and number of ratings
    return top_cat
  
  # Step 2
  # Build user x category preference matrix (average rating per category)
  def user_category_matrix(categories=None):
    """
    The function builds and returns a matrix with rows representing users, columns representing different categories,
    and the value of each cell is the average rating of that user for that category.
    Unobserved user-category combinations will be filled with 0.0.
    If "categories" set is given, only those categories in the "categories" set will be included in the matrix.
    """
  
    # Explode categories_list to make each category has its own row
    df_strategy_after_explode = explode_categories(df_strategy[["user_id", "category_list", "rating"]])
  
  
    matrix = (df_strategy_after_explode.groupby(["user_id", "category"])["rating"] # Group the dataset by user_id, then category.
               .mean()                                                          # Compute the mean rating of each user for each category.
               .unstack(fill_value=0.0))                                        # Pivot the dataset to a wide matrix and fill missing value as 0.0
    # Check if "categories" parameter is not None
    if categories is not None:
      # Loop over the "categories" set to ensure all requested columns exist
      for c in categories:
        # If any input category is missing, the matrix will add new column and fill it with 0.0
        if c not in matrix.columns:
          matrix[c] = 0.0
      # Reorder the columns to match the order of "categories"
      matrix = matrix[categories]
    # Return a matrix with users in rows, categories in columns, and cells are filled with average ratings or 0.0
    return matrix
  
  def similar_users_by_categories(user_id, k_neighbours=100, min_overlap=5, min_user_total_reviews=10):
    """
    Given a user_id, the functions builds a feature space using only the target's top_n categories from Step 1.
    The function then fit KNN model with cosine metric on the matrix obtained from "user_category_matrix" function
    restricted to the top_n categories. Qualified neighbours would need to have at least "min_overlap" overlap
    categories as the target user and have made at least "min_user_total_reviews" total reviews in those categories.
    The function returns neighbours as list of tuples including neighbour user_id, similarity indicator and overlap
    in number of categories sort by similarity then overlap in descending order, and return the top_n catogories of
    the target user.
    """
    # Convert user_id to string to match dataframe keys
    target_user = str(user_id)
  
    # Return the top_n categories of the target user
    top_cats = top_categories_for_target_user(target_user, top_n=10)
    # Extract the values in the top categories to a list
    cats = top_cats["category"].tolist()
    # Raise ValueError if no category found fod the target user
    if not cats:
      raise ValueError("No categories found for this users.")
  
    # Create a matrix restricted to the obtained top categories
    matrix =  user_category_matrix(categories=cats)
  
    # Raise ValueError if the target user is not presented in the matrix
    if target_user not in matrix.index:
      raise ValueError("Target user missing  in matrix after filtering.")
  
    ## Fit KNN model with cosine metric on the matrix
    model = NearestNeighbors(metric="cosine", algorithm="brute")
    model.fit(matrix.values)
  
    # Obtain the number of neighbours
    num_neighbours = int(builtins.min(k_neighbours+1, len(matrix)))
    # Returns distances to each neighbours and integer row positons
    distances, index = model.kneighbors(
        matrix.loc[[target_user]].values,
        n_neighbors= num_neighbours
    )
    # Convert distiances to simialries
    similarities = 1 - distances.flatten()
    # Flatten neighbour indices for easy iteration
    neigh_index = index.flatten()
  
    # Count total reviews for each user
    tot_reviews = df_strategy.groupby("user_id")["gmap_id"].count()
  
    # Convert user_id from matrix into Python list
    user_order = matrix.index.to_list()
    # Instantiate an empty neighbours list
    neighbours = []
    # Loop over the row position of a neighbour in matrix and that neighbour's similarity amount
    for idx, sim in zip(neigh_index, similarities):
      # Index into user_order to find user_id
      uid = user_order[idx]
      if uid == target_user:
        # Skip the user_id of the target user
        continue
      # Fetch this neighbour's feature vector
      vector = matrix.loc[uid].values
      # Count how many non-zero entries in the vector
      overlap = np.count_nonzero(vector)
      # Check whether the overlap categories of the user is at least min_overlap and if the total number of reviews of the user is at least min_user_total_reviews
      if overlap >= min_overlap and tot_reviews.get(uid, 0) >= min_user_total_reviews:
        # Append the user's id, similarty and overlap to the neighbours list if all conditions are met
        neighbours.append((uid, float(sim), int(overlap)))
  
    # Sort the neighbours list by similarity then by overlap in descending order
    neighbours.sort(key=lambda t: (t[1], t[2]), reverse=True)
    # Return neighbours list and the list of all top categories
    return neighbours, cats
  
  # Step 3
  def recommend_monthly_top5(user_id, k_neighbours=100, min_overlap=5, min_user_total_reviews=10, min_reviews_per_business_from_neighbours=5):
    """
    The function builds and returns business recommendations for the target user by month.
    The function finds similar users via KNN over the target user's top categories in Step 2.
    Then the function group the dataset by month, gmap_id, business_name to compute the average rating
    and number of reviews from the cohort.
    Any business that has been rated by the target user will be removed.
    The function filters to keep only rows with business that has been reviewed at least min_reviews_per_business_from_neighbours.
    Sort the dataset by each month, and within each month, sort the data by mean rating and number of ratings in descending order, and take only top 5 business
    in each month.
    Display the month, the business, its average ratings and number of reviews, and the categories of the business.
    """
    # Convert user_id to string to match dataframe keys
    target_user = str(user_id)
  
    # Return the similar neighbours set using KNN model in Step 2
    neighbours, cats = similar_users_by_categories(target_user, k_neighbours=k_neighbours, min_overlap=min_overlap, min_user_total_reviews=min_user_total_reviews)
    # Raise ValueError is no neighbours passes the threshold
    if not neighbours:
      raise ValueError("No similar users found with current thresholds.")
  
    # Create set of neighbour user_id for faster cheecks
    similar_ids = set(uid for uid, _, _ in neighbours)
  
    # Find all the businesses that have been rated by target user
    business_rated = set(df_strategy.loc[df_strategy["user_id"] == target_user, "gmap_id"].unique())
  
    # Create a copy of all neighbours information only
    cohort = df_strategy[df_strategy["user_id"].isin(similar_ids)].copy()
  
    cohort_grouped = (cohort.groupby(["month", "gmap_id", "business_name"], as_index=False)    # group the dataset by month, gmap_id, then business_name
                  .agg(avg_rating=("rating","mean"), n_reviews=("rating","size")))  # compute the average ratings and number of ratings
  
    # Keep only businesses that have been reviewed at least "min_reviews_per_business_from_neighbours" times
    cohort_grouped = cohort_grouped[cohort_grouped["n_reviews"] >= min_reviews_per_business_from_neighbours]
  
    # Filter out business that have been rated by the target user
    cohort_grouped = cohort_grouped[~cohort_grouped["gmap_id"].isin(business_rated)]
  
    # Sort the dataset by month. Within each month, rank the dataset by average rating, then by number of ratings in descending order
    month_order = [f"{m:02d}" for m in range(1,13)]
    cohort_grouped["month"] = pd.Categorical(cohort_grouped["month"], categories=month_order, ordered=True)
    cohort_grouped = cohort_grouped.sort_values(["month", "avg_rating",  "n_reviews"], ascending=[True, False, False])
  
    # Take the top 5 businesses for each month
    top5_per_month = cohort_grouped.groupby("month", as_index=False).head(5).reset_index(drop=True)
  
    # Function to stringify category_list for display
    def _cat_to_str(x):
      if isinstance(x, (list, tuple, set)):
        return ",".join(map(str, x))
      if pd.isna(x):
        return ""
      return str(x)
  
    # Attach a readable category_list for each business for display
    cat_lookup = (df_strategy.loc[:, ["gmap_id", "category_list"]].copy())
    cat_lookup["category_list"] = cat_lookup["category_list"].apply(_cat_to_str)
    cat_lookup = cat_lookup.drop_duplicates(subset="gmap_id")
  
    # Merge categories_list into the sorted output
    output = top5_per_month.merge(cat_lookup, on="gmap_id", how="left")
  
    # Round the average rating to 2 decimals
    output["avg_rating"] = output["avg_rating"].round(2)
  
    # Return business recommendation
    return output`

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
