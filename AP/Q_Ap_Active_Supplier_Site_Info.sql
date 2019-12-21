
 SELECT sup.vendor_id ,
        sup.vendor_name,
        sup.segment1 supplier_number,                                                
        sit.vendor_site_id,
        sit.vendor_site_code,
        CASE
           WHEN    NVL (sup.end_date_active, SYSDATE + 2) <= SYSDATE
                OR sup.enabled_flag <> 'Y'
                OR NVL (sit.inactive_date, SYSDATE + 2) <= SYSDATE
           THEN
              'INACTIVE'
           ELSE
              'ACTIVE'
        END   site_status,
        sup.end_date_active,
        sup.enabled_flag,
        sit.inactive_date,
        sit.pay_site_flag,
        sup.one_time_flag,
        sit.org_id,
        sit.address_line1,
        sit.address_line2,
        sit.address_line3,
        sit.city,
        sit.state,
        sit.province,
        sit.zip,
        sit.country,
        sit.phone 
   --  sit.creation_date,
   --  sit.created_by,
   --  sit.last_update_date,
   --  sit.last_updated_by,
   --  sit.last_update_login
   FROM ap.ap_suppliers sup, ap.ap_supplier_sites_all sit
  WHERE sup.vendor_id = sit.vendor_id 
   -- AND sit.org_id IN (203, 205) 
   AND NVL (sup.vendor_type_lookup_code, 'VENDOR') NOT LIKE '%EMPLOYEE%'
   --AND sup.vendor_id = :p_vendor_id
   AND sup.segment1 = :p_vendor_no
   AND sit.pay_site_flag = 'Y'
   AND sup.one_time_flag = 'N'
   AND sup.enabled_flag = 'Y'
   --AND sup.end_date_active IS NULL
  -- AND sit.inactive_date IS NULL;
