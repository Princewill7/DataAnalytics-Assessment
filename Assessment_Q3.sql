WITH LatestTransaction AS (
    SELECT 
        owner_id, 
        plan_id, 
        savings_id, 
        transaction_date AS last_transaction_date,
        RANK() OVER (PARTITION BY owner_id ORDER BY transaction_date DESC) AS rnk
    FROM Savings_savingsaccount
),
FilteredTransactions AS (
    SELECT 
        a.plan_id, 
        a.owner_id, 
        b.is_regular_savings,
        b.is_fixed_investment,
        b.is_deleted,
        a.last_transaction_date, 
        DATEDIFF(CURRENT_DATE, a.last_transaction_date) AS inactivity_days
    FROM LatestTransaction AS a  
    LEFT JOIN plans_plan AS b ON a.plan_id = b.id
    WHERE a.rnk = 1
)
SELECT 
    plan_id, 
    owner_id, 
    CASE 
        WHEN is_regular_savings = '1' THEN 'Savings'
        WHEN is_fixed_investment = '1' THEN 'Investment'
        ELSE NULL 
    END AS Type, 
    last_transaction_date, 
    inactivity_days
FROM FilteredTransactions
WHERE (is_regular_savings > 0 OR is_fixed_investment > 0)  
      AND inactivity_days >= 365 and is_deleted != '1';