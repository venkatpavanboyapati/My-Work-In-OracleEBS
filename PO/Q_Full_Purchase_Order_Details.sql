
-- Purchase Orders for non inventory items like service
SELECT ph.segment1 po_num,
       ph.creation_date,
       hou.NAME "Operating Unit",
       ppx.full_name "Buyer Name",
       ph.type_lookup_code "PO Type",
       plc.displayed_field "PO Status",
       ph.comments,
       pl.line_num,
       plt.order_type_lookup_code "Line Type",
       NULL "Item Code",
       pl.item_description,
       pl.unit_meas_lookup_code "UOM",
       pl.base_unit_price,
       pl.unit_price,
       pl.quantity,
       ood.organization_code "Shipment Org Code",
       ood.organization_name "Shipment Org Name",
       pv.vendor_name supplier,
       pvs.vendor_site_code,
       (pl.unit_price * pl.quantity) "Line Amount",
       prh.segment1 req_num,
       prh.type_lookup_code req_method,
       ppx1.full_name "Requisition requestor"
  FROM po_headers_all ph,
       po_lines_all pl,
       po_distributions_all pda,
       po_vendors pv,
       po_vendor_sites_all pvs,
       po_distributions_all pd,
       po_req_distributions_all prd,
       po_requisition_lines_all prl,
       po_requisition_headers_all prh,
       hr_operating_units hou,
       per_people_x ppx,
       po_line_types_b plt,
       org_organization_definitions ood,
       per_people_x ppx1,
       po_lookup_codes plc
 WHERE     1 = 1
       AND TO_CHAR (ph.creation_date, 'YYYY') IN (2010, 2011)
       AND ph.vendor_id = pv.vendor_id
       AND ph.po_header_id = pl.po_header_id
       AND ph.vendor_site_id = pvs.vendor_site_id
       AND ph.po_header_id = pd.po_header_id
       AND pl.po_line_id = pd.po_line_id
       AND pd.req_distribution_id = prd.distribution_id(+)
       AND prd.requisition_line_id = prl.requisition_line_id(+)
       AND prl.requisition_header_id = prh.requisition_header_id(+)
       AND hou.organization_id = ph.org_id
       AND ph.agent_id = ppx.person_id
       AND pda.po_header_id = ph.po_header_id
       AND pda.po_line_id = pl.po_line_id
       AND pl.line_type_id = plt.line_type_id
       AND ood.organization_id = pda.destination_organization_id
       AND ppx1.person_id(+) = prh.preparer_id
       AND plc.lookup_type = 'DOCUMENT STATE'
       AND plc.lookup_code = ph.closed_code
       AND pl.item_id IS NULL
UNION
-- Purchase Orders for inventory items
SELECT ph.segment1 po_num,
       ph.creation_date,
       hou.NAME "Operating Unit",
       ppx.full_name "Buyer Name",
       ph.type_lookup_code "PO Type",
       plc.displayed_field "PO Status",
       ph.comments,
       pl.line_num,
       plt.order_type_lookup_code "Line Type",
       msi.segment1 "Item Code",
       pl.item_description,
       pl.unit_meas_lookup_code "UOM",
       pl.base_unit_price,
       pl.unit_price,
       pl.quantity,
       ood.organization_code "Shipment Org Code",
       ood.organization_name "Shipment Org Name",
       pv.vendor_name supplier,
       pvs.vendor_site_code,
       (pl.unit_price * pl.quantity) "Line Amount",
       prh.segment1 req_num,
       prh.type_lookup_code req_method,
       ppx1.full_name "Requisition requestor"
  FROM po_headers_all ph,
       po_lines_all pl,
       po_distributions_all pda,
       po_vendors pv,
       po_vendor_sites_all pvs,
       po_distributions_all pd,
       po_req_distributions_all prd,
       po_requisition_lines_all prl,
       po_requisition_headers_all prh,
       hr_operating_units hou,
       per_people_x ppx,
       mtl_system_items_b msi,
       po_line_types_b plt,
       org_organization_definitions ood,
       per_people_x ppx1,
       po_lookup_codes plc
 WHERE     1 = 1
       AND TO_CHAR (ph.creation_date, 'YYYY') IN (2010, 2011)
       AND ph.vendor_id = pv.vendor_id
       AND ph.po_header_id = pl.po_header_id
       AND ph.vendor_site_id = pvs.vendor_site_id
       AND ph.po_header_id = pd.po_header_id
       AND pl.po_line_id = pd.po_line_id
       AND pd.req_distribution_id = prd.distribution_id(+)
       AND prd.requisition_line_id = prl.requisition_line_id(+)
       AND prl.requisition_header_id = prh.requisition_header_id(+)
       AND hou.organization_id = ph.org_id
       AND ph.agent_id = ppx.person_id
       AND pda.po_header_id = ph.po_header_id
       AND pda.po_line_id = pl.po_line_id
       AND pl.line_type_id = plt.line_type_id
       AND ood.organization_id = pda.destination_organization_id
       AND ppx1.person_id(+) = prh.preparer_id
       AND pda.destination_organization_id = msi.organization_id(+)
       AND msi.inventory_item_id = NVL (pl.item_id, msi.inventory_item_id)
       AND plc.lookup_type = 'DOCUMENT STATE'
       AND plc.lookup_code = ph.closed_code
       AND pl.item_id IS NOT NULL
