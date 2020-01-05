DECLARE
  --
  --Cursor to fetch the data
  --
  CURSOR data_cur
  IS
    --
    SELECT empno,ename,job,hiredate,sal FROM emp;
  --
  output_row data_cur%rowtype;
BEGIN
  --
  --
  dbms_output.put_line('<?xml version="1.0" encoding="US-ASCII" standalone="no"?>');
  fnd_file.put_line(fnd_file.output,'<?xml version="1.0" encoding="US-ASCII" standalone="no"?>');
  dbms_output.put_line('<OUTPUT>');
  fnd_file.put_line(fnd_file.output,'<OUTPUT>');
  --
  OPEN data_cur;
  LOOP
    --
    FETCH data_cur INTO output_row;
    EXIT
  WHEN data_cur%notfound;
    --
    dbms_output.put_line('<ROW>');
    fnd_file.put_line(fnd_file.output,'<ROW>');
    --
    dbms_output.put_line('<ENUM>'||dbms_xmlgen.convert(output_row.empno)||'</ENUM>');
    fnd_file.put_line(fnd_file.output,'<ENUM>'||dbms_xmlgen.convert(output_row.empno)||'</ENUM>');
    --
    dbms_output.put_line('<ENAME>'||dbms_xmlgen.convert(output_row.ename )||'</ENAME>');
    fnd_file.put_line(fnd_file.output,'<ENAME>'||dbms_xmlgen.convert(output_row.ename )||'</ENAME>');
    --
    dbms_output.put_line('<JOB>'||dbms_xmlgen.convert(output_row.job )||'</JOB>');
    fnd_file.put_line(fnd_file.output,'<JOB>'||dbms_xmlgen.convert(output_row.job )||'</JOB>');
    --
    dbms_output.put_line('<HIRE_DATE>'||dbms_xmlgen.convert(output_row.hiredate )||'</HIRE_DATE>');
    fnd_file.put_line(fnd_file.output,'<HIRE_DATE>'||dbms_xmlgen.convert(output_row.hiredate )||'</HIRE_DATE>');
    --
    dbms_output.put_line('<SAL>'||dbms_xmlgen.convert(output_row.sal )||'</SAL>');
    fnd_file.put_line(fnd_file.output,'<SAL>'||dbms_xmlgen.convert(output_row.sal )||'</SAL>');
    --
    dbms_output.put_line('</ROW>');
    fnd_file.put_line(fnd_file.output,'</ROW>');
    --
  END LOOP;
  CLOSE data_cur;
  --
  dbms_output.put_line('</OUTPUT>');
  fnd_file.put_line(fnd_file.output,'</OUTPUT>');
  --
END;
/
