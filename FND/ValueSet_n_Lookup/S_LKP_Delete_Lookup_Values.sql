DECLARE
   CURSOR cur_lkp_values
   IS
      SELECT lookup_type, lookup_code, security_group_id,
             view_application_id
        FROM fnd_lookup_values
       WHERE lookup_type = 'XX_LKP_NAME' AND lookup_code LIKE 'XX_LKP_CODE';
BEGIN
   FOR i IN cur_lkp_values
   LOOP
      BEGIN
         fnd_lookup_values_pkg.delete_row
                             (x_lookup_type              => i.lookup_type,
                              x_security_group_id        => i.security_group_id,
                              x_view_application_id      => i.view_application_id,
                              x_lookup_code              => i.lookup_code
                             );
         COMMIT;
         DBMS_OUTPUT.put_line ('Lookup Code ' || i.lookup_code || ' is deleted and committed');
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('Exception inside for loop: ' || SQLERRM);
      END;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Main Exception ' || SQLERRM);
END;
/
