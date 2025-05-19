WITH Marker AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m-01') AS period,
        COUNT(id) AS transaction_number
    FROM Savings_savingsaccount
    GROUP BY owner_id, period
),

Frequency AS (
    SELECT 
        *, 
        CASE 
            WHEN transaction_number <= 2 THEN 'Low Frequency'
            WHEN transaction_number <= 9 THEN 'Medium Frequency'
            ELSE 'High Frequency' 
        END AS Frequency_category
    FROM Marker
)

SELECT 
    Frequency_category, 
    COUNT(owner_id) AS customer_count, 
    AVG(transaction_number) AS avg_transactions_per_month
FROM Frequency
GROUP BY Frequency_category;