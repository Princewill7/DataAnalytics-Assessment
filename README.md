# DataAnalytics-Assessment

## Assessment 1 - Approach
The first CTE, UsersList, extracts user data from the users_customuser table. It selects the user ID (aliased as owner_id) and concatenates the user's first and last names into a full name. This prepares a clean and standardised reference for users to be used in later joins.

The second CTE, Savings_Investment, focuses on counting the number of regular savings and fixed investment plans for each user from the plans_plan table. It uses conditional aggregation with the CASE WHEN clause to check whether each plan is a regular savings or a fixed investment. The result is grouped by the user ID (owner_id), giving each user’s count of savings and investment plans.

The third CTE, DepositAmount, calculates the total amount each user has deposited into their savings account, based on records in the Savings_savingsaccount table. Only successful transactions are included, as determined by specific gateway_response_message values such as "Payment successful" or "Approved." The total amount is summed for each user and cast as a decimal for precision.

The final SELECT statement brings all these CTEs together. It joins the UsersList with Savings_Investment and DepositAmount using LEFT JOINs on the owner_id. This ensures that all users are considered, even if they don’t have deposit records. However, the WHERE clause filters the result to include only users who have at least one regular savings plan and one fixed investment plan. The output displays the user's ID, full name, the number of their savings and investment plans, and the total value of their successful deposits.

## Assessment 2 - Approach
The query begins with a CTE named Marker, which pulls data from the Savings_savingsaccount table. For each owner_id (user), it groups their transactions by month using the DATE_FORMAT(transaction_date, '%Y-%m-01') function. This formatting normalizes all dates in a month to the first day of that month, essentially allowing monthly aggregation. It then counts how many transactions each user made within each month, resulting in a record of transaction frequency per user per month.

The next CTE, Frequency, builds on the Marker CTE. It adds a new column called Frequency_category by using a CASE statement to classify each user-month record based on the number of transactions. Users with 2 or fewer transactions in a month are labeled as "Low Frequency," those with 3 to 9 transactions are labeled as "Medium Frequency," and those with more than 9 are classified as "High Frequency."

Finally, the main SELECT query summarizes the frequency data. It groups the results by Frequency_category and calculates two key metrics for each category: the number of distinct customer-month entries (customer_count) and the average number of transactions (avg_transactions_per_month). This provides a clear picture of how users are engaging with their savings accounts on a monthly basis, categorized by transaction activity levels.


## Assessment 3 - Approach
The query starts with a CTE named LatestTransaction, which pulls data from the Savings_savingsaccount table. It selects key fields including owner_id, plan_id, savings_id, and transaction_date. A window function RANK() is used to rank each transaction by its date in descending order, partitioned by each user (owner_id). This means the most recent transaction for every user will receive a rank of 1.

The second CTE, FilteredTransactions, then filters this ranked data to retain only the most recent transaction for each user (i.e., rnk = 1). It joins the transaction data with the plans_plan table to bring in additional plan information, such as whether the plan is a regular savings or fixed investment, and whether the plan has been deleted. It also calculates the number of days of inactivity using DATEDIFF(CURRENT_DATE, last_transaction_date), which measures the time since the last transaction.

Finally, the main SELECT query retrieves records where the user has an active plan (either savings or investment) that hasn't been deleted, and where their last transaction occurred at least 365 days ago (i.e., inactive for a year or more). It also categorises each plan type into either 'Savings' or 'Investment' using a CASE statement.


## Assessment 4 - Approach
The query begins with Temp1, a CTE that extracts essential user details from the users_customuser table. It selects the user ID (aliased as customer_id), concatenates their first and last names into a single Name field, and formats the date_joined value to the first day of the month using DATE_FORMAT(date_joined, '%Y-%m-01'). This formatting sets the foundation for consistent tenure calculation.

The next CTE, Temp2, builds on Temp1 by calculating how long each user has been with the platform. It uses the TIMESTAMPDIFF(MONTH, tenure, CURRENT_DATE) function to determine the total number of months between the user's join date and today, storing this as tenure_months.

Then comes Temp4, which computes transactional insights. It first filters successful transactions from the Savings_savingsaccount table using specific gateway_response_message values that indicate success (e.g., 'Payment successful', 'Approved'). For each transaction, it estimates profit as 0.1% (i.e., 0.001 × amount). These are grouped by user (owner_id) and profit, and then the outer query calculates the total number of transactions (total_transactions) and the average profit per transaction (avg_profit) for each user.

Finally, the main SELECT query combines the user data (Temp2) and transaction data (Temp4) using a LEFT JOIN on customer_id and owner_id. It computes the estimated Customer Lifetime Value (estimated_clv) using the formula: (TotalTransactions/TenureinMonths)×12×AverageProfit

This formula annualises the user's transaction frequency and multiplies it by average profit per transaction, giving an estimate of how much value the user is expected to generate annually. The result is ordered in descending order of estimated_clv, so the most valuable users appear at the top.


## Challenges
The challenges faced were as follows;
It was difficult to differentiate between the savings plan and the fixed investment plan; however, this was tackled by educated guess after looking at the table headers and deciphering what they would mean.
