  SELECT DISTINCT
         fu.user_name User_Name,
         fu.description,
         fn.node_name,
         TO_CHAR (IC.FIRST_CONNECT, 'dd-Mon-rrrr HH24:mi:ss') "First Accessed",
         TO_CHAR (IC.LAST_CONNECT, 'dd-Mon-rrrr HH24:mi:ss') "Last Accessed",
         FVL.RESPONSIBILITY_NAME "RESPONSIBILITY NAME",
         ic.disabled_flag
    FROM fnd_user fu,
         fnd_nodes fn,
         fnd_responsibility fr,
         icx_sessions ic,
         fnd_responsibility_VL FVL
   WHERE     fu.user_id = ic.user_id
         AND FR.RESPONSIBILITY_KEY = FVL.RESPONSIBILITY_KEY
         AND fr.responsibility_id = ic.responsibility_id
         AND ic.node_id = fn.node_id
         AND ic.disabled_flag = 'N'
         AND ic.responsibility_id IS NOT NULL
         AND ic.last_connect > SYSDATE - (ic.time_out / 60) / 96
         AND UPPER (NODE_NAME) IN ('XXOAPV07')
--and fu.description like 'Tay%'
ORDER BY "Last Accessed" DESC;
