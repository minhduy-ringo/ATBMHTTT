SET serveroutput ON
/*----------------------------------------------------
    SESSION 1
    -   Create DEMO tablespace and USER TEST_DEMO 
*/----------------------------------------------------
create tablespace DEMO
    datafile 'demo.dat'
    size 10M
    reuse
    autoextend on next 10M maxsize 200M;

CREATE USER test_demo
    IDENTIFIED BY "123456"
    DEFAULT TABLESPACE DEMO
    --TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON DEMO;

GRANT ALL PRIVILEGES TO test_demo;              --Grant all basic privileges such as create session, create table to user
GRANT EXECUTE ON sys.dbms_crypto TO test_demo;
GRANT EXECUTE ON sys.dbms_output TO test_demo;  
GRANT SELECT ON USER$ TO test_demo;             --Grant SELECT on table USER$ so that this user can query PASSWORD field

--Switch to schema test_demo
connect test_demo/"123456"
alter session set current_schema = test_demo;

/*-----------------------------------------------------------------------------------------
    SESSION 2
    -   In this session, we create table PHIEUBAU and table NHANVIEN and insert some data to
    provide input for ENCRYPT and DECRYPT function. 
    -   Then we create table KEY_STORE that
    stores all the key we created which serve for symmetric encryption.
    
*/-----------------------------------------------------------------------------------------
--Table phieu bau
CREATE TABLE PHIEUBAU 
(
  MA_PHIEUBAU VARCHAR2(10 BYTE) NOT NULL 
, MA_THANHVIEN VARCHAR2(10 BYTE) 
, UCV1 VARCHAR2(50 BYTE) 
, UCV2 VARCHAR2(50 BYTE) 
, UCV3 VARCHAR2(50 BYTE) 
) 
TABLESPACE DEMO;

--Table nhan vien
CREATE TABLE NhanVien(
maNV VARCHAR2(8) NOT NULL,
hoTen VARCHAR2(50) NOT NULL,
diaChi VARCHAR2(100) NOT NULL,
dienThoai VARCHAR2(20),
email VARCHAR2(100),
maPhong VARCHAR2(8),
chiNhanh VARCHAR2(8),
luong FLOAT
)
TABLESPACE DEMO;

--Table key store
CREATE TABLE KEY_STORE 
(
  ID VARCHAR2(10) NOT NULL 
, VALUE RAW(2000) 
, BYTE_NUM NUMBER 
)   
TABLESPACE DOAN;

/*-----------------------------------------------------------------------------------------
    SESSION 3
    - In this session, we create 3 functions:
        + Encrypt
        + Decrypt
        + Hash
    - Notice:   that in encrypt and decrypt, althought the IN_KEY parameter is OPTIONAL, but
                if we want to decrypt the cipher text encrypted by ENCRYPT function, we need
                the same key in for both functions.
*/-----------------------------------------------------------------------------------------
/*
    Encrypt data function using AES128 algorithm
    Parameter : IN RAW plain text data, RAW key (optional)
                OUT raw encrypted data
    Call: encrypt_data_AES128(  in_data => raw_data,
                                in_key  => raw_key );
*/
create replace FUNCTION encrypt_data_AES128
(
    in_data IN RAW,
    in_key IN RAW DEFAULT NULL
)
RETURN RAW
IS
    encryption_type PLS_INTEGER := dbms_crypto.encrypt_AES128
                                    + dbms_crypto.chain_cbc 
                                    + dbms_crypto.pad_pkcs5;
    m_key RAW(16);
    encrypted_data RAW(2000);
BEGIN
    --Check if user provide a key
    m_key := in_key;
    if m_key = NULL then
        m_key := dbms_crypto.randombytes(16);
    end if;
    encrypted_data := dbms_crypto.encrypt
        (   src => in_data,
            typ => encryption_type,
            key => m_key
        );
    return encrypted_data;
END;

/*
    Decrypt data function using AES128 algorithm
    Parameter : IN RAW cipher text data, RAW key (optionla)
                OUT RAW plain text data
    Call: decrypt_data_AES128(  in_data => raw_data,
                                in_key  => raw_key );
*/
create replace function decrypt_data_AES128
(
    in_data IN RAW,
    in_key IN RAW DEFAULT NULL
)
RETURN RAW
IS
    decryption_type PLS_INTEGER := dbms_crypto.encrypt_AES128
                                    + dbms_crypto.chain_cbc 
                                    + dbms_crypto.pad_pkcs5;
    m_key RAW(16);
    plain_text_data RAW(2000);
BEGIN
--Check if user provide a key
    m_key := in_key;
    if m_key = NULL then
        m_key := dbms_crypto.randombytes(16);
    end if;
    plain_text_data := dbms_crypto.decrypt
        (   src => in_data,
            typ => decryption_type,
            key => m_key
        );
    return plain_text_data;
END;

/*
    Hash function
*/
create FUNCTION hash_data
(
    in_data IN RAW,
    numbit IN NUMBER DEFAULT 128
)
RETURN RAW
IS
    hashed_data RAW(32);
BEGIN
    IF numbytes = 128 THEN
        hashed_data := dbms_crypto.hash(in_data, 2);
    END IF;
    return hashed_data;
END;
    
/*-----------------------------------------------------------------------------------------
    SESSION 4
    -   In this session, we going to encrypt data in table PHIEUBAU
    -   Context: In voting process, we need to obscure the elected person names for every votes.
    -   How-to: using one high level-access key ( key that can only use by user that have
                high authority ) to encrypt the vote before insert into database.
    -   We can limit accesses to table KEY_STORE using VPD or OLS, but in this demo, we 
        using IF STAMENT that check if current session user is test_demo.
*/-----------------------------------------------------------------------------------------
INSERT INTO KEY_STORE
    VALUES (1,dbms_crypto.randombytes(16),16);  --create 16 bytes key

--Trigger that fire when UPDATE or INSERT into table PHIEUBAU
create or replace TRIGGER alter_phieubau_trigger
    BEFORE UPDATE OR INSERT ON PHIEUBAU 
    FOR EACH ROW
declare
    ciphertext RAW(2000);
    current_user VARCHAR(50);
    m_key RAW(32);
BEGIN
    current_user := SYS_CONTEXT('userenv','SESSION_USER');
    select KEY_STORE.value 
        into m_key 
        from KEY_STORE 
        where ID = '1';
    IF current_user = 'test_demo' THEN
        ciphertext := encrypt_data_AES128(  in_data => UTL_I18N.STRING_TO_RAW(:new.UCV1,'AL32UTF8'),
                                            in_key  => m_key
                                            );
        :new.UCV1 := UTL_RAW.CAST_TO_VARCHAR2(ciphertext);
        
        ciphertext := encrypt_data_AES128(  in_data => UTL_I18N.STRING_TO_RAW(:new.UCV2,'AL32UTF8'),
                                            in_key  => m_key
                                            );
        :new.UCV2 := UTL_RAW.CAST_TO_VARCHAR2(ciphertext);
        
        ciphertext := encrypt_data_AES128(  in_data => UTL_I18N.STRING_TO_RAW(:new.UCV3,'AL32UTF8'),
                                            in_key  => m_key
                                            );
        :new.UCV3 := UTL_RAW.CAST_TO_VARCHAR2(ciphertext);
    ELSE
        raise_application_error(-100,'User authority level is not sufficient');
    END IF;
END;

INSERT INTO PHIEUBAU
    VALUES ('1','TDA01','Jacquenetta Jenoure','Annabel Dunlop','Gisele Grice');
    
SELECT * FROM PHIEUBAU;

--Create a procedure to print out decypted UCV in the vote
CREATE OR REPLACE PROCEDURE QUERY_UNGVIEN 
(
  MAPHIEUBAU IN VARCHAR2 
) AS
    plaintext VARCHAR2(100);
    ciphertext RAW(2000);
    m_key RAW(32);
    current_user VARCHAR(50);
BEGIN
    current_user := SYS_CONTEXT('userenv','SESSION_USER');
    IF current_user = 'TEST_DEMO' THEN
        --select key
        select KEY_STORE.value 
            into m_key 
            from KEY_STORE 
            where ID = '1';
        --decrypt UCV1
        select UTL_I18N.STRING_TO_RAW(PHIEUBAU.UCV1)
            into ciphertext 
            from PHIEUBAU 
            where MA_PHIEUBAU = MAPHIEUBAU;
        plaintext := UTL_RAW.CAST_TO_VARCHAR2(decrypt_data_AES128(ciphertext,m_key));
        dbms_output.put_line('Ung cu vien 1: ' || plaintext);
        --decrypt UCV1
        select UTL_I18N.STRING_TO_RAW(PHIEUBAU.UCV2)
            into ciphertext 
            from PHIEUBAU 
            where MA_PHIEUBAU = MAPHIEUBAU;
        plaintext := UTL_RAW.CAST_TO_VARCHAR2(decrypt_data_AES128(ciphertext,m_key));
        dbms_output.put_line('Ung cu vien 2: ' || plaintext);
        --decrypt UCV1
        select UTL_I18N.STRING_TO_RAW(PHIEUBAU.UCV3)
            into ciphertext 
            from PHIEUBAU 
            where MA_PHIEUBAU = MAPHIEUBAU;
        plaintext := UTL_RAW.CAST_TO_VARCHAR2(decrypt_data_AES128(ciphertext,m_key));
        dbms_output.put_line('Ung cu vien 3: ' || plaintext);
    ELSE
        raise_application_error(-20000,'User authority level is not sufficient');
    END IF;
END;

begin
    query_ungvien(1);
end;

/*-----------------------------------------------------------------------------------------
    SESSION 5
    -Delete data
*/-----------------------------------------------------------------------------------------
--drop table PHIEUBAU;
--drop table NHANVIEN;
drop tablespace DEMO;
--drop user test_demo cascade;