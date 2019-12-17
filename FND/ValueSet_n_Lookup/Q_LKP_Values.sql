SELECT *
  FROM apps.fnd_lookup_values
 WHERE  UPPER (lookup_type) LIKE '%XX%%'
   AND Enabled_flag = 'Y'
   AND SYSDATE BETWEEN start_date_active AND end_date_active
