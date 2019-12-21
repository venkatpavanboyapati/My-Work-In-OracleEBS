SELECT cba.bank_account_name ,
  cba.bank_account_id,
  cba.bank_account_name_alt,
  cba.bank_account_num ,
  cba.multi_currency_allowed_flag ,
  cba.zero_amount_allowed ,
  cba.account_classification ,
  bb.bank_name ,
  cba.bank_id,
  bb.bank_number,
  bb.bank_branch_type ,
  bb.bank_branch_name ,
  cba.bank_branch_id ,
  bb.bank_branch_number ,
  bb.eft_swift_code ,
  bb.description BANK_DESCRIPTION,
  cba.currency_code ,
  bb.address_line1,
  bb.city,
  bb.county,
  bb.state,
  bb.zip_code,
  bb.country,
  ou.name ,
  gcf.concatenated_segments,
  cba.ap_use_allowed_flag,
  cba.ar_use_allowed_flag,
  cba.xtr_use_allowed_flag,
  cba.pay_use_allowed_flag
FROM apps.ce_bank_accounts cba,
  apps.ce_bank_acct_uses_all bau,
  apps.cefv_bank_branches bb,
  apps.hr_operating_units ou,
  apps.gl_code_combinations_kfv gcf
WHERE cba.bank_account_id         = bau.bank_account_id
AND cba.bank_branch_id            = bb.bank_branch_id
AND ou.organization_id            = bau.org_id
AND cba.asset_code_combination_id = gcf.code_combination_id
AND (cba.end_date                IS NULL
OR cba.end_date                   > TRUNC(SYSDATE))
--ORDER BY TO_NUMBER(cba.bank_account_num);
