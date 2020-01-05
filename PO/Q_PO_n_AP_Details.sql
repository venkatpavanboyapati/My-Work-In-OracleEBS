
SELECT a.org_id "ORG ID",
       e.segment1 "VENDOR NUM",
       e.vendor_name "SUPPLIER NAME",
       UPPER (e.vendor_type_lookup_code) "VENDOR TYPE",
       f.vendor_site_code "VENDOR SITE CODE",
       f.address_line1 "ADDRESS",
       f.city "CITY",
       f.country "COUNTRY",
       TO_CHAR (TRUNC (d.creation_date)) "PO Date",
       d.segment1 "PO NUM",
       d.type_lookup_code "PO Type",
       c.quantity_ordered "QTY ORDERED",
       c.quantity_cancelled "QTY CANCELLED",
       g.item_id "ITEM ID",
       g.item_description "ITEM DESCRIPTION",
       g.unit_price "UNIT PRICE",
         (NVL (c.quantity_ordered, 0) - NVL (c.quantity_cancelled, 0))
       * NVL (g.unit_price, 0)
          "PO Line Amount",
       (SELECT DECODE (ph.approved_flag, 'Y', 'Approved')
          FROM po.po_headers_all ph
         WHERE ph.po_header_id = d.po_header_id)
          "PO Approved?",
       a.invoice_type_lookup_code "INVOICE TYPE",
       a.invoice_amount "INVOICE AMOUNT",
       TO_CHAR (TRUNC (a.invoice_date)) "INVOICE DATE",
       a.invoice_num "INVOICE NUMBER",
       (SELECT DECODE (x.match_status_flag, 'A', 'Approved')
          FROM ap.ap_invoice_distributions_all x
         WHERE x.invoice_distribution_id = b.invoice_distribution_id)
          "Invoice Approved?",
       a.amount_paid,
       h.amount,
       h.check_id,
       h.invoice_payment_id "Payment Id",
       i.check_number "Cheque Number",
       TO_CHAR (TRUNC (i.check_date)) "Payment Date"
  FROM ap.ap_invoices_all a,
       ap.ap_invoice_distributions_all b,
       po.po_distributions_all c,
       po.po_headers_all d,
       po.po_vendors e,
       po.po_vendor_sites_all f,
       po.po_lines_all g,
       ap.ap_invoice_payments_all h,
       ap.ap_checks_all i
 WHERE     a.invoice_id = b.invoice_id
       AND b.po_distribution_id = c.po_distribution_id(+)
       AND c.po_header_id = d.po_header_id(+)
       AND e.vendor_id(+) = d.vendor_id
       AND f.vendor_site_id(+) = d.vendor_site_id
       AND d.po_header_id = g.po_header_id
       AND c.po_line_id = g.po_line_id
       AND a.invoice_id = h.invoice_id
       AND h.check_id = i.check_id
       AND f.vendor_site_id = i.vendor_site_id
       AND c.po_header_id IS NOT NULL
       AND a.payment_status_flag = 'Y'
       AND d.type_lookup_code != 'BLANKET'
