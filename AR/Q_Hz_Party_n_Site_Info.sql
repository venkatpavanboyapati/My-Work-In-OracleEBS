SELECT
  ----------------------
  --Customer Information
  ----------------------
  hp.party_id,
  hp.party_name "CUSTOMER_NAME",
  hca.cust_account_id,
  hca.account_number,
  hcas.org_id,
  ---------------------------
  --Customer Site Information
  ---------------------------
  hcas.cust_acct_site_id,
  hps.party_site_number,
  hcsu.site_use_code,
  -----------------------
  --Customer Site Address
  -----------------------
  hl.address1,
  hl.address2,
  hl.address3,
  hl.address4,
  hl.city,
  hl.postal_code,
  hl.state,
  hl.province,
  hl.county,
  hl.country,
  hl.address_style
FROM hz_parties hp,
  hz_party_sites hps,
  hz_cust_accounts_all hca,
  hz_cust_acct_sites_all hcas,
  hz_cust_site_uses_all hcsu,
  hz_locations hl
WHERE 1                    =1
AND hp.party_id            = hca.party_id
AND hca.cust_account_id    = hcas.cust_account_id(+)
AND hps.party_site_id(+)   = hcas.party_site_id
AND hcas.cust_acct_site_id = hcsu.cust_acct_site_id
  --
AND hps.location_id = hl.location_id(+)
  --
AND hp.party_type = 'ORGANIZATION' -- only ORGANIZATION Party types
AND hp.status     = 'A'            -- only Active Parties/Customers
ORDER BY to_number(hp.party_number),
  hp.party_name,
  hca.account_number;
