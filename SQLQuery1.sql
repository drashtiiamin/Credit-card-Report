--create view to connect two table 
CREATE VIEW c_details AS
SELECT
    c.Client_Num,
    c.Customer_Age,
    c.Gender,
    c.Marital_Status,
    c.Education_Level,
    c.Income,
    c.state_cd,
    c.Dependent_Count,
    c.Customer_Job,
    cc.Card_Category,
    cc.Annual_Fees,
    cc.Activation_30_Days,
    cc.Customer_Acq_Cost,
    cc.Week_Start_Date,
    cc.Week_Num,
    cc.Qtr,
    cc.current_year,
    cc.Credit_Limit,
    cc.Total_Revolving_Bal,
    cc.Total_Trans_Amt,
    cc.Total_Trans_Vol,
    cc.Avg_Utilization_Ratio,
    cc.Use_Chip,
    cc.Exp_Type,
    cc.Interest_Earned,
    cc.Delinquent_Acc
FROM
    ccdb.dbo.cust_details c
JOIN
    ccdb.dbo.cc_details cc ON c.Client_Num = cc.Client_Num;

--what are the demographics of customers using each type of credit card?
select Customer_Age, Gender, Education_Level, Marital_Status, Income, Card_Category
from c_details
order by Card_Category DESC;

--which customers have the highest total transaction amounts?
Select Customer_Age, Gender, Education_Level, Marital_Status, Income, Total_Trans_Amt
from c_details
order by Total_Trans_Amt DESC;

--What is the average credit limit per customer and how does it vary by state or gender?
select Gender, state_cd, AVG(Credit_Limit) 
from c_details
group by Gender, state_cd;

--Which customers are at risk of default based on their delinquent account?
select Customer_Age, Gender, Education_Level, Marital_Status, Income, Delinquent_Acc
from c_details
where Delinquent_Acc>0;

--how does the utilization ratio vary among different customer age groups or education levels?
Select
	CASE 
		WHEN Customer_Age BETWEEN 18 AND 22 THEN '18-22'
		WHEN Customer_Age BETWEEN 23 AND 29 THEN '23-29'
		WHEN Customer_Age BETWEEN 30 AND 35 THEN '30-35'
		WHEN Customer_Age BETWEEN 36 AND 45 THEN '36-45'
		ELSE '45 or more'
	END AS age_group, AVG(Avg_Utilization_Ratio) as avg_ratio
from c_details
group by 
	CASE 
		WHEN Customer_Age BETWEEN 18 AND 22 THEN '18-22'
		WHEN Customer_Age BETWEEN 23 AND 29 THEN '23-29'
		WHEN Customer_Age BETWEEN 30 AND 35 THEN '30-35'
		WHEN Customer_Age BETWEEN 36 AND 45 THEN '36-45'
		ELSE '45 or more'
	END
order by age_group;

Select Education_Level, AVG(Avg_Utilization_Ratio) as avg_ratio
from c_details
group by Education_Level;

--What is the relationship between customer income and their credit card usage patterns?
Select Income, AVG(Total_Trans_Amt) AS avg_trans_amt
from c_details
group by Income
order by Income;

Select Income, AVG(Total_Trans_Vol) AS avg_trans_vol
from c_details
group by Income
order by Income;

Select Income, AVG(Credit_Limit) AS CreditLimit
from c_details
group by Income
order by Income;

Select Income, AVG(Avg_Utilization_Ratio) AS avg_ratio
from c_details
group by Income
order by Income;

-- How many customers have annual fees greater than a certain amount?
select COUNT(Client_Num) as total_fees_cnt, Annual_Fees
from c_details
where Annual_Fees>300
group by Annual_Fees;

--what is the total number of customers per state?
Select COUNT(Client_Num) as no_customer, state_cd
From c_details
group by state_cd;
 
--which customers have the highest satisfaction scores?
Select Client_Num, Customer_Age, Gender,state_cd, Cust_Satisfaction_Score
from ccdb.dbo.cust_details
order by Cust_Satisfaction_Score DESC;



