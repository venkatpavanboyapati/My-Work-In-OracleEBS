SELECT sup.vendor_name,
       sup.segment1 supplier_number,
       sit.vendor_site_id,
       sit.vendor_site_code,
          sit.address_line1
       || ' '
       || sit.address_line2
       || ' '
       || sit.address_line3
          street_address,
       sit.city,
       NVL2 (sit.state, sit.state, sit.province) "State/Province",
       sit.zip,
       sit.country,
       sit.phone,
       (SELECT SUM (apay.amount)
          FROM apps.ap_invoices_all api, apps.ap_invoice_payments_all apay
         WHERE     api.invoice_id = apay.invoice_id
               AND apay.last_update_date > SYSDATE - 365
               AND api.vendor_site_id = sit.vendor_site_id)
          "Annual Spend",
       (SELECT COUNT (apay.invoice_payment_id)
          FROM apps.ap_invoices_all api, apps.ap_invoice_payments_all apay
         WHERE     api.invoice_id = apay.invoice_id
               AND apay.last_update_date > SYSDATE - 365
               AND api.vendor_site_id = sit.vendor_site_id)
          "Annual Payment Count",
       apt.name "Paymenrt Terms",
       NVL (
          (SELECT ieppm.payment_method_code
             FROM apps.iby_external_payees_all iepa, apps.iby_ext_party_pmt_mthds ieppm
            WHERE     sit.vendor_site_id = iepa.supplier_site_id
                  AND iepa.ext_payee_id = ieppm.ext_pmt_party_id
                  AND (   (ieppm.inactive_date IS NULL)
                       OR (ieppm.inactive_date > SYSDATE))
                  --AND assa.vendor_site_id = :p_vendor_site_id
                  AND ieppm.primary_flag = 'Y'),
          (SELECT paym.payment_method_code
             FROM apps.iby_external_payees_all payee, apps.iby_ext_party_pmt_mthds paym
            WHERE     sup.party_id = payee.payee_party_id
                  AND payee.ext_payee_id = paym.ext_pmt_party_id
                  AND (   (paym.inactive_date IS NULL)
                       OR (paym.inactive_date > SYSDATE))
                       AND    supplier_site_id IS NULL
                  AND paym.primary_flag = 'Y'))
          payment_method_supplier,
       sit.vendor_site_id "Supplier Unique Id",
       (SELECT COUNT (api.invoice_id)
          FROM apps.ap_invoices_all api
         WHERE     1 = 1
               AND api.last_update_date > SYSDATE - 365
               AND api.vendor_site_id = sit.vendor_site_id)
          annualinvoicecount,
       (SELECT COUNT (po)
          FROM (SELECT DISTINCT pod.po_header_id po, vendor_site_id
                  FROM apps.ap_invoices_all api,
                       apps.ap_invoice_distributions_all aid,
                       apps.po_distributions_all pod
                 WHERE     api.invoice_id = aid.invoice_id
                       AND aid.last_update_date > SYSDATE - 365
                       AND aid.po_distribution_id = pod.po_distribution_id)
               pnt
         WHERE pnt.vendor_site_id = sit.vendor_site_id)
          "Annual Purchase order Count",
       sit.email_address,
       sit.org_id
  FROM ap.ap_suppliers sup,
       ap.ap_supplier_sites_all sit,
       apps.ap_terms_tl apt
 WHERE     sup.vendor_id = sit.vendor_id
       AND NVL (sup.vendor_type_lookup_code, 'VENDOR') NOT LIKE '%EMPLOYEE%'
       --AND sup.vendor_id = 1367799
       -- AND sup.segment1 = '869906'
       --AND sit.pay_site_flag = 'Y'
       --AND sup.one_time_flag = 'N'
       AND sup.enabled_flag = 'Y'
       AND sit.terms_id = apt.term_id
       AND sup.end_date_active IS NULL
       AND sit.inactive_date IS NULL
    --   AND sup.vendor_name LIKE '%XX%' 
