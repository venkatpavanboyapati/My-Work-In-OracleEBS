SELECT   SUBSTR (e.profile_option_name, 1, 25) internal_name,
         SUBSTR (pot.user_profile_option_name, 1, 60) name_in_forms,
         DECODE (a.level_id,
                 10001, 'Site',
                 10002, 'Application',
                 10003, 'Resp',
                 10004, 'User',
                 10005, 'Server',
                 10007, 'Server + Resp',
                 a.level_id
                ) levell,
         DECODE (a.level_id,
                 10001, 'Site',
                 10002, c.application_short_name,
                 10003, b.responsibility_name,
                 10004, d.user_name,
                 10005, n.node_name,
                 10007, m.node_name || ' + ' || b.responsibility_name,
                 a.level_id
                ) level_value,
         NVL (a.profile_option_value, 'Is Null') VALUE,
         TO_CHAR (a.last_update_date, 'DD-MON-YYYY HH24:MI') last_update_date,
         dd.user_name last_update_user
    FROM fnd_profile_option_values a,
         fnd_responsibility_tl b,
         fnd_application c,
         fnd_user d,
         fnd_profile_options e,
         fnd_nodes n,
         fnd_nodes m,
         fnd_responsibility_tl x,
         fnd_user dd,
         fnd_profile_options_tl pot
   WHERE e.profile_option_name LIKE 'MFG_ORGANIZATION_ID'  
     AND e.profile_option_name = pot.profile_option_name(+)
     AND e.profile_option_id = a.profile_option_id(+)
     AND a.level_value = b.responsibility_id(+)
     AND a.level_value = c.application_id(+)
     AND a.level_value = d.user_id(+)
     AND a.level_value = n.node_id(+)
     AND a.level_value_application_id = x.responsibility_id(+)
     AND a.level_value2 = m.node_id(+)
     AND a.last_updated_by = dd.user_id(+)
     AND pot.LANGUAGE = 'US'
ORDER BY e.profile_option_name
