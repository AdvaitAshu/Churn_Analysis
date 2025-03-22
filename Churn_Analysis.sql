**Customer Data Analysis and Cleaning**

### **1. Displaying Tables and Data**
- `SHOW TABLES;`  
  Lists all tables in the database.
- `SELECT * FROM customer_data;`  
  Retrieves all records from the `customer_data` table.

### **2. Gender Distribution Analysis**
- Counts the number of customers based on gender.
- Calculates the percentage of each gender compared to the total.
```sql
SELECT Gender, COUNT(Gender) AS TotalCount,
( COUNT(Gender) / (SELECT COUNT(*) FROM customer_data) ) * 100 AS Percentage
FROM customer_data
GROUP BY Gender;
```

### **3. Contract Type Analysis**
- Counts and calculates the percentage of different contract types.
```sql
SELECT Contract, COUNT(Contract) AS TotalCount,
( COUNT(Contract) / (SELECT COUNT(*) FROM customer_data) ) * 100 AS Percentage
FROM customer_data
GROUP BY Contract;
```

### **4. Customer Status and Revenue Analysis**
- Groups data by `Customer_Status` and sums `Total_Revenue`.
- Calculates the revenue percentage of each status.
```sql
SELECT Customer_Status, COUNT(Customer_Status) AS TotalCount,
SUM(Total_Revenue) AS TotalRev,
SUM(Total_Revenue) / (SELECT SUM(Total_Revenue) FROM customer_data) * 100 AS RevPercentage
FROM customer_data
GROUP BY Customer_Status;
```

### **5. State-wise Customer Distribution**
- Counts the number of customers per state and calculates percentages.
- Orders results in descending order.
```sql
SELECT state, COUNT(state) AS total_Count,
(COUNT(state) / (SELECT COUNT(*) FROM customer_data)) * 100 AS Percentage
FROM customer_data
GROUP BY state
ORDER BY Percentage DESC;
```

### **6. Unique Internet Types**
- Retrieves distinct internet types.
```sql
SELECT DISTINCT(Internet_Type) FROM customer_data;
```

### **7. Checking for Missing Values**
- Counts NULL or empty values for each column.
```sql
SELECT
    SUM(CASE WHEN NULLIF(TRIM(Customer_ID), '') IS NULL THEN 1 ELSE 0 END) AS Customer_ID_Null_Count,
    SUM(CASE WHEN NULLIF(TRIM(Gender), '') IS NULL THEN 1 ELSE 0 END) AS Gender_Null_Count,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Null_Count,
    ...
    SUM(CASE WHEN NULLIF(TRIM(Churn_Reason), '') IS NULL THEN 1 ELSE 0 END) AS Churn_Reason_Null_Count
FROM customer_data;
```

### **8. Creating Cleaned Data Table**
- Creates a new table `Cleaned_Customer_Data` with cleaned values.
- Replaces empty strings and NULLs with default values.
```sql
CREATE TABLE Cleaned_Customer_Data AS
SELECT
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    COALESCE(NULLIF(TRIM(Value_Deal), ''), 'None') AS Value_Deal,
    COALESCE(NULLIF(TRIM(Internet_Type), ''), 'None') AS Internet_Type,
    COALESCE(NULLIF(TRIM(Online_Security), ''), 'No') AS Online_Security,
    ...
    COALESCE(NULLIF(TRIM(Churn_Reason), ''), 'Others') AS Churn_Reason
FROM Customer_data;
```

### **9. Creating Customer Status View**
- Filters `Cleaned_Customer_Data` for `Churned` and `Stayed` customers.
```sql
CREATE VIEW Customer_Status_View AS
SELECT * FROM Cleaned_Customer_Data
WHERE Customer_Status IN ('Churned', 'Stayed');
```

### **10. Creating Customer Joined View**
- Filters `Cleaned_Customer_Data` for newly joined customers.
```sql
CREATE VIEW Customer_Joined_View AS
SELECT * FROM cleaned_customer_data
WHERE Customer_Status='Joined';
```

### **Functions Used**
- **COALESCE(value1, value2, ...)**: Returns the first non-NULL value.
- **NULLIF(value1, value2)**: Returns NULL if both values are equal.
- **TRIM(value)**: Removes leading and trailing spaces from a string.

