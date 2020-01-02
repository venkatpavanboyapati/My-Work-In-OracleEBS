

SELECT DISTINCT                                         
               i.creation_date,
                i.source,
                s.vendor_name,
                s.segment1 vendor_num,
                ss.vendor_site_code,
                i.invoice_num,
                i.invoice_date,
                i.invoice_amount
              --  ,(select max(last_update_date) from apps.ap_invoice_distributions_all d where attribute1 = 'T' and invoice_id = i.invoice_id)
  FROM apps.ap_invoices_all i,
       apps.ap_suppliers s,
       apps.ap_supplier_sites_all ss
 WHERE     1 = 1
       AND i.vendor_id = s.vendor_id
       AND i.vendor_site_id = ss.vendor_site_id
       AND i.creation_date > SYSDATE - 6
       and exists (select * from apps.ap_invoice_distributions_all d where attribute1 = 'T' and invoice_id = i.invoice_id)
     --  and i.org_id = 203
       AND  EXISTS
                  (SELECT *
                     FROM apps.ap_holds_all
                    WHERE     invoice_id = i.invoice_id
                          AND hold_lookup_code IN ('Tax Determination Hold',
                                                   'Tax Process Error Hold')
                          AND release_lookup_code IS NULL)
       order by i.creation_date desc
