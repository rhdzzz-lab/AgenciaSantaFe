/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 04_Consultas.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Consultas solicitadas para la práctica de la Agencia de Autos SantaFe.
    Este archivo debe ejecutarse después de:
      01_Crear_BaseDeDatos.sql
      02_Insertar_Catalogos.sql
      03_Insertar_Datos.sql
************************************************************************************************/

USE AgenciaSantaFe;
GO

SET NOCOUNT ON;
GO

/*==============================================================================================
  01. Mostrar clave, nombre y modelo del automóvil
  Se toma la clave del automóvil, el nombre del modelo y el modelo comercial.
==============================================================================================*/
SELECT
    a.id_automovil AS clave,
    ma.nombre      AS nombre,
    ma.version     AS modelo
FROM Automovil a
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
ORDER BY a.id_automovil;
GO

/*==============================================================================================
  02. Mostrar clave, nombre, marca, modelo y versión del automóvil,
      cuyo precio esté comprendido entre 300,000 y 450,000 y cuya transmisión sea automática
==============================================================================================*/
SELECT
    a.id_automovil AS clave,
    ma.nombre      AS nombre,
    m.nombre       AS marca,
    ma.nombre      AS modelo,
    ma.version     AS version
FROM Automovil a
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
INNER JOIN Marca m
    ON ma.id_marca = m.id_marca
WHERE ma.precio_contado BETWEEN 300000 AND 450000
  AND a.transmision = 'Automatica'
ORDER BY ma.precio_contado;
GO

/*==============================================================================================
  03. Mostrar clave, nombre, marca, color y transmisión de todos aquellos
      que sean transmisión manual de color rojo, negro y azul
==============================================================================================*/
SELECT
    a.id_automovil AS clave,
    ma.nombre      AS nombre,
    m.nombre       AS marca,
    a.color        AS color,
    a.transmision  AS transmision
FROM Automovil a
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
INNER JOIN Marca m
    ON ma.id_marca = m.id_marca
WHERE a.transmision = 'Manual'
  AND a.color IN ('Rojo', 'Negro', 'Azul')
ORDER BY a.color, ma.nombre;
GO

/*==============================================================================================
  04. Mostrar clave, nombre, marca y modelo de todos aquellos vehículos de tipo sedan
==============================================================================================*/
SELECT
    a.id_automovil AS clave,
    ma.nombre      AS nombre,
    m.nombre       AS marca,
    ma.version     AS modelo
FROM Automovil a
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
INNER JOIN Marca m
    ON ma.id_marca = m.id_marca
INNER JOIN Tipo_Vehiculo tv
    ON ma.id_tipo_vehiculo = tv.id_tipo_vehiculo
WHERE tv.nombre = 'Sedan'
ORDER BY ma.nombre;
GO

/*==============================================================================================
  05. Mostrar clave, nombre, marca y modelo de todos los autos sedan y camionetas
      cuyo precio de financiamiento supere los $500,000 pesos
==============================================================================================*/
SELECT
    a.id_automovil AS clave,
    ma.nombre      AS nombre,
    m.nombre       AS marca,
    ma.version     AS modelo
FROM Automovil a
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
INNER JOIN Marca m
    ON ma.id_marca = m.id_marca
INNER JOIN Tipo_Vehiculo tv
    ON ma.id_tipo_vehiculo = tv.id_tipo_vehiculo
WHERE tv.nombre IN ('Sedan', 'Camioneta')
  AND ma.precio_financiamiento > 500000
ORDER BY ma.precio_financiamiento DESC;
GO

/*==============================================================================================
  06. Mostrar clave y nombre completo de los empleados que sean gerentes y
      que sean del estado de Hidalgo
==============================================================================================*/
SELECT
    e.id_empleado AS clave,
    CONCAT(e.nombre, ' ', e.ap_paterno, ' ', ISNULL(e.ap_materno, '')) AS nombre_completo
FROM Empleado e
INNER JOIN Puesto p
    ON e.id_puesto = p.id_puesto
INNER JOIN Municipio mu
    ON e.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE p.nombre LIKE 'Gerente%'
  AND es.nombre = 'Hidalgo'
ORDER BY e.id_empleado;
GO

/*==============================================================================================
  07. Mostrar clave y nombre completo de los empleados de Tula, Tlahuelilpan y Tlaxcoapan,
      que sean mujeres cuya edad esté comprendida entre 30 y 45 años
      con puestos gerencia y administrativos
==============================================================================================*/
SELECT
    e.id_empleado AS clave,
    CONCAT(e.nombre, ' ', e.ap_paterno, ' ', ISNULL(e.ap_materno, '')) AS nombre_completo
FROM Empleado e
INNER JOIN Genero g
    ON e.id_genero = g.id_genero
INNER JOIN Municipio mu
    ON e.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
INNER JOIN Puesto p
    ON e.id_puesto = p.id_puesto
WHERE g.nombre = 'Femenino'
  AND mu.nombre IN ('Tula de Allende', 'Tlahuelilpan', 'Tlaxcoapan')
  AND DATEDIFF(YEAR, e.fecha_nacimiento, GETDATE()) BETWEEN 30 AND 45
  AND (
        p.nombre LIKE 'Gerente%'
        OR p.nombre IN ('Administrador', 'Auxiliar Administrativo', 'Recursos Humanos', 'Contador')
      )
ORDER BY e.id_empleado;
GO

/*==============================================================================================
  08. Mostrar clave y nombre completo de los trabajadores de ventas
      que no sean del estado de Hidalgo, hombres y mujeres cuyo salario - ISR
      esté comprendido entre $15,000 y $25,000
==============================================================================================*/
SELECT
    e.id_empleado AS clave,
    CONCAT(e.nombre, ' ', e.ap_paterno, ' ', ISNULL(e.ap_materno, '')) AS nombre_completo
FROM Empleado e
INNER JOIN Puesto p
    ON e.id_puesto = p.id_puesto
INNER JOIN Municipio mu
    ON e.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE p.nombre LIKE '%Ventas%'
  AND es.nombre <> 'Hidalgo'
  AND e.salario_neto BETWEEN 15000 AND 25000
ORDER BY e.salario_neto DESC;
GO

/*==============================================================================================
  09. Mostrar clave y nombre completo del cliente del estado de Hidalgo
      cuyos ingresos superen los $50,000 pesos
==============================================================================================*/
SELECT
    c.id_cliente AS clave,
    CONCAT(c.nombre, ' ', c.ap_paterno, ' ', ISNULL(c.ap_materno, '')) AS nombre_completo
FROM Cliente c
INNER JOIN Municipio mu
    ON c.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE es.nombre = 'Hidalgo'
  AND c.ingresos > 50000
ORDER BY c.ingresos DESC;
GO

/*==============================================================================================
  10. Mostrar clave y nombre de cliente, CDMX, Querétaro, EdoMex
      cuya edad esté comprendida entre los 40 y 60 años
      y sus ingresos sean entre 40,000 y 70,000 pesos
==============================================================================================*/
SELECT
    c.id_cliente AS clave,
    CONCAT(c.nombre, ' ', c.ap_paterno, ' ', ISNULL(c.ap_materno, '')) AS nombre_completo
FROM Cliente c
INNER JOIN Municipio mu
    ON c.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE es.nombre IN ('Ciudad de México', 'Querétaro', 'Estado de México')
  AND DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) BETWEEN 40 AND 60
  AND c.ingresos BETWEEN 40000 AND 70000
ORDER BY c.ingresos DESC;
GO

/*==============================================================================================
  11. Mostrar clave y nombre del proveedor de todos aquellos que no son del estado de Hidalgo
==============================================================================================*/
SELECT
    p.id_proveedor AS clave,
    p.nombre       AS nombre
FROM Proveedor p
INNER JOIN Municipio mu
    ON p.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE es.nombre <> 'Hidalgo'
ORDER BY p.nombre;
GO

/*==============================================================================================
  12. Mostrar clave y nombre del proveedor de Puebla, Tlaxcala y CDMX
==============================================================================================*/
SELECT
    p.id_proveedor AS clave,
    p.nombre       AS nombre
FROM Proveedor p
INNER JOIN Municipio mu
    ON p.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE es.nombre IN ('Puebla', 'Tlaxcala', 'Ciudad de México')
ORDER BY es.nombre, p.nombre;
GO

/*==============================================================================================
  13. Mostrar la clave y número de contrato de todos los vehículos Jetta con cobertura amplia
==============================================================================================*/
SELECT
    a.id_automovil    AS clave,
    p.numero_contrato AS numero_contrato
FROM Poliza p
INNER JOIN Venta v
    ON p.id_venta = v.id_venta
INNER JOIN Automovil a
    ON v.id_automovil = a.id_automovil
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
INNER JOIN Poliza_Cobertura pc
    ON p.id_poliza = pc.id_poliza
INNER JOIN Cobertura c
    ON pc.id_cobertura = c.id_cobertura
WHERE ma.nombre = 'Jetta'
  AND c.nombre = 'Amplia'
ORDER BY p.numero_contrato;
GO

/*==============================================================================================
  14. Mostrar clave y número de contrato de todos los vehículos Tiguan, CRV y Mustang
      cuyo estatus sea vigente
==============================================================================================*/
SELECT
    a.id_automovil    AS clave,
    p.numero_contrato AS numero_contrato
FROM Poliza p
INNER JOIN Venta v
    ON p.id_venta = v.id_venta
INNER JOIN Automovil a
    ON v.id_automovil = a.id_automovil
INNER JOIN Modelo_Automovil ma
    ON a.id_modelo = ma.id_modelo
WHERE ma.nombre IN ('Tiguan', 'CR-V', 'Mustang')
  AND p.estatus = 'Vigente'
ORDER BY ma.nombre;
GO

/*==============================================================================================
  15. Mostrar clave y nombre de las aseguradoras de Estado de México y CDMX
==============================================================================================*/
SELECT
    a.id_aseguradora AS clave,
    a.nombre         AS nombre
FROM Aseguradora a
INNER JOIN Municipio mu
    ON a.id_municipio = mu.id_municipio
INNER JOIN Estado es
    ON mu.id_estado = es.id_estado
WHERE es.nombre IN ('Estado de México', 'Ciudad de México')
ORDER BY a.nombre;
GO

/*==============================================================================================
  16. Mostrar clave y nombre del servicio de costos entre $10,000 y $20,000
==============================================================================================*/
SELECT
    s.id_servicio AS clave,
    s.nombre      AS nombre
FROM Servicio s
WHERE s.costo BETWEEN 10000 AND 20000
ORDER BY s.costo;
GO

/*==============================================================================================
  17. Mostrar clave y nombre del servicio con fechas de ingreso en el mes de junio
==============================================================================================*/
SELECT
    s.id_servicio AS clave,
    s.nombre      AS nombre
FROM Servicio s
WHERE MONTH(s.fecha_ingreso) = 6
ORDER BY s.fecha_ingreso;
GO

/*==============================================================================================
  18. Mostrar clave y nombre del servicio con fechas de entrega en julio
==============================================================================================*/
SELECT
    s.id_servicio AS clave,
    s.nombre      AS nombre
FROM Servicio s
WHERE s.fecha_entrega IS NOT NULL
  AND MONTH(s.fecha_entrega) = 7
ORDER BY s.fecha_entrega;
GO

/*==============================================================================================
  19. Mostrar clave y nombre del servicio de costos mayores a $20,000 + IVA
==============================================================================================*/
SELECT
    s.id_servicio AS clave,
    s.nombre      AS nombre
FROM Servicio s
WHERE s.total > 20000
ORDER BY s.total DESC;
GO

/*==============================================================================================
  20. Mostrar clave y nombre del servicio de todos aquellos que fueron reparaciones
      con costos entre $30,000 y $40,000 + IVA
==============================================================================================*/
SELECT
    s.id_servicio AS clave,
    s.nombre      AS nombre
FROM Servicio s
INNER JOIN Tipo_Servicio ts
    ON s.id_tipo_servicio = ts.id_tipo_servicio
WHERE ts.nombre = 'Reparación'
  AND s.total BETWEEN 30000 AND 40000
ORDER BY s.total;
GO

/*==============================================================================================
  CONSULTAS ADICIONALES DE APOYO
  Útiles para validar el contenido de la base de datos.
==============================================================================================*/

-- Ver vehículos por tipo y precio
SELECT
    ma.nombre AS modelo,
    m.nombre  AS marca,
    tv.nombre AS tipo,
    ma.precio_contado,
    ma.precio_financiamiento
FROM Modelo_Automovil ma
INNER JOIN Marca m ON ma.id_marca = m.id_marca
INNER JOIN Tipo_Vehiculo tv ON ma.id_tipo_vehiculo = tv.id_tipo_vehiculo
ORDER BY tv.nombre, ma.precio_contado;
GO

-- Ver ventas con cliente, empleado y automóvil
SELECT
    v.folio,
    v.fecha_venta,
    CONCAT(c.nombre, ' ', c.ap_paterno) AS cliente,
    CONCAT(e.nombre, ' ', e.ap_paterno) AS empleado,
    ma.nombre AS modelo,
    v.total
FROM Venta v
INNER JOIN Cliente c ON v.id_cliente = c.id_cliente
INNER JOIN Empleado e ON v.id_empleado = e.id_empleado
INNER JOIN Automovil a ON v.id_automovil = a.id_automovil
INNER JOIN Modelo_Automovil ma ON a.id_modelo = ma.id_modelo
ORDER BY v.fecha_venta DESC;
GO

PRINT '04_Consultas.sql ejecutado correctamente.';
GO
