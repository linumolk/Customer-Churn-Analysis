--                          TELCO CUSTOMER CHURN ANALYSIS

CREATE DATABASE Customer_churn;

USE Customer_churn;

CREATE TABLE customer_info 
(customerID varchar(20) primary key, gender varchar(6), SeniorCitizen int, Partner varchar(10), Dependents varchar(10),
tenure int, PhoneService varchar(10), MultipleLines varchar (20), InternetService varchar(20), 
OnlineSecurity varchar(20), OnlineBackup varchar(20), DeviceProtection varchar(20), TechSupport varchar(20),
StreamingTV varchar(20), StreamingMovies varchar(20), Contract varchar(20), PaperlessBilling varchar(20),
PaymentMethod varchar(30), MonthlyCharges decimal (10,2), TotalCharges varchar(20), Churn varchar(20));

DESCRIBE customer_info;

SELECT * FROM customer_info;

-- Total no.of rows
SELECT COUNT(*) FROM customer_info;

-- Changed blank cells to null
UPDATE customer_info
SET Totalcharges = NULL
WHERE Totalcharges = " ";

SELECT COUNT(*) FROM customer_info WHERE Totalcharges IS NULL ;

-- Altered datatype of totalcharges from varchar to decimal
ALTER TABLE customer_info MODIFY Totalcharges DECIMAL(10,2);

SELECT tenure, Totalcharges FROM customer_info
WHERE Totalcharges IS NULL;

ALTER TABLE customer_info MODIFY SeniorCitizen varchar(10);

UPDATE customer_info SET SeniorCitizen = 
CASE
WHEN SeniorCitizen = 0 THEN "No"
WHEN SeniorCitizen = 1 THEN "Yes"
END;

SELECT tenure, Totalcharges FROM customer_info WHERE Totalcharges IS NULL;

UPDATE customer_info
SET TotalCharges = 0
WHERE TotalCharges IS NULL;

-- DATA CLEANING

-- Duplicate Check
SELECT customerID, COUNT(*) FROM customer_info
GROUP BY customerID
HAVING COUNT(*) > 1;

-- Checked for inconsistent values

SELECT DISTINCT gender FROM customer_info;
SELECT DISTINCT SeniorCitizen FROM customer_info;
SELECT DISTINCT partner FROM customer_info;
SELECT DISTINCT Dependents FROM customer_info;
SELECT DISTINCT PhoneService FROM customer_info;
SELECT DISTINCT MultipleLines FROM customer_info;
SELECT DISTINCT InternetService FROM customer_info;
SELECT DISTINCT OnlineSecurity FROM customer_info;
SELECT DISTINCT OnlineBackup FROM customer_info;
SELECT DISTINCT DeviceProtection FROM customer_info;
SELECT DISTINCT TechSupport FROM customer_info;
SELECT DISTINCT StreamingTV FROM customer_info;
SELECT DISTINCT StreamingMovies FROM customer_info;
SELECT DISTINCT Contract FROM customer_info;
SELECT DISTINCT OnlineBackup FROM customer_info;
SELECT DISTINCT PaperlessBilling FROM customer_info;
SELECT DISTINCT PaymentMethod FROM customer_info;
SELECT DISTINCT Churn FROM customer_info;

-- Outlier Checking
SELECT MIN(MonthlyCharges) AS MinCharge, MAX(MonthlyCharges) AS MaxCharge
FROM customer_info;

SELECT MonthlyCharges FROM customer_info WHERE MonthlyCharges < 18.25;
SELECT MonthlyCharges FROM customer_info WHERE MonthlyCharges > 118.75;

-- Check for Inconsistent Combinations
SELECT PhoneService FROM customer_info WHERE PhoneService = 'No';

SELECT InternetService, OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, 
StreamingTV, StreamingMovies FROM customer_info WHERE InternetService = 'No';

SELECT tenure, MonthlyCharges, Totalcharges FROM customer_info;

-- Added a column to group tenure 
ALTER TABLE customer_info ADD tenure_grp varchar(30);

UPDATE customer_info SET tenure_grp = CASE
WHEN tenure <= 12 THEN "0-1 Years" 
WHEN tenure <= 24 THEN "1-2 Years"
WHEN tenure <= 48 THEN "2-3 Years"
ELSE "4+ Years"
END;

SELECT tenure, tenure_grp FROM customer_info;

-- Checked for Negative Values 
SELECT tenure FROM customer_info WHERE tenure < 0;
SELECT MonthlyCharges FROM customer_info WHERE MonthlyCharges < 0;
SELECT Totalcharges FROM customer_info WHERE Totalcharges < 0;


-- EXPLORATORY DATA ANALYSIS

-- 1.Total Number of Customers
SELECT COUNT(customerID) FROM customer_info;

-- 2.Churn vs Not churned count
SELECT Churn, COUNT(*) AS Count_Customers,
ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM customer_info), 2) AS Percentage
FROM customer_info
GROUP BY Churn;

-- 3.Total Customer by Gender
SELECT gender, Count(*) FROM customer_info
GROUP BY gender;

-- 4.Total No.of Senior Citizen churned
SELECT SeniorCitizen, COUNT(*) AS Count
FROM customer_info
WHERE Churn = "Yes"
GROUP BY SeniorCitizen;

-- 5.Churn rate by tenure
SELECT tenure,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info
GROUP BY tenure
ORDER BY Churned DESC;

-- 6.Churn rate by tenure group
SELECT tenure_grp,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info
GROUP BY tenure_grp;

-- 7.Churn rate by internet service
SELECT InternetService,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info
GROUP BY InternetService
ORDER BY Churn_Rate DESC;

-- 8.Churn count by phone service
SELECT PhoneService, COUNT(*) AS Churn_Count
FROM customer_info
WHERE Churn = 'Yes'
GROUP BY PhoneService;

-- 9.Churn rate by Contract
SELECT Contract, COUNT(*) AS Churn_Count,
SUM(CASE WHEN churn = "Yes" THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN churn = "Yes" THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY Contract;

-- 10.Churn rate by gender
SELECT gender, COUNT(*) AS Churn_Count,
SUM(CASE WHEN churn = "Yes" THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN churn = "Yes" THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY gender;

-- 11.Churn rate by payment method
SELECT PaymentMethod, COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 END) AS Churned,
ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY PaymentMethod ORDER BY Churn_Rate DESC;

-- 12.Churn rate by internet Service Type
SELECT InternetService, COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn="Yes" THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn="Yes" THEN 1 ELSE 0 END )/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY InternetService;

-- 13.Churn Rate by Monthly Charges
SELECT AVG(MonthlyCharges) FROM customer_info;

ALTER TABLE customer_info ADD Monthlycharge_range varchar(10);

UPDATE customer_info SET Monthlycharge_range =
CASE  
WHEN MonthlyCharges < 50 THEN "Low"
WHEN MonthlyCharges BETWEEN 50 AND 80 THEN "Medium"
ELSE "High"
END;

SELECT MonthlyCharges, Monthlycharge_range FROM customer_info;

SELECT Monthlycharge_range, COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY Monthlycharge_range;

-- 14.Churn rate by paperless billing
SELECT PaperlessBilling, COUNT(*) AS total,
SUM(CASE WHEN Churn='Yes' THEN 1 END) AS churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 END)/COUNT(*)*100,2) AS churn_rate
FROM customer_info
GROUP BY PaperlessBilling;

-- 15.Churn rate by TechSupport
SELECT TechSupport, COUNT(*) AS total,
SUM(CASE WHEN Churn='Yes' THEN 1 END) AS churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 END)/COUNT(*)*100,2) AS churn_rate
FROM customer_info
GROUP BY TechSupport;

-- 16.Churn Rate by Contract Type + Monthly Charges
SELECT Contract,
ROUND(AVG(MonthlyCharges),2) AS Avg_MonthlyCharges,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info
GROUP BY Contract;

-- 17.Churn Rate by Online Security, Device Protection, Backup
SELECT OnlineSecurity, COUNT(*) AS Total_customers,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM Customer_info GROUP BY OnlineSecurity;

SELECT DeviceProtection, COUNT(*) AS Total_customers,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM Customer_info GROUP BY DeviceProtection;

SELECT OnlineBackup, COUNT(*) AS Total_customers,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM Customer_info GROUP BY OnlineBackup;


-- 18.Churn Rate by No.of services used.
SELECT Total_Services,
COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM (SELECT customerID,
((OnlineSecurity='Yes') +
(OnlineBackup='Yes') +
(DeviceProtection='Yes') +
(TechSupport='Yes') +
(StreamingTV='Yes') +
(StreamingMovies='Yes')) AS Total_Services, Churn FROM customer_info) AS sub
GROUP BY Total_Services ORDER BY Churn_Rate DESC;


-- 19.High-value customers who churned
SELECT customerID, MonthlyCharges, TotalCharges, tenure
FROM customer_info
WHERE Churn='Yes'
ORDER BY TotalCharges DESC
LIMIT 20;

-- 20.Customers with very short tenure but high monthly charges
SELECT customerID, tenure, MonthlyCharges, Churn
FROM customer_info
WHERE tenure < 3 AND MonthlyCharges > 80;

-- 21.Monthly Revenue lost due to churn
SELECT ROUND(SUM(MonthlyCharges),2) AS Total_Revenue_Lost
FROM customer_info
WHERE Churn='Yes';

-- 22.Average monthly revenue lost due to churn
SELECT ROUND(AVG(MonthlyCharges),2) AS Avg_Loss_From_Churn
FROM customer_info
WHERE Churn = 'Yes';


-- 23. Churn rate by dependents and partner
SELECT Partner, COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY Partner;

SELECT Dependents, COUNT(*) AS Total_Customers,
SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS Churned,
ROUND(SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)/COUNT(*)*100,2) AS Churn_Rate
FROM customer_info GROUP BY Dependents;






