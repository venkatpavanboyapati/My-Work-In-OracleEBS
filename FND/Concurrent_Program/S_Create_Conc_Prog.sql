--
DECLARE  
  --
  l_program                  VARCHAR2 (200);
  l_application              VARCHAR2 (200);
  l_enabled                  VARCHAR2 (200);
  l_short_name               VARCHAR2 (200);
  l_description              VARCHAR2 (200);
  l_executable_short_name    VARCHAR2 (200);
  l_executable_application   VARCHAR2 (200);
  l_execution_options        VARCHAR2 (200);
  l_priority                 NUMBER;
  l_save_output              VARCHAR2 (200);
  l_print                    VARCHAR2 (200);
  l_cols                     NUMBER;
  l_rows                     NUMBER;
  l_style                    VARCHAR2 (200);
  l_style_required           VARCHAR2 (200);
  l_printer                  VARCHAR2 (200);
  l_request_type             VARCHAR2 (200);
  l_request_type_application VARCHAR2 (200);
  l_use_in_srs               VARCHAR2 (200);
  l_allow_disabled_values    VARCHAR2 (200);
  l_run_alone                VARCHAR2 (200);
  l_output_type              VARCHAR2 (200);
  l_enable_trace             VARCHAR2 (200);
  l_restart                  VARCHAR2 (200);
  l_nls_compliant            VARCHAR2 (200);
  l_icon_name                VARCHAR2 (200);
  l_language_code            VARCHAR2 (200);
  l_mls_function_short_name  VARCHAR2 (200);
  l_mls_function_application VARCHAR2 (200);
  l_incrementor              VARCHAR2 (200);
  l_refresh_portlet          VARCHAR2 (200);
  l_check                    VARCHAR2 (2);
  --
BEGIN
  --
  l_program                  := 'Concurrent program registered from backend - OraclePB';
  l_application              := 'CUSTOM Custom';
  l_enabled                  := 'Y';
  l_short_name               := 'XX_ORACLEPB_CP';
  l_description              := 'OraclePB Test Program';
  l_executable_short_name    := 'XX_ORACLEPB_EXE';
  l_executable_application   := 'CUSTOM Custom';
  l_execution_options        := NULL;
  l_priority                 := NULL;
  l_save_output              := 'Y';
  l_print                    := 'Y';
  l_cols                     := NULL;
  l_rows                     := NULL;
  l_style                    := NULL;
  l_style_required           := 'N';
  l_printer                  := NULL;
  l_request_type             := NULL;
  l_request_type_application := NULL;
  l_use_in_srs               := 'Y';
  l_allow_disabled_values    := 'N';
  l_run_alone                := 'N';
  l_output_type              := 'TEXT';
  l_enable_trace             := 'N';
  l_restart                  := 'Y';
  l_nls_compliant            := 'Y';
  l_icon_name                := NULL;
  l_language_code            := 'US';
  l_mls_function_short_name  := NULL;
  l_mls_function_application := NULL;
  l_incrementor              := NULL;
  l_refresh_portlet          := NULL;
 --
 --Calling API to create concurrent program definition
 --
 apps.fnd_program.register
        (program                       => l_program,
         application                   => l_application,
         enabled                       => l_enabled,
         short_name                    => l_short_name,
         description                   => l_description,
         executable_short_name         => l_executable_short_name,
         executable_application        => l_executable_application,
         execution_options             => l_execution_options,
         priority                      => l_priority,
         save_output                   => l_save_output,
         print                         => l_print,
         cols                          => l_cols,
         ROWS                          => l_rows,
         STYLE                         => l_style,
         style_required                => l_style_required,
         printer                       => l_printer,
         request_type                  => l_request_type,
         request_type_application      => l_request_type_application,
         use_in_srs                    => l_use_in_srs,
         allow_disabled_values         => l_allow_disabled_values,
         run_alone                     => l_run_alone,
         output_type                   => l_output_type,
         enable_trace                  => l_enable_trace,
         restart                       => l_restart,
         nls_compliant                 => l_nls_compliant,
         icon_name                     => l_icon_name,
         language_code                 => l_language_code,
         mls_function_short_name       => l_mls_function_short_name,
         mls_function_application      => l_mls_function_application,
         incrementor                   => l_incrementor,
         refresh_portlet               => l_refresh_portlet
         );  
  --
  COMMIT;
  --
  BEGIN
  --
   --To check whether Concurrent Program is registered or not
   --
     SELECT 'Y'
       INTO l_check
       FROM fnd_concurrent_programs
      WHERE concurrent_program_name = 'XX_ORACLEPB_CP';
       --
       DBMS_OUTPUT.put_line ('Concurrent Program Registered Successfully');
       --
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.put_line ('Concurrent Program Registration Failed');
  END;
END;
