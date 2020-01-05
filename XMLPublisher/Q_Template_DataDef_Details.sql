
SELECT DISTINCT (XL.file_name) "File Name",
                XDDV.data_source_code "Data Definition Code",
                XDDV.data_source_name "Data Definition",
                XDDV.description "Data Definition Description",
                XTB.template_code "Template Code",
                XTT.template_name "Template Name",
                XTT.description "Template Description",
                XTB.template_type_code "Type",
                XL.file_name "File Name",
                XTB.default_output_type "Default Output Type"
  FROM apps.XDO_DS_DEFINITIONS_VL XDDV,
       apps.XDO_TEMPLATES_B XTB,
       apps.XDO_TEMPLATES_TL XTT,
       apps.XDO_LOBS XL,
       apps.FND_APPLICATION_TL FAT,
       APPS.FND_APPLICATION FA
 WHERE     XDDV.DATA_SOURCE_CODE LIKE 'XXW%'
       --AND FAT.application_name = '&Application_Name'
       AND XDDV.application_short_name = FA.application_short_name
       AND FAT.application_id = FA.application_id
       AND XTB.application_short_name = XDDV.application_short_name
       AND XDDV.data_source_code = XTB.data_source_code
       AND XTT.template_code = XTB.template_code
       AND XL.LOB_CODE = XTB.TEMPLATE_CODE
       AND XL.XDO_FILE_TYPE = XTB.TEMPLATE_TYPE_CODE;
