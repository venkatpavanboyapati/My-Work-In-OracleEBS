
  SELECT a.user_id,
         a.employee_id,
         a.user_name,
         a.description,
         b.responsibility_name,
         b.description,
         d.full_name,
         e.job_id,
         g.control_group_name,
         h.object_code,
         h.amount_limit
    FROM fnd_user a,
         fnd_responsibility_vl b,
         fnd_user_resp_groups_direct c,
         per_all_people_f d,
         per_all_assignments_f e,
         po_position_controls_all f,
         po_control_groups_all g,
         po_control_rules h
   WHERE     b.responsibility_id = c.responsibility_id
         AND c.user_id = a.user_id
         AND b.responsibility_name LIKE '%PO%Super%User'
         AND a.end_date IS NULL
         AND d.effective_end_date > SYSDATE
         AND d.person_id = a.employee_id
         AND d.person_id = e.person_id
         AND e.effective_end_date > SYSDATE
         AND e.job_id = f.job_id
         AND f.control_group_id = g.control_group_id
         AND g.control_group_id = h.control_group_id
         AND g.org_id = 105
ORDER BY user_name
