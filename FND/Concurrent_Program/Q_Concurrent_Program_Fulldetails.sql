
  SELECT DISTINCT fcpl.user_concurrent_program_name "Concurrent Program Name",
                  fcp.concurrent_program_name "Short Name",
                  fat.application_name,
                  fl.meaning execution_method,
                  fe.execution_file_name,
                  fcp.output_file_type,
                  fdfcuv.column_seq_num "Column Seq Number",
                  fdfcuv.end_user_column_name "Parameter Name",
                  fdfcuv.form_left_prompt "Prompt",
                  fdfcuv.enabled_flag " Enabled Flag",
                  fdfcuv.required_flag "Required Flag",
                  fdfcuv.display_flag "Display Flag",
                  fdfcuv.flex_value_set_id "Value Set Id",
                  ffvs.flex_value_set_name "Value Set Name",
                  flv.meaning "Default Type",
                  fdfcuv.DEFAULT_VALUE "Default Value"
    FROM apps.fnd_concurrent_programs fcp,
         apps.fnd_concurrent_programs_tl fcpl,
         apps.fnd_descr_flex_col_usage_vl fdfcuv,
         apps.fnd_flex_value_sets ffvs,
         apps.fnd_lookup_values flv,
         apps.fnd_lookups fl,
         apps.fnd_executables fe,
         apps.fnd_executables_tl fet,
         apps.fnd_application_tl fat
   WHERE     1 = 1
         AND fcp.concurrent_program_id = fcpl.concurrent_program_id
         AND fcp.enabled_flag = 'Y'
         AND fcpl.user_concurrent_program_name LIKE
                'Workflow Background Process' --<Your Concurrent Program Name>
         AND fdfcuv.descriptive_flexfield_name =
                '$SRS$.' || fcp.concurrent_program_name
         AND ffvs.flex_value_set_id = fdfcuv.flex_value_set_id
         AND flv.lookup_type(+) = 'FLEX_DEFAULT_TYPE'
         AND flv.lookup_code(+) = fdfcuv.default_type
         AND fcpl.language = 'US'
         AND flv.language(+) = 'US'
         AND fl.lookup_type = 'CP_EXECUTION_METHOD_CODE'
         AND fl.lookup_code = fcp.execution_method_code
         AND fe.executable_id = fcp.executable_id
         AND fe.executable_id = fet.executable_id
         AND fet.language = 'US'
         AND fat.application_id = fcp.application_id
         AND fat.language = 'US'
ORDER BY fdfcuv.column_seq_num;
