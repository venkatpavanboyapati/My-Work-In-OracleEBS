SELECT prh.segment1 "Req #",
       prh.creation_date,
       prh.created_by,
       poh.segment1 "PO #",
       ppx.full_name "Requestor Name",
       prh.description "Req Description",
       prh.authorization_status,
       prh.note_to_authorizer,
       prh.type_lookup_code,
       prl.line_num,
       prl.line_type_id,
       prl.item_description,
       prl.unit_meas_lookup_code,
       prl.unit_price,
       prl.quantity,
       prl.quantity_delivered,
       prl.need_by_date,
       prl.note_to_agent,
       prl.currency_code,
       prl.rate_type,
       prl.rate_date,
       prl.quantity_cancelled,
       prl.cancel_date,
       prl.cancel_reason
  FROM po_requisition_headers_all prh,
       po_requisition_lines_all prl,
       po_req_distributions_all prd,
       per_people_x ppx,
       po_headers_all poh,
       po_distributions_all pda
 WHERE     prh.requisition_header_id = prl.requisition_header_id
       AND ppx.person_id = prh.preparer_id
       AND prh.type_lookup_code = 'PURCHASE'
       AND prd.requisition_line_id = prl.requisition_line_id
       AND pda.req_distribution_id = prd.distribution_id
       AND pda.po_header_id = poh.po_header_id;
