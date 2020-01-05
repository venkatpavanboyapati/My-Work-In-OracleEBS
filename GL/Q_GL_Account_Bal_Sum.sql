SELECT   gld.NAME, gb.actual_flag, gb.period_name, gcc.code_combination_id,
            gcc.segment1
         || '-'
         || gcc.segment2
         || '-'
         || gcc.segment3
         || '-'
         || gcc.segment4 "DISTRIBUTION",
         gcc.segment1, gcc.segment2, gcc.segment3, gcc.segment4,
         SUM (NVL (gb.begin_balance_dr, 0) - NVL (gb.begin_balance_cr, 0)
             ) "OPEN BAL",
         NVL (gb.period_net_dr, 0) "DEBIT", NVL (gb.period_net_cr,
                                                 0) "CREDIT",
         SUM (NVL (gb.period_net_dr, 0) - NVL (gb.period_net_cr, 0)
             ) "NET MOVEMENT",
           SUM ((NVL (gb.period_net_dr, 0) + NVL (gb.begin_balance_dr, 0))
               )
         - SUM (NVL (gb.period_net_cr, 0) + NVL (gb.begin_balance_cr, 0))
                                                                  "CLOSE BAL",
         gb.translated_flag, gb.template_id
    FROM gl_balances gb,
         gl_code_combinations gcc,
         gl_ledgers gld
   WHERE gcc.code_combination_id = gb.code_combination_id
     AND gb.actual_flag = 'A'
     AND gb.template_id IS NULL
     AND gb.ledger_id = gld.ledger_id
     AND gb.period_name = 'APR-05'
GROUP BY gld.NAME,
         gb.actual_flag,
         gb.period_name,
         gcc.code_combination_id,
            gcc.segment1
         || '-'
         || gcc.segment2
         || '-'
         || gcc.segment3
         || '-'
         || gcc.segment4,
         gcc.segment1,
         gcc.segment2,
         gcc.segment3,
         gcc.segment4,
         NVL (gb.period_net_dr, 0),
         NVL (gb.period_net_cr, 0),
         gb.translated_flag,
         gb.template_id
  HAVING   SUM ((NVL (gb.period_net_dr, 0) + NVL (gb.begin_balance_dr, 0)))
         - SUM (NVL (gb.period_net_cr, 0) + NVL (gb.begin_balance_cr, 0)) <> 0;
