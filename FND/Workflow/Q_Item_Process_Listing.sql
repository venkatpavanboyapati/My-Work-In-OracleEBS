
  SELECT item_type,
         item_key,
         TO_CHAR (begin_date, 'DD-MON-RR HH24:MI:SS') begin_date,
         TO_CHAR (end_date, 'DD-MON-RR HH24:MI:SS') end_date,
         root_activity activity,
         OWNER_ROLE,
         USER_KEY
    FROM apps.wf_items
   WHERE item_type = '&item_type' 
     AND end_date IS NULL
ORDER BY TO_DATE (begin_date, 'DD-MON-YYYY hh24:mi:ss') DESC;
