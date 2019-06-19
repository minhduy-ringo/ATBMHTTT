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
--CREATE USER NV
--    IDENTIFIED BY "123456"
--    DEFAULT TABLESPACE BINHBAU;
--GRANT NHANVIEN TO NV;
--DROP USER NV;

/*------------------------------------------------------------------------
    Trigger và procedure để tạo user connection khi thêm 1 hàng vào bảng THANHVIEN
*/------------------------------------------------------------------------

create or replace PROCEDURE TAO_USER(
    mathanhvien IN NUMBER
)
IS
    default_pw NUMBER := '123456';
    lv_stmt varchar2(1000);
BEGIN
    lv_stmt := 'CREATE USER "' || mathanhvien || '" IDENTIFIED BY ' || default_pw || ' DEFAULT TABLESPACE BINHBAU';
    EXECUTE IMMEDIATE (lv_stmt);
    dbms_output.put_line(lv_stmt);

    --Cấp quyền cho cơ bản là NHANVIEN cho user
    lv_stmt := 'GRANT NHANVIEN TO "' || mathanhvien || '"';
    EXECUTE IMMEDIATE (lv_stmt);
    dbms_output.put_line(lv_stmt);
END TAO_USER;

CREATE OR REPLACE TRIGGER TAO_CONNECTION
    BEFORE INSERT ON THANHVIEN
    FOR EACH ROW
DECLARE
    nam_gia_nhap NUMBER;
BEGIN
    select substr(to_char(sysdate, 'YYYY'),-3) into nam_gia_nhap from dual;
    select nam_gia_nhap || :new.ma_thanhvien into :new.ma_thanhvien from dual;
    TAO_USER(:new.ma_thanhvien);
END TAO_CONNECTION;