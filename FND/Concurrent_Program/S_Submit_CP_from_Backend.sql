DECLARE
ln_responsibility_id   NUMBER;
ln_application_id      NUMBER;
ln_user_id             NUMBER;
ln_request_id            NUMBER;
BEGIN

--  FND_GLOBAL.APPS_INITIALIZE (ln_user_id,ln_responsibility_id,ln_application_id);
    FND_GLOBAL.APPS_INITIALIZE (1312,20434,101);  
 
   -- Submitting Concurrent Request
  ln_request_id := FND_REQUEST.SUBMIT_REQUEST (
                            application   => 'XXSVL', -- Application Short Code
                            program       => 'XXCUSTCONVPRG', -- Concurrent Program Short NAme
                            description   => 'SVL Customer Conversion Program', -- Concurrent Program Description
                            start_time    => SYSDATE,
                            sub_request   => FALSE,
       argument1     => 100 -- Parameter Value
  );

  COMMIT; -- It is Mandatory

  IF ln_request_id = 0
  THEN
     DBMS_OUTPUT.PUT_LINE ('Concurrent Request Failed to Submit.');
  ELSE
     DBMS_OUTPUT.PUT_LINE('Successfully Submitted the Concurrent Request. Request Id: '||ln_request_id);
  END IF;

EXCEPTION
WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('Error While Submitting Concurrent Request '||TO_CHAR(SQLCODE)||'-'||SQLERRM);
END;
/   
