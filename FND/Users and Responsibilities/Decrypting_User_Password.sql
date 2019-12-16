
/*********************************************************
*PURPOSE: Package to fetch and decrypt UserPassword      *
*                                                        *
*AUTHOR: Pavan Boyapati                                  *
**********************************************************/

--Package Specification
CREATE OR REPLACE PACKAGE get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2;
END get_pwd;
/

--Package Body
CREATE OR REPLACE PACKAGE BODY get_pwd
AS
   FUNCTION decrypt (KEY IN VARCHAR2, VALUE IN VARCHAR2)
      RETURN VARCHAR2
   AS
      LANGUAGE JAVA
      NAME 'oracle.apps.fnd.security.WebSessionManagerProc.decrypt(java.lang.String,java.lang.String) return java.lang.String';
END get_pwd;
/


--Query to execute
SELECT usr.user_name,
       get_pwd.decrypt
          ((SELECT (SELECT get_pwd.decrypt
                              (fnd_web_sec.get_guest_username_pwd,
                               usertable.encrypted_foundation_password
                              )
                      FROM DUAL) AS apps_password
              FROM fnd_user usertable
             WHERE usertable.user_name =
                      (SELECT SUBSTR
                                  (fnd_web_sec.get_guest_username_pwd,
                                   1,
                                     INSTR
                                          (fnd_web_sec.get_guest_username_pwd,
                                           '/'
                                          )
                                   - 1
                                  )
                         FROM DUAL)),
           usr.encrypted_user_password
          ) PASSWORD
  FROM fnd_user usr
 WHERE usr.user_name = '&USER_NAME';
