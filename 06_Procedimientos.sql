/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 06_Procedimientos.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Contiene procedimientos almacenados para registrar clientes, empleados,
    ventas, financiamientos, pólizas, coberturas, servicios y renovaciones.
************************************************************************************************/

USE AgenciaSantaFe;
GO

SET NOCOUNT ON;
GO

/*==============================================================================================
  01. REGISTRAR CLIENTE
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarCliente
    @nombre           VARCHAR(60),
    @ap_paterno       VARCHAR(60),
    @ap_materno       VARCHAR(60) = NULL,
    @fecha_nacimiento DATE,
    @telefono         VARCHAR(20) = NULL,
    @correo           VARCHAR(120) = NULL,
    @rfc              VARCHAR(13) = NULL,
    @curp             VARCHAR(18) = NULL,
    @ocupacion        VARCHAR(80) = NULL,
    @ingresos         DECIMAL(14,2),
    @id_genero        INT,
    @id_municipio     INT,
    @calle            VARCHAR(120) = NULL,
    @colonia          VARCHAR(100) = NULL,
    @codigo_postal    CHAR(5) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO Cliente
        (
            nombre, ap_paterno, ap_materno, fecha_nacimiento, telefono,
            correo, rfc, curp, ocupacion, ingresos, id_genero,
            id_municipio, calle, colonia, codigo_postal
        )
        VALUES
        (
            @nombre, @ap_paterno, @ap_materno, @fecha_nacimiento, @telefono,
            @correo, @rfc, @curp, @ocupacion, @ingresos, @id_genero,
            @id_municipio, @calle, @colonia, @codigo_postal
        );

        SELECT SCOPE_IDENTITY() AS id_cliente;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  02. REGISTRAR EMPLEADO
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarEmpleado
    @nombre           VARCHAR(60),
    @ap_paterno       VARCHAR(60),
    @ap_materno       VARCHAR(60) = NULL,
    @fecha_nacimiento DATE,
    @telefono         VARCHAR(20) = NULL,
    @correo           VARCHAR(120),
    @rfc              VARCHAR(13),
    @curp             VARCHAR(18),
    @calle            VARCHAR(120) = NULL,
    @colonia          VARCHAR(100) = NULL,
    @id_municipio     INT,
    @codigo_postal    CHAR(5) = NULL,
    @fecha_ingreso    DATE,
    @salario_bruto    DECIMAL(12,2),
    @porcentaje_isr   DECIMAL(5,2) = 16.00,
    @id_genero        INT,
    @id_puesto        INT,
    @id_turno         INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        INSERT INTO Empleado
        (
            nombre, ap_paterno, ap_materno, fecha_nacimiento, telefono,
            correo, rfc, curp, calle, colonia, id_municipio, codigo_postal,
            fecha_ingreso, salario_bruto, porcentaje_isr, id_genero,
            id_puesto, id_turno
        )
        VALUES
        (
            @nombre, @ap_paterno, @ap_materno, @fecha_nacimiento, @telefono,
            @correo, @rfc, @curp, @calle, @colonia, @id_municipio, @codigo_postal,
            @fecha_ingreso, @salario_bruto, @porcentaje_isr, @id_genero,
            @id_puesto, @id_turno
        );

        SELECT SCOPE_IDENTITY() AS id_empleado;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  03. REGISTRAR VENTA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarVenta
    @folio          VARCHAR(25),
    @fecha_venta    DATE,
    @precio_pactado DECIMAL(14,2),
    @descuento      DECIMAL(14,2) = 0,
    @id_cliente     INT,
    @id_empleado    INT,
    @id_automovil   INT,
    @id_metodo_pago INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Automovil WHERE id_automovil = @id_automovil)
        BEGIN
            THROW 50001, 'El automóvil indicado no existe.', 1;
        END;

        IF EXISTS (SELECT 1 FROM Automovil WHERE id_automovil = @id_automovil AND estado_inventario = 'Vendido')
        BEGIN
            THROW 50002, 'El automóvil ya fue vendido.', 1;
        END;

        INSERT INTO Venta
        (
            folio, fecha_venta, precio_pactado, descuento,
            id_cliente, id_empleado, id_automovil, id_metodo_pago
        )
        VALUES
        (
            @folio, @fecha_venta, @precio_pactado, @descuento,
            @id_cliente, @id_empleado, @id_automovil, @id_metodo_pago
        );

        UPDATE Automovil
        SET estado_inventario = 'Vendido'
        WHERE id_automovil = @id_automovil;

        SELECT SCOPE_IDENTITY() AS id_venta;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  04. REGISTRAR FINANCIAMIENTO
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarFinanciamiento
    @id_venta            INT,
    @id_banco            INT,
    @enganche            DECIMAL(14,2),
    @porcentaje_enganche DECIMAL(5,2),
    @plazo_meses         INT,
    @tasa_anual          DECIMAL(6,3),
    @mensualidad         DECIMAL(14,2),
    @fecha_inicio        DATE = NULL,
    @estatus             VARCHAR(20) = 'Activo'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_ini DATE = COALESCE(@fecha_inicio, CAST(GETDATE() AS DATE));
    DECLARE @fecha_fin DATE = DATEADD(MONTH, @plazo_meses, @fecha_ini);

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Venta WHERE id_venta = @id_venta)
        BEGIN
            THROW 50011, 'La venta indicada no existe.', 1;
        END;

        IF EXISTS (SELECT 1 FROM Financiamiento WHERE id_venta = @id_venta)
        BEGIN
            THROW 50012, 'La venta ya tiene un financiamiento registrado.', 1;
        END;

        INSERT INTO Financiamiento
        (
            id_venta, id_banco, enganche, porcentaje_enganche,
            plazo_meses, tasa_anual, mensualidad,
            fecha_inicio, fecha_fin, estatus
        )
        VALUES
        (
            @id_venta, @id_banco, @enganche, @porcentaje_enganche,
            @plazo_meses, @tasa_anual, @mensualidad,
            @fecha_ini, @fecha_fin, @estatus
        );

        SELECT SCOPE_IDENTITY() AS id_financiamiento;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  05. REGISTRAR PÓLIZA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarPoliza
    @numero_contrato VARCHAR(30),
    @fecha_inicio    DATE,
    @tipo_poliza     VARCHAR(50),
    @prima_anual     DECIMAL(14,2),
    @id_venta        INT,
    @id_aseguradora  INT,
    @estatus         VARCHAR(20) = 'Vigente'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_fin DATE = DATEADD(YEAR, 1, @fecha_inicio);

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Venta WHERE id_venta = @id_venta)
        BEGIN
            THROW 50021, 'La venta indicada no existe.', 1;
        END;

        IF EXISTS (SELECT 1 FROM Poliza WHERE id_venta = @id_venta)
        BEGIN
            THROW 50022, 'La venta ya tiene una póliza registrada.', 1;
        END;

        INSERT INTO Poliza
        (
            numero_contrato, fecha_inicio, fecha_fin, tipo_poliza,
            prima_anual, estatus, id_venta, id_aseguradora
        )
        VALUES
        (
            @numero_contrato, @fecha_inicio, @fecha_fin, @tipo_poliza,
            @prima_anual, @estatus, @id_venta, @id_aseguradora
        );

        SELECT SCOPE_IDENTITY() AS id_poliza;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  06. ASIGNAR COBERTURA A PÓLIZA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_AsignarCoberturaPoliza
    @id_poliza    INT,
    @id_cobertura INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Poliza WHERE id_poliza = @id_poliza)
        BEGIN
            THROW 50031, 'La póliza indicada no existe.', 1;
        END;

        IF NOT EXISTS (SELECT 1 FROM Cobertura WHERE id_cobertura = @id_cobertura)
        BEGIN
            THROW 50032, 'La cobertura indicada no existe.', 1;
        END;

        IF EXISTS (
            SELECT 1 FROM Poliza_Cobertura
            WHERE id_poliza = @id_poliza AND id_cobertura = @id_cobertura
        )
        BEGIN
            THROW 50033, 'La cobertura ya está asignada a la póliza.', 1;
        END;

        INSERT INTO Poliza_Cobertura (id_poliza, id_cobertura)
        VALUES (@id_poliza, @id_cobertura);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  07. RENOVAR PÓLIZA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RenovarPoliza
    @id_poliza      INT,
    @fecha          DATE = NULL,
    @observaciones  VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_evento DATE = COALESCE(@fecha, CAST(GETDATE() AS DATE));
    DECLARE @nueva_fecha_inicio DATE;
    DECLARE @nueva_fecha_fin DATE;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Poliza WHERE id_poliza = @id_poliza)
        BEGIN
            THROW 50041, 'La póliza indicada no existe.', 1;
        END;

        SELECT @nueva_fecha_inicio = DATEADD(DAY, 1, fecha_fin)
        FROM Poliza
        WHERE id_poliza = @id_poliza;

        SET @nueva_fecha_fin = DATEADD(YEAR, 1, @nueva_fecha_inicio);

        UPDATE Poliza
        SET fecha_inicio = @nueva_fecha_inicio,
            fecha_fin = @nueva_fecha_fin,
            estatus = 'Renovada'
        WHERE id_poliza = @id_poliza;

        INSERT INTO Renovacion (id_poliza, fecha, accion, observaciones)
        VALUES (@id_poliza, @fecha_evento, 'Renovar', @observaciones);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  08. CANCELAR PÓLIZA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_CancelarPoliza
    @id_poliza      INT,
    @fecha          DATE = NULL,
    @observaciones  VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fecha_evento DATE = COALESCE(@fecha, CAST(GETDATE() AS DATE));

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Poliza WHERE id_poliza = @id_poliza)
        BEGIN
            THROW 50051, 'La póliza indicada no existe.', 1;
        END;

        UPDATE Poliza
        SET estatus = 'Cancelada'
        WHERE id_poliza = @id_poliza;

        INSERT INTO Renovacion (id_poliza, fecha, accion, observaciones)
        VALUES (@id_poliza, @fecha_evento, 'Cancelar', @observaciones);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  09. REGISTRAR SERVICIO
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_RegistrarServicio
    @nombre              VARCHAR(100),
    @fecha_ingreso        DATE,
    @fecha_entrega        DATE = NULL,
    @costo                DECIMAL(14,2),
    @kilometraje_ingreso  INT = 0,
    @observaciones        VARCHAR(350) = NULL,
    @aplica_garantia      BIT = 1,
    @id_automovil         INT,
    @id_empleado          INT,
    @id_tipo_servicio     INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Automovil WHERE id_automovil = @id_automovil)
        BEGIN
            THROW 50061, 'El automóvil indicado no existe.', 1;
        END;

        IF NOT EXISTS (SELECT 1 FROM Empleado WHERE id_empleado = @id_empleado)
        BEGIN
            THROW 50062, 'El empleado indicado no existe.', 1;
        END;

        IF NOT EXISTS (SELECT 1 FROM Tipo_Servicio WHERE id_tipo_servicio = @id_tipo_servicio)
        BEGIN
            THROW 50063, 'El tipo de servicio indicado no existe.', 1;
        END;

        INSERT INTO Servicio
        (
            nombre, fecha_ingreso, fecha_entrega, costo, kilometraje_ingreso,
            observaciones, aplica_garantia, id_automovil, id_empleado, id_tipo_servicio
        )
        VALUES
        (
            @nombre, @fecha_ingreso, @fecha_entrega, @costo, @kilometraje_ingreso,
            @observaciones, @aplica_garantia, @id_automovil, @id_empleado, @id_tipo_servicio
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

/*==============================================================================================
  10. CONSULTAR AUTOS DISPONIBLES
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_ListarAutosDisponibles
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        a.id_automovil,
        a.codigo,
        m.nombre AS marca,
        ma.nombre AS modelo,
        ma.version,
        tv.nombre AS tipo_vehiculo,
        a.color,
        a.transmision,
        a.condicion,
        a.estado_inventario,
        ma.precio_contado,
        ma.precio_financiamiento
    FROM Automovil a
    INNER JOIN Modelo_Automovil ma ON a.id_modelo = ma.id_modelo
    INNER JOIN Marca m ON ma.id_marca = m.id_marca
    INNER JOIN Tipo_Vehiculo tv ON ma.id_tipo_vehiculo = tv.id_tipo_vehiculo
    WHERE a.estado_inventario = 'Disponible'
    ORDER BY m.nombre, ma.nombre, a.codigo;
END;
GO

/*==============================================================================================
  11. CONSULTAR VENTA COMPLETA
==============================================================================================*/
CREATE OR ALTER PROCEDURE usp_ConsultarVentaCompleta
    @id_venta INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        v.id_venta,
        v.folio,
        v.fecha_venta,
        CONCAT(c.nombre,' ',c.ap_paterno,' ',ISNULL(c.ap_materno,'')) AS cliente,
        CONCAT(e.nombre,' ',e.ap_paterno,' ',ISNULL(e.ap_materno,'')) AS empleado,
        m.nombre AS marca,
        ma.nombre AS modelo,
        ma.version,
        a.codigo,
        a.color,
        a.transmision,
        mp.nombre AS metodo_pago,
        v.precio_pactado,
        v.descuento,
        v.subtotal,
        v.iva,
        v.total
    FROM Venta v
    INNER JOIN Cliente c ON v.id_cliente = c.id_cliente
    INNER JOIN Empleado e ON v.id_empleado = e.id_empleado
    INNER JOIN Automovil a ON v.id_automovil = a.id_automovil
    INNER JOIN Modelo_Automovil ma ON a.id_modelo = ma.id_modelo
    INNER JOIN Marca m ON ma.id_marca = m.id_marca
    INNER JOIN Metodo_Pago mp ON v.id_metodo_pago = mp.id_metodo_pago
    WHERE v.id_venta = @id_venta;
END;
GO

/*==============================================================================================
  VALIDACIÓN BÁSICA DE PROCEDIMIENTOS
==============================================================================================*/
SELECT name AS procedimiento
FROM sys.procedures
WHERE name LIKE 'usp_%'
ORDER BY name;
GO

PRINT '06_Procedimientos.sql ejecutado correctamente.';
GO
