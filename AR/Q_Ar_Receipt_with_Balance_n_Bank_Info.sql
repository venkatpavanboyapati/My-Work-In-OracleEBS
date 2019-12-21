select distinct cr.receipt_number, cr.receipt_method_id, rm.name,
                cr.issue_date, cr.amount, cr.cash_receipt_id,
                cr.doc_sequence_value, cr.org_id, cr.currency_code,
                cr.attribute_category, cr.attribute1 cash_amount,
                cr.attribute2 cheque_amount, cr.attribute3 cheque_details,
                round (cr.amount, 2) amt,
                   replace
                      (replace
                          (iby_amount_in_words.get_amount_in_words (cr.amount,
                                                                    'USD',
                                                                    2,
                                                                    null
                                                                   ),
                           '*',
                           null
                          ),
                       'Dollars',
                       null
                      )
                || ' only' amt_word,
                cr.issuer_name, cust.account_number,
                rtrim (rtrim (substrb (party.party_name, 1, 50)),
                       to_multi_byte (' ')
                      ) customer_name,
                ps.due_date maturity_date, bb.bank_name remit_bank_name,
                bb.branch_party_id remittance_bank_branch_id,
                bb.bank_branch_name remit_bank_branch,
                (select sum (ral.extended_amount)
                   from ar_receivable_applications_all ra,
                        ra_customer_trx_lines_all ral
                  where ra.status = 'APP'
                    and ra.applied_customer_trx_id = ral.customer_trx_id
                    and ral.org_id = ra.org_id
                    and ra.cash_receipt_id = cr.cash_receipt_id
                    and ra.org_id = cr.org_id) app_amt,
                (  (select sum (ral.extended_amount)
                      from ar_receivable_applications_all ra,
                           ra_customer_trx_lines_all ral
                     where ra.status = 'APP'
                       and ra.applied_customer_trx_id = ral.customer_trx_id
                       and ral.org_id = ra.org_id
                       and ra.cash_receipt_id = cr.cash_receipt_id
                       and ra.org_id = cr.org_id)
                 - cr.amount
                ) bal
           from ar_cash_receipts_all cr,
                hz_parties party,
                hz_cust_accounts cust,
                ar_payment_schedules_all ps,
                ce_bank_branches_v bb,
                ce_bank_accounts cba,
                ce_bank_acct_uses_all remit_bank,
                ar_receipt_methods rm
          where 1 = 1
            and cr.pay_from_customer = cust.cust_account_id(+)
            and cust.party_id = party.party_id(+)
            and ps.cash_receipt_id(+) = cr.cash_receipt_id
            and ps.org_id(+) = cr.org_id
            and bb.branch_party_id(+) = cba.bank_branch_id
            and remit_bank.bank_acct_use_id(+) = cr.remit_bank_acct_use_id
            and remit_bank.org_id(+) = cr.org_id
            and remit_bank.bank_account_id = cba.bank_account_id(+)
            and cr.receipt_method_id = rm.receipt_method_id
            and cr.receipt_number = nvl (:rcpt_no, cr.receipt_number)
            and cr.org_id = nvl (:p_ou, cr.org_id)
