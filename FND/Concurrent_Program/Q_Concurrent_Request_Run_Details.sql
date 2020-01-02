/**************************************************************************
 *PURPOSE: To find out information about a Concurrent Request             *
 **************************************************************************/
 SELECT  fcrs.request_id, fcrs.user_concurrent_program_name,
         fcrs.actual_start_date, fcrs.actual_completion_date,
         FLOOR(((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60)/3600)||':'||
         FLOOR((((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60) -
         FLOOR(((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60)/3600)*3600)/60)||':'||
         round((((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60) -
         FLOOR(((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60)/3600)*3600 -
         (FLOOR((((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60) -
         FLOOR(((fcrs.actual_completion_date-fcrs.actual_start_date)*24*60*60)/3600)*3600)/60)*60) )) "HOURS:MINUTES:SECONDS",
         fcrs.argument_text, fcrs.requestor,
         DECODE (fcrs.status_code,
                'A', 'Waiting',
                'B', 'Resuming',
                'C', 'Normal',
                'D', 'Cancelled',
                'E', 'Errored',
                'F', 'Scheduled',
                'G', 'Warning',
                'H', 'On Hold',
                'I', 'Normal',
                'M', 'No Manager',
                'Q', 'Standby',
                'R', 'Normal',
                'S', 'Suspended',
                'T', 'Terminating',
                'U', 'Disabled',
                'W', 'Paused',
                'X', 'Terminated',
                'Z', 'Waiting',
                 fcrs.status_code
                ) "Status",
         decode(fcrs.phase_code,
                'C','Completed',
                'I','Inactive',
                'R','Running',
                'A','Active',
                fcrs.phase_code) "Phase Code",  fcrs.completion_text,
         fcrs.responsibility_application_id, frt.responsibility_name,
         fcrs.save_output_flag, fcrs.request_date ,
         decode (fcrs.execution_method_code,
                 'B', 'Request Set Stage Function',
                 'Q', 'SQL*Plus',
                 'H', 'Host',
                 'L', 'SQL*Loader',
                 'A', 'Spawned',
                 'I', 'PL/SQL Stored Procedure',
                 'P', 'Oracle Reports',
                 'S', 'Immediate',
                 fcrs.execution_method_code
               ) execution_method , fcrs.concurrent_program_id, fcrs.program_short_name, fcrs.printer,
               fcrs.parent_request_id
    FROM fnd_conc_req_summary_v fcrs, 
         fnd_responsibility_tl frt
   WHERE 1 = 1
AND user_concurrent_program_name LIKE '%'
--and argument_text LIKE '%'
--and requestor not in ('SYSADMIN','INVADMIN')
--and request_id = 9686914
AND frt.language = 'US' AND fcrs.responsibility_id = frt.responsibility_id
--and fcrs.actual_start_date < sysdate
--and fcrs.phase_code = 'R'
--and fcrs.status_code = 'X'
--and fcrs.status_code not in ('P','D','Q','C')
--and trunc(fcrs.actual_start_date) =trunc(sysdate)
--and trunc(fcrs.actual_completion_date) = trunc(sysdate)
ORDER BY fcrs.actual_start_date DESC;
