--Dùng để gán quyền cho user QUANTRI để tạo view trong QUANTRI schema
--hoặc có thể dùng lệnh ở tạo view bên dưới với sysdba
--alter session set container = orclpdb;
--
--grant SELECT on cdb_roles to QUANTRI;
--grant SELECT on cdb_role_privs to QUANTRI;
--grant SELECT on cdb_users to QUANTRI;

--Xem các role có trong CSDL bình bầu
create or replace view binhbau_roles as
select role_id, role, con_id 
    from containers(cdb_roles) 
    where role in (
        select granted_role 
            from containers(cdb_role_privs) 
            where grantee IN (
                select username 
                from containers(cdb_users) 
                where default_tablespace = 'BINHBAU')) 
    order by role_id;

--Xem role của các user
create or replace view binhbau_user_roles as
select grantee,granted_role,admin_option,con_id 
    from cdb_role_privs 
    where grantee IN (
        select username 
        from cdb_users 
        where default_tablespace = 'BINHBAU')
    order by grantee;
