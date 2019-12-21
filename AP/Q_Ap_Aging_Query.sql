 SELECT vendor_name,
         vendor_number,
         invoice_number,
         invoice_date,
         gl_date,
         invoice_type,
         due_date,
         past_due_days,
         invoice_amount,
         amt_due_remaining,
         payment_terms,
         CASE WHEN past_due_days <= 0 THEN amt_due_remaining ELSE NULL END
            current_bucket,
         CASE
            WHEN past_due_days > 0 AND past_due_days <= 30
            THEN
               amt_due_remaining
            ELSE
               NULL
         END
            bucket_1_30,
         CASE
            WHEN past_due_days > 30 AND past_due_days <= 60
            THEN
               amt_due_remaining
            ELSE
               NULL
         END
            bucket_31_60,
         CASE
            WHEN past_due_days > 60 AND past_due_days <= 90
            THEN
               amt_due_remaining
            ELSE
               NULL
         END
            bucket_61_90,
         CASE WHEN past_due_days > 90 THEN amt_due_remaining ELSE NULL END
            greater_than_90
    FROM (SELECT pv.vendor_name vendor_name,
                 pv.segment1 vendor_number,
                 i.invoice_num invoice_number,
                 i.payment_status_flag,
                 i.invoice_type_lookup_code invoice_type,
                 i.invoice_date invoice_date,
                 i.gl_date gl_date,
                 ps.due_date due_date,
                 CEIL (
                      TO_DATE (TO_CHAR ( :p_as_of_date, 'DD-MON-RRRR'),
                               'DD-MON-RRRR')
                    - ps.due_date)
                    past_due_days,
                   NVL (aida.invoice_amount, i.invoice_amount)
                 - NVL (aipa.invoice_amt_paid, 0)
                    amt_due_remaining,
                 term.name payment_terms,
                 i.invoice_amount
            FROM ap_payment_schedules_all ps,
                 ap_invoices_all i,
                 po_vendors pv,
                 ap_lookup_codes alc1,
                 ap_terms_val_v term,
                 (  SELECT SUM (p.amount + NVL (p.discount_taken, 0))
                              invoice_amt_paid,
                           p.invoice_id
                      FROM ap_invoice_payments_all p
                     WHERE p.accounting_date <= :p_as_of_date
                  GROUP BY p.invoice_id) aipa,
                 (  SELECT SUM (d.amount) invoice_amount, d.invoice_id
                      FROM ap_invoice_distributions_all d
                     WHERE d.accounting_date <= :p_as_of_date
                  GROUP BY d.invoice_id) aida
           WHERE     i.invoice_id = ps.invoice_id
                 AND i.vendor_id = pv.vendor_id
                 AND i.cancelled_date IS NULL
                 AND alc1.lookup_type(+) = 'INVOICE TYPE'
                 AND alc1.lookup_code(+) = i.invoice_type_lookup_code
                 AND i.terms_id = term.term_id(+)
                 AND i.invoice_id = aipa.invoice_id(+)
                 AND i.invoice_id = aida.invoice_id(+)
                 AND   NVL (aida.invoice_amount, i.invoice_amount)
                     - NVL (aipa.invoice_amt_paid, 0) != 0
                 AND NVL ( (SELECT MIN (d.accounting_date)
                              FROM ap_invoice_distributions_all d
                             WHERE d.invoice_id = i.invoice_id),
                          (i.gl_date)) <= ( :p_as_of_date))
ORDER BY vendor_name, vendor_number, payment_terms
