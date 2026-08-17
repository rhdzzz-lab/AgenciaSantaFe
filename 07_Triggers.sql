/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 07_Triggers.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Triggers de automatización y validación para la Agencia SantaFe.
    Este archivo debe ejecutarse después de crear la base de datos,
    cargar catálogos, cargar datos, vistas y procedimientos.
************************************************************************************************/

USE AgenciaSantaFe;
GO

SET NOCOUNT ON;
GO

/*==============================================================================================
  01. TRIGGER: ACTUALIZAR ESTADO DEL AUTOMÓVIL AL REGISTRAR UNA VENTA
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Venta_ActualizarEstadoAutomovil', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Venta_ActualizarEstadoAutomovil;
GO

CREATE TRIGGER dbo.TRG_Venta_ActualizarEstadoAutomovil
ON dbo.Venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE a
       SET a.estado_inventario = 'Vendido'
    FROM dbo.Automovil a
    INNER JOIN inserted i
        ON i.id_automovil = a.id_automovil;
END;
GO

/*==============================================================================================
  02. TRIGGER: DISMINUIR EXISTENCIAS DEL MODELO AL VENDER UN AUTOMÓVIL
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Venta_DisminuirExistenciasModelo', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Venta_DisminuirExistenciasModelo;
GO

CREATE TRIGGER dbo.TRG_Venta_DisminuirExistenciasModelo
ON dbo.Venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE m
       SET m.existencias = CASE 
                                WHEN m.existencias > 0 THEN m.existencias - 1
                                ELSE 0
                            END
    FROM dbo.Modelo_Automovil m
    INNER JOIN dbo.Automovil a
        ON a.id_modelo = m.id_modelo
    INNER JOIN inserted i
        ON i.id_automovil = a.id_automovil;
END;
GO

/*==============================================================================================
  03. TRIGGER: IMPEDIR VENDER UN AUTOMÓVIL QUE YA FUE VENDIDO
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Venta_BloquearAutomovilVendido', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Venta_BloquearAutomovilVendido;
GO

CREATE TRIGGER dbo.TRG_Venta_BloquearAutomovilVendido
ON dbo.Venta
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Automovil a
            ON a.id_automovil = i.id_automovil
        WHERE a.estado_inventario = 'Vendido'
        AND EXISTS
        (
            SELECT 1
            FROM dbo.Venta v
            WHERE v.id_automovil = i.id_automovil
            AND v.id_venta <> i.id_venta
        )
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'No se puede registrar la venta: el automóvil ya fue vendido.', 1;
    END;
END;
GO

/*==============================================================================================
  04. TRIGGER: VALIDAR GARANTÍA AL REGISTRAR SERVICIO
  El servicio solo se permite mientras el automóvil conserve garantía.
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Servicio_ValidarGarantia', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Servicio_ValidarGarantia;
GO

CREATE TRIGGER dbo.TRG_Servicio_ValidarGarantia
ON dbo.Servicio
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Automovil a
            ON a.id_automovil = i.id_automovil
        WHERE i.fecha_ingreso > DATEADD(MONTH, a.meses_garantia, a.fecha_ingreso_agencia)
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50002, 'No se puede registrar el servicio: el automóvil ya no cuenta con garantía vigente.', 1;
    END;
END;
GO

/*==============================================================================================
  05. TRIGGER: VALIDAR KILOMETRAJE DEL AUTOMÓVIL
  Evita disminuir el kilometraje en una actualización.
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Automovil_ValidarKilometraje', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Automovil_ValidarKilometraje;
GO

CREATE TRIGGER dbo.TRG_Automovil_ValidarKilometraje
ON dbo.Automovil
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d
            ON d.id_automovil = i.id_automovil
        WHERE i.kilometraje < d.kilometraje
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50003, 'No se puede disminuir el kilometraje de un automóvil.', 1;
    END;
END;
GO

/*==============================================================================================
  06. TRIGGER: VALIDAR SALARIO DEL EMPLEADO
  Impide salarios fuera de un rango razonable.
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Empleado_ValidarSalario', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Empleado_ValidarSalario;
GO

CREATE TRIGGER dbo.TRG_Empleado_ValidarSalario
ON dbo.Empleado
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE salario_bruto < 10000 OR salario_bruto > 100000
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50004, 'El salario del empleado debe estar entre 10,000 y 100,000.', 1;
    END;
END;
GO

/*==============================================================================================
  07. TRIGGER: VALIDAR CORREO ÚNICO EN CLIENTE
  Refuerza la unicidad del correo como capa adicional.
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Cliente_ValidarCorreo', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Cliente_ValidarCorreo;
GO

CREATE TRIGGER dbo.TRG_Cliente_ValidarCorreo
ON dbo.Cliente
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM dbo.Cliente c
        INNER JOIN inserted i
            ON i.correo = c.correo
        GROUP BY c.correo
        HAVING COUNT(*) > 1
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50005, 'Ya existe un cliente registrado con ese correo electrónico.', 1;
    END;
END;
GO

/*==============================================================================================
  08. TRIGGER: ACTUALIZAR ESTATUS DE PÓLIZA AL RENOVAR O CANCELAR
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Renovacion_ActualizarPoliza', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Renovacion_ActualizarPoliza;
GO

CREATE TRIGGER dbo.TRG_Renovacion_ActualizarPoliza
ON dbo.Renovacion
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
       SET p.estatus = CASE 
                           WHEN i.accion = 'Renovar' THEN 'Renovada'
                           WHEN i.accion = 'Cancelar' THEN 'Cancelada'
                       END
    FROM dbo.Poliza p
    INNER JOIN inserted i
        ON i.id_poliza = p.id_poliza;
END;
GO

/*==============================================================================================
  09. TRIGGER: GENERAR AUDITORÍA SIMPLE DE SERVICIOS
  Si la tabla de auditoría no existe, este trigger no la usa.
  Se deja preparado el patrón para extenderlo si se agrega una tabla Auditoria_Servicio.
==============================================================================================*/
IF OBJECT_ID('dbo.TRG_Servicio_ValidarFechaEntrega', 'TR') IS NOT NULL
    DROP TRIGGER dbo.TRG_Servicio_ValidarFechaEntrega;
GO

CREATE TRIGGER dbo.TRG_Servicio_ValidarFechaEntrega
ON dbo.Servicio
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE fecha_entrega IS NOT NULL
          AND fecha_entrega < fecha_ingreso
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50006, 'La fecha de entrega no puede ser menor que la fecha de ingreso del servicio.', 1;
    END;
END;
GO

PRINT '07_Triggers.sql ejecutado correctamente.';
GO
