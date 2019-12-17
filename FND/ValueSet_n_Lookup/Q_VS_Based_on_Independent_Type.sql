SELECT ffvs.flex_value_set_id ,
    ffvs.flex_value_set_name ,
    ffvs.description set_description ,
    ffvs.validation_type,
    ffv.flex_value_id ,
    ffv.flex_value ,
    ffvt.flex_value_meaning ,
    ffvt.description value_description
FROM fnd_flex_value_sets ffvs ,
    fnd_flex_values ffv ,
    fnd_flex_values_tl ffvt
WHERE
    ffvs.flex_value_set_id     = ffv.flex_value_set_id
    and ffv.flex_value_id      = ffvt.flex_value_id
    AND ffvt.language          = USERENV('LANG');
