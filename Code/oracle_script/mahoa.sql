/*-------------------------------------------------------------------------------------------
    Encrypt data function using AES128 algorithm
    Parameter : IN RAW plain text data, RAW key (optional)
                OUT raw encrypted data
    Call: encrypt_data_AES128(  in_data => raw_data,
                                in_key  => raw_key );
*/-------------------------------------------------------------------------------------------
create or replace FUNCTION encrypt_data_AES128
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

/*-------------------------------------------------------------------------------------------
    Decrypt data function using AES128 algorithm
    Parameter : IN RAW cipher text data, RAW key (optionla)
                OUT RAW plain text data
    Call: decrypt_data_AES128(  in_data => raw_data,
                                in_key  => raw_key );
*/-------------------------------------------------------------------------------------------
create or replace function decrypt_data_AES128
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

/*-------------------------------------------------------------------------------------------
    Hash function
*/-------------------------------------------------------------------------------------------
create or replace FUNCTION hash_data
(
    in_data IN RAW,
    numbytes IN NUMBER DEFAULT 128
)
RETURN RAW
IS
    hashed_data RAW(32);
BEGIN
    IF numbytes = 128 OR numbytes = 16 THEN
        hashed_data := dbms_crypto.hash(in_data, dbms_crypto.hash_md5);
    ELSE IF numbytes = 256 OR numbytes = 32 THEN
        hashed_data := dbms_crypto.hash(in_data, dbms_crypto.hash_sh256);
    return hashed_data;
    END IF;
    END IF;
END;

/*-------------------------------------------------------------------------------------------
    Mã hóa thông tin ứng cử viên trên phiếu bầu
*/-------------------------------------------------------------------------------------------
--Tạo table key_store để chứa khóa
CREATE TABLE KEY_STORE 
(
  ID VARCHAR2(10) NOT NULL 
, VALUE RAW(2000) 
, BYTE_NUM NUMBER 
)   
TABLESPACE BINHBAU;

--Tạo một khóa ngẫu nhiên 16 bytes
INSERT INTO KEY_STORE
    VALUES (1,dbms_crypto.randombytes(16),16);
    
--Trigger mã hóa thông tin UCV được thêm vào phiếu bầu
create or replace TRIGGER alter_phieubau_trigger
    BEFORE UPDATE OR INSERT ON PHIEUBAU 
    FOR EACH ROW
declare
    ciphertext RAW(2000);
    current_user VARCHAR(50);
    m_key RAW(32);
BEGIN
    select KEY_STORE.value 
        into m_key 
        from KEY_STORE 
        where ID = '1';
        
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
END;

INSERT INTO PHIEUBAU
    VALUES ('1','TDA01','Jacquenetta Jenoure','Annabel Dunlop','Gisele Grice');
    
SELECT * FROM PHIEUBAU;

--Tạo function để lấy thông tin phiếu bầu
create or replace TYPE PHIEUBAU_TYPE
AS OBJECT (
    UCV1 VARCHAR2(100),
    UCV2 VARCHAR2(100),
    UCV3 VARCHAR2(100),
);

create or replace TYPE PHIEUBAU_TABLE
AS TABLE OF PHIEUBAU_TYPE;

CREATE OR REPLACE FUNCTION QUERY_UNGVIEN 
RETURN PHIEUBAU_TABLE 
PIPELINED
AS
    plaintext VARCHAR2(100);
    ciphertext RAW(2000);
    m_key RAW(32);
    curr_user VARCHAR2(128);
    user_role VARCHAR2(128);
BEGIN
    curr_user := SYS_CONTEXT('userenv','SESSION_USER');
    select granted_role into user_role 
        from BINHBAU_USER_ROLES 
        where grantee = curr_user AND granted_role != 'NHANVIEN';
        exception
        when NO_DATA_FOUND then
            user_role := '';
    IF user_role = 'THEODOIKQ' THEN
        --select key
        select KEY_STORE.value 
            into m_key 
            from KEY_STORE 
            where ID = '1';
        --decrypt UCV1
        
        FOR pb IN (select UCV1, UCV2, UCV3 from PHIEUBAU)
        LOOP
            pb.UCV1 := UTL_RAW.CAST_TO_NUMBER(decrypt_data_AES128(UTL_I18N.STRING_TO_RAW(pb.UCV1),m_key));
            dbms_output.put_line('Ung cu vien 1: ' || plaintext);
            --decrypt UCV2
            pb.UCV2 := UTL_RAW.CAST_TO_NUMBER(decrypt_data_AES128(UTL_I18N.STRING_TO_RAW(pb.UCV2),m_key));
            dbms_output.put_line('Ung cu vien 2: ' || plaintext);
            --decrypt UCV3
            pb.UCV3 := UTL_RAW.CAST_TO_NUMBER(decrypt_data_AES128(UTL_I18N.STRING_TO_RAW(pb.UCV3),m_key));
            dbms_output.put_line('Ung cu vien 3: ' || plaintext);
            
            PIPE ROW (PHIEUBAU_TYPE(pb.UCV1,pb.UCV2,pb.UCV3));
        END LOOP;
    ELSE
        raise_application_error(-20000,'User authority level is not sufficient');
    END IF;
END;

--Cho phép người dùng THEODOIKQ sử dụng function decrypt
create or replace trigger capquyen_mahoa_phieubau 
    AFTER INSERT ON THEODOI
    FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
    stm varchar2(100);
BEGIN
    stm := 'GRANT EXECUTE ON QUANTRI.QUERY_UNGVIEN TO "' || :new.ma_theodoi || '"';
    execute immediate stm;
    commit;
END capquyen_mahoa_phieubau;

select * from table(query_ungvien());