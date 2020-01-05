/* Lists all pending journal import groups and the number*/
/* of records in each group */
set linesize 120
col Currency format a8
spool q_ji1
Select set_of_books_id Book
, user_je_source_name Source
, user_je_category_name Category
, currency_code Currency
, trunc (date_created) Created
, actual_flag Journal
, count(*)
from gl_interface
group by set_of_books_id
, user_je_source_name
, user_je_category_name
, currency_code
, trunc (date_created)
, actual_flag
order by set_of_books_id, trunc (date_created);


/* Calculates the total amounts for a given group id */
set linesize 120
col s_en_cr format S999,999,999.99
col s_en_dr format S999,999,999.99
col s_acc_cr format S999,999,999.99
col s_acc_dr format S999,999,999.99
spool q_ji3
Select user_je_source_name Source
, User_je_category_name Category
, currency_code Currency
, sum (entered_cr) s_en_cr
, sum (entered_dr) s_en_dr
, sum (accounted_cr) s_acc_cr
, sum (accounted_dr) s_acc_dr
from gl_interface
where group_id = &group_id
group by user_je_source_name
, User_je_category_name
, currency_code
