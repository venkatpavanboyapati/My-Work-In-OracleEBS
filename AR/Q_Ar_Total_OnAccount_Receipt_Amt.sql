SELECT NVL (SUM (ps.amount_due_remaining), 0) total_onacct_receipts
  FROM hz_cust_accounts_all cust_acct,
       ar_payment_schedules_all ps,
       ar_receivable_applications_all arr,
       hz_cust_acct_sites_all acct_site,
       hz_party_sites party_site,
       hz_locations loc,
       hz_cust_site_uses_all site_uses,
       ar_cash_receipts_all acr,
       ar_cash_receipt_history_all crh,
       gl_code_combinations cc
 WHERE     TRUNC (ps.gl_date) <= :p_as_of_date
       AND ps.customer_id = cust_acct.cust_account_id
       AND cust_acct.account_number = :p_account_number
       AND ps.customer_id = cust_acct.cust_account_id
       AND acct_site.party_site_id = party_site.party_site_id
       AND loc.location_id = party_site.location_id
       AND ps.cash_receipt_id = acr.cash_receipt_id
       AND acr.cash_receipt_id = crh.cash_receipt_id
       AND crh.account_code_combination_id = cc.code_combination_id
       AND ps.trx_date <= :p_as_of_date
       AND ps.CLASS = 'PMT'
       AND ps.cash_receipt_id = arr.cash_receipt_id
       AND arr.status IN ('ACC')
       AND ps.status = 'OP'
       AND site_uses.site_use_code = 'BILL_TO'
       AND site_uses.cust_acct_site_id = acct_site.cust_acct_site_id
       AND NVL (site_uses.status, 'A') = 'A'
       AND cust_acct.cust_account_id = acct_site.cust_account_id
       AND acct_site.cust_acct_site_id = site_uses.cust_acct_site_id
       AND ps.customer_id = acct_site.cust_account_id
       AND ps.customer_site_use_id = site_uses.site_use_id
HAVING NVL (SUM (arr.amount_applied), 0) > 0;
