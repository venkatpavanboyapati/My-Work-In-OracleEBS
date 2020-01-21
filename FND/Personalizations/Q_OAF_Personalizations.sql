SELECT
    jp.path_docid ,
    jdr_mds_internal.getdocumentname(jp.path_docid) Personalization_path,
    jp.path_name,
    Jp.Path_Owner_Docid,
    Jp.Path_Seq,
    Jp.Path_Type,
    Jp.Path_Xml_Encoding,
    Jp.Path_Xml_Version,
    Jp.Created_By,
    Jp.Creation_Date,
    Jp.Last_Updated_By,
    Jp.Last_Update_Date    
  FROM apps.jdr_paths jp
WHERE jp.path_docid IN (
        SELECT DISTINCT comp_docid
        FROM jdr_components
        WHERE
            comp_seq = 0
            AND   comp_element = 'customization'
            AND   comp_id IS NULL
    )
    AND   upper(apps.jdr_mds_internal.getdocumentname(jp.path_docid) ) LIKE upper('%USER%ByrMainPG%');
