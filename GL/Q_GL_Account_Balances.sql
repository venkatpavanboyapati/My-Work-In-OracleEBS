  SELECT a.ledger_id,
         a.budget_version_id,
         a.period_year,
         a.code_combination_id,
         a.currency_code,
         a.period_name,
         a.actual_flag,
         gcc.segment1,
         gcc.segment2,
         gcc.segment3,
         gcc.segment4,
         a.PERIOD_NET_DR,
         a.last_update_date,
         a.*
    FROM apps.gl_balances a, apps.GL_code_Combinations gcc
   WHERE a.code_combination_id = gcc.code_combination_id 
       --and segment1 = '35'
       --and segment2 = '04112'
         AND segment3 = '4041' AND actual_flag = 'A' 
      --and period_name in ( '01-16')
         AND period_year = 2016
--and a.budget_version_id = 1121 -- Revised USD budget
ORDER BY period_num
