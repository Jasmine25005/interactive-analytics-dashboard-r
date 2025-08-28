# Interactive Analytics Dashboard with R & Shiny

![R](https://img.shields.io/badge/R-4.3.1-blue?style=for-the-badge&logo=r)
![Shiny](https://img.shields.io/badge/Shiny-1.8.0-hotpink?style=for-the-badge&logo=rstudio)

An interactive web application built with R and the Shiny framework for comprehensive data analysis. This tool allows users to upload a CSV file and perform data cleaning, visualization, customer clustering, and association rule mining through a simple and intuitive user interface.

---


## ✨ Features

This application provides a complete pipeline for data exploration with the following features:

* **📤 Dynamic Data Upload:** Upload your own dataset in CSV format.
* **🧹 Data Cleaning:** Automatically remove rows with missing values and duplicate entries with a single click.
* **📊 Data Summary:** Generate a quick statistical summary of the cleaned dataset.
* **📈 Rich Visualizations:** Generate four key plots to understand the data:
    * **Pie Chart:** For categorical data distribution (e.g., payment types).
    * **Scatter Plot:** To explore relationships between two numerical variables (e.g., age vs. spending).
    * **Bar Plot:** For comparing values across categories (e.g., total spending per city).
    * **Box Plot:** To understand the distribution of a numerical variable (e.g., total spending).
* **🧩 K-Means Clustering:** Segment data into 2 to 4 clusters based on numerical features to identify patterns.
* **🛒 Association Rule Mining:** Use the Apriori algorithm to discover relationships and patterns between items in transactional data.

---

## 🛠️ Tech Stack

This project is built entirely in R, leveraging the following powerful libraries:

* **`shiny`:** For building the interactive web application framework.
* **`ggplot2`:** For creating elegant and powerful data visualizations.
* **`dplyr`:** For efficient data manipulation and cleaning.
* **`arules`:** For mining association rules using the Apriori algorithm.
* **`reader`:** For reading the input data.

---

## 🚀 Getting Started

To run this application on your local machine, follow these steps:

1.  **Prerequisites:**
    * Make sure you have [R](https://www.r-project.org/) installed.
    * It is recommended to use an IDE like [RStudio](https://posit.co/download/rstudio-desktop/).

2.  **Clone the repository:**
    ```sh
    git clone [https://github.com/your-username/interactive-analytics-dashboard-r.git](https://github.com/your-username/interactive-analytics-dashboard-r.git)
    cd interactive-analytics-dashboard-r
    ```

3.  **Install the required R packages:**
    Open R or RStudio and run the following command in the console:
    ```r
    install.packages(c("shiny", "ggplot2", "dplyr", "arules", "reader"))
    ```

4.  **Run the application:**
    Open the `app.R` file (أو اسم الملف الذي يحتوي على الكود) in RStudio and click on "Run App" in the top right corner of the script editor.

---

## Usage

1.  Launch the application.
2.  Click "Choose CSV File" to upload your dataset.
3.  Use the action buttons on the sidebar to perform different analyses (Clean, Visualize, Cluster, etc.).
4.  Navigate through the tabs in the main panel to see the results.
