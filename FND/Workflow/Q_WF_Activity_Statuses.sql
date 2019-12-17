SELECT execution_time,
       to_char(ias.begin_date,
               'DD-MON-RR HH24:MI:SS') begin_date,
       ap.display_name || '/' || ac.display_name activity,
       ias.activity_status status,
       ias.activity_result_code RESULT,
       ias.assigned_user ass_user
  FROM wf_item_activity_statuses ias,
       wf_process_activities     pa,
       wf_activities_vl          ac,
       wf_activities_vl          ap,
       wf_items                  i
 WHERE ias.item_type = '&item_type'
   AND ias.item_key = '&item_key'
   AND ias.process_activity = pa.instance_id
   AND pa.activity_name = ac.name
   AND pa.activity_item_type = ac.item_type
   AND pa.process_name = ap.name
   AND pa.process_item_type = ap.item_type
   AND pa.process_version = ap.version
   AND i.item_type = '&item_type'
   AND i.item_key = ias.item_key
   AND i.begin_date >= ac.begin_date
   AND i.begin_date < nvl(ac.end_date,
                          i.begin_date + 1)
UNION ALL
SELECT execution_time,
       to_char(ias.begin_date,
               'DD-MON-RR HH24:MI:SS') begin_date,
       ap.display_name || '/' || ac.display_name activity,
       ias.activity_status status,
       ias.activity_result_code RESULT,
       ias.assigned_user ass_user
  FROM wf_item_activity_statuses_h ias,
       wf_process_activities       pa,
       wf_activities_vl            ac,
       wf_activities_vl            ap,
       wf_items                    i
 WHERE ias.item_type = '&item_type'
   AND ias.item_key = '&item_key'
   AND ias.process_activity = pa.instance_id
   AND pa.activity_name = ac.name
   AND pa.activity_item_type = ac.item_type
   AND pa.process_name = ap.name
   AND pa.process_item_type = ap.item_type
   AND pa.process_version = ap.version
   AND i.item_type = '&item_type'
   AND i.item_key = ias.item_key
   AND i.begin_date >= ac.begin_date
   AND i.begin_date < nvl(ac.end_date,
                          i.begin_date + 1)
 ORDER BY 2,
          1
