With Temp1 as
(Select id as customer_id,
CONCAT_WS(' ', first_name, last_name) as Name,
DATE_FORMAT(date_joined, '%Y-%m-01') as tenure
from users_customuser)
,
Temp2 as
(Select 
customer_id,
Name,
TIMESTAMPDIFF(MONTH, tenure, CURRENT_DATE) AS tenure_months
from Temp1
)
,
Temp4 as
(select 
owner_id 
, count(*) as total_transactions
, avg(profit) as avg_profit
from 
(
Select 
owner_id, 
#count(*) as total_transactions,
(0.001 * amount) as profit
from Savings_savingsaccount
where gateway_response_message in ('Payment successful','Approved','Approved by Financial Institution','Successful')
group by 1,2
) a
group by 1)

Select 
a.customer_id, 
a.Name, 
a.tenure_months, 
b.total_transactions,
((b.total_transactions / a.tenure_months) * 12 * b.avg_profit) as estimated_clv
FROM
Temp2 as a
LEFT JOIN Temp4 as b ON a.customer_id = b.owner_id
order by estimated_clv desc