/*Encrypt data function
Parameter : IN raw plain text data, raw key (opt)
            OUT raw encrypted data
Call: encrypt_data(   in_data => raw_data,
                      in_key  => raw_key
                  )
*/
create or replace FUNCTION encrypt_data
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

--Trigger fire when UPDATE or INSERT into table PHIEUBAU
create or replace TRIGGER alter_phieubau_trigger
    BEFORE UPDATE OR INSERT ON PHIEUBAU 
    FOR EACH ROW
declare
    encrypted_data RAW(2000);
    m_key RAW(16);
BEGIN
    --select password into m_key from sys.user$ where name = 'QLBINHBAU';
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV1,'AL32UTF8'));
    :new.UCV1 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV2,'AL32UTF8'));
    :new.UCV2 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV3,'AL32UTF8'));
    :new.UCV3 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
END;

/*Decrypt data function
Parameter : IN raw cypher text data, raw key (opt)
            OUT raw plain text data
Call: decrypt_data( in_data => raw_data,
                    in_key  => raw_key
                   )
*/
create or replace function decrypt_data
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