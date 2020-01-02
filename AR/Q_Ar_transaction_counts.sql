  SELECT bs.description, ctt.name, COUNT (1)
    FROM apps.ra_customer_trx_all ct,
         apps.ra_batch_sources_all bs,
         apps.ra_cust_trx_types_all ctt
   WHERE     ct.batch_source_id = bs.batch_source_id
         AND ct.cust_trx_type_id = ctt.cust_trx_type_id
         AND ct.creation_date > SYSDATE - 180
GROUP BY bs.description, ctt.name
