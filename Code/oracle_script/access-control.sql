/*----------------------------------------------------------------------
    VPD
----------------------------------------------------------------------*/
/*
    Chính sách cho phép :
        TOLAP : chỉ xem được thông tin nhân viên trong đơn vị của mình
        NHANVIEN : chỉ xem được thông tin của bản thân

*/
create or replace FUNCTION f_select_thanhvien_donvi (
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
    
    --Kiểm tra role của người dùng
    FOR rec IN (select granted_role from BINHBAU_USER_ROLES where grantee = m_user)
    LOOP
        --Nếu role TOLAP
--        if rec.granted_role = 'TOLAP' then
--            select DONVI into m_donvi from THANHVIEN where ma_thanhvien = TO_NUMBER('m_user'); 
--            stm := 'DONVI = ' || m_donvi;
--            exit;
--        end if;
        
        --Nếu role khác
        if rec.granted_role = 'NHANVIEN' then
            stm := 'MA_THANHVIEN = ' || m_user;
            exit;
        end if;
    END LOOP;
    return stm;
end;

BEGIN
    dbms_rls.add_policy (
        object_schema   => 'QUANTRI',
        object_name     => 'THANHVIEN',
        policy_name     => 'Xem_thanhvien_donvi',
        function_schema => 'QUANTRI',
        policy_function => 'f_select_thanhvien_donvi',
        statement_types => 'select'
    );
END;

begin 
    DBMS_RLS.ENABLE_POLICY(
        'QUANTRI',
        'THANHVIEN',
        'Xem_thanhvien_donvi',
        true
    );
end;

/*----------------------------------------------------------------------
    OLS
----------------------------------------------------------------------*/
            
