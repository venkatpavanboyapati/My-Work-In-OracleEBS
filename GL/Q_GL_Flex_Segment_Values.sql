SELECT  V.FLEX_VALUE AS GL_ACCOUNT,v.description,
       SUBSTR(V.COMPILED_VALUE_ATTRIBUTES, 5, 1) AS ACCOUNT_TYPE,
       V.Enabled_flag,
       V.Summary_Flag,
       V.start_date_active,
       V.End_date_Active
FROM   APPLSYS.FND_FLEX_VALUE_SETS S
       INNER JOIN APPS.FND_FLEX_VALUES_VL V
         ON V.FLEX_VALUE_SET_ID = S.FLEX_VALUE_SET_ID
WHERE  S.FLEX_VALUE_SET_NAME IN ('XX_COST_CENTER', 'XX_COST_CENTER')
       AND V.ENABLED_FLAG = 'Y'
      -- AND SUBSTR(V.COMPILED_VALUE_ATTRIBUTES, 5, 1) IN ( 'R', 'L', 'O' )
      AND flex_value = '1956'
ORDER BY v.creation_date DESC
