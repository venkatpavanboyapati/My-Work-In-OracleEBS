 SELECT PPP.SYSTEM_PROFILE_CODE,
         PPP.SYSTEM_PROFILE_NAME,
         PPP.SYSTEM_PROFILE_DESCRIPTION,
         PPP.PAYMENT_FORMAT_CODE,
         PPP.PROCESSING_TYPE,
         PPP.SEEDED_FLAG,
         format.format_name,
         bank_acct.APPLICABLE_VALUE_TO Bank_id,
         bank.bank_account_name,
         bank.bank_account_num,
         bank.currency_code
    FROM IBY_SYS_PMT_PROFILES_VL PPP,
         iby_bepinfo bep,
         iby_formats_vl format,
         iby_formats_vl acpltr_format,
         iby_formats_vl pospay_format,
         iby_formats_vl regrpt_format,
         iby_formats_vl pireg_format,
         iby_applicable_pmt_profs bank_acct,
         ce_bank_accounts bank,
         iby_bank_instructions_vl bank_instr1,
         iby_bank_instructions_vl bank_instr2,
         ce_payment_documents pdoc,
         fnd_lookups f1,
         fnd_lookups f2,
         fnd_lookups f3
   WHERE     PPP.bepid = bep.bepid(+)
         AND PPP.BANK_INSTRUCTION1_CODE = bank_instr1.BANK_INSTRUCTION_CODE(+)
         AND PPP.BANK_INSTRUCTION2_CODE = bank_instr2.BANK_INSTRUCTION_CODE(+)
         AND PPP.SYSTEM_PROFILE_CODE = bank_acct.SYSTEM_PROFILE_CODE
         AND bank.bank_account_id = bank_acct.applicable_value_to
         AND PPP.payment_format_code = format.format_code
         AND PPP.POSITIVE_PAY_FORMAT_CODE = pospay_format.format_code(+)
         AND PPP.DECLARATION_REPORT_FORMAT_CODE = regrpt_format.format_code(+)
         AND PPP.PAY_FILE_LETTER_FORMAT_CODE = acpltr_format.format_code(+)
         AND pdoc.payment_document_id(+) = PPP.DEFAULT_PAYMENT_DOCUMENT_ID
         AND PPP.pi_register_format = pireg_format.format_code(+)
         AND PROCESSING_TYPE = f1.lookup_code
         AND f1.lookup_type = 'IBY_PROCESSING_TYPES'
         AND MARK_COMPLETE_EVENT = f2.lookup_code(+)
         AND f2.lookup_type(+) = 'IBY_MARK_COMPLETE_EVENTS'
         AND MANUAL_MARK_COMPLETE_FLAG = f3.lookup_code
         AND f3.lookup_type = 'IBY_YES_NO'
         AND bank_acct.APPLICABLE_TYPE_CODE = 'INTERNAL_BANK_ACCOUNT'
         AND PPP.INACTIVE_DATE IS NULL
         AND bank.bank_account_num LIKE '999999'
ORDER BY system_profile_description;
