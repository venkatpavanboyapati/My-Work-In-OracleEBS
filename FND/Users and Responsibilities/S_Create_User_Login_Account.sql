
DECLARE
  p_user_name                  VARCHAR2 (200)       := 'PBOYA01';
  p_owner                      VARCHAR2 (200)       := NULL;
  p_unencrypted_password       VARCHAR2 (200)       := 'welcome';
  p_session_number             NUMBER               := USERENV ('sessionid');
  p_start_date                 DATE                 := SYSDATE;
  p_end_date                   DATE                 := NULL;
  p_last_logon_date            DATE                 := NULL;
  p_description                VARCHAR2 (200)       := 'New USer account';
  p_password_date              DATE                 := SYSDATE;
  p_password_accesses_left     NUMBER         := NULL;
  p_password_lifespan_accesses NUMBER         := NULL;
  p_password_lifespan_days     NUMBER         := NULL;
  p_employee_id                NUMBER         := NULL;
  p_email_address              VARCHAR2 (200) := 'venpavan@gmail.com';
  p_fax                        VARCHAR2 (200) := NULL;
  p_customer_id                NUMBER         := NULL;
  p_supplier_id                NUMBER         := NULL;
  v_user_id                    NUMBER;
BEGIN
  --  
  --
   fnd_user_pkg.createuser
               (x_user_name                       => p_user_name,
                x_owner                           => p_owner,
                x_unencrypted_password            => p_unencrypted_password,
                x_session_number                  => p_session_number,
                x_start_date                      => p_start_date,
                x_end_date                        => p_end_date,
                x_last_logon_date                 => p_last_logon_date,
                x_description                     => p_description,
                x_password_date                   => p_password_date,
                x_password_accesses_left          => p_password_accesses_left,
                x_password_lifespan_accesses      => p_password_lifespan_accesses,
                x_password_lifespan_days          => p_password_lifespan_days,
                x_employee_id                     => p_employee_id,
                x_email_address                   => p_email_address,
                x_fax                             => p_fax,
                x_customer_id                     => p_customer_id,
                x_supplier_id                     => p_supplier_id
               );


   SELECT user_id
     INTO v_user_id
     FROM fnd_user
    WHERE user_name = p_user_name;

  DBMS_OUTPUT.put_line ('User_id : ' || v_user_id);

  COMMIT;

EXCEPTION
WHEN OTHERS THEN

  DBMS_OUTPUT.put_line ('Error while creating a user: ' || SQLERRM);

END;
