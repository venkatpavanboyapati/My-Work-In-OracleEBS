DECLARE
      CURSOR c_main
      IS
           SELECT sit.party_site_id,
       sup.party_id,
       sit.org_id,sup.segment1 vendor_num,
                  sup.vendor_name,
                  sit.vendor_site_code,
                  sup.vendor_id,
                  sit.vendor_site_id,
                 sit.email_address,
                sit.remittance_email
             FROM ap.ap_suppliers sup, ap.ap_supplier_sites_all sit, apps.hz_party_sites hps
            WHERE    sup.vendor_id = sit.vendor_id
                AND sit.org_id IN (203, 205)
               -- AND sup.segment1 = '1176'
                AND sup.one_time_flag = 'N'
                AND sup.enabled_flag = 'Y'
                AND (INACTIVE_DATE IS NULL OR INACTIVE_DATE > SYSDATE)
                  --     AND sup.vendor_type_lookup_code = 'VENDOR'
                  AND NVL (sup.vendor_type_lookup_code, 'VENDOR') NOT LIKE
                         '%EMPLOYEE%'
                         and sit.party_site_id = hps.party_site_id
                         and hps.status = 'A'
         ORDER BY vendor_num, sit.org_id;

      CURSOR c_contacts (
         c_party_id         NUMBER,
         c_party_site_id    NUMBER)
      IS
      SELECT DISTINCT hcp2.email_address contact_email
          FROM apps.hz_party_sites hps, apps.hz_contact_points hcp2, apps.hz_locations hzl
         WHERE     hps.location_id = hzl.location_id
               AND NVL (hps.end_date_active, SYSDATE) >= SYSDATE
               AND hcp2.owner_table_id(+) = hps.party_site_id
               AND hcp2.CONTACT_POINT_TYPE(+) = 'EMAIL'
               AND hcp2.status(+) = 'A'
               AND hcp2.owner_table_name(+) = 'HZ_PARTY_SITES'
               AND hcp2.primary_flag(+) = 'Y'
               AND hps.party_site_id = c_party_site_id
               and hcp2.email_address is not null
             --  and 1 <> 1
               union all
               SELECT hcpe.email_address contact_email
          FROM apps.hz_parties hp,
               apps.hz_relationships hzr,
               apps.hz_parties hzr_hp,
               apps.hz_party_usg_assignments hpua,
               apps.HZ_CONTACT_POINTS hcpe
         WHERE     hp.party_id = hzr.subject_id
               -- AND hzr.object_id = 2928564
               AND hzr.relationship_type = 'CONTACT'
               AND hzr.relationship_code = 'CONTACT_OF'
               AND hzr.subject_type = 'PERSON'
               AND hzr.object_type = 'ORGANIZATION'
               AND (hzr.end_date IS NULL OR hzr.end_date > SYSDATE)
               AND hzr.status = 'A'
               AND hzr.party_id = hzr_hp.party_id
               AND hpua.party_id = hp.party_id
               AND hpua.status_flag = 'A'
               AND hpua.party_usage_code = 'SUPPLIER_CONTACT'
               AND hcpe.OWNER_TABLE_NAME(+) = 'HZ_PARTIES'
               AND hcpe.OWNER_TABLE_ID(+) = hzr.PARTY_ID
               AND hcpe.CONTACT_POINT_TYPE(+) = 'EMAIL'
               AND hcpe.status(+) = 'A'
               AND (   hpua.effective_end_date IS NULL
                    OR hpua.effective_end_date > SYSDATE)
               AND hcpe.email_address IS NOT NULL
               and  hzr.object_id = c_party_id
              -- and 1 <> 1
               ;


      i              NUMBER := 0;
      l_site_email   VARCHAR2 (200);
      l_email1       VARCHAR2 (200);
      l_email2       VARCHAR2 (200);
      l_email3       VARCHAR2 (200);
      l_email4       VARCHAR2 (200);
            l_email5       VARCHAR2 (200);

   BEGIN
      DBMS_OUTPUT.put_line (
         'ORG ID|Supplier Number|Supplier name|Site Code|Site Email|remittance_email|Contact Email1|Contact Email2|Contact Email3|Contact Email4|Contact Email5');

      FOR c_main_rec IN c_main
      LOOP
         l_site_email := NULL;
         l_site_email := c_main_rec.email_address;
        i:= 0;
        l_email1 := NULL;
            l_email2 := NULL;
            l_email3 := NULL;
            l_email4 := NULL;
            l_email5 := NULL;
         FOR c_contacts_rec
            IN c_contacts (c_main_rec.party_id, c_main_rec.party_site_id)
         LOOP
            NULL;
            i := i + 1;            
            IF c_contacts_rec.contact_email IS NOT NULL
            THEN
           -- DBMS_OUTPUT.put_line ('Email - '||i||' '||c_contacts_rec.contact_email);

               IF i = 1
               THEN
                  l_email1 := c_contacts_rec.contact_email;
               ELSIF i = 2
               THEN
                  l_email2 := c_contacts_rec.contact_email;
               ELSIF i = 3
               THEN
                  l_email3 := c_contacts_rec.contact_email;
               ELSIF i = 4
               THEN
                  l_email4 := c_contacts_rec.contact_email;
                  ELSIF i = 5
               THEN
                  l_email5 := c_contacts_rec.contact_email;
               END IF;
            END IF;
         END LOOP;

         IF    l_site_email IS NOT NULL
            OR c_main_rec.remittance_email IS NOT NULL
             OR l_email1 IS NOT NULL
            OR l_email2 IS NOT NULL
            OR l_email3 IS NOT NULL
            OR l_email4 IS NOT NULL
            OR l_email5 IS NOT NULL
         THEN
            DBMS_OUTPUT.put_line (
                  c_main_rec.org_id
               || '|'
              ||  c_main_rec.vendor_num
               || '|'
               || c_main_rec.vendor_name
               || '|'
               || c_main_rec.vendor_site_code
               || '|'
               || l_site_email
                || '|'
               || c_main_rec.remittance_email
               || '|'
               || l_email1
               || '|'
               || l_email2
               || '|'
               || l_email3
               || '|'
               || l_email4
               || '|'
               || l_email5);
         END IF;
      END LOOP;
   END;
