{{
    config(
        materialized='table',
        alias='"g g"',
        quoting={
            "identifier": True
        }
    )
}}
select 1 as id