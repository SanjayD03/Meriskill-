/*----------------------------- Create a Database----------------------------------------------*/
CREATE DATABASE DIABETES;

/*----------------------------- Use a Specific Database------------------------------------------*/
USE DIABETES;

/*----------------------------- Creating a Table for Dataset:------------------------------------*/
DROP TABLE IF EXISTS DIABETES_DATA;
CREATE TABLE DIABETES_DATA(
Pregnancies INT,
Glucose	INT,
BloodPressure INT,
SkinThickness INT,
Insulin	INT,
BMI	FLOAT,
DiabetesPedigreeFunction FLOAT,
Age	INT,
Outcome INT
);

/*----------------------------- Loading the Data in file ------------------------------------*/
LOAD DATA INFILE 'D:/MeriSkill/Project 2 - Diabetes Data-20231009T143032Z-001/Project 2 - Diabetes Data/Project 2 MeriSKILL/diabetes.csv' INTO TABLE DIABETES_DATA
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

/*---------------- To fetch all the data stored in the Specific table(Diabetes Data):-------------------*/
SELECT*FROM DIABETES_DATA;

/*---------------------------------------- Questionnaires.------------------------------------------*/
#1. What are the average health metrics (glucose levels, blood pressure, BMI, skin thickness) based on the number of pregnancies and outcomes (Diabetic and Non-Diabetic)?
SELECT SUM(Pregnancies) AS "Total Number of Pregnancies", 
		ROUND(avg(Glucose),2) AS "Average Glucose Level", 
		ROUND(avg(BloodPressure),2) AS "Average Blood Pressure",
		ROUND(avg(BMI),2) AS "Average BMI",
		ROUND(avg(SkinThickness),2) AS "Average Skin Thickness",
		SUM(Outcome) as "Total Outcomes"
FROM diabetes_data;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 # 2. What is the percentage distribution of health conditions among the given population, and how does it compare between Diabetic and Non-Diabetic individuals?
 SELECT 
    CASE 
        WHEN outcome = 1 THEN 'Diabetic'
        WHEN outcome = 0 THEN 'Non-Diabetic'
    END AS Health_Condition,
    COUNT(*) AS "Total Count",
    round(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
FROM 
    Diabetes_Data
GROUP BY 
    Health_Condition;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
#3. What is the percentage distribution of health statuses within the population based on glucose level, differentiating between Normal, Prediabetic, and Diabetic individuals?
SELECT
	CASE
		WHEN Glucose<100 THEN "Normal"
		WHEN Glucose>=100 AND Glucose<=125 THEN "Prediabetic"
		ELSE "Diabetic"
    END AS Health_Status,
    COUNT(*) AS Total_Count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
FROM 
	Diabetes_Data
GROUP BY 
	Health_status
ORDER BY 
    Total_count;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
#4.What is the distribution of blood pressure statuses among the population, with a focus on the prevalence of Normal, Not Measured, and Elevated statuses?
SELECT
	CASE
		WHEN BloodPressure= 0 THEN "Not Measured"
		WHEN BloodPressure<120 THEN "Normal"
		WHEN BloodPressure>=120 AND BloodPressure<=129 THEN "Elevated"
		WHEN BloodPressure>=130 AND BloodPressure<=139 THEN "High BP"
		ELSE "Hypertension"
	END AS BloodPressure_Status,
	COUNT(*) as Total_Count,
	ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
FROM 
	Diabetes_Data
GROUP BY 
	BloodPressure_Status;
        
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------        
# 5. How is the population distributed across different age groups, specifically focusing on Adults, Young individuals, and Senior Citizens?
SELECT
    CASE
        WHEN age >= 18 AND age <= 25 THEN 'Young'
        WHEN age >= 26 AND age <= 60 THEN 'Adult'
        WHEN age > 60 THEN 'Senior Citizen'
    END AS age_group,
    COUNT(*) as Total_Count,
    Round(COUNT(*)*100/(SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
    FROM 
		Diabetes_Data
    GROUP BY 
		age_group;
        
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
# 6. What is the distribution of blood pressure statuses (Not Measured, Normal, Elevated, High BP, Hypertension) among different age groups (Adult, Young, Senior Citizen)?
SELECT
    CASE
        WHEN age >= 18 AND age <= 25 THEN 'Young'
        WHEN age >= 26 AND age <= 60 THEN 'Adult'
        WHEN age > 60 THEN 'Senior Citizen'
    END AS age_group,
    SUM(CASE
        WHEN BloodPressure = 0 THEN 1
        ELSE 0
    END) AS not_measured,
    SUM(CASE
        WHEN BloodPressure < 120 and BloodPressure !=0 THEN 1
        ELSE 0
    END) AS normal,
    SUM(CASE
        WHEN BloodPressure >= 120 AND BloodPressure <= 129 THEN 1
        ELSE 0
    END) AS elevated,
    SUM(CASE
        WHEN BloodPressure >= 130 AND BloodPressure <= 139 THEN 1
        ELSE 0
    END) AS high_bp,
    SUM(CASE
        WHEN BloodPressure >= 140 THEN 1
        ELSE 0
    END) AS hypertension
FROM
    Diabetes_Data
GROUP BY
    age_group;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
#7. What is the distribution of BMI statuses (Obese, Overweight, Normal, Not Measured, Underweight) within the surveyed population?
SELECT
	CASE
        WHEN BMI= 0 THEN "Not Measured"
        WHEN BMI<18.5 THEN "UnderWeight"
        WHEN BMI>=18.5 AND BMI<=24.9 THEN "Normal"
        WHEN BMI>=25 AND BMI<=29.9 THEN "OverWeight"
        ELSE "Obese"
	END AS BMI_Status,
	COUNT(*) as Total_Count,
	ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
FROM 
	Diabetes_Data
GROUP BY 
	BMI_Status;
    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#8. How many individuals fall under the categories of High Risk, Moderate Risk, and Low Risk based on their DiabetesPedigreeFunction (DPF) scores?
SELECT
	CASE 
		WHEN DiabetesPedigreeFunction>0.8 THEN "High Risk"
		WHEN DiabetesPedigreeFunction >=0.5 AND DiabetesPedigreeFunction <= 0.8 THEN "Moderate Risk"
		ELSE "Low Risk"
	END as DPF_Status,
    COUNT(*) as Total_Count,
	Round(COUNT(*)*100/(SELECT COUNT(*) FROM Diabetes_Data),2) AS "Percentage Distribution"
FROM 
	Diabetes_Data
GROUP BY 
	DPF_Status
ORDER BY 
	Total_Count;