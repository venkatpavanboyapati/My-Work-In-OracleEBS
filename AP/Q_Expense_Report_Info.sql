
SELECT   * 
FROM     ( 
                  SELECT   ppl.full_name, 
                           hdr.invoice_num, 
                           hdr.week_end_date, 
                           line.start_expense_date, 
                           line.end_expense_date, 
                           ccid.segment1 AS company, 
                           ccid.segment3 AS account, 
                           tl.description, 
                           ccid.segment2 AS cost_center, 
                           line.justification, 
                           line.merchant_name, 
                           line.submitted_amount 
                  FROM     ap.ap_expense_report_lines_all line, 
                           ap.ap_expense_report_headers_all hdr, 
                           hr.per_all_people_f ppl, 
                           gl.gl_code_combinations ccid, 
                           applsys.fnd_flex_value_sets vset, 
                           applsys.fnd_flex_values val, 
                           applsys.fnd_flex_values_tl tl 
                  WHERE    line.report_header_id = hdr.report_header_id 
                  AND      hdr.employee_id = ppl.person_id 
                  AND      line.code_combination_id = ccid.code_combination_id 
                  AND      vset.flex_value_set_name = 'WEN_ACCOUNTS' 
                  AND      vset.flex_value_set_id = val.flex_value_set_id 
                  AND      val.flex_value_id = tl.flex_value_id 
                  AND      ccid.segment3 = val.flex_value 
                  AND      hdr.week_end_date > '31-OCT-19' 
                  AND      hdr.week_end_date < '01-JAN-20' 
                  AND      ccid.segment3 IN ('1010', 
                                             '0071', 
                                             '1013', 
                                             '1030', 
                                             '5300', 
                                             '6040', 
                                             '9202') 
                  AND      ppl.effective_end_date > SYSDATE 
                  ORDER BY ccid.segment2, 
                           ppl.full_name ) sub1 
ORDER BY 3 ASC
