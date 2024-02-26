use fda;

# Task 1: Identifying Approval Trends
# 1 Determine the number of drugs approved each year and provide insights into the yearly trends.

# Number of drugs approved
select year(ActionDate) as Year_of_approval, count(ApplNo) as Number_of_approvals 
from regactiondate 
where ActionType = 'AP' 
group by year(ActionDate) 
order by (count(ApplNo)) desc;

# Approval trends year-wise
select year(ActionDate) as Year_of_approval, count(ApplNo) as Number_of_approvals 
from regactiondate 
where ActionType = 'AP' 
group by year(ActionDate) 
order by (Year_of_approval) desc;

# 2 Identify the top three years that got the highest and lowest approvals, in descending and ascending order, respectively.

# a)Top 3 Years with highest approvals
select year(ActionDate) as Year_of_approval, count(ApplNo) as Number_of_approvals 
from regactiondate 
where ActionType = 'AP' 
group by (Year_of_approval)
order by (Number_of_approvals) desc
limit 3;

# b)Top 3 Years with lowest approvals
select year(ActionDate) as Year_of_approval, count(ApplNo) as Number_of_approvals 
from regactiondate 
where ActionType = 'AP' and ActionDate is not null
group by (Year_of_approval)
order by (Number_of_approvals) asc
limit 3;

# 3  Explore approval trends over the years based on sponsors
select year(regactiondate.ActionDate) as Year_of_approval, count(regactiondate.ApplNo) as Number_of_approvals, application.SponsorApplicant as Spornsor_Applicant 
from regactiondate 
join application on regactiondate.ApplNo = application.ApplNo
where regactiondate.ActionType = 'AP'
group by (Year_of_approval), application.SponsorApplicant
order by (Number_of_approvals) desc;

# 4  Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
select year(regactiondate.ActionDate) as Year_of_approval, count(regactiondate.ApplNo) as Number_of_approvals, application.SponsorApplicant as Spornsor_Applicant 
from regactiondate 
join application on regactiondate.ApplNo = application.ApplNo
where regactiondate.ActionType = 'AP' and year(regactiondate.ActionDate) between 1939 and 1960
group by (Year_of_approval), application.SponsorApplicant 
order by (Number_of_approvals) desc;

# Task 2: Segmentation Analysis Based on Drug MarketingStatus
# 1  Group products based on MarketingStatus. Provide meaningful insights into the segmentation patterns.
select product.ProductMktStatus as Product_Marketing_Status, product.drugname as Drug_Name
from product
group by product.ProductMktStatus, product.drugname
order by product.ProductMktStatus;


# 2 Calculate the total number of applications for each MarketingStatus year-wise after the year 2010.
select year(appdoc.DocDate) as Marketing_Year, product.ProductMktStatus as Marketing_Status, count(appdoc.ApplNo) as Application_count 
from appdoc
join product on appdoc.ApplNo = product.ApplNo 
where year(appdoc.DocDate) > 2010
group by Marketing_Year , Marketing_Status
order by Marketing_Year asc, Application_count desc;

# 3 dentify the top MarketingStatus with the maximum number of applications and analyze its trend over time
select year(appdoc.DocDate) as Marketing_Year, product.ProductMktStatus as Marketing_Status, count(appdoc.ApplNo) as Application_count 
from appdoc
join product on appdoc.ApplNo = product.ApplNo
group by Marketing_Year , Marketing_Status
order by Application_count desc;

# Task 3: Analyzing Products
# 1 Categorize Products by dosage form and analyze their distribution.
select product.Dosage as Dosage, product.Form as Form, product.drugname as Drug_Name, count(product.ApplNo) as Count_of_Distribution
from product
group by Dosage, Form, Drug_name
order by Form asc, Dosage asc, Count_of_Distribution desc;

# 2  Calculate the total number of approvals for each dosage form and identify the most successful forms.
select product.Form as Form, count(regactiondate.ActionType) as Total_Approvals 
from product
join regactiondate on product.ApplNo = regactiondate.ApplNo
where regactiondate.ActionType = 'AP'
group by Form
order by Total_Approvals desc;

# 3  Investigate yearly trends related to successful forms. 
select year(regactiondate.ActionDate) as Year_of_Approval, product.Form as Form, count(regactiondate.ActionType) as Total_Approvals 
from product
join regactiondate on product.ApplNo = regactiondate.ApplNo
where regactiondate.ActionType = 'AP'
group by Year_of_Approval, Form
order by Total_Approvals desc;

# Task 4: Exploring Therapeutic Classes and Approval Trends
# 1 Analyze drug approvals based on therapeutic evaluation code (TE_Code)
select product_tecode.TECode as TE_Code, regactiondate.ActionType as Action_Type, count(product_tecode.ApplNo) as Total_Count
from product_tecode
join regactiondate on product_tecode.ApplNo = regactiondate.ApplNo
where regactiondate.ActionType = 'AP'
group by TE_Code
order by Total_Count desc;

# 2 Determine the therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
select Year_of_Approval, TE_Code, Total_Count
from (
select year(regactiondate.ActionDate) as Year_of_Approval, product_tecode.TECode as TE_Code, regactiondate.ActionType as Action_Type, count(product_tecode.ApplNo) as Total_Count,
rank () over (partition by year(regactiondate.ActionDate) order by count(product_tecode.ApplNo) desc) as rnk
from regactiondate
join product_tecode on product_tecode.ApplNo = regactiondate.ApplNo
where regactiondate.ActionType = 'AP'
group by Year_of_Approval, TE_Code
) as ranked 
where rnk = 1
order by Total_Count desc, Year_of_Approval;

