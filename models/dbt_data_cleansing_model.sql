{{
    config(
        materialized='table',
        database='ECOM_PROJECT',
        schema='SILVER_SCHEMA'
    )
}}

WITH PRAVEEN_DBT_TRAINER AS (
SELECT TRIM(CUST_ID) AS CUSTOMER_ID, 
       REGEXP_REPLACE(ORD_ID,'[^0-9]') AS ORDER_ID, 
       INITCAP(TRIM(F_NAME)) AS F_NAME, 
       INITCAP(TRIM(M_NAME)) AS M_NAME, 
       INITCAP(TRIM(L_NAME)) AS L_NAME, 
       TRIM(UPPER(L_NAME||' '||F_NAME||' '||NVL(M_NAME,''))) AS FULL_NAME,
       CASE WHEN UPPER(GENDER) = 'M' THEN 'MALE'
            WHEN UPPER(GENDER) = 'F' THEN 'FEMALE' 
            WHEN GENDER IS NULL THEN 'NOT SPECIFIED' END GENDER,        
       TO_CHAR(TO_DATE(DOB),'YYYY') AS YEAR_OF_BIRTH,
       TO_CHAR(TO_DATE(DOB),'MMMM') AS MONTH_OF_BIRTH,
       TO_CHAR(TO_DATE(DOB),'DD-MON-YYYY') DOB,
       DATEDIFF(YEAR,DOB,CURRENT_DATE) AGE_OF_CUSTOMER,    
        UPPER(EMAIL) EMAIL,
        UPPER(split_part(SPLIT_PART(EMAIL,'@',2),'.',1))  DOMAIN,
        'Rs.'||CAST(ORDER_AMOUNT AS DECIMAL(10,2)) ORDER_AMOUNT, 
        QUANTITY, 
        coalesce(DISCOUNT,0) DISCOUNT,
         ORDER_DATE, CREATED_AT, 
         upper(COUNTRY) COUNTRY, 
         decode(IS_ACTIVE,1,'ACTIVE',0,'INACTIVE') STATUS,
         ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID,ORDER_ID,ORDER_DATE ORDER BY 1,2) K
    FROM dual
    
)
SELECT {{dbt_utils.generate_surrogate_key(['CUSTOMER_ID','ORDER_ID'])}} customer_sk, * 
      FROM PRAVEEN_DBT_TRAINER
  QUALIFY K=1
  
