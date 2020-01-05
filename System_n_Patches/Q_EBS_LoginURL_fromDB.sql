QUERY 1:   SELECT home_url FROM icx_parameters;

QUERY 2:
SELECT profile_option_value
FROM fnd_profile_option_values
WHERE profile_option_id=
(SELECT profile_option_id
FROM fnd_profile_options WHERE profile_option_name = ‘APPS_FRAMEWORK_AGENT’)
AND level_value = 0;
