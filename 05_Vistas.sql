/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 05_Vistas.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Vistas útiles para consultar inventario, ventas, clientes, empleados,
    financiamientos, pólizas y servicios.
************************************************************************************************/

USE AgenciaSantaFe;
GO

SET NOCOUNT ON;
GO

/*==============================================================================================
  01. VISTA: AUTOS DISPONIBLES
==============================================================================================*/
CREATE OR ALTER VIEW VW_AutosDisponibles
AS
SELECT
    a.id_automovil,
    a.codigo,
    ma.nombre AS modelo,
    ma.version,
    m.nombre AS marca,
    tv.nombre AS tipo_vehiculo,
    a.color,
    a.transmision,
    a.condicion,
    a.estado_inventario,
    ma.precio_contado,
    ma.precio_financiamiento,
    a.meses_garantia
FROM Automovil a
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Tipo_Vehiculo tv ON tv.id_tipo_vehiculo = ma.id_tipo_vehiculo
WHERE a.estado_inventario = 'Disponible';
GO

/*==============================================================================================
  02. VISTA: AUTOS SEDAN
==============================================================================================*/
CREATE OR ALTER VIEW VW_AutosSedan
AS
SELECT
    a.id_automovil,
    a.codigo,
    ma.nombre AS modelo,
    ma.version,
    m.nombre AS marca,
    a.color,
    a.transmision,
    a.condicion,
    ma.precio_contado,
    ma.precio_financiamiento
FROM Automovil a
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Tipo_Vehiculo tv ON tv.id_tipo_vehiculo = ma.id_tipo_vehiculo
WHERE tv.nombre = 'Sedan';
GO

/*==============================================================================================
  03. VISTA: AUTOS SUV
==============================================================================================*/
CREATE OR ALTER VIEW VW_AutosSUV
AS
SELECT
    a.id_automovil,
    a.codigo,
    ma.nombre AS modelo,
    ma.version,
    m.nombre AS marca,
    a.color,
    a.transmision,
    a.condicion,
    ma.precio_contado,
    ma.precio_financiamiento
FROM Automovil a
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Tipo_Vehiculo tv ON tv.id_tipo_vehiculo = ma.id_tipo_vehiculo
WHERE tv.nombre = 'SUV';
GO

/*==============================================================================================
  04. VISTA: VENTAS COMPLETAS
==============================================================================================*/
CREATE OR ALTER VIEW VW_VentasCompletas
AS
SELECT
    v.id_venta,
    v.folio,
    v.fecha_venta,
    c.id_cliente,
    CONCAT(c.nombre,' ',c.ap_paterno,' ',ISNULL(c.ap_materno,'')) AS cliente,
    e.id_empleado,
    CONCAT(e.nombre,' ',e.ap_paterno,' ',ISNULL(e.ap_materno,'')) AS vendedor,
    a.id_automovil,
    a.codigo,
    m.nombre AS marca,
    ma.nombre AS modelo,
    ma.version,
    a.color,
    a.transmision,
    mp.nombre AS metodo_pago,
    v.precio_pactado,
    v.descuento,
    v.subtotal,
    v.iva,
    v.total
FROM Venta v
INNER JOIN Cliente c ON c.id_cliente = v.id_cliente
INNER JOIN Empleado e ON e.id_empleado = v.id_empleado
INNER JOIN Automovil a ON a.id_automovil = v.id_automovil
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Metodo_Pago mp ON mp.id_metodo_pago = v.id_metodo_pago;
GO

/*==============================================================================================
  05. VISTA: FINANCIAMIENTOS ACTIVOS
==============================================================================================*/
CREATE OR ALTER VIEW VW_FinanciamientosActivos
AS
SELECT
    f.id_financiamiento,
    v.id_venta,
    v.folio,
    v.fecha_venta,
    b.nombre AS banco,
    f.enganche,
    f.porcentaje_enganche,
    f.plazo_meses,
    f.tasa_anual,
    f.mensualidad,
    f.fecha_inicio,
    f.fecha_fin,
    f.estatus
FROM Financiamiento f
INNER JOIN Venta v ON v.id_venta = f.id_venta
INNER JOIN Banco b ON b.id_banco = f.id_banco
WHERE f.estatus = 'Activo';
GO

/*==============================================================================================
  06. VISTA: PÓLIZAS VIGENTES
==============================================================================================*/
CREATE OR ALTER VIEW VW_PolizasVigentes
AS
SELECT
    p.id_poliza,
    p.numero_contrato,
    p.fecha_inicio,
    p.fecha_fin,
    p.tipo_poliza,
    p.prima_anual,
    p.estatus,
    a.nombre AS aseguradora,
    v.id_venta,
    v.folio,
    m.nombre AS marca,
    ma.nombre AS modelo,
    auto.codigo AS codigo_automovil
FROM Poliza p
INNER JOIN Aseguradora a ON a.id_aseguradora = p.id_aseguradora
INNER JOIN Venta v ON v.id_venta = p.id_venta
INNER JOIN Automovil auto ON auto.id_automovil = v.id_automovil
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = auto.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
WHERE p.estatus = 'Vigente';
GO

/*==============================================================================================
  07. VISTA: SERVICIOS DEL MES DE JUNIO
==============================================================================================*/
CREATE OR ALTER VIEW VW_ServiciosJunio
AS
SELECT
    s.id_servicio,
    s.nombre,
    s.fecha_ingreso,
    s.fecha_entrega,
    s.costo,
    s.iva,
    s.total,
    s.kilometraje_ingreso,
    s.observaciones,
    s.aplica_garantia,
    ts.nombre AS tipo_servicio,
    a.codigo AS codigo_automovil,
    m.nombre AS marca,
    ma.nombre AS modelo,
    CONCAT(e.nombre,' ',e.ap_paterno,' ',ISNULL(e.ap_materno,'')) AS empleado
FROM Servicio s
INNER JOIN Tipo_Servicio ts ON ts.id_tipo_servicio = s.id_tipo_servicio
INNER JOIN Automovil a ON a.id_automovil = s.id_automovil
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Empleado e ON e.id_empleado = s.id_empleado
WHERE MONTH(s.fecha_ingreso) = 6;
GO

/*==============================================================================================
  08. VISTA: SERVICIOS ENTREGADOS EN JULIO
==============================================================================================*/
CREATE OR ALTER VIEW VW_ServiciosJulio
AS
SELECT
    s.id_servicio,
    s.nombre,
    s.fecha_ingreso,
    s.fecha_entrega,
    s.costo,
    s.iva,
    s.total,
    s.kilometraje_ingreso,
    s.observaciones,
    s.aplica_garantia,
    ts.nombre AS tipo_servicio,
    a.codigo AS codigo_automovil,
    m.nombre AS marca,
    ma.nombre AS modelo,
    CONCAT(e.nombre,' ',e.ap_paterno,' ',ISNULL(e.ap_materno,'')) AS empleado
FROM Servicio s
INNER JOIN Tipo_Servicio ts ON ts.id_tipo_servicio = s.id_tipo_servicio
INNER JOIN Automovil a ON a.id_automovil = s.id_automovil
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Empleado e ON e.id_empleado = s.id_empleado
WHERE MONTH(s.fecha_entrega) = 7;
GO

/*==============================================================================================
  09. VISTA: EMPLEADOS GERENCIALES
==============================================================================================*/
CREATE OR ALTER VIEW VW_EmpleadosGerenciales
AS
SELECT
    e.id_empleado,
    CONCAT(e.nombre,' ',e.ap_paterno,' ',ISNULL(e.ap_materno,'')) AS empleado,
    g.nombre AS genero,
    e.fecha_nacimiento,
    e.fecha_ingreso,
    e.salario_bruto,
    e.porcentaje_isr,
    e.isr,
    e.salario_neto,
    p.nombre AS puesto,
    t.nombre AS turno,
    e.correo,
    e.telefono,
    mu.nombre AS municipio,
    es.nombre AS estado
FROM Empleado e
INNER JOIN Genero g ON g.id_genero = e.id_genero
INNER JOIN Puesto p ON p.id_puesto = e.id_puesto
INNER JOIN Turno t ON t.id_turno = e.id_turno
INNER JOIN Municipio mu ON mu.id_municipio = e.id_municipio
INNER JOIN Estado es ON es.id_estado = mu.id_estado
WHERE p.nombre LIKE 'Gerente%';
GO

/*==============================================================================================
  10. VISTA: CLIENTES POR UBICACIÓN
==============================================================================================*/
CREATE OR ALTER VIEW VW_ClientesPorUbicacion
AS
SELECT
    c.id_cliente,
    CONCAT(c.nombre,' ',c.ap_paterno,' ',ISNULL(c.ap_materno,'')) AS cliente,
    g.nombre AS genero,
    c.fecha_nacimiento,
    c.ocupacion,
    c.ingresos,
    c.correo,
    c.telefono,
    mu.nombre AS municipio,
    es.nombre AS estado
FROM Cliente c
INNER JOIN Genero g ON g.id_genero = c.id_genero
INNER JOIN Municipio mu ON mu.id_municipio = c.id_municipio
INNER JOIN Estado es ON es.id_estado = mu.id_estado;
GO

/*==============================================================================================
  11. VISTA: INVENTARIO GENERAL
==============================================================================================*/
CREATE OR ALTER VIEW VW_InventarioGeneral
AS
SELECT
    a.id_automovil,
    a.codigo,
    a.numero_serie,
    a.vin,
    a.numero_motor,
    a.placas,
    a.color,
    a.transmision,
    a.condicion,
    a.kilometraje,
    a.estado_inventario,
    a.fecha_ingreso_agencia,
    a.meses_garantia,
    ma.nombre AS modelo,
    ma.version,
    m.nombre AS marca,
    tv.nombre AS tipo_vehiculo,
    ma.precio_contado,
    ma.precio_financiamiento,
    ma.existencias
FROM Automovil a
INNER JOIN Modelo_Automovil ma ON ma.id_modelo = a.id_modelo
INNER JOIN Marca m ON m.id_marca = ma.id_marca
INNER JOIN Tipo_Vehiculo tv ON tv.id_tipo_vehiculo = ma.id_tipo_vehiculo;
GO

/*==============================================================================================
  FIN DEL ARCHIVO
==============================================================================================*/
