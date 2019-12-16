
DECLARE

  resp_count NUMBER := 0;

  CURSOR src_user_resp_details
  IS
    SELECT DISTINCT fa.application_short_name,
      fr.responsibility_key                  ,
      fsg.security_group_key
       FROM fnd_application fa      ,
      fnd_responsibility fr         ,
      fnd_user fu                   ,
      fnd_user_resp_groups_all furga,
      fnd_security_groups fsg
      WHERE 1                               = 1
    AND fu.user_name                        = 'USERACCOUNT_1'
    AND fu.user_id                          = furga.user_id
    AND fa.application_id                   = fr.application_id
    AND furga.responsibility_id             = fr.responsibility_id
    AND furga.responsibility_application_id = fa.application_id
    AND fsg.security_group_id               = furga.security_group_id
      -- AND furga.end_date IS NULL OR trunc(furga.end_date) > trunc(SYSDATE)
    AND furga.end_date IS NULL;


BEGIN
  FOR user_resp_details_rec IN src_user_resp_details
  LOOP
    BEGIN
      --
      fnd_user_pkg.addresp
                 (username            => 'USERACCOUNT_2',
                  resp_app            => user_resp_details_rec.application_short_name,
                  resp_key            => user_resp_details_rec.responsibility_key,
                  security_group      => user_resp_details_rec.security_group_key,
                  description         => NULL,
                  start_date          => SYSDATE,
                  end_date            => NULL
                 );

      resp_count := resp_count + 1;

    EXCEPTION
    WHEN OTHERS THEN

      DBMS_OUTPUT.put_line ( 'Error while Adding Responsibility: ' || SQLERRM );
      DBMS_OUTPUT.put_line ( 'resp_app: ' || user_resp_details_rec.application_short_name );
      DBMS_OUTPUT.put_line ( 'resp_key: ' || user_resp_details_rec.responsibility_key );

    END;
  END LOOP;

  DBMS_OUTPUT.put_line (resp_count || ' Responsibilities Successfully Copied!!' );

  COMMIT;
END;
