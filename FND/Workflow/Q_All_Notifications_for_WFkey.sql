SELECT wn.notification_id nid,
       wn.context,
       wn.GROUP_ID,
       wn.status,
       wn.mail_status,
       wn.MESSAGE_TYPE,
       wn.message_name,
       wn.access_key,
       wn.priority,
       wn.begin_date,
       wn.end_date,
       wn.due_date,
       wn.callback,
       wn.recipient_role,
       wn.responder,
       wn.original_recipient,
       wn.from_user,
       wn.to_user,
       wn.subject
  FROM wf_notifications wn, wf_item_activity_statuses wias
 WHERE     wn.GROUP_ID = wias.notification_id
       AND wias.item_type = '&item_type'
       AND wias.item_key = '&item_key';
