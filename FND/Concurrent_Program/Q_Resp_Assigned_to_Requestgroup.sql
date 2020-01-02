  SELECT responsibility_name, request_group_name, frg.description
    FROM fnd_request_groups frg, fnd_responsibility_vl frv
   WHERE frv.request_group_id = frg.request_group_id 
   --AND request_group_name LIKE 'US SHRMS Reports % Processes'
         AND responsibility_name LIKE 'XX System Administrator'
ORDER BY responsibility_name;
