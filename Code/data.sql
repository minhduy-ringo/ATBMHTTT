CREATE TABLE PHIEUBAU 
(
  MA_PHIEUBAU VARCHAR2(10 BYTE) NOT NULL 
, MA_THANHVIEN VARCHAR2(10 BYTE) 
, UCV1 VARCHAR2(50 BYTE) 
, UCV2 VARCHAR2(50 BYTE) 
, UCV3 VARCHAR2(50 BYTE) 
) 
TABLESPACE DOAN;

CREATE TABLE KEY_STORE 
(
  ID VARCHAR2(10) NOT NULL 
, VALUE RAW(2000) 
, BYTE_NUM NUMBER 
)
TABLESPACE DOAN;

--INSERT INTO KEY_STORE
--(id,value) VALUES ('A',dbms_crypto.randombytes(16));

--INSERT INTO PHIEUBAU VALUES ('1','1','A','B','C');

DECLARE
  m_key RAW(16);
BEGIN
  select password into m_key from sys.user$ where name = 'QLBINHBAU';
  dbms_output.put_line(encrypt_data(  in_data => UTL_I18N.STRING_TO_RAW('ABC','AL32UTF8'),
                                    in_key  => m_key
                                  ));
END;