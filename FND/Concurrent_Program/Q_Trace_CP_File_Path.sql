 SELECT req.request_id, req.logfile_node_name node, req.oracle_process_id,
       req.enable_trace,
          dest.VALUE
       || '/'
       || LOWER (dbnm.VALUE)
       || '_ora_'
       || oracle_process_id
       || '.trc' trace_filename,
       prog.user_concurrent_program_name,
       phase_code, status_code
  FROM apps.fnd_concurrent_requests req,
       v$session ses,
       v$process proc,
       v$parameter dest,
       v$parameter dbnm,
       apps.fnd_concurrent_programs_vl prog,
       apps.fnd_executables execname
 WHERE 1 = 1
   AND req.request_id = 123456789 --Request ID
   AND req.oracle_process_id = proc.spid(+)
   AND proc.addr = ses.paddr(+)
   AND dest.NAME = 'user_dump_dest'
   AND dbnm.NAME = 'db_name'
   AND req.concurrent_program_id = prog.concurrent_program_id
   AND req.program_application_id = prog.application_id
   AND prog.application_id = execname.application_id
   AND prog.executable_id = execname.executable_id
