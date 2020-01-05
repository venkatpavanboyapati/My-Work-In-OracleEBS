SELECT fvs.flex_value_set_name, fct.user_concurrent_program_name,
       ffc.enabled_flag, fvt.application_table_name, fvt.value_column_name,
       fvt.id_column_name, fvt.meaning_column_name,
       fvt.additional_where_clause
  FROM fnd_flex_value_sets fvs,
       fnd_descr_flex_col_usage_vl ffc,
       fnd_flex_validation_tables fvt,
       fnd_concurrent_programs fcp,
       fnd_concurrent_programs_tl fct
 WHERE ffc.flex_value_set_id = fvs.flex_value_set_id
   AND fvs.flex_value_set_id = fvt.flex_value_set_id
   AND fcp.concurrent_program_id = fct.concurrent_program_id
   AND ffc.descriptive_flexfield_name ='$SRS$.' || fcp.concurrent_program_name
   AND fvs.flex_value_set_name = :value_set_name
