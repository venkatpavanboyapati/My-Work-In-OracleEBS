SELECT ffv.form_id ,
  ffv.form_name ,
  ffv.user_form_name  ,
  ffv.description "Form Description",
  ffcr.sequence  ,
  ffcr.description "Personalization Rule Name"
   FROM apps.fnd_form_vl ffv,
  apps.fnd_form_custom_rules ffcr
  WHERE ffv.form_name = ffcr.form_name
ORDER BY ffv.form_name,
  ffcr.sequence;
