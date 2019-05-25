/*Encrypt data procedure
Parameter : IN raw data, raw key
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
    m_key RAW(128);
    encrypted_data RAW(2000);
BEGIN
    --Check if user provide a key
    m_key := in_key;
    if m_key = NULL then
        m_key := dbms_crypto.randombytes(128);
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
BEGIN
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV1,'AL32UTF8'));
    :new.UCV1 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV2,'AL32UTF8'));
    :new.UCV2 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
    encrypted_data := encrypt_data(in_data => UTL_I18N.STRING_TO_RAW(:new.UCV3,'AL32UTF8'));
    :new.UCV3 := UTL_RAW.CAST_TO_VARCHAR2(encrypted_data);
END;