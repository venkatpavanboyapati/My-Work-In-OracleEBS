SELECT pa.agent_id,
       papf.person_id,
       papf.employee_number,
       papf.email_address,
       pa.category_id,
       pa.location_id,
       papf.effective_start_date,
       papf.effective_end_date
  FROM apps.po_agents pa, apps.per_all_people_f papf, apps.hr_all_organization_units haou
 WHERE     pa.agent_id = papf.person_id
       AND papf.business_group_id = haou.business_group_id
       AND TRUNC (SYSDATE) BETWEEN papf.effective_start_date
                               AND papf.effective_end_date
       AND papf.effective_end_date > SYSDATE
     --  AND haou.business_group_id = 83      
