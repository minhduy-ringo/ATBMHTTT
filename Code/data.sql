CREATE TABLE PHIEUBAU 
(
  MA_PHIEUBAU VARCHAR2(10 BYTE) NOT NULL 
, MA_THANHVIEN VARCHAR2(10 BYTE) 
, UCV1 VARCHAR2(50 BYTE) 
, UCV2 VARCHAR2(50 BYTE) 
, UCV3 VARCHAR2(50 BYTE) 
) 
TABLESPACE DOAN;

INSERT INTO PHIEUBAU
(ma_phieubau,UCV1,UCV2,UCV3) VALUES ('1','A','B','C'); 

dbms_output.put_line(encrypt_data(in_data => UTL_I18N.STRING_TO_RAW('ABC','AL32UTF8')));
BEGIN
dbms_output.put_line(encrypt_data(in_data => UTL_I18N.STRING_TO_RAW('ABC','AL32UTF8')));
END;