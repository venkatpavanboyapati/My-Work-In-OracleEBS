    
      SELECT
      XMLCONCAT (
                XMLELEMENT ("SUPP_TOP10_OPTS",
                XMLAGG ( XMLELEMENT ("SUPP_OPTS"
                                , XMLELEMENT ("VENDOR_NAME",vendor_name )
                                , XMLELEMENT ("VENDOR_NO",segment1 )
                                , XMLELEMENT ("VENDOR_PAY_GROUP", pay_group_lookup_code)
                                , XMLELEMENT ("PAY_DATE_BASIS", pay_date_basis_lookup_code)
                                , XMLELEMENT ("TERMS_DATE_BASIS", terms_date_basis)             
                                , XMLELEMENT ("TERM_NAME", terms_name)
                                , XMLELEMENT ("ALWAYS_TAKE_DISC_FLAG", always_take_disc_flag)
                                , XMLELEMENT ("EXCLUDE_FREIGHT_FROM_DISC", exclude_freight_from_discount )
                                , XMLELEMENT ("SUPP_SITES"
                                ,( SELECT  XMLAGG(  XMLELEMENT ("SUPP_SITE"
                                                , XMLELEMENT ("VENDOR_SITE_CODE",vendor_site_code )
                                                , XMLELEMENT ("ADDRESS",address )
                                                , XMLELEMENT ("PAY_SITE_FLAG",Pay_site_flag )
                                                , XMLELEMENT ("VENDOR_PAY_GROUP", site_pay_group)
                                                , XMLELEMENT ("PAY_DATE_BASIS", site_pay_date_basis)
                                                , XMLELEMENT ("TERMS_DATE_BASIS", site_terms_date_basis)             
                                                , XMLELEMENT ("TERM_NAME", site_terms_name)
                                                , XMLELEMENT ("ALWAYS_TAKE_DISC_FLAG", site_always_take_disc_flag)
                                                , XMLELEMENT ("EXCLUDE_FREIGHT_FROM_DISC", site_exclude_frt_from_disc )))
                                   FROM  ( SELECT apss.vendor_site_code,
                                                  apss.address_line1||' , '||apss.city||' , '||apss.state||' , '||apss.country  address,
                                                  apss.pay_site_flag,
                                                  apss.pay_group_lookup_code site_pay_group,
                                                  apss.pay_date_basis_lookup_code site_pay_date_basis,
                                                  apss.terms_date_basis site_terms_date_basis,
                                                  atvs.name site_terms_name,
                                                  apss.always_take_disc_flag site_always_take_disc_flag,
                                                  apss.exclude_freight_from_discount site_exclude_frt_from_disc
                                            FROM  ap_supplier_sites_all apss
                                                , ap_terms_vl atvs  
                                           WHERE 1=1
                                             AND apsup.vendor_id = apss.vendor_id
                                             AND apss.terms_id = atvs.term_id(+)   
                                             AND apss.pay_site_flag = 'Y'
                                             AND (apss.inactive_date is null or apss.inactive_date > sysdate) ))
                                )))))
     ---  INTO v_supp_optns
       FROM
        (SELECT   aps.pay_group_lookup_code,
                  aps.pay_date_basis_lookup_code,
                  aps.terms_date_basis,
                  aps.always_take_disc_flag,
                  atv.name terms_name,
                  aps.exclude_freight_from_discount,
                  aps.segment1,
                  aps.vendor_name ,
                  aps.vendor_id  vendor_id               
          FROM ap_suppliers aps             
             , ap_terms_vl atv                        
         WHERE 1 = 1 
         AND aps.terms_id = atv.term_id(+)      
         AND ROWNUM < 11 ) apsup ;
