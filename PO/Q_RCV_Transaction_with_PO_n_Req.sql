
  SELECT ph.segment1 po_num,
         ood.organization_name,
         pol.po_line_id,
         pll.quantity,
         rsh.receipt_source_code,
         rsh.vendor_id,
         rsh.vendor_site_id,
         rsh.organization_id,
         rsh.shipment_num,
         rsh.receipt_num,
         rsh.ship_to_location_id,
         rsh.bill_of_lading,
         rsl.shipment_line_id,
         rsl.quantity_shipped,
         rsl.quantity_received,
         rct.transaction_type,
         rct.transaction_id,
         NVL (rct.source_doc_quantity, 0) transaction_qty
    FROM rcv_transactions rct,
         rcv_shipment_headers rsh,
         rcv_shipment_lines rsl,
         po_lines_all pol,
         po_line_locations_all pll,
         po_headers_all ph,
         org_organization_definitions ood
   WHERE     1 = 1
         AND TO_CHAR (rct.creation_date, 'YYYY') IN ('2010', '2011')
         AND rct.po_header_id = ph.po_header_id
         AND rct.po_line_location_id = pll.line_location_id
         AND rct.po_line_id = pol.po_line_id
         AND rct.shipment_line_id = rsl.shipment_line_id
         AND rsl.shipment_header_id = rsh.shipment_header_id
         AND rsh.ship_to_org_id = ood.organization_id
ORDER BY rct.transaction_id
