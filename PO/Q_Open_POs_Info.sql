SELECT h.segment1 "PO NUM", h.authorization_status "STATUS",
       l.line_num "SEQ NUM", ll.line_location_id, d.po_distribution_id,
       h.type_lookup_code "TYPE"
  FROM po.po_headers_all h,
       po.po_lines_all l,
       po.po_line_locations_all ll,
       po.po_distributions_all d
 WHERE h.po_header_id = l.po_header_id
   AND ll.po_line_id = l.po_line_id
   AND ll.line_location_id = d.line_location_id
   AND h.closed_date IS NULL
   AND h.type_lookup_code NOT IN ('QUOTATION');
