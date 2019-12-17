
select ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffvt.value_column_name ,
    ffvt.meaning_column_name ,
    ffvt.id_column_name ,
    ffvt.application_table_name ,
    ffvt.additional_where_clause
FROM apps.fnd_flex_value_sets ffvs ,
    apps.fnd_flex_validation_tables ffvt
WHERE ffvs.flex_value_set_id = ffvt.flex_value_set_id;
