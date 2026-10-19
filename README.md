# Olist E-commerce Analytics: Customer, Operations & Profitability Intelligence

## Project Overview

This project analyzes Brazilian e-commerce data from Olist to uncover insights into sales performance, customer behavior, product categories, seller performance, delivery operations, customer satisfaction, and marketing effectiveness.

The goal is to transform raw transactional data into actionable business insights using SQL, Python, and Power BI.

## Business Objectives

* Analyze revenue and order trends over time.
* Understand customer purchasing behavior and segmentation.
* Identify top-performing product categories and sellers.
* Evaluate delivery performance and its relationship with customer reviews.
* Examine marketing lead conversion and sales funnel performance.
* Build an interactive dashboard to support data-driven decisions.

## Tools & Technologies

* **SQL:** PostgreSQL
* **Python:** Pandas, NumPy, Matplotlib, Seaborn, Scikit-learn, Statsmodels
* **Notebook:** Jupyter Notebook
* **Visualization:** Power BI
* **Data Source:** Olist Brazilian E-commerce Public Dataset

## Project Structure

```text
Olist_Ecommerce_Analytics/
├── data/
│   └── raw/
├── notebooks/
│   └── 01_olist_analytics.ipynb
├── sql/
│   ├── 01_database_setup_and_audit.sql
│   ├── 02_customer_analysis.sql
│   └── 03_business_analysis.sql
├── dashboards/
│   └── Olist_Ecommerce_Analytics_Dashboard.pbix
└── README.md
```

*Note: SQL filenames may differ slightly depending on the final saved filenames.*

## Analysis Performed

### 1. Sales & Revenue Analysis

* Monthly revenue and order trends
* Sales performance indicators
* Product category performance

### 2. Customer Intelligence

* Customer purchasing behavior
* RFM-based customer segmentation
* Repeat-purchase analysis
* Customer value and retention analysis

### 3. Product & Seller Analytics

* Best-performing product categories
* Seller performance comparisons
* Product and order-item analysis

### 4. Operations & Customer Experience

* Delivery time and delay analysis
* Order status analysis
* Customer review score analysis
* Relationship between delivery delays and customer satisfaction

### 5. Marketing Funnel

* Marketing-qualified leads
* Closed-deal analysis
* Lead conversion indicators
* Lead-source performance

### 6. Predictive Analysis

* Machine learning experiments using Python
* Delivery-delay risk analysis
* Exploratory revenue forecasting

## Power BI Dashboard

The interactive dashboard contains five pages:

1. Executive Overview
2. Customer Intelligence
3. Product & Seller Analytics
4. Operations & Customer Experience
5. Forecast & Business Recommendations

The dashboard combines key performance indicators, charts, comparisons, and business recommendations to communicate findings effectively.

## Key Business Questions

* How do sales and order volumes change over time?
* Which product categories and sellers perform best?
* How can customers be segmented based on purchasing behavior?
* Are delivery delays associated with lower customer review scores?
* Which marketing lead sources contribute to closed deals?
* What operational improvements could improve customer experience?

## Limitations

* The analysis depends on the quality and completeness of the supplied dataset.
* Some predictive analyses are exploratory and should not be treated as production-ready models.
* Historical patterns may not reliably predict future business performance.
* Marketing funnel metrics should be interpreted according to the available data and relationships between tables.

## Future Improvements

* Deploy the dashboard to a cloud-based reporting platform.
* Automate data refresh and reporting.
* Improve predictive models through additional validation and feature engineering.
* Incorporate more recent transaction data for ongoing monitoring.

## Conclusion

This project demonstrates an end-to-end data analytics workflow, from data preparation and SQL-based analysis to Python experimentation and interactive Power BI reporting. It applies analytical techniques to practical e-commerce business questions and translates findings into insights that can support business decision-making.

## Author

**Sharon Reddy**

M.Sc. Data Science

GITAM School of Science, GITAM (Deemed to be University), Visakhapatnam
