# Bug Analysis in Modern Web Browsers

## Overview
This repository contains the code and resources for the research paper titled "Bug Analysis in Modern Web Browsers: A Study of Firefox and Chromium." The study employs natural language processing (NLP) techniques to categorize and analyze bugs in Firefox and Chromium, providing insights into common defects and defect-prone components.

## Contents
- **Data Collection**: Scripts for collecting bug data from GitHub repositories of Firefox and Chromium.
- **Preprocessing**: Code for cleaning and preparing the data for analysis.
- **NLP Analysis**: Implementation of the BERT model for clustering bug descriptions and generating word clouds.
- **Visualization**: Tools for visualizing bug clusters and defect patterns.
- **Results**: Analysis scripts that summarize the findings of the research.

Methodology 

Our methodology consisted of several stages to analyze and categorize bugs in Chrome and Firefox using Natural Language Processing (NLP) and clustering techniques.

![A screenshot of the Methodology](./methodology.png)

Data Collection & Pre-processing:

We collected bug descriptions and component information from bug reports, forming a relational table to link bugs to affected components.
Commit data from Git repositories was linked to bugs by extracting bug IDs and labeling commits with component names based on file paths.
NLP & Tokenization:

We pre-processed the text by removing stop words, tokenizing, and lemmatizing bug descriptions to prepare for analysis.
Using TF-IDF, we calculated word importance, filtered irrelevant words, and identified key terms for clustering.
Clustering & Thematic Analysis:

We used K-Means clustering and Principal Component Analysis (PCA) to group similar bugs, identifying clusters based on token patterns.
We conducted thematic analysis and inter-rater reliability checks to finalize categories for bug types.
Knowledge Embedding:

Using OpenAI embeddings, we created vector representations of bug descriptions and commit messages to capture relationships between bugs and components.
This approach allowed us to categorize bugs effectively and assess the model’s understanding of browser-specific bug patterns.

**Research Question 1 (RQ1)**

This document provides an overview of the files and structure used for
Research Question 1 (RQ1) in our research project. It includes
descriptions of the folders, data files, and notebooks used for the
analysis.

**Folder Structure**

1**. Data**

This folder contains the CSV files extracted from bug-tracking systems.
These datasets are used for analysis related to bugs in Firefox and
Chromium.

**Files:**

- bugzilla_3.csv

  - This CSV file was extracted from the Bugzilla website, a
    bug-tracking system used by Firefox. It contains data relevant to
    the analysis of Firefox bugs.

- ch_bug_data.csv

  - This CSV file was extracted from the Chromium website, which serves
    as the bug tracking system for Chromium. It contains data relevant
    to the analysis of Chromium bugs.

2**. Ipynb (Notebooks)**

This folder contains Jupyter notebooks used to analyze the data from the
CSV files. The notebooks perform tasks such as data preprocessing,
exploratory data analysis, and advanced techniques like using language
models for bug analysis.

**Files:**

- Firefox_GPT4_LLM.ipynb

  - This notebook focuses on analyzing bug data for Firefox using
    advanced techniques like GPT-4o based language modeling. It includes
    steps for data preprocessing (e.g., cleaning, tokenization, and
    feature extraction), followed by applying GPT-4o to analyze textual
    patterns in the fx_component_bug_export.csv file. The analysis aims
    to identify trends and extract meaningful insights from bug reports.

- CHROMIUM_NLP_NEW.ipynb

  - This notebook focuses on natural language processing (NLP)
    techniques applied to Chromium bug data. It processes and analyzes
    the ch_bug_data.csv file, including steps like text cleaning,
    keyword extraction, and sentiment analysis, to understand the nature
    of the bugs.

- FIRE_FOX_NLP.ipynb

  - This notebook explores NLP-based analysis specifically for Firefox
    bug data. It complements the GPT-4o based analysis by focusing on
    linguistic features in bug descriptions, such as term frequency
    analysis, topic modeling, and clustering of similar bug reports.

- Chromium_GPT4_LLM.ipynb

  - This notebook employs GPT-4o based language modeling to analyze the
    ch_component_bug_export.csv file for Chromium. Similar to the
    Firefox notebook, it involves data preprocessing (e.g., handling
    missing values, standardizing text formats, and feature engineering)
    and uses GPT-4o to uncover patterns in the bug reports, providing
    deeper insights into recurring issues and their textual
    characteristics.

**Process Overview**

1.  **Data Extraction**:

    - Data was extracted from the Bugzilla and Chromium bug tracking
      systems to create the CSV files (bugzilla_3.csv and
      ch_bug_data.csv).

2.  **Data Analysis:**

    - The Jupyter notebooks analyze the respective datasets. Two
      notebooks focus on GPT-4o based modeling, while the other two
      leverage NLP techniques.

3.  **Insights:**

    - Each notebook extracts relevant patterns, analyzes linguistic
      attributes, and derives insights related to bug descriptions and
      reports.

**RQ2: Bug Categorization Analysis**

**This section focuses on RQ2 of the research paper, where bug
categorization analysis was performed using large-scale data and models.
The files provided include Jupyter notebooks, CSV files containing
predictions, and visualizations of bug distributions.**

**Folder Structure**

**1. Ipynb Files**

These Jupyter notebooks contain the implementation details for analyzing
and predicting bug categories for two browsers:

- Firefox_gpt4_subject_11_9.ipynb: Analyzes Firefox bug reports,
  processes data, and predicts bug categories using a GPT-4o based
  model. The CSV File for this IPYNB is used the same one, which we use
  in RQ1 (fx_component_bug_export.csv)

- chromium_gpt4_subject_11_9.ipynb: Performs similar analysis for
  Chromium bug reports and predicts categories. The CSV File for this
  IPYNB is used the same one, which we use in RQ1
  (ch_component_bug_export.csv)

The notebooks load raw bug components and descriptions, preprocess the
data, and apply classification techniques to assign categories to each
bug.

**2. Csv Files**

The CSV files contain the predicted bug categories generated by running
the corresponding Jupyter notebooks:

- fx_component_bug_predicted_category.csv: Results from Firefox bug
  analysis, containing predicted bug categories.

- ch_component_bug_predicted_category.csv: Results from Chromium bug
  analysis.

The CSV files can be used for further analysis, visualization, or
validation.

**3. Images**

The provided images showcase the distribution of bugs across different
categories:

- bug_category_chart_firefox.jpg: Visualization of the number of bugs
  per category for Firefox.

- bug_category_chart_chromium.jpg: Similar visualization for Chromium.

These charts summarize the findings and highlight the most frequent bug
categories for each system.

**4. Data Source and Process (Brief)**

The CSV files used for analysis were derived from the ch_commit and
ch_git_revision tables. Components and bugs were extracted, and further
analysis was performed to predict bug categories. For detailed steps,
please look at the Methodology section of the research paper.

**RQ3: High Effort Consuming (HEC) Bugs Analysis**

**Overview**

This folder contains data files, SQL scripts, and a Jupyter Notebook
related to analyzing High Effort Consuming (HEC) bugs. The
analysis focuses on identifying and visualizing bugs with significant
churn (effort) for two browsers: **Firefox** and **Chromium**.

**Folder Structure**

The folder contains the following files:

1.  **CSV Folder**

    - **firefox_hec_churn.csv**:  
      Contains High Effort Consuming (HEC) bugs in Firefox with total
      churn greater than 1000.

    - **firefox_churn.csv**:  
      Contains all Firefox bugs and their total churn values.

    - **chromium_hec_churn.csv**:  
      Contains High Effort Consuming (HEC) bugs in Chromium with total
      churn greater than 1000.

    - **chromium_churn.csv**:  
      Contains all Chromium bugs and their total churn values.

2.  **SQL Scripts File**

    - **SQL Scripts.docx**:  
      Describes two main processes:

      1.  **Calculating Total Churn**:

          - The total churn is calculated for each bug_id by summing
            effort values in two tables (fx_effort for Firefox and
            ch_effort for Chromium).

          - Results are saved to CSV files.

      2.  **Filtering High Effort Consuming (HEC) Bugs**:

          - Bugs with a total churn greater than 1000 are filtered.

          - Results are saved to separate CSV files for each browser.

3.  **Jupyter Notebook**

    - **RQ3.ipynb**:  
      This notebook analyzes and visualizes the High Effort Consuming
      bugs in both browsers.

      - **Inputs**: CSV files for all bugs and HEC bugs.

      - **Outputs**: Visualizations comparing the churn distributions.

4.  **Image Output**

    - **churn-per-bug.jpg**:  
      A violin plot comparing the distributions of Log Total Churn for:

      - All Bugs

      - High Effort Consuming (HEC) Bugs  
        across Firefox and Chromium.

**SQL Workflow Summary**

The SQL scripts perform two key tasks:

1.  **Calculating Total Churn**:

    - For each browser, total churn is calculated by summing the effort
      values (churn) for all bug_ids from the respective tables.

    - The results are exported to separate CSV files (chromium_churn.csv
      and firefox_churn.csv).

2.  **Filtering HEC Bugs**:

    - From the total churn results, bugs with a total churn greater than
      1000 are filtered.

    - The filtered HEC bugs are saved to separate CSV files
      (chromium_hec_churn.csv and firefox_hec_churn.csv).

**Jupyter Notebook Workflow (RQ3.ipynb)**

1.  **Data Loading**:

    - Load CSV files for both All Bugs and HEC Bugs.

2.  **Data Processing**:

    - Clean and combine data where necessary.

3.  **Visualization**:

    - Generate violin plots to compare:

      - The churn distribution of **All Bugs** vs. **HEC Bugs**.

      - Differences between **Firefox** and **Chromium**.

4.  **Output**:

    - Visualizations are displayed and saved as churn-per-bug.jpg.

**Usage Instructions**

1.  Ensure you have the necessary tools installed:

    - Python

    - Jupyter Notebook

    - Required libraries (pandas, matplotlib, seaborn, etc.).

2.  Open **RQ3.ipynb** in Jupyter Notebook.

3.  Run all cells to:

    - Load and analyze the data.

    - Generate and save the visualizations.

4.  Review the results, including the comparison plots.

**References**

For more details on:

- **Total churn calculation**

- **Bug ID extraction**  
  Please refer to our **Research Paper**.

**RQ4 Component Level Analysis**

**Overview**

This section contains files and scripts to analyze bug churn metrics at
the component level for **Chromium** and **Firefox**. It identifies
components with high bugfix churn, total churn, and bug counts through
SQL queries, CSV datasets, and visualization scripts.

**Files**

**1. CSV Files**

- **firefox_common_components.csv**

- **chromium_common_components.csv**

These files contain the component-level analysis results for Firefox and
Chromium.  
**Columns:**

- Component Name

- Total Churn

- Bug Count

- Bugfix Churns

These metrics help analyze which components experience higher bug churn
and require more fixes.

**2. SQL Queries (SQL Queries.docx)**

The document contains SQL queries used to calculate the metrics:

- **Total Churn**: Sum of churned lines of code per component.

- **Bug Count**: Number of unique bugs per component.

- **Bugfix Churns**: Churn specifically related to fixing bugs.

The queries fetch results and export them as CSV files for analysis.

**3. Visualization Notebook (RQ4.ipynb)**

This Jupyter Notebook processes the CSV data and generates bar plots for
Chromium and Firefox components.

- **Bar Plot**: Displays Bugfix Churn, Total Churn, and Bug Count for
  each component.

- The visualization highlights components with high churn and
  bug-related activity.

**4. Image File (component-bug-ch-fx-bar.jpg)**

![Chromium-predicted categories](https://github.com/user-attachments/assets/96d414b1-0bc3-40ac-a9e4-1cc17a020f03)

**4. Image File (firefox-bug-ch-fx-bar.jpg)**

![Firefox-predicted categories bigger font size ](https://github.com/user-attachments/assets/4c4803c0-2bba-4fa6-9e5a-e02dc7953184)

This image shows the bar plots generated from the data, where:

- **X-Axis**: Component names

- **Y-Axis**: Counts (log scale)

- **Metrics Visualized**:

  - Bugfix Churns (Blue)

  - Total Churns (Orange)

  - Bug Count (Green)

**Process Summary**

1.  **Data Extraction**: SQL queries (from SQL Queries.docx) were
    executed to export firefox_common_components.csv and
    chromium_common_components.csv.

2.  **Data Analysis**: The Jupyter Notebook (RQ4.ipynb) processed and
    visualized the data.

3.  **Visualization**: Bar plots were generated to highlight components
    with high bug churn metrics (component-bug-ch-fx-bar.jpg).

**Usage**

- Run the provided SQL queries to regenerate CSV data (optional).

- Open RQ4.ipynb to analyze and visualize the CSV files.

- Refer to component-bug-ch-fx-bar.jpg for quick insights.

**Purpose**

This analysis helps identify critical components in **Chromium** and
**Firefox** that require focus for bug fixing and maintenance.




## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/singhrahulbrijesh/common-defect-in-browsers.git
Navigate to the project directory:
bash


cd repo-name
Install the required packages:
bash


Contributions
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug reports.

License
This project is licensed under the MIT License. See the LICENSE file for details.

Acknowledgments
Thanks to the contributors of the Firefox and Chromium projects for their open-source efforts, which made this research possible.

Contact
For any inquiries, please reach out to me at singhrahulbrijesh@gmail.com.


Feel free to modify the content to suit your specific project details!
