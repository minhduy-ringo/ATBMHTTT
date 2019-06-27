/*------------------------------------------------------------------------
    Tạo role trong hệ thống
*/------------------------------------------------------------------------
CREATE ROLE NHANVIEN;
CREATE ROLE BTC;
CREATE ROLE TOLAP;
CREATE ROLE THEODOIKQ;
CREATE ROLE GIAMSAT;

/*------------------------------------------------------------------------
    Cấp quyền cho role NHANVIEN
*/------------------------------------------------------------------------
GRANT CREATE SESSION TO NHANVIEN;
GRANT SELECT ON THANHVIEN TO NHANVIEN;

/*------------------------------------------------------------------------
    Cấp quyền cho role BTC
*/------------------------------------------------------------------------
GRANT SELECT, INSERT, UPDATE ON UNGCUVIEN TO BTC;
GRANT SELECT, INSERT, UPDATE ON GIAMSAT TO BTC;
GRANT SELECT, INSERT, UPDATE ON TO_LAP TO BTC;
GRANT SELECT, INSERT, UPDATE ON THEODOI TO BTC;

/*------------------------------------------------------------------------
    Cấp quyền cho role TOLAP
*/------------------------------------------------------------------------
GRANT SELECT ON THANHVIEN TO TOLAP
GRANT SELECT, UPDATE on CUTRI TO TOLAP

/*------------------------------------------------------------------------
    Cấp quyền cho role THEODOIKQ
*/------------------------------------------------------------------------
GRANT SELECT ON PHIEUBAU TO THEODOIKQ;
GRANT SELECT ON CUTRI TO THEODOIKQ;
GRANT SELECT ON UNGCUVIEN TO THEODOIKQ;

/*------------------------------------------------------------------------
    Cấp quyền cho role GIAMSAT
*/------------------------------------------------------------------------
GRANT SELECT ON CHINHANH TO GIAMSAT;
GRANT SELECT ON DONVI TO GIAMSAT;
GRANT SELECT ON THANHVIEN TO GIAMSAT;
GRANT SELECT ON BTC TO GIAMSAT;
GRANT SELECT ON TO_LAP TO GIAMSAT;
GRANT SELECT ON GIAMSAT TO GIAMSAT;
GRANT SELECT ON UNGCUVIEN TO GIAMSAT;
GRANT SELECT ON THEODOI TO GIAMSAT;
GRANT SELECT ON THONGBAO TO GIAMSAT;
GRANT SELECT ON PHIEUBAU TO GIAMSAT;
GRANT SELECT ON CUTRI TO GIAMSAT;

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