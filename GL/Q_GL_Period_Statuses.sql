
SELECT gl_led.ledger_id,
       gl_led.NAME ledger_name,
       hou.organization_id,
       hou.NAME org_name,
       gps.period_set_name,
       gp.period_name,
       gp.start_date,
       gp.end_date,
       gp.period_num,
       gp.period_type,
       gprs.closing_status
  FROM gl_ledgers gl_led,
       hr_operating_units hou,
       gl_period_sets gps,
       gl_periods gp,
       gl_period_statuses gprs
 WHERE     1 = 1
       AND hou.organization_id = fnd_profile.VALUE ('ORG_ID')
       AND hou.set_of_books_id = gl_led.ledger_id
       AND gl_led.period_set_name = gps.period_set_name
       AND gps.period_set_name = gp.period_set_name
       AND gp.adjustment_period_flag = 'N'
       AND gp.period_name = gprs.period_name
       AND gprs.set_of_books_id = gl_led.ledger_id
       AND gprs.set_of_books_id = fnd_profile.VALUE ('GL_SET_OF_BKS_ID')
       AND gprs.application_id = 101  -- Change Application to get Subledger status
       AND gprs.closing_status IN ('O', 'F')
