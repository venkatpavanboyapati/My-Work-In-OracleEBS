 SELECT wrr.RULE_ID,
         wrr.ROLE,
         wrr.MESSAGE_TYPE,
         wrr.MESSAGE_NAME,
         wrr.BEGIN_DATE,
         wrr.END_DATE,
         wrr.ACTION,
         wrr.ACTION_ARGUMENT,
         wit.DISPLAY_NAME AS TYPE_DISPLAY,
         wm.DISPLAY_NAME AS MSG_DISPLAY,
         wm.SUBJECT,
         LookupsEO.MEANING AS ACTION_DISPLAY,
         wit.NAME,
         wm.TYPE,
         wm.NAME AS NAME1,
         LookupsEO.LOOKUP_TYPE,
         LookupsEO.LOOKUP_CODE
    FROM apps.WF_ROUTING_RULES wrr,
         apps.WF_ITEM_TYPES_VL wit,
         apps.WF_MESSAGES_VL wm,
         apps.WF_LOOKUPS LookupsEO
   WHERE   1 = 1--  wrr.ROLE = :1
         AND wrr.MESSAGE_TYPE = wit.NAME(+)
         AND wrr.MESSAGE_TYPE = wm.TYPE(+)
         AND wrr.MESSAGE_NAME = wm.NAME(+)
         AND wrr.ACTION = LookupsEO.LOOKUP_CODE
         AND LookupsEO.LOOKUP_TYPE = 'WFSTD_ROUTING_ACTIONS'
         order by begin_date desc
