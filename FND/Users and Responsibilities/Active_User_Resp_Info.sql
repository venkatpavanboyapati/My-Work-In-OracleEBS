
SELECT fu.user_name,
       fu.start_date USER_START_DATE,
       fu.end_date USER_END_DATE, 
       fu.email_address,
       frv.responsibility_name,
       frv.responsibility_key,
       TO_CHAR (furgd.start_date, 'DD-MON-YYYY') RESP_START_DATE,
       TO_CHAR (furgd.end_date, 'DD-MON-YYYY') RESP_END_DATE
FROM fnd_user fu,
  fnd_user_resp_groups_direct furgd,
  fnd_responsibility_vl frv
WHERE fu.user_id                     = furgd.user_id
AND furgd.responsibility_id          = frv.responsibility_id
AND furgd.end_date                  IS NULL
--AND fu.user_name                     = '&p_username' 
AND furgd.start_date                <= sysdate
AND NVL(furgd.end_date, sysdate + 1) > sysdate
AND fu.start_date                   <= sysdate
AND NVL(fu.end_date, sysdate + 1)    > sysdate
AND frv.start_date                  <= sysdate
AND NVL(frv.end_date, sysdate + 1)   > sysdate;
