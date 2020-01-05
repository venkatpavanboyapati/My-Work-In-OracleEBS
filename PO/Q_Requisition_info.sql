SELECT DISTINCT u.description "Requestor", porh.segment1 AS "Req Number",
                TRUNC (porh.creation_date) "Created On", pord.last_updated_by,
                porh.authorization_status "Status",
                porh.description "Description", poh.segment1 "PO Number",
                TRUNC (poh.creation_date) "PO Creation Date",
                poh.authorization_status "PO Status",
                TRUNC (poh.approved_date) "Approved Date"
           FROM apps.po_headers_all poh,
                apps.po_distributions_all pod,
                apps.po_req_distributions_all pord,
                apps.po_requisition_lines_all porl,
                apps.po_requisition_headers_all porh,
                apps.fnd_user u
          WHERE porh.requisition_header_id = porl.requisition_header_id
            AND porl.requisition_line_id = pord.requisition_line_id
            AND pord.distribution_id = pod.req_distribution_id(+)
            AND pod.po_header_id = poh.po_header_id(+)
            AND porh.created_by = u.user_id
       ORDER BY 2
