
Step1 : Create a table to stage data to insert into Lookup.

CREATE TABLE XX_LOOKUP_TEMP_TABLE
  (
    X_LOOKUP_CODE         VARCHAR2(30 BYTE),
    X_LOOKUP_MEANING      VARCHAR2(80 BYTE),
    X_LOOKUP_DESCRIPTION  VARCHAR2(240 BYTE),
    X_LOOKUP_TAG          VARCHAR2(30 BYTE),
    X_LOOKUP_START_DATE   DATE,
    X_LOOKUP_END_DATE     DATE,
    X_LOOKUP_ENABLED_FLAG VARCHAR2(1 BYTE),
    X_LOOKUP_CONTEXT      VARCHAR2(30 BYTE),
    X_LOOKUP_ATTRIBUTE1   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE2   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE3   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE4   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE5   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE6   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE7   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE8   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE9   VARCHAR2(150 BYTE),
    X_LOOKUP_ATTRIBUTE10  VARCHAR2(150 BYTE)
  );

Step2 : Script to Insert Values into FND_lookup

set serveroutput on;
-- API to Create Lookup Values - "FND_LOOKUP_VALUES"


DECLARE
   CURSOR get_lookup_details
   IS
      SELECT   ltype.application_id,
               ltype.customization_level,
               ltype.creation_date,
               ltype.created_by,
               ltype.last_update_date,
               ltype.last_updated_by,
               ltype.last_update_login,
               tl.lookup_type,
               tl.security_group_id,
               tl.view_application_id,
               tl.description,
               tl.meaning
        FROM   fnd_lookup_types_tl tl, fnd_lookup_types ltype
       WHERE       ltype.lookup_type = 'XX_GL_DM_PARENT_CC_LKP'
               AND ltype.lookup_type = tl.lookup_type
               AND language = 'US';

   CURSOR get_VALUES
   IS
      SELECT   * FROM XX_LOOKUP_TEMP_TABLE where x_lookup_code not in ( select lookup_code
        FROM   fnd_lookup_values_vl
       WHERE       lookup_type = 'XX_GL_DM_PARENT_CC_LKP'
)
      ;--'CO12505A';

   l_rowid   VARCHAR2 (100) := 0;

   BEGIN
   FOR i IN get_lookup_details
   LOOP
      FOR j IN get_VALUES
      LOOP
         l_rowid := NULL;
        
         BEGIN
            fnd_lookup_values_pkg.insert_row (
               x_rowid                 => l_rowid,
               x_lookup_type           => i.lookup_type,
               x_security_group_id     => i.security_group_id,
               x_view_application_id   => i.view_application_id,
               x_lookup_code           => j.X_LOOKUP_CODE,
               x_tag                   => j.X_LOOKUP_TAG,
               x_attribute_category    => j.X_LOOKUP_CONTEXT,
               x_attribute1            => j.X_LOOKUP_ATTRIBUTE1,
               x_attribute2            => j.X_LOOKUP_ATTRIBUTE2,
               x_attribute3            => j.X_LOOKUP_ATTRIBUTE3,
               x_attribute4            => j.X_LOOKUP_ATTRIBUTE4,
               x_enabled_flag          => 'Y',
               x_start_date_active     => j.X_LOOKUP_START_DATE,
               x_end_date_active       => j.X_LOOKUP_END_DATE,
               x_territory_code        => NULL,
               x_attribute5            => j.X_LOOKUP_ATTRIBUTE5,
               x_attribute6            => j.X_LOOKUP_ATTRIBUTE6,
               x_attribute7            => j.X_LOOKUP_ATTRIBUTE7,
               x_attribute8            => j.X_LOOKUP_ATTRIBUTE8,
               x_attribute9            => j.X_LOOKUP_ATTRIBUTE9,
               x_attribute10           => j.X_LOOKUP_ATTRIBUTE10,
               x_attribute11           => NULL,
               x_attribute12           => NULL,
               x_attribute13           => NULL,
               x_attribute14           => NULL,
               x_attribute15           => NULL,
               x_meaning               => j.X_LOOKUP_MEANING,
               x_description           => j.X_LOOKUP_DESCRIPTION,
               x_creation_date         => SYSDATE,
               x_created_by            => -1, --i.created_by,
               x_last_update_date      => SYSDATE, --i.last_update_date,
               x_last_updated_by       => -1,--i.last_updated_by,
               x_last_update_login     => i.last_update_login
            );
            COMMIT;
            DBMS_OUTPUT.put_line (j.X_LOOKUP_CODE || ' loaded');
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line ('Inner Exception: ' || SQLERRM);
         END;
      END LOOP;
   END LOOP;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('Main Exception: ' || SQLERRM);
END;
