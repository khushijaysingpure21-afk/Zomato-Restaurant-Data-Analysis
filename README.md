# Zomato Restaurant Data Analysis 🍽️📊

An end-to-end data analytics project exploring the Zomato restaurant database using MySQL to uncover business insights, analyze consumer behavior, and present actionable recommendations via structured reporting[cite: 14].

---

## 👥 Project Team: Select Star ⭐
* **Yukta Jaysingpure**[cite: 14]
* **Monika Mengawade**[cite: 14]
* **Akash Jadhao**[cite: 14]
* **Revan Gunjal**[cite: 14]

---

## 🎯 Project Objective
The primary objective is to analyze a comprehensive MySQL restaurant relational database to uncover key sales trends, customer segmentation, cuisine performance, and operational insights to support data-driven business decisions[cite: 14].

---

## 🗄️ Dataset & Table Inventory
The project utilizes a normalized MySQL relational database consisting of five core tables[cite: 14, 18]:

| Table Name | Rows Count | Columns | Key / Relationships |
| :--- | :--- | :--- | :--- |
| **users** | 100,000 | 10 | Primary Key: `user_id`[cite: 14] |
| **restaurant** | 148,541 | 12 | Primary Key: `restaurant ID`[cite: 14] |
| **orders** | 150,281 | 6 | Foreign Keys: `user_id`, `r_id`[cite: 14] |
| **menu** | 1,179,936 | 5 | Foreign Keys: `r_id`, `f_id`[cite: 14] |
| **food** | 371,561 | 3 | Primary Key: `f_id`[cite: 14] |

---

## ⚙️ Challenges & Solutions during Data Preparation
* **Data Type Mismatches:** Date and numeric fields stored as text were handled using `CAST()` and `CONVERT()` functions for aggregation[cite: 14].
* **Null Ratings:** Missing ratings were filtered out using `IS NOT NULL` conditions to prevent skewed average calculations[cite: 14].
* **Duplicate Orders:** Handled and identified using `ROW_NUMBER()` window functions alongside Common Table Expressions (CTEs)[cite: 14].
* **Join Complexity:** Implemented clear aliases and `LEFT JOIN` operations to preserve total restaurant records during multi-table queries[cite: 14].

---

## 🔍 Key Business Insights & Findings

1. **Customer Retention:** 
   * Identified **44,480 repeat customers** versus **33,452 one-time customers**, highlighting a strong retention base with significant potential for win-back marketing campaigns[cite: 14].
2. **High-Revenue, Low-Rated Restaurants:** 
   * Uncovered high-earning restaurant partners operating with ratings below 3.5, signaling areas requiring immediate food consistency and service-quality reviews[cite: 14].
3. **Top Cuisine Sales:** 
   * Ranked cuisine categories by sales performance, noting that the combined label **“North Indian,Chinese”** generated the highest overall sales volume[cite: 14].

---

## 💡 Strategic Recommendations
* **Targeted Offers:** Design promotional loyalty campaigns directed at converting one-time customers into repeat users[cite: 18].
* **Partner Quality Audits:** Investigate customer feedback and service standards for high-revenue but poorly rated restaurant listings[cite: 18].
* **Promotional Planning:** Utilize cuisine demand analytics to shape targeted restaurant partner marketing and promotional discounts[cite: 18].

---

## 🛠️ Tech Stack & Tools
* **Database:** MySQL[cite: 14]
* **Query Language:** Advanced SQL (Joins, CTEs, Window Functions like `DENSE_RANK()`, Aggregations)[cite: 14, 18]
* **Visualization & Presentation:** PowerPoint / Dashboard Reporting[cite: 14, 18]

---

## 📂 Repository Structure
```text
├── dataset/                  # Source CSV/SQL dump files
├── sql_queries/              # Mandatory and additional analytical SQL scripts
├── presentation/             # Final project presentation (.pptx / PDF)
└── README.md                 # Project documentation
