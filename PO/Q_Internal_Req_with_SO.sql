
  SELECT rqh.segment1,
         rql.line_num,
         rql.requisition_header_id,
         rql.requisition_line_id,
         rql.item_id,
         rql.unit_meas_lookup_code,
         rql.unit_price,
         rql.quantity,
         rql.quantity_cancelled,
         rql.quantity_delivered,
         rql.cancel_flag,
         rql.source_type_code,
         rql.source_organization_id,
         rql.destination_organization_id,
         rqh.transferred_to_oe_flag
    FROM po_requisition_lines_all rql, po_requisition_headers_all rqh
   WHERE     rql.requisition_header_id = rqh.requisition_header_id
         AND rql.source_type_code = 'INVENTORY'
         AND rql.source_organization_id IS NOT NULL
         AND EXISTS
                    (SELECT 'existing internal order'
                       FROM oe_order_lines_all lin
                      WHERE     lin.source_document_line_id =
                                   rql.requisition_line_id
                            AND lin.source_document_type_id = 10)
ORDER BY rqh.requisition_header_id, rql.line_num
