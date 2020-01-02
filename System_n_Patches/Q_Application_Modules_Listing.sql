SELECT substr(fpi.application_id,1,6) APP_ID
,substr(fat.application_name,1,40) APPLICATION, fa.application_short_name
,substr(l.meaning,1,15) STATUS
,substr(decode(fpi.patch_level,null,'11i.'||
fa.application_short_name||'.?',fpi.patch_level),1,12) PATCH
FROM apps.fnd_product_installations fpi
,apps.fnd_application_tl fat
,apps.fnd_application fa
,apps.fnd_lookups l
WHERE (fpi.application_id 
--800 and 850
between 100 and 850
OR fpi.application_id in (178,275,712,777))
AND fpi.application_id = fat.application_id
AND fpi.application_id = fa.application_id
and l.lookup_type = 'FND_PRODUCT_STATUS'
and l.lookup_code = fpi.status 
--and application_name like '%Shop%'
order by 3
--ORDER BY fat.application_id
