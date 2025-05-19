With UsersList as
(Select id as owner_id, CONCAT_WS(' ', first_name, last_name) as Name
from users_customuser)

,Savings_Investment as
(Select owner_id,
count(case when is_regular_savings = '1' then owner_id else null end) as savings_count, 
count(case when is_fixed_investment = '1' then owner_id else null end) as investment_count
from plans_plan
group by 1 order by owner_id desc)

,DepositAmount as
(Select owner_id, CAST(sum(amount) AS DECIMAL(10,2)) as total_deposits
from Savings_savingsaccount
where gateway_response_message in ('Payment successful','Approved','Approved by Financial Institution','Successful')
group by 1)

Select u.owner_id, u.name, s.savings_count, s.investment_count, d.total_deposits
from UsersList u
LEFT JOIN Savings_Investment s ON s.owner_id = u.owner_id
LEFT JOIN DepositAmount d ON d.owner_id = u.owner_id
where s.savings_count > '0' and s.investment_count > '0'