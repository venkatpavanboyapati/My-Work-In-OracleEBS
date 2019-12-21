SELECT "Transaction Type Name",
       party_name,
       PARTY_SITE_NUMBER,
       "Payment Terms",
       gl_date,
       due_date,
       total_days,
       CASE WHEN total_days > 0 THEN amt_due_remaining END "Not Due Amount",
       CASE WHEN total_days BETWEEN 1 AND 30 THEN amt_due_remaining END
          "0 to 30",
       CASE WHEN total_days BETWEEN 31 AND 60 THEN amt_due_remaining END
          "31 to 60",
       CASE WHEN total_days BETWEEN 61 AND 90 THEN amt_due_remaining END
          "61 to 90",
       CASE WHEN total_days BETWEEN 91 AND 120 THEN amt_due_remaining END
          "91 to 120",
       CASE WHEN total_days > 120 THEN amt_due_remaining END " More than 120",
       "Transaction Date",
       "Transaction Number",
       amount_due_original,
       amt_due_remaining
  FROM (  SELECT RT.NAME "Transaction Type Name",
                 hp.party_name,
                 aps.due_date,
                 hps_bill.PARTY_SITE_NUMBER,
                 pt.name "Payment Terms",
                 aps.gl_date,
                 TO_DATE ( :p_as_of_date) - aps.due_date total_days,
                 ra.trx_date "Transaction Date",
                 ra.trx_number "Transaction Number",
                 aps.amount_due_original,
                 (  aps.amount_due_original
                  - NVL (
                       (SELECT SUM (NVL (ara.amount_applied, 0))
                          FROM ar_receivable_applications_all ara
                         WHERE     ara.applied_customer_trx_id =
                                      aps.customer_trx_id
                               AND ara.display = 'Y'
                               AND TRUNC (ara.gl_date) <= :p_as_of_date),
                       0)
                  + NVL (
                       (SELECT SUM (NVL (aaa.amount, 0))
                          FROM ar_adjustments_all aaa
                         WHERE     aaa.payment_schedule_id =
                                      aps.payment_schedule_id
                               AND aaa.gl_date <= :p_as_of_date),
                       0))
                    amt_due_remaining,
                 hc.ORIG_SYSTEM_REFERENCE "Orig_Sys_Bill_To_Cust_Ref",
                 hcasa_bill.ORIG_SYSTEM_REFERENCE
                    "Orig_Sys_Bill_to_Cus_Add_Ref",
                 hc.ORIG_SYSTEM_REFERENCE "Orig_Sys_Ship_to_Cus_Acc_Ref",
                 hcasa_bill.ORIG_SYSTEM_REFERENCE "Orig_Ship_Cus_Acc_Add_Ref"
            FROM ra_customer_trx_all ra,
                 ar_payment_schedules_all aps,
                 ra_cust_trx_types_all rt,
                 hz_cust_accounts hc,
                 hz_parties hp,
                 hz_cust_acct_sites_all hcasa_bill,
                 hz_cust_site_uses_all hcsua_bill,
                 hz_party_sites hps_bill,
                 ra_terms pt
           WHERE     1 = 1
                 AND ra.TERM_ID = pt.TERM_ID(+)
                 AND ra.customer_trx_id = aps.customer_trx_id
                 AND ra.org_id = aps.org_id
                 AND ra.complete_flag = 'Y'
                 --AND rl.line_type IN ('FREIGHT', 'LINE')
                 AND ra.cust_trx_type_id = rt.cust_trx_type_id
                 AND ra.bill_to_customer_id = hc.cust_account_id
                 AND hc.status = 'A'
                 AND hp.party_id = hc.party_id
                 AND hcasa_bill.cust_account_id = ra.bill_to_customer_id
                 AND hcasa_bill.cust_acct_site_id =
                        hcsua_bill.cust_acct_site_id
                 AND hcsua_bill.site_use_code = 'BILL_TO'
                 AND hcsua_bill.site_use_id = ra.bill_to_site_use_id
                 AND hps_bill.party_site_id = hcasa_bill.party_site_id
                 AND hcasa_bill.status = 'A'
                 AND hcsua_bill.status = 'A'
                 AND aps.amount_due_remaining <> 0
                 AND aps.status = 'OP'
                 AND aps.class != 'PMT'
                 AND aps.gl_date <= :p_as_of_date
                 AND ra.org_id = :p_org_id
        ORDER BY ra.trx_number) a1
