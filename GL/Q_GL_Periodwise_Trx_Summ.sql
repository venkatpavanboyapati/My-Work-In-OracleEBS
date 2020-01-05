

-------------------------------------------------------------------------------
-- Query to find GL Period-wise Transaction Summary
-------------------------------------------------------------------------------

SELECT
       b.name                        batch_name,
       b.description                 batch_description,
       b.running_total_accounted_dr  batch_total_dr,
       b.running_total_accounted_cr  batch_total_cr,
       b.status                      batch_status,
       b.default_effective_date      effective_date,
       b.default_period_name         batch_period_name,
       b.creation_date,
       u.user_name                   batch_created_by,
       h.je_category,
       h.je_source,
       h.period_name                 je_period_name,
       h.name                        journal_name,
       h.status                      journal_status,
       h.creation_date               je_created_date,
       u1.user_name                  je_created_by,
       h.description                 je_description,
       h.running_total_accounted_dr  je_total_dr,
       h.running_total_accounted_cr  je_total_cr,
       l.je_line_num                 line_number,
       l.ledger_id,
       glcc.concatenated_segments    account,
       l.entered_dr,
       l.entered_cr,
       l.accounted_dr,
       l.accounted_cr,
       xlal.unrounded_accounted_dr   xla_unrounded_accounted_dr,
       xlal.unrounded_accounted_cr   xla_unrounded_accounted_cr,
       l.description,
       xlal.code_combination_id,
       xlal.accounting_class_code,
       xlal.accounted_dr             xlal_accounted_dr,
       xlal.accounted_cr             xlal_accounted_cr,
       xlal.description              xlal_description,
       xlal.accounting_date          xlal_accounting_date,
       xlate.entity_code             xlate_entity_code,
       xlate.source_id_int_1         xlate_source_id_int_1,
       xlate.source_id_int_2         xlate_source_id_int_2,
       xlate.source_id_int_3         xlate_source_id_int_3,
       xlate.security_id_int_1       xlate_security_id_int_1,
       xlate.security_id_int_2       xlate_security_id_int_2,
       xlate.transaction_number      xlate_transaction_number
  FROM
       gl_je_batches                 b,
       gl_je_headers                 h,
       gl_je_lines                   l,
       fnd_user                      u,
       fnd_user                      u1,
       gl_code_combinations_kfv      glcc,
       gl_import_references          gir,
       xla_ae_lines                  xlal,
       xla_ae_headers                xlah,
       xla_events                    xlae,
       xla.xla_transaction_entities  xlate
 WHERE 
       1=1
   AND b.created_by              =  u.user_id
   AND h.created_by              =  u1.user_id
   AND b.je_batch_id             =  h.je_batch_id
   AND h.je_header_id            =  l.je_header_id
   AND xlal.code_combination_id  =  glcc.code_combination_id
   AND l.je_header_id            =  gir.je_header_id
   AND l.je_line_num             =  gir.je_line_num
   AND gir.gl_sl_link_table      =  xlal.gl_sl_link_table
   AND gir.gl_sl_link_id         =  xlal.gl_sl_link_id
   AND xlal.ae_header_id         =  xlah.ae_header_id
   AND xlah.event_id             =  xlae.event_id
   AND xlae.entity_id            =  xlate.entity_id
   AND xlae.application_id       =  xlate.application_id
      -- AND XLATE.SOURCE_ID_INT_1 = RCVT.TRANSACTION_ID
   AND h.je_source               =  'Receivables'
   AND h.period_name             =  'NOV-12' --'&PERIOD_NAME'
