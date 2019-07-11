/*------------------------------------------------------------------------
    DAC, RBAC
------------------------------------------------------------------------*/
/*
    Tạo role trong hệ thống
*/
CREATE ROLE NHANVIEN;
CREATE ROLE BTC;
CREATE ROLE TOLAP;
CREATE ROLE THEODOIKQ;
CREATE ROLE GIAMSAT;
CREATE ROLE CUTRI;

/*
    Cấp quyền cho role NHANVIEN
*/
GRANT CREATE SESSION TO NHANVIEN;
GRANT SELECT ON THANHVIEN TO NHANVIEN;

/*
    Cấp quyền cho role CUTRI
*/
GRANT INSERT, UPDATE ON PHIEUBAU TO CUTRI;

/*
    Cấp quyền cho role BTC
*/
GRANT SELECT, INSERT, UPDATE ON UNGCUVIEN TO BTC;
GRANT SELECT, INSERT, UPDATE ON GIAMSAT TO BTC;
GRANT SELECT, INSERT, UPDATE ON TO_LAP TO BTC;
GRANT SELECT, INSERT, UPDATE ON THEODOI TO BTC;

/*
    Cấp quyền cho role TOLAP
*/
GRANT SELECT, UPDATE, INSERT, DELETE on CUTRI TO TOLAP

/*
    Cấp quyền cho role THEODOIKQ
*/
GRANT SELECT ON PHIEUBAU TO THEODOIKQ;
GRANT SELECT ON CUTRI TO THEODOIKQ;
GRANT SELECT ON UNGCUVIEN TO THEODOIKQ;

/*
    Cấp quyền cho role GIAMSAT
*/
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
    VPD
------------------------------------------------------------------------*/
/*
    Chính sách cho phép :
        NHANVIEN : chỉ xem được thông tin của bản thân
*/
create or replace FUNCTION f_select_thanhvien (
p_schema VARCHAR2,
p_obj VARCHAR2
)
Return VARCHAR2
AS
    m_user VARCHAR2(128);
    m_donvi VARCHAR2(20);
    user_role VARCHAR2(128);
    stm VARCHAR2(100);
begin
    select user into m_user from dual;

    --Kiểm tra là QUANTRI hoặc người dùng TOLAP
    select granted_role into user_role from BINHBAU_USER_ROLES where grantee = to_char(m_user) AND granted_role != 'NHANVIEN';
    if user = 'QUANTRI' or user_role = 'TOLAP' then
        return stm := '';
    else
        stm := 'MA_THANHVIEN = ' || m_user;
    end if;

    return stm;
end f_select_thanhvien;

begin dbms_rls.drop_policy('QUANTRI','THANHVIEN','Xem_thanhvien'); end;

BEGIN
    dbms_rls.add_policy (
        object_schema   => 'QUANTRI',
        object_name     => 'THANHVIEN',
        policy_name     => 'Xem_thanhvien',
        function_schema => 'QUANTRI',
        policy_function => 'f_select_thanhvien',
        statement_types => 'select'
    );
END;

begin
DBMS_RLS.ENABLE_POLICY('QUANTRI','THANHVIEN','Xem_thanhvien',true);
end;

/*
    Chính sách cho phép :
        CUTRI : update thông tin phiếu bầu của bản thân
*/
create or replace FUNCTION f_update_cutri_phieubau (
p_schema VARCHAR2,
p_obj VARCHAR2
)
Return VARCHAR2
AS
    m_user VARCHAR2(128);
    stm VARCHAR2(100);
begin
    select user into m_user from dual;
    stm := 'ma_thanhvien = ' || to_char(user);
    return stm;
end f_update_cutri_phieubau;

BEGIN
    dbms_rls.add_policy (
        object_schema   => 'QUANTRI',
        object_name     => 'PHIEUBAU',
        policy_name     => 'Capnhat_phieubau',
        function_schema => 'QUANTRI',
        policy_function => 'f_update_cutri_phieubau',
        statement_types => 'update'
    );
END;

/*------------------------------------------------------------------------
    OLS
------------------------------------------------------------------------*/
--Tạo policy và gán quyền thực thi trên policy
execute sa_sysdba.drop_policy('thanhvien_policy');
execute sa_sysdba.create_policy( 'thanhvien_policy', 'ols_thanhvien' );
grant THANHVIEN_POLICY_DBA to QUANTRI;
--grant THANHVIEN_POLICY_DBA to LBACSYS;

--Tạo thành phần policy
execute sa_components.create_level('thanhvien_policy',10,'NV','NHAN VIEN');
execute sa_components.create_level('thanhvien_policy',20,'TL','TO LAP');
execute sa_components.create_compartment('thanhvien_policy',1,'DV1','DONVI 1');
execute sa_components.create_compartment('thanhvien_policy',2,'DV2','DONVI 2');
execute sa_components.create_compartment('thanhvien_policy',3,'DV3','DONVI 3');
execute sa_components.create_compartment('thanhvien_policy',4,'DV4','DONVI 4');
execute sa_components.create_group('thanhvien_policy',100,'CN1','CHI NHANH 1');
execute sa_components.create_group('thanhvien_policy',200,'CN2','CHI NHANH 2');

--Function tự gán nhãn cho dữ liệu
create or replace function tao_nhan_OLS_thanhvien (
    p_mtv in number,
    p_donvi in varchar2,
    p_chinhanh in varchar2
)
return lbacsys.lbac_label as
    v_label varchar2(100);
    m_donvi varchar(20);
    m_chinhanh varchar(20);
begin 
    FOR u IN (select granted_role from BINHBAU_USER_ROLES where grantee = TO_CHAR(p_mtv))
    LOOP
        if u.granted_role = 'TOLAP' then
            v_label := v_label || 'TL:';
        else
            v_label := 'NV:';
        end if;
    END LOOP;
    
    if p_donvi = '1' then
        v_label := 'DV1:';
    elsif p_donvi = '2' then
        v_label := 'DV2:';
    elsif p_donvi = '3' then
        v_label := 'DV3:';
    else
        v_label := 'DV4:';
    end if;

    if p_chinhanh = '1' then
        v_label := v_label || 'CN1';
    else
        v_label := v_label || 'CN2';
    end if;
    
    return TO_LBAC_DATA_LABEL('thanhvien_policy',v_label);
end tao_nhan_OLS_thanhvien;

BEGIN
    sa_policy_admin.apply_table_policy (
        policy_name     => 'thanhvien_policy',
        schema_name     => 'QUANTRI',
        table_name      => 'THANHVIEN',
        table_options   => 'NO_CONTROL',
        --label_function  => 'QUANTRI.tao_nhan_OLS_thanhvien(:new.ma_thanhvien,:new.donvi,:new_chinhanh)',
        predicate       => NULL
        );
END;    

UPDATE THANHVIEN
    SET ols_thanhvien = char_to_label('thanhvien_policy','DV1');

execute sa_policy_admin.remove_table_policy('thanhvien_policy','QUANTRI','THANHVIEN');
BEGIN
    sa_policy_admin.apply_table_policy (
        policy_name     => 'thanhvien_policy',
        schema_name     => 'QUANTRI',
        table_name      => 'THANHVIEN',
        table_options   => 'READ_CONTROL,WRITE_CONTROL,CHECK_CONTROL',
        label_function  => 'QUANTRI.tao_nhan_thanhvien(:new.ma_thanhvien,:new.donvi,:new_chinhanh)',
        predicate       => NULL
        );
END;


/*----------------------------------------------------------------------
    Procedure và trigger để tự động cập nhật lại role của một user khi thêm một dòng vào 1 trong các bảng
    role (BTC, GIAMSAT, THEODOI, TO_LAP)
    Đồng thời, gọi 1 lệnh update tới bảng thành viên để cập lại label
----------------------------------------------------------------------*/
--Procedure cập nhật role của một user khi user được thêm vào một trong các bảng Role
create or replace procedure capnhat_role (
    p_user in number,
    p_role in VARCHAR2
)
AS
    gr varchar(128);
    stm varchar2(100);
BEGIN
    select granted_role into gr from BINHBAU_USER_ROLES where grantee = TO_CHAR(p_user) AND GRANTED_ROLE != 'NHANVIEN';
    stm := 'REVOKE ' || gr || ' FROM "' || p_user || '"';
    execute immediate stm;

    stm := 'GRANT ' || p_role || ' TO "' || p_user || '"';
    execute immediate stm;
END;

/*
    Các trigger thực hiện khi thêm 1 dòng dữ liệu vào các bảng Role
*/
create or replace trigger them_btc
    AFTER INSERT ON BTC
    FOR EACH ROW
DECLARE    
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    QUANTRI.capnhat_role(:new.ma_btc,'BTC');
--    UPDATE THANHVIEN
--        SET ma_thanhvien = ma_thanhvien WHERE ma_thanhvien = :new.ma_btc;
    COMMIT;
END;

create or replace trigger them_tolap
    AFTER INSERT ON TO_LAP
    FOR EACH ROW
DECLARE    
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    QUANTRI.capnhat_role(:new.ma_tolap,'TOLAP');
--    UPDATE THANHVIEN
--        SET ma_thanhvien = ma_thanhvien WHERE ma_thanhvien = :new.ma_tolap;
    COMMIT;
END;

create or replace trigger them_giamsat
    AFTER INSERT ON GIAMSAT
    FOR EACH ROW
DECLARE    
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    QUANTRI.capnhat_role(:new.ma_giamsat,'GIAMSAT');
--    UPDATE THANHVIEN
--        SET ma_thanhvien = ma_thanhvien WHERE ma_thanhvien = :new.ma_giamsat;
    COMMIT;
END;

create or replace trigger them_theodoi
    AFTER INSERT ON THEODOI
    FOR EACH ROW
DECLARE    
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    QUANTRI.capnhat_role(:new.ma_theodoi,'THEODOIKQ');
--    UPDATE THANHVIEN
--        SET ma_thanhvien = ma_thanhvien WHERE ma_thanhvien = :new.ma_theodoi;
    COMMIT;
END;

create or replace TRIGGER THEM_CUTRI 
    AFTER INSERT ON CUTRI 
    FOR EACH ROW
DECLARE    
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    QUANTRI.capnhat_role(:new.ma_cutri,'CUTRI');
--    UPDATE THANHVIEN
--        SET ma_thanhvien = ma_thanhvien WHERE ma_thanhvien = :new.ma_cutri;
    COMMIT;
END;

