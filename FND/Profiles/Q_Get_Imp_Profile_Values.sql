SELECT
      FND_PROFILE.VALUE ('MFG_ORGANIZATION_ID'),
       FND_PROFILE.VALUE ('ORG_ID'), FND_PROFILE.VALUE ('LOGIN_ID'),
       FND_PROFILE.VALUE ('USER_ID'), FND_PROFILE.VALUE ('USERNAME'),
       FND_PROFILE.VALUE ('CONCURRENT_REQUEST_ID'),
       FND_PROFILE.VALUE ('GL_SET_OF_BKS_ID'),
       FND_PROFILE.VALUE ('SO_ORGANIZATION_ID'),
       FND_PROFILE.VALUE ('APPL_SHRT_NAME'),
      FND_PROFILE.VALUE ('RESP_NAME'),
       FND_PROFILE.VALUE ('RESP_ID')
  FROM DUAL;
