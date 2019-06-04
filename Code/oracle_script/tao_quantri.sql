--Chuyển vào 1 pluggable database (ORCLPDB) để tạo local user
ALTER SESSION SET CONTAINER = ORCLPDB;

/*------------------------------------------------------------------------
    Tạo tablespace cho cơ sở dữ liệu bình bầu trong database
*/------------------------------------------------------------------------
CREATE TABLESPACE BINHBAU
    DATAFILE 'BINH_BAU.dat'
        SIZE 20M
    ONLINE;
--DROP TABLESPACE BINHBAU INCLUDING CONTENTS AND DATAFILES;

/*------------------------------------------------------------------------
    Tạo user quản trị cơ sở dữ liệu
*/------------------------------------------------------------------------
CREATE USER QUANTRI
    IDENTIFIED BY "123456"
    DEFAULT TABLESPACE BINHBAU
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON BINHBAU;

/*
    Cho phép người dùng QUANTRI: ( trên tablespace BINHBAU )
        +   Tạo session
        +   Tạo user
        +   Tạo role
        +   Quản lý quyền người dùng
*/
GRANT ALL PRIVILEGES TO QUANTRI;

--
GRANT ALL ON sys.dbms_crypto to QUANTRI;
GRANT ALL ON sys.dbms_output to QUANTRI;

--Tạo view cho phép người dùng quản trị xem người dùng có trong hệ thống
CREATE VIEW quantri_nguoidung AS
    SELECT * FROM dba_users WHERE default_tablespace = 'BINHBAU';
GRANT SELECT ON quantri_nguoidung TO QUANTRI;