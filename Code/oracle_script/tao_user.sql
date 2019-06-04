/*------------------------------------------------------------------------
    Tạo role trong hệ thống
*/------------------------------------------------------------------------
CREATE ROLE NHANVIEN;
CREATE ROLE BTC;
CREATE ROLE LAPDS;
CREATE ROLE THEODOIKQ;
CREATE ROLE GIAMSAT;

/*------------------------------------------------------------------------
    Cấp quyền cho role nhân viên
*/------------------------------------------------------------------------
GRANT CREATE SESSION TO NHANVIEN;

/*------------------------------------------------------------------------
    Tạo user demo trong hệ thống
*/------------------------------------------------------------------------
CREATE USER NV
    IDENTIFIED BY "123456"
    DEFAULT TABLESPACE BINHBAU;
GRANT NHANVIEN TO NV;