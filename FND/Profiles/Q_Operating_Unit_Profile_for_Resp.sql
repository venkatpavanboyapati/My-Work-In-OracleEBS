
SELECT fr.responsibility_name
     , fpov.profile_option_value orgid
     , NAME org_name
  FROM fnd_profile_options_vl fpo,
       fnd_profile_option_values fpov,
       applsys.fnd_responsibility_tl fr,
       hr_operating_units hou
 WHERE     UPPER (fpo.user_profile_option_name) LIKE UPPER ('MO%OPERATIN%')
       AND profile_option_name = 'ORG_ID'
       AND fpo.profile_option_id = fpov.profile_option_id
       AND TO_NUMBER (fpov.level_value) = fr.responsibility_id
       AND TO_CHAR (hou.organization_id) =
              TO_CHAR (fpov.profile_option_value)
       AND fr.responsibility_name LIKE 'XXDA_DA_AYAAN_RESP%'
