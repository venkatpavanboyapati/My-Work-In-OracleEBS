SELECT *
  FROM apps.iby_transmit_values transmitvalueseo,
       apps.iby_transmit_parameters_vl PARAMETERS,
       apps.iby_transmit_configs_vl transmit_config,
       apps.fnd_lookups
 WHERE transmitvalueseo.transmit_parameter_code =
                                            PARAMETERS.transmit_parameter_code
   AND transmitvalueseo.transmit_configuration_id =
                                     transmit_config.transmit_configuration_id
   AND transmit_config.transmit_protocol_code =
                                             PARAMETERS.transmit_protocol_code
   AND NVL (PARAMETERS.dynamic_flag, 'N') <> 'Y'
   AND lookup_type = 'IBY_PARAMETER_TYPES'
   AND lookup_code = transmit_parameter_type
      and transmit_configuration_name like '%%'
   order by transmitvalueseo.creation_date desc, display_order
