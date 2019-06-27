/*--------------------------------------------------------------------------------
    Tạo các bảng dữ liệu cho cơ sở dữ liệu bình bầu
*/--------------------------------------------------------------------------------

Create table CHINHANH
(
    MA_CHINHANH varchar2(20) NOT NULL,
    TenChiNhanh varchar2(50),
    CONSTRAINT PK_ChiNhanh PRIMARY KEY (MA_CHINHANH)  
);

Create table DONVI
(
    MA_DONVI varchar2(20) NOT NULL,
    TENDONVI varchar2(50),
    TRUONGDONVI NUMBER,
    CONSTRAINT PK_DonVi PRIMARY KEY (MA_DONVI)
);

Create table THANHVIEN
(
    MA_THANHVIEN NUMBER GENERATED BY DEFAULT AS IDENTITY START WITH 1000,
    HOTEN varchar2(50),
    GIOITINH varchar2(3),
    QUEQUAN varchar2(100),
    NAMSINH VARCHAR2(4),
    QUOCTICH VARCHAR2(20),
    DIACHI VARCHAR(100),
    DONVI varchar2(20),
    CHINHANH varchar2(20),
    LUONG float(10),
    CONGTAC NUMBER(1,0) DEFAULT 0,
    TAMNGHI NUMBER(1,0) DEFAULT 0,
    CONSTRAINT PK_ThanhVien PRIMARY KEY (MA_THANHVIEN)
);

Create table BTC
(
    MA_BTC NUMBER,
    HOTEN varchar2(50),
    NAMSINH VARCHAR2(4),
    GIOITINH varchar2(3),
    CONSTRAINT PK_BTC PRIMARY KEY (MA_BTC)
);

Create table TO_LAP
(
    MA_TOLAP NUMBER,
    HOTEN varchar2(50),
    NAMSINH VARCHAR2(4),
    GIOITINH varchar2(3),
    DONVI varchar2(20),
    CONSTRAINT PK_TO_LAP PRIMARY KEY (MA_TOLAP )
    
);

Create table GIAMSAT
(
    MA_GIAMSAT NUMBER,
    HOTEN varchar2(50),
    NAMSINH VARCHAR2(4),
    GIOITINH varchar2(3),
    CONSTRAINT PK_GIAMSAT PRIMARY KEY (MA_GIAMSAT )
);

Create table UNGCUVIEN
(
    MA_UCV NUMBER,
    HOTEN varchar2(50),
    NAMSINH VARCHAR2(4),
    DONVI varchar2(20),
    CONSTRAINT PK_UNGCUVIEN PRIMARY KEY (MA_UCV )
);

Create table THEODOI
(
    MA_THEODOI NUMBER,
    HOTEN varchar2(50),
    NAMSINH VARCHAR2(4),
    GIOITINH varchar2(3),
    CONSTRAINT PK_THEODOI PRIMARY KEY (MA_THEODOI )
);

Create table THONGBAO
(
    MA_NOIDUNG varchar2(20) NOT NULL,
    NOIDUNG varchar2(100),
    LOAITB VARCHAR2(4),
    COLUMN_OLS varchar2(3),
    CONSTRAINT PK_THONGBAO PRIMARY KEY (MA_NOIDUNG )
);

Create table PHIEUBAU
(
    MA_PHIEUBAU NUMBER GENERATED BY DEFAULT AS IDENTITY,
    MA_THANHVIEN NUMBER,
    UCV1 NUMBER,
    UCV2 NUMBER,
    UCV3 NUMBER,
    CONSTRAINT PK_PHIEUBAU PRIMARY KEY (MA_PHIEUBAU,MA_THANHVIEN )
);

/*------------------------------------------------------------------------
    Tạo khóa ngoại
*/------------------------------------------------------------------------

ALTER TABLE DONVI
ADD CONSTRAINT FK_Donvi_Thanhvien
FOREIGN KEY (TRUONGDONVI) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE THANHVIEN
ADD CONSTRAINT FK_ThanhVien_DonVi
FOREIGN KEY (DONVI) REFERENCES DONVI(MA_DONVI);

ALTER TABLE THANHVIEN
ADD CONSTRAINT FK_ThanhVien_ChiNhanh
FOREIGN KEY (CHINHANH) REFERENCES CHINHANH(MA_CHINHANH);

ALTER TABLE BTC
ADD CONSTRAINT FK_BTC_THANHVIEN
FOREIGN KEY (MA_BTC) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE TO_LAP
ADD CONSTRAINT FK_TOLAP_THANHVIEN
FOREIGN KEY (MA_TOLAP) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE TO_LAP
ADD CONSTRAINT FK_TOLAP_DONVI
FOREIGN KEY (DONVI) REFERENCES DONVI(MA_DONVI);

ALTER TABLE GIAMSAT
ADD CONSTRAINT FK_GIAMSAT_THANHVIEN
FOREIGN KEY (MA_GIAMSAT) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE UNGCUVIEN
ADD CONSTRAINT FK_UNGCUVIEN_DONVI
FOREIGN KEY (DONVI) REFERENCES DONVI(MA_DONVI);

ALTER TABLE UNGCUVIEN
ADD CONSTRAINT FK_UNGCUVIEN_THANHVIEN
FOREIGN KEY (MA_UCV) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE THEODOI
ADD CONSTRAINT FK_THEODOI_THANHVIEN
FOREIGN KEY (MA_THEODOI) REFERENCES THANHVIEN(MA_THANHVIEN);

ALTER TABLE PHIEUBAU
ADD CONSTRAINT FK_PHIEUBAU_THANHVIEN
FOREIGN KEY (MA_THANHVIEN) REFERENCES THANHVIEN(MA_THANHVIEN);
