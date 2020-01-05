

--This table includes the defined bugs on the system: 
SELECT   bug_number 
FROM     apps.ad_bugs
WHERE   bug_number LIKE '%20251722%';

--This table includes patches applied on the system:
SELECT patch_name 
FROM   apps.ad_applied_patches
WHERE patch_name LIKE '%20251722%';
