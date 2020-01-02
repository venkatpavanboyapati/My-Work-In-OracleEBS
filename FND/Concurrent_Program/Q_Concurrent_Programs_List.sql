
  SELECT DISTINCT fcpl.user_concurrent_program_name "Concurrent Program Name",
                  fcp.concurrent_program_name "Short Name",
                  fcpl.Description,
                  fcpl.creation_date,
                  fat.application_name,
                  fl.meaning execution_method,
                  fe.execution_file_name,
                  fcp.output_file_type                  
    FROM apps.fnd_concurrent_programs fcp,
         apps.fnd_concurrent_programs_tl fcpl,
         apps.fnd_lookups fl,
         apps.fnd_executables fe,
         apps.fnd_executables_tl fet,
         apps.fnd_application_tl fat
   WHERE     1 = 1
         AND fcp.concurrent_program_id = fcpl.concurrent_program_id
         AND fcp.enabled_flag = 'Y'
         AND fcpl.language = 'US'
         AND fl.lookup_type = 'CP_EXECUTION_METHOD_CODE'
         AND fl.lookup_code = fcp.execution_method_code
         AND fe.executable_id = fcp.executable_id
         AND fe.executable_id = fet.executable_id
         AND fet.language = 'US'
         AND fat.application_id = fcp.application_id
         AND fat.language = 'US'
         --AND (fcpl.user_concurrent_program_name  like 'XX%' or fcpl.user_concurrent_program_name like 'ZZ%')
         AND fat.application_name in ('XX Custom Application')
   ORDER BY fcpl.creation_date DESC
