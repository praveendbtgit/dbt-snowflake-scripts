WITH c AS (
    SELECT * FROM {{ ref('silver_customers') }}
),
p AS (
    SELECT * FROM {{ ref('silver_policies') }}
),
cl AS (
    SELECT * FROM {{ ref('silver_claims') }}
),
pay AS (
    SELECT * FROM {{ ref('silver_payments') }}
)

SELECT
    c.CUSTOMER_ID,
    p.POLICY_ID,
    p.PREMIUM_AMOUNT,
    SUM(cl.CLAIM_AMOUNT) AS TOTAL_CLAIMS,
    SUM(pay.PAYMENT_AMOUNT) AS TOTAL_PAYMENTS,
    SUM(pay.PAYMENT_AMOUNT) - SUM(cl.CLAIM_AMOUNT) AS PROFIT
FROM c
JOIN p ON c.CUSTOMER_ID = p.CUSTOMER_ID
LEFT JOIN cl ON p.POLICY_ID = cl.POLICY_ID
LEFT JOIN pay ON p.POLICY_ID = pay.POLICY_ID
GROUP BY c.CUSTOMER_ID, p.POLICY_ID, p.PREMIUM_AMOUNT
