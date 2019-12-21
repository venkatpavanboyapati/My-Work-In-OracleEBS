SELECT hpp.party_name "Contact Person Name",
  hpc.party_name "Customer Name"            ,
  hpc.party_number "Registry ID"            ,
  fat.application_name "Created from Application"
   FROM apps.hz_relationships hr,
  apps.hz_parties hpp           ,
  apps.hz_parties hpc           ,
  fnd_application_tl fat
  WHERE 1                            =1
AND hr.subject_table_name            = 'HZ_PARTIES'
AND hr.object_type                   = 'ORGANIZATION'
AND hr.subject_id                    = hpp.party_id
AND hr.object_id                     = hpc.party_id
AND hr.status                       <> 'I'
AND hpp.application_id               = fat.application_id
AND fat.language                     = 'US'
AND (hpp.party_name,hpc.party_name) IN
  (SELECT hpp.party_name,
    hpc.party_name
     FROM apps.hz_relationships hr,
    apps.hz_parties hpp           ,
    apps.hz_parties hpc
    WHERE 1                 =1
  AND hr.subject_table_name = 'HZ_PARTIES'
  AND hr.object_type        = 'ORGANIZATION'
  AND hr.subject_id         = hpp.party_id
  AND hr.object_id          = hpc.party_id
  AND hr.status            <> 'I'
 GROUP BY hpp.party_name ,
    hpc.party_name
  HAVING COUNT(hpp.party_name) > 1
  )
ORDER BY hpp.party_name ;
