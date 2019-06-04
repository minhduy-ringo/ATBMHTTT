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