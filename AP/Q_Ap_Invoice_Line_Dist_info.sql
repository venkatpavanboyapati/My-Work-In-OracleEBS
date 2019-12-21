select  aia.invoice_id 
       ,aia.source
            ,aia.invoice_num
            ,aia.invoice_date 
            ,aia.invoice_amount
            ,aial.line_number 
            ,fit.description line_type 
           ,aial.amount line_amount
          ,aida.attribute1
          ,aida.attribute2
          ,aida.attribute3
           ,aida.distribution_line_number
          ,aida.line_type_lookup_code
          ,aida.dist_code_combination_id
          ,aida.amount distribution_amount
  from apps.ap_invoices_all aia
    ,apps.ap_invoice_lines_all aial
    ,apps.fnd_lookup_values fit
    ,apps.ap_invoice_distributions_all aida
 WHERE 1 = 1 
   AND aia.invoice_id = aial.invoice_id
   AND aial.invoice_id = aida.invoice_id
   AND aial.line_number = aida.invoice_line_number
   AND aial.line_type_lookup_code = fit.lookup_code
   AND fit.lookup_type = 'INVOICE LINE TYPE'
   --AND aia.invoice_id = 10853141
  --and aia.source = ':P_Source'
   order by aida.creation_date desc;
