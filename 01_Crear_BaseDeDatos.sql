/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 01_Crear_BaseDeDatos.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Crea desde cero la estructura relacional de la Agencia SantaFe.
    El modelo se diseña para soportar las 20 consultas solicitadas en clase,
    ventas de vehículos nuevos y seminuevos, financiamientos bancarios,
    pólizas anuales, renovaciones y servicios de mantenimiento/reparación.
************************************************************************************************/

USE master;
GO

IF DB_ID('AgenciaSantaFe') IS NOT NULL
BEGIN
    ALTER DATABASE AgenciaSantaFe SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE AgenciaSantaFe;
END;
GO

CREATE DATABASE AgenciaSantaFe;
GO

USE AgenciaSantaFe;
GO

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

/*==============================================================================================
  01. CATÁLOGO: ESTADO
==============================================================================================*/
CREATE TABLE Estado
(
    id_estado       INT IDENTITY(1,1) NOT NULL,
    nombre          VARCHAR(80) NOT NULL,
    abreviatura     VARCHAR(10) NULL,
    CONSTRAINT PK_Estado PRIMARY KEY (id_estado),
    CONSTRAINT UQ_Estado_Nombre UNIQUE (nombre),
    CONSTRAINT UQ_Estado_Abreviatura UNIQUE (abreviatura)
);
GO

/*==============================================================================================
  02. CATÁLOGO: MUNICIPIO
==============================================================================================*/
CREATE TABLE Municipio
(
    id_municipio   INT IDENTITY(1,1) NOT NULL,
    id_estado      INT NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Municipio PRIMARY KEY (id_municipio),
    CONSTRAINT UQ_Municipio_Estado_Nombre UNIQUE (id_estado, nombre),
    CONSTRAINT FK_Municipio_Estado FOREIGN KEY (id_estado)
        REFERENCES Estado(id_estado)
);
GO

/*==============================================================================================
  03. CATÁLOGO: GÉNERO
==============================================================================================*/
CREATE TABLE Genero
(
    id_genero      INT IDENTITY(1,1) NOT NULL,
    nombre         VARCHAR(30) NOT NULL,
    CONSTRAINT PK_Genero PRIMARY KEY (id_genero),
    CONSTRAINT UQ_Genero_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  04. CATÁLOGO: MARCA
==============================================================================================*/
CREATE TABLE Marca
(
    id_marca       INT IDENTITY(1,1) NOT NULL,
    nombre         VARCHAR(60) NOT NULL,
    pais_origen    VARCHAR(60) NULL,
    CONSTRAINT PK_Marca PRIMARY KEY (id_marca),
    CONSTRAINT UQ_Marca_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  05. CATÁLOGO: TIPO DE VEHÍCULO
==============================================================================================*/
CREATE TABLE Tipo_Vehiculo
(
    id_tipo_vehiculo   INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(40) NOT NULL,
    descripcion        VARCHAR(200) NULL,
    CONSTRAINT PK_TipoVehiculo PRIMARY KEY (id_tipo_vehiculo),
    CONSTRAINT UQ_TipoVehiculo_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  06. CATÁLOGO: PUESTO
==============================================================================================*/
CREATE TABLE Puesto
(
    id_puesto       INT IDENTITY(1,1) NOT NULL,
    nombre          VARCHAR(60) NOT NULL,
    salario_base    DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_Puesto PRIMARY KEY (id_puesto),
    CONSTRAINT UQ_Puesto_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Puesto_Salario CHECK (salario_base > 0)
);
GO

/*==============================================================================================
  07. CATÁLOGO: TURNO
==============================================================================================*/
CREATE TABLE Turno
(
    id_turno       INT IDENTITY(1,1) NOT NULL,
    nombre         VARCHAR(30) NOT NULL,
    hora_inicio    TIME NULL,
    hora_fin       TIME NULL,
    CONSTRAINT PK_Turno PRIMARY KEY (id_turno),
    CONSTRAINT UQ_Turno_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Turno_Horas CHECK (hora_inicio IS NULL OR hora_fin IS NULL OR hora_fin > hora_inicio)
);
GO

/*==============================================================================================
  08. CATÁLOGO: BANCO
==============================================================================================*/
CREATE TABLE Banco
(
    id_banco       INT IDENTITY(1,1) NOT NULL,
    nombre         VARCHAR(80) NOT NULL,
    rfc            VARCHAR(13) NULL,
    telefono       VARCHAR(20) NULL,
    correo         VARCHAR(120) NULL,
    id_estado      INT NOT NULL,
    CONSTRAINT PK_Banco PRIMARY KEY (id_banco),
    CONSTRAINT UQ_Banco_Nombre UNIQUE (nombre),
    CONSTRAINT UQ_Banco_RFC UNIQUE (rfc),
    CONSTRAINT FK_Banco_Estado FOREIGN KEY (id_estado)
        REFERENCES Estado(id_estado)
);
GO

/*==============================================================================================
  09. CATÁLOGO: PROVEEDOR
  El proveedor representa el distribuidor/proveedor de una marca.
==============================================================================================*/
CREATE TABLE Proveedor
(
    id_proveedor       INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(120) NOT NULL,
    ejecutivo          VARCHAR(100) NULL,
    telefono           VARCHAR(20) NULL,
    correo             VARCHAR(120) NULL,
    calle              VARCHAR(120) NULL,
    colonia            VARCHAR(100) NULL,
    id_municipio       INT NOT NULL,
    codigo_postal      CHAR(5) NULL,
    id_marca           INT NOT NULL,
    CONSTRAINT PK_Proveedor PRIMARY KEY (id_proveedor),
    CONSTRAINT UQ_Proveedor_Nombre UNIQUE (nombre),
    CONSTRAINT UQ_Proveedor_Correo UNIQUE (correo),
    CONSTRAINT FK_Proveedor_Municipio FOREIGN KEY (id_municipio)
        REFERENCES Municipio(id_municipio),
    CONSTRAINT FK_Proveedor_Marca FOREIGN KEY (id_marca)
        REFERENCES Marca(id_marca)
);
GO

/*==============================================================================================
  10. CATÁLOGO: ASEGURADORA
==============================================================================================*/
CREATE TABLE Aseguradora
(
    id_aseguradora   INT IDENTITY(1,1) NOT NULL,
    nombre           VARCHAR(100) NOT NULL,
    rfc              VARCHAR(13) NULL,
    telefono         VARCHAR(20) NULL,
    correo           VARCHAR(120) NULL,
    calle            VARCHAR(120) NULL,
    colonia          VARCHAR(100) NULL,
    id_municipio     INT NOT NULL,
    codigo_postal    CHAR(5) NULL,
    ejecutivo        VARCHAR(100) NULL,
    CONSTRAINT PK_Aseguradora PRIMARY KEY (id_aseguradora),
    CONSTRAINT UQ_Aseguradora_Nombre UNIQUE (nombre),
    CONSTRAINT UQ_Aseguradora_RFC UNIQUE (rfc),
    CONSTRAINT FK_Aseguradora_Municipio FOREIGN KEY (id_municipio)
        REFERENCES Municipio(id_municipio)
);
GO

/*==============================================================================================
  11. CATÁLOGO: COBERTURA
==============================================================================================*/
CREATE TABLE Cobertura
(
    id_cobertura       INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(60) NOT NULL,
    descripcion        VARCHAR(300) NULL,
    monto_maximo       DECIMAL(14,2) NULL,
    CONSTRAINT PK_Cobertura PRIMARY KEY (id_cobertura),
    CONSTRAINT UQ_Cobertura_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Cobertura_Monto CHECK (monto_maximo IS NULL OR monto_maximo >= 0)
);
GO

/*==============================================================================================
  12. CATÁLOGO: MÉTODO DE PAGO
==============================================================================================*/
CREATE TABLE Metodo_Pago
(
    id_metodo_pago     INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(50) NOT NULL,
    CONSTRAINT PK_MetodoPago PRIMARY KEY (id_metodo_pago),
    CONSTRAINT UQ_MetodoPago_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  13. CATÁLOGO: TIPO DE SERVICIO
==============================================================================================*/
CREATE TABLE Tipo_Servicio
(
    id_tipo_servicio   INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(60) NOT NULL,
    descripcion        VARCHAR(250) NULL,
    CONSTRAINT PK_TipoServicio PRIMARY KEY (id_tipo_servicio),
    CONSTRAINT UQ_TipoServicio_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  14. CATÁLOGO: EQUIPAMIENTO
==============================================================================================*/
CREATE TABLE Equipamiento
(
    id_equipamiento    INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(100) NOT NULL,
    descripcion        VARCHAR(250) NULL,
    CONSTRAINT PK_Equipamiento PRIMARY KEY (id_equipamiento),
    CONSTRAINT UQ_Equipamiento_Nombre UNIQUE (nombre)
);
GO

/*==============================================================================================
  15. CLIENTE
==============================================================================================*/
CREATE TABLE Cliente
(
    id_cliente         INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(60) NOT NULL,
    ap_paterno         VARCHAR(60) NOT NULL,
    ap_materno         VARCHAR(60) NULL,
    fecha_nacimiento   DATE NOT NULL,
    telefono           VARCHAR(20) NULL,
    correo             VARCHAR(120) NULL,
    rfc                VARCHAR(13) NULL,
    curp               VARCHAR(18) NULL,
    ocupacion          VARCHAR(80) NULL,
    ingresos           DECIMAL(14,2) NOT NULL,
    id_genero          INT NOT NULL,
    id_municipio       INT NOT NULL,
    calle              VARCHAR(120) NULL,
    colonia            VARCHAR(100) NULL,
    codigo_postal      CHAR(5) NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY (id_cliente),
    CONSTRAINT UQ_Cliente_RFC UNIQUE (rfc),
    CONSTRAINT UQ_Cliente_CURP UNIQUE (curp),
    CONSTRAINT UQ_Cliente_Correo UNIQUE (correo),
    CONSTRAINT CK_Cliente_Ingresos CHECK (ingresos >= 0),
    CONSTRAINT FK_Cliente_Genero FOREIGN KEY (id_genero)
        REFERENCES Genero(id_genero),
    CONSTRAINT FK_Cliente_Municipio FOREIGN KEY (id_municipio)
        REFERENCES Municipio(id_municipio)
);
GO

/*==============================================================================================
  16. EMPLEADO
  salario_neto se deja calculado a partir de salario_bruto e ISR.
==============================================================================================*/
CREATE TABLE Empleado
(
    id_empleado        INT IDENTITY(1,1) NOT NULL,
    nombre             VARCHAR(60) NOT NULL,
    ap_paterno         VARCHAR(60) NOT NULL,
    ap_materno         VARCHAR(60) NULL,
    fecha_nacimiento   DATE NOT NULL,
    telefono           VARCHAR(20) NULL,
    correo             VARCHAR(120) NULL,
    rfc                VARCHAR(13) NOT NULL,
    curp               VARCHAR(18) NOT NULL,
    calle              VARCHAR(120) NULL,
    colonia            VARCHAR(100) NULL,
    id_municipio       INT NOT NULL,
    codigo_postal      CHAR(5) NULL,
    fecha_ingreso      DATE NOT NULL,
    salario_bruto      DECIMAL(12,2) NOT NULL,
    porcentaje_isr     DECIMAL(5,2) NOT NULL DEFAULT 16.00,
    isr                AS CAST(salario_bruto * (porcentaje_isr / 100.0) AS DECIMAL(12,2)) PERSISTED,
    salario_neto       AS CAST(salario_bruto - (salario_bruto * (porcentaje_isr / 100.0)) AS DECIMAL(12,2)) PERSISTED,
    id_genero          INT NOT NULL,
    id_puesto          INT NOT NULL,
    id_turno           INT NOT NULL,
    CONSTRAINT PK_Empleado PRIMARY KEY (id_empleado),
    CONSTRAINT UQ_Empleado_RFC UNIQUE (rfc),
    CONSTRAINT UQ_Empleado_CURP UNIQUE (curp),
    CONSTRAINT UQ_Empleado_Correo UNIQUE (correo),
    CONSTRAINT CK_Empleado_Salario CHECK (salario_bruto > 0),
    CONSTRAINT CK_Empleado_ISR CHECK (porcentaje_isr >= 0 AND porcentaje_isr <= 50),
    CONSTRAINT FK_Empleado_Genero FOREIGN KEY (id_genero)
        REFERENCES Genero(id_genero),
    CONSTRAINT FK_Empleado_Municipio FOREIGN KEY (id_municipio)
        REFERENCES Municipio(id_municipio),
    CONSTRAINT FK_Empleado_Puesto FOREIGN KEY (id_puesto)
        REFERENCES Puesto(id_puesto),
    CONSTRAINT FK_Empleado_Turno FOREIGN KEY (id_turno)
        REFERENCES Turno(id_turno)
);
GO

/*==============================================================================================
  17. MODELO DE AUTOMÓVIL
==============================================================================================*/
CREATE TABLE Modelo_Automovil
(
    id_modelo            INT IDENTITY(1,1) NOT NULL,
    nombre                VARCHAR(80) NOT NULL,
    version               VARCHAR(80) NULL,
    descripcion           VARCHAR(300) NULL,
    anio                  SMALLINT NOT NULL,
    precio_contado       DECIMAL(14,2) NOT NULL,
    precio_financiamiento DECIMAL(14,2) NOT NULL,
    existencias           INT NOT NULL DEFAULT 0,
    id_marca              INT NOT NULL,
    id_tipo_vehiculo      INT NOT NULL,
    id_proveedor          INT NOT NULL,
    CONSTRAINT PK_ModeloAutomovil PRIMARY KEY (id_modelo),
    CONSTRAINT CK_Modelo_Anio CHECK (anio BETWEEN 2000 AND 2100),
    CONSTRAINT CK_Modelo_PrecioContado CHECK (precio_contado > 0),
    CONSTRAINT CK_Modelo_PrecioFin CHECK (precio_financiamiento > 0),
    CONSTRAINT CK_Modelo_Existencias CHECK (existencias >= 0),
    CONSTRAINT FK_Modelo_Marca FOREIGN KEY (id_marca)
        REFERENCES Marca(id_marca),
    CONSTRAINT FK_Modelo_Tipo FOREIGN KEY (id_tipo_vehiculo)
        REFERENCES Tipo_Vehiculo(id_tipo_vehiculo),
    CONSTRAINT FK_Modelo_Proveedor FOREIGN KEY (id_proveedor)
        REFERENCES Proveedor(id_proveedor)
);
GO

/*==============================================================================================
  18. MODELO - EQUIPAMIENTO
==============================================================================================*/
CREATE TABLE Modelo_Equipamiento
(
    id_modelo         INT NOT NULL,
    id_equipamiento   INT NOT NULL,
    CONSTRAINT PK_ModeloEquipamiento PRIMARY KEY (id_modelo, id_equipamiento),
    CONSTRAINT FK_ME_Modelo FOREIGN KEY (id_modelo)
        REFERENCES Modelo_Automovil(id_modelo) ON DELETE CASCADE,
    CONSTRAINT FK_ME_Equipamiento FOREIGN KEY (id_equipamiento)
        REFERENCES Equipamiento(id_equipamiento) ON DELETE CASCADE
);
GO

/*==============================================================================================
  19. AUTOMÓVIL - UNIDAD FÍSICA
==============================================================================================*/
CREATE TABLE Automovil
(
    id_automovil           INT IDENTITY(1,1) NOT NULL,
    codigo                 VARCHAR(20) NOT NULL,
    numero_serie           VARCHAR(30) NOT NULL,
    vin                    VARCHAR(30) NOT NULL,
    numero_motor           VARCHAR(30) NOT NULL,
    placas                 VARCHAR(15) NULL,
    color                  VARCHAR(30) NOT NULL,
    transmision            VARCHAR(20) NOT NULL,
    condicion              VARCHAR(20) NOT NULL,
    kilometraje            INT NOT NULL DEFAULT 0,
    estado_inventario      VARCHAR(30) NOT NULL DEFAULT 'Disponible',
    fecha_ingreso_agencia  DATE NOT NULL,
    meses_garantia         INT NOT NULL DEFAULT 36,
    id_modelo              INT NOT NULL,
    CONSTRAINT PK_Automovil PRIMARY KEY (id_automovil),
    CONSTRAINT UQ_Automovil_Codigo UNIQUE (codigo),
    CONSTRAINT UQ_Automovil_Serie UNIQUE (numero_serie),
    CONSTRAINT UQ_Automovil_VIN UNIQUE (vin),
    CONSTRAINT UQ_Automovil_Motor UNIQUE (numero_motor),
    CONSTRAINT CK_Automovil_Transmision CHECK (transmision IN ('Manual','Automatica')),
    CONSTRAINT CK_Automovil_Condicion CHECK (condicion IN ('Nuevo','Seminuevo')),
    CONSTRAINT CK_Automovil_Estado CHECK (estado_inventario IN ('Disponible','Apartado','Vendido','Servicio','Baja')),
    CONSTRAINT CK_Automovil_Kilometraje CHECK (kilometraje >= 0),
    CONSTRAINT CK_Automovil_Garantia CHECK (meses_garantia >= 0),
    CONSTRAINT FK_Automovil_Modelo FOREIGN KEY (id_modelo)
        REFERENCES Modelo_Automovil(id_modelo)
);
GO

/*==============================================================================================
  20. VENTA
==============================================================================================*/
CREATE TABLE Venta
(
    id_venta         INT IDENTITY(1,1) NOT NULL,
    folio            VARCHAR(25) NOT NULL,
    fecha_venta      DATE NOT NULL,
    precio_pactado   DECIMAL(14,2) NOT NULL,
    descuento        DECIMAL(14,2) NOT NULL DEFAULT 0,
    subtotal         AS CAST(precio_pactado - descuento AS DECIMAL(14,2)) PERSISTED,
    iva              AS CAST((precio_pactado - descuento) * 0.16 AS DECIMAL(14,2)) PERSISTED,
    total            AS CAST((precio_pactado - descuento) * 1.16 AS DECIMAL(14,2)) PERSISTED,
    id_cliente       INT NOT NULL,
    id_empleado      INT NOT NULL,
    id_automovil     INT NOT NULL,
    id_metodo_pago   INT NOT NULL,
    CONSTRAINT PK_Venta PRIMARY KEY (id_venta),
    CONSTRAINT UQ_Venta_Folio UNIQUE (folio),
    CONSTRAINT UQ_Venta_Automovil UNIQUE (id_automovil),
    CONSTRAINT CK_Venta_Precio CHECK (precio_pactado > 0),
    CONSTRAINT CK_Venta_Descuento CHECK (descuento >= 0 AND descuento <= precio_pactado),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente),
    CONSTRAINT FK_Venta_Empleado FOREIGN KEY (id_empleado)
        REFERENCES Empleado(id_empleado),
    CONSTRAINT FK_Venta_Automovil FOREIGN KEY (id_automovil)
        REFERENCES Automovil(id_automovil),
    CONSTRAINT FK_Venta_MetodoPago FOREIGN KEY (id_metodo_pago)
        REFERENCES Metodo_Pago(id_metodo_pago)
);
GO

/*==============================================================================================
  21. FINANCIAMIENTO
==============================================================================================*/
CREATE TABLE Financiamiento
(
    id_financiamiento       INT IDENTITY(1,1) NOT NULL,
    id_venta                INT NOT NULL,
    id_banco                INT NOT NULL,
    enganche                DECIMAL(14,2) NOT NULL,
    porcentaje_enganche     DECIMAL(5,2) NOT NULL,
    plazo_meses             INT NOT NULL,
    tasa_anual              DECIMAL(6,3) NOT NULL,
    mensualidad             DECIMAL(14,2) NOT NULL,
    fecha_inicio            DATE NOT NULL,
    fecha_fin               DATE NOT NULL,
    estatus                 VARCHAR(20) NOT NULL DEFAULT 'Activo',
    CONSTRAINT PK_Financiamiento PRIMARY KEY (id_financiamiento),
    CONSTRAINT UQ_Financiamiento_Venta UNIQUE (id_venta),
    CONSTRAINT CK_Fin_Enganche CHECK (enganche >= 0),
    CONSTRAINT CK_Fin_Porcentaje CHECK (porcentaje_enganche BETWEEN 0 AND 100),
    CONSTRAINT CK_Fin_Plazo CHECK (plazo_meses IN (12,24,36,48,60,72)),
    CONSTRAINT CK_Fin_Tasa CHECK (tasa_anual >= 0),
    CONSTRAINT CK_Fin_Mensualidad CHECK (mensualidad > 0),
    CONSTRAINT CK_Fin_Fechas CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT CK_Fin_Estatus CHECK (estatus IN ('Activo','Liquidado','Cancelado')),
    CONSTRAINT FK_Fin_Venta FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta),
    CONSTRAINT FK_Fin_Banco FOREIGN KEY (id_banco)
        REFERENCES Banco(id_banco)
);
GO

/*==============================================================================================
  22. PÓLIZA DE SEGURO
==============================================================================================*/
CREATE TABLE Poliza
(
    id_poliza          INT IDENTITY(1,1) NOT NULL,
    numero_contrato    VARCHAR(30) NOT NULL,
    fecha_inicio       DATE NOT NULL,
    fecha_fin          DATE NOT NULL,
    tipo_poliza        VARCHAR(50) NOT NULL,
    prima_anual        DECIMAL(14,2) NOT NULL,
    estatus             VARCHAR(20) NOT NULL DEFAULT 'Vigente',
    id_venta            INT NOT NULL,
    id_aseguradora     INT NOT NULL,
    CONSTRAINT PK_Poliza PRIMARY KEY (id_poliza),
    CONSTRAINT UQ_Poliza_Contrato UNIQUE (numero_contrato),
    CONSTRAINT UQ_Poliza_Venta UNIQUE (id_venta),
    CONSTRAINT CK_Poliza_Fechas CHECK (fecha_fin > fecha_inicio),
    CONSTRAINT CK_Poliza_Prima CHECK (prima_anual > 0),
    CONSTRAINT CK_Poliza_Estatus CHECK (estatus IN ('Vigente','Renovada','Cancelada','Vencida')),
    CONSTRAINT FK_Poliza_Venta FOREIGN KEY (id_venta)
        REFERENCES Venta(id_venta),
    CONSTRAINT FK_Poliza_Aseguradora FOREIGN KEY (id_aseguradora)
        REFERENCES Aseguradora(id_aseguradora)
);
GO

/*==============================================================================================
  23. PÓLIZA - COBERTURA
==============================================================================================*/
CREATE TABLE Poliza_Cobertura
(
    id_poliza       INT NOT NULL,
    id_cobertura    INT NOT NULL,
    CONSTRAINT PK_PolizaCobertura PRIMARY KEY (id_poliza, id_cobertura),
    CONSTRAINT FK_PC_Poliza FOREIGN KEY (id_poliza)
        REFERENCES Poliza(id_poliza) ON DELETE CASCADE,
    CONSTRAINT FK_PC_Cobertura FOREIGN KEY (id_cobertura)
        REFERENCES Cobertura(id_cobertura) ON DELETE CASCADE
);
GO

/*==============================================================================================
  24. SERVICIO
==============================================================================================*/
CREATE TABLE Servicio
(
    id_servicio             INT IDENTITY(1,1) NOT NULL,
    nombre                  VARCHAR(100) NOT NULL,
    fecha_ingreso           DATE NOT NULL,
    fecha_entrega           DATE NULL,
    costo                   DECIMAL(14,2) NOT NULL,
    iva                     AS CAST(costo * 0.16 AS DECIMAL(14,2)) PERSISTED,
    total                   AS CAST(costo * 1.16 AS DECIMAL(14,2)) PERSISTED,
    kilometraje_ingreso     INT NOT NULL DEFAULT 0,
    observaciones           VARCHAR(350) NULL,
    aplica_garantia         BIT NOT NULL DEFAULT 1,
    id_automovil            INT NOT NULL,
    id_empleado             INT NOT NULL,
    id_tipo_servicio        INT NOT NULL,
    CONSTRAINT PK_Servicio PRIMARY KEY (id_servicio),
    CONSTRAINT CK_Servicio_Costo CHECK (costo >= 0),
    CONSTRAINT CK_Servicio_Km CHECK (kilometraje_ingreso >= 0),
    CONSTRAINT CK_Servicio_Fechas CHECK (fecha_entrega IS NULL OR fecha_entrega >= fecha_ingreso),
    CONSTRAINT FK_Servicio_Automovil FOREIGN KEY (id_automovil)
        REFERENCES Automovil(id_automovil),
    CONSTRAINT FK_Servicio_Empleado FOREIGN KEY (id_empleado)
        REFERENCES Empleado(id_empleado),
    CONSTRAINT FK_Servicio_Tipo FOREIGN KEY (id_tipo_servicio)
        REFERENCES Tipo_Servicio(id_tipo_servicio)
);
GO

/*==============================================================================================
  25. RENOVACIÓN / CANCELACIÓN DE PÓLIZA
==============================================================================================*/
CREATE TABLE Renovacion
(
    id_renovacion     INT IDENTITY(1,1) NOT NULL,
    id_poliza         INT NOT NULL,
    fecha             DATE NOT NULL,
    accion            VARCHAR(20) NOT NULL,
    observaciones     VARCHAR(250) NULL,
    CONSTRAINT PK_Renovacion PRIMARY KEY (id_renovacion),
    CONSTRAINT CK_Renovacion_Accion CHECK (accion IN ('Renovar','Cancelar')),
    CONSTRAINT FK_Renovacion_Poliza FOREIGN KEY (id_poliza)
        REFERENCES Poliza(id_poliza)
);
GO

/*==============================================================================================
  ÍNDICES PRINCIPALES PARA CONSULTAS
==============================================================================================*/
CREATE INDEX IX_Municipio_Estado ON Municipio(id_estado);
CREATE INDEX IX_Proveedor_Municipio ON Proveedor(id_municipio);
CREATE INDEX IX_Proveedor_Marca ON Proveedor(id_marca);
CREATE INDEX IX_Banco_Estado ON Banco(id_estado);
CREATE INDEX IX_Aseguradora_Municipio ON Aseguradora(id_municipio);
CREATE INDEX IX_Cliente_Municipio ON Cliente(id_municipio);
CREATE INDEX IX_Cliente_Ingresos ON Cliente(ingresos);
CREATE INDEX IX_Empleado_Municipio ON Empleado(id_municipio);
CREATE INDEX IX_Empleado_Puesto ON Empleado(id_puesto);
CREATE INDEX IX_Empleado_SalarioBruto ON Empleado(salario_bruto);
CREATE INDEX IX_Modelo_Marca ON Modelo_Automovil(id_marca);
CREATE INDEX IX_Modelo_Tipo ON Modelo_Automovil(id_tipo_vehiculo);
CREATE INDEX IX_Modelo_PrecioContado ON Modelo_Automovil(precio_contado);
CREATE INDEX IX_Modelo_PrecioFinanciamiento ON Modelo_Automovil(precio_financiamiento);
CREATE INDEX IX_Automovil_Modelo ON Automovil(id_modelo);
CREATE INDEX IX_Automovil_Color ON Automovil(color);
CREATE INDEX IX_Automovil_Transmision ON Automovil(transmision);
CREATE INDEX IX_Automovil_Estado ON Automovil(estado_inventario);
CREATE INDEX IX_Venta_Fecha ON Venta(fecha_venta);
CREATE INDEX IX_Venta_Cliente ON Venta(id_cliente);
CREATE INDEX IX_Venta_Empleado ON Venta(id_empleado);
CREATE INDEX IX_Financiamiento_Banco ON Financiamiento(id_banco);
CREATE INDEX IX_Financiamiento_Estatus ON Financiamiento(estatus);
CREATE INDEX IX_Poliza_Estatus ON Poliza(estatus);
CREATE INDEX IX_Poliza_Aseguradora ON Poliza(id_aseguradora);
CREATE INDEX IX_Servicio_FechaIngreso ON Servicio(fecha_ingreso);
CREATE INDEX IX_Servicio_FechaEntrega ON Servicio(fecha_entrega);
CREATE INDEX IX_Servicio_Costo ON Servicio(costo);
CREATE INDEX IX_Servicio_Tipo ON Servicio(id_tipo_servicio);
GO

/*==============================================================================================
  FIN DEL SCRIPT
  La carga de catálogos y datos se realizará en 02_Insertar_Catalogos.sql y
  03_Insertar_Datos.sql para mantener separadas estructura y datos.
==============================================================================================*/
