
SELECT DISTINCT
       fifs.id_flex_structure_code,
       fsav.application_column_name,
       ffsg.segment_name,
       DECODE (fsav.segment_attribute_type,
               'FA_COST_CTR', 'Cost Center Segment',
               'GL_ACCOUNT', 'Natural Account Segment',
               'GL_BALANCING', 'Balancing Segment',
               'GL_INTERCOMPANY', 'Intercompany Segment',
               'GL_SECONDARY_TRACKING', 'Secondary Tracking Segment',
               'GL_MANAGEMENT', 'Management Segment',
               fsav.segment_attribute_type)
  FROM fnd_segment_attribute_values fsav,
       fnd_id_flex_structures fifs,
       fnd_id_flex_segments ffsgWHERE
 UPPER(fifs.id_flex_structure_code) = UPPER('&Flexfield_Code')
AND fsav.attribute_value = 'Y'
AND segment_attribute_type NOT IN ('GL_GLOBAL', 'GL_LEDGER')
AND fsav.ID_FLEX_NUM = fifs.ID_FLEX_NUM
AND ffsg.ID_FLEX_NUM = fifs.ID_FLEX_NUM
AND ffsg.application_column_name = fsav.application_column_name
ORDER BY application_column_name;
