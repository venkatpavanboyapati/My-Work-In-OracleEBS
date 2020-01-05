------------------------------------------------------------------------
--  GL Journal Header Details
--  Version 1.0
--  Description :
--      Provides GL Journal Header Level Details with Approver Info
--
-- How to use:
--  1 Add filter Conditions to restrict data in output. 
--  2.Run the query and Modify select columns as required
--
------------------------------------------------------------------------
SELECT  gll.name Ledger_name
       ,gjh.period_name
       ,glb.name  Batch_name
       ,gjh.name  Journal_name
       ,gjh.status
       ,gjh.description
       ,gjh.running_total_dr 
       ,gjh.running_total_cr
       ,papf.full_name  Approver
       ,fu.user_name   Created_by
       ,gjs.user_je_source_name
       ,gjc.user_je_category_name
       ,gjh.Date_created
       ,gjh.Currency_code
       ,gjh.Posted_Date
       ,gjh.Currency_conversion_rate
       ,gjh.currency_conversion_type
       ,gjh.currency_conversion_date
       ,gjh.je_from_sla_flag
  FROM apps.gl_je_headers gjh,
       apps.gl_je_batches glb,
       apps.fnd_user fu,
       apps.gl_je_sources gjs,
       apps.gl_je_categories gjc,
       apps.gl_ledgers gll,
      (SELECT person_id,full_name
          FROM apps.per_all_people_f papf
         WHERE SYSDATE BETWEEN effective_start_date AND effective_end_date)
       papf
WHERE     gjh.je_batch_id = GLB.je_batch_id
       AND GLB.approver_employee_id = papf.person_id (+)
       AND gjh.created_by = fu.user_id
       AND gjh.je_source = gjs.je_source_name
       AND gjh.je_category = gjc.je_category_name
       AND gjh.ledger_id = gll.ledger_id 
ORDER BY gjh.creation_date DESC;
