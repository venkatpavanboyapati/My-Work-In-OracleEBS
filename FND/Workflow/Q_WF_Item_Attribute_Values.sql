SELECT NAME attr_name,
       nvl(text_value,
           nvl(to_char(number_value),
               to_char(date_value))) VALUE
  FROM apps.wf_item_attribute_values
 WHERE item_type = upper('&item_type')
   AND item_key = nvl('&item_key',item_key);
