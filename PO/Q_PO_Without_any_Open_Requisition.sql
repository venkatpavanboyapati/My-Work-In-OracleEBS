SELECT   prh.segment1 "PR NUM", TRUNC (prh.creation_date) "CREATED ON",
         TRUNC (prl.creation_date) "Line Creation Date", prl.line_num "Seq #",
         msi.segment1 "Item Num", prl.item_description "Description",
         prl.quantity "Qty", TRUNC (prl.need_by_date) "Required By",
         ppf1.full_name "REQUESTOR", ppf2.agent_name "BUYER"
    FROM po.po_requisition_headers_all prh,
         po.po_requisition_lines_all prl,
         apps.per_people_f ppf1,
         (SELECT DISTINCT agent_id, agent_name
                     FROM apps.po_agents_v) ppf2,
         po.po_req_distributions_all prd,
         inv.mtl_system_items_b msi,
         po.po_line_locations_all pll,
         po.po_lines_all pl,
         po.po_headers_all ph
   WHERE prh.requisition_header_id = prl.requisition_header_id
     AND prl.requisition_line_id = prd.requisition_line_id
     AND ppf1.person_id = prh.preparer_id
     AND prh.creation_date BETWEEN ppf1.effective_start_date
                               AND ppf1.effective_end_date
     AND ppf2.agent_id(+) = msi.buyer_id
     AND msi.inventory_item_id = prl.item_id
     AND msi.organization_id = prl.destination_organization_id
     AND pll.line_location_id(+) = prl.line_location_id
     AND pll.po_header_id = ph.po_header_id(+)
     AND pll.po_line_id = pl.po_line_id(+)
     AND prh.authorization_status = 'APPROVED'
     AND pll.line_location_id IS NULL
     AND prl.closed_code IS NULL
     AND NVL (prl.cancel_flag, 'N') <> 'Y'
ORDER BY 1, 2    
