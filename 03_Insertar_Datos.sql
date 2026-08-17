/************************************************************************************************
    UNIVERSIDAD AUTÓNOMA DEL ESTADO DE HIDALGO
    ESCUELA SUPERIOR DE TLAHUELILPAN

    CARRERA: Ingeniería en Software
    PROYECTO: Sistema de Administración - Agencia de Autos SantaFe
    ARCHIVO: 03_Insertar_Datos.sql
    MOTOR: Microsoft SQL Server 2022
    AUTOR: Roberto Hernández Ríos
    VERSIÓN: 1.0

    DESCRIPCIÓN:
    Inserta datos operativos de ejemplo para soportar las consultas académicas.
    Este archivo se ejecuta después de:
      01_Crear_BaseDeDatos.sql
      02_Insertar_Catalogos.sql
************************************************************************************************/

USE AgenciaSantaFe;
GO

SET NOCOUNT ON;
GO

/*==============================================================================================
  01. ASEGURADORAS EXTRA (para cubrir CDMX y Estado de México)
==============================================================================================*/
INSERT INTO Aseguradora
(nombre, rfc, telefono, correo, calle, colonia, id_municipio, codigo_postal, ejecutivo)
SELECT v.nombre, v.rfc, v.telefono, v.correo, v.calle, v.colonia, m.id_municipio, v.codigo_postal, v.ejecutivo
FROM
(
    VALUES
    ('AXA Estado de México','AXE990101AA1','8009001292','edomex@axa.com.mx','Av. López Mateos','Centro','53370','Laura Mendoza'),
    ('GNP Estado de México','GNE990101BB2','8004009000','edomex@gnp.com.mx','Av. Gustavo Baz','Centro','54000','Carlos Ramírez'),
    ('Qualitas CDMX','QCD990101CC3','8008002880','cdmx@qualitas.com.mx','Insurgentes Sur','Del Valle','03100','Mariana Torres')
) v(nombre,rfc,telefono,correo,calle,colonia,codigo_postal,ejecutivo)
INNER JOIN Municipio m
    ON m.nombre = CASE
                    WHEN v.nombre LIKE '%Estado de México%' THEN 'Naucalpan de Juárez'
                    ELSE 'Cuauhtémoc'
                  END;
GO

/*==============================================================================================
  02. PROVEEDORES
==============================================================================================*/
INSERT INTO Proveedor
(nombre, contacto, telefono, correo, calle, colonia, id_municipio, codigo_postal, id_marca)
SELECT v.nombre, v.contacto, v.telefono, v.correo, v.calle, v.colonia, m.id_municipio, v.codigo_postal, ma.id_marca
FROM
(
    VALUES
    ('Distribuidora Volkswagen Hidalgo','Carlos Peña','7711001001','vw.hidalgo@agencia.com','Blvd. Felipe Ángeles','Centro','42000','Pachuca de Soto','Volkswagen'),
    ('Honda del Valle','María López','7711001002','honda.valle@agencia.com','Av. Zaragoza','Centro','42800','Tula de Allende','Honda'),
    ('Ford Centro Bajío','Laura Sánchez','4771001003','ford.bajio@agencia.com','Blvd. Adolfo López Mateos','Centro','37250','León','Ford'),
    ('Nissan Puebla Norte','Javier Torres','2221001004','nissan.norte@agencia.com','Av. 11 Sur','Angelópolis','72190','Puebla','Nissan'),
    ('Grupo Automotriz CDMX Sur','Daniela Ramírez','5551001005','cdmxsur@agencia.com','Insurgentes Sur','Del Valle','03100','Benito Juárez','Chevrolet'),
    ('Autos Querétaro Premium','Ricardo Méndez','4421001006','qro.premium@agencia.com','5 de Febrero','Centro','76000','Querétaro','Toyota'),
    ('Toyota Tlaxcala','Patricia Salinas','2461001007','toyota.tlx@agencia.com','Carr. Apizaco-Tlaxcala','Centro','90300','Apizaco','Toyota'),
    ('Mazda México Oriente','Fernando Ruiz','5511001008','mazda.oriente@agencia.com','Periférico Norte','Naucalpan','53370','Naucalpan de Juárez','Mazda')
) v(nombre,contacto,telefono,correo,calle,colonia,codigo_postal,municipio_nombre,marca_nombre)
INNER JOIN Municipio m
    ON m.nombre = v.municipio_nombre
INNER JOIN Marca ma
    ON ma.nombre = v.marca_nombre;
GO

/*==============================================================================================
  03. CLIENTES
==============================================================================================*/
INSERT INTO Cliente
(nombre, ap_paterno, ap_materno, fecha_nacimiento, telefono, correo, rfc, curp, ocupacion, ingresos, id_genero, id_municipio, calle, colonia, codigo_postal)
SELECT v.nombre, v.ap_paterno, v.ap_materno, v.fecha_nacimiento, v.telefono, v.correo, v.rfc, v.curp, v.ocupacion, v.ingresos, g.id_genero, m.id_municipio, v.calle, v.colonia, v.codigo_postal
FROM
(
    VALUES
    ('Roberto','Hernández','Ríos','1998-05-14','7712003001','roberto.h@correo.com','HERR980514HDFNBS09','HERR980514HDFNSB01','Ingeniero',68000.00,'Masculino','Pachuca de Soto','Pachuca','Arboledas','42080'),
    ('María Fernanda','López','Cruz','1990-02-08','7712003002','mfer.lc@correo.com','LOCM900208MDFPRR03','LOCM900208MDFCRR02','Doctora',72000.00,'Femenino','Tula de Allende','Tula','Centro','42800'),
    ('Luis Alberto','Ramírez','Salas','1987-11-23','7712003003','lar.salas@correo.com','RASL871123HDFMLS01','RASL871123HDFSLS04','Comerciante',54000.00,'Masculino','Tlaxcoapan','Tlaxcoapan','Centro','42950'),
    ('Ana Paola','Martínez','Díaz','1979-07-19','7712003004','ana.pd@correo.com','MADP790719MDFZDN05','MADP790719MDFDZN05','Contadora',65000.00,'Femenino','Benito Juárez','CDMX','Del Valle','03100'),
    ('Jorge Iván','García','Muñoz','1968-09-30','7712003005','jig.munoz@correo.com','GAMJ680930HDFRZG02','GAMJ680930HDFMZJ02','Abogado',58000.00,'Masculino','Querétaro','Querétaro','Centro','76000'),
    ('Carmen','Torres','Luna','1974-01-12','7712003006','c.torres@correo.com','TOLC740112MDFRNR03','TOLC740112MDFLNR04','Empresaria',61000.00,'Femenino','Toluca','Toluca','Centro','50000'),
    ('Carlos Eduardo','Sánchez','Pérez','1993-04-05','7712003007','cesperez@correo.com','SAPC930405HDFRRS08','SAPC930405HDFPRZ08','Licenciado',43000.00,'Masculino','Naucalpan de Juárez','Naucalpan','Lomas Verdes','53370'),
    ('Laura Itzel','Hernández','Flores','1983-12-15','7712003008','lher.flores@correo.com','HEFL831215MDFRRS06','HEFL831215MDFFLS06','Administradora',47000.00,'Femenino','Puebla','Puebla','Angelópolis','72190'),
    ('Eduardo','Vargas','Núñez','1980-08-21','7712003009','edu.vargas@correo.com','VANE800821HDFRZD07','VANE800821HDFNZZ07','Médico',69000.00,'Masculino','San Juan del Río','Querétaro','Centro','76800'),
    ('Verónica','Ortega','Silva','1996-03-11','7712003010','vero.silva@correo.com','ORSV960311MDFLVR09','ORSV960311MDFSLV09','Maestra',51000.00,'Femenino','Tlahuelilpan','Hidalgo','Centro','42780'),
    ('Héctor','González','Ramos','1972-10-01','7712003011','hector.ramos@correo.com','GORH721001HDFNMS10','GORH721001HDFRMS10','Administrador',76000.00,'Masculino','Iztapalapa','CDMX','San Lorenzo','09000'),
    ('Paola','Reyes','Mendoza','1988-06-27','7712003012','paola.reyes@correo.com','REMP880627MDFYND11','REMP880627MDFDNS11','Psicóloga',63000.00,'Femenino','Ecatepec de Morelos','Edomex','San Cristóbal','55000')
) v(nombre,ap_paterno,ap_materno,fecha_nacimiento,telefono,correo,rfc,curp,ocupacion,ingresos,genero_nombre,municipio_nombre,estado_nombre,calle,colonia,codigo_postal)
INNER JOIN Genero g
    ON g.nombre = v.genero_nombre
INNER JOIN Estado e
    ON e.nombre = v.estado_nombre
INNER JOIN Municipio m
    ON m.nombre = CASE
                    WHEN v.estado_nombre = 'Hidalgo' AND v.municipio_nombre = 'Hidalgo' THEN 'Tlahuelilpan'
                    WHEN v.estado_nombre = 'CDMX' THEN 'Iztapalapa'
                    WHEN v.estado_nombre = 'Edomex' THEN 'Ecatepec de Morelos'
                    ELSE v.municipio_nombre
                  END
   AND m.id_estado = e.id_estado;
GO

/*==============================================================================================
  04. EMPLEADOS
==============================================================================================*/
INSERT INTO Empleado
(nombre, ap_paterno, ap_materno, fecha_nacimiento, telefono, correo, rfc, curp, calle, colonia, id_municipio, codigo_postal, fecha_ingreso, salario_bruto, porcentaje_isr, id_genero, id_puesto, id_turno)
SELECT v.nombre, v.ap_paterno, v.ap_materno, v.fecha_nacimiento, v.telefono, v.correo, v.rfc, v.curp, v.calle, v.colonia, m.id_municipio, v.codigo_postal, v.fecha_ingreso, v.salario_bruto, v.porcentaje_isr, g.id_genero, p.id_puesto, t.id_turno
FROM
(
    VALUES
    ('José','Hernández','López','1985-04-20','7713004001','jose.hernandez@agencia.com','HELJ850420HDFRPS01','HELJ850420HDFLPS01','Centro','Centro','Pachuca de Soto','42000','2014-02-10',45000.00,16.00,'Masculino','Gerente General','Matutino'),
    ('Mariana','Luna','Vargas','1992-09-14','7713004002','mariana.luna@agencia.com','LUMM920914MDFRNS02','LUMM920914MDFVRS02','Centro','Centro','Tula de Allende','42800','2018-06-01',32000.00,16.00,'Femenino','Gerente de Ventas','Vespertino'),
    ('Patricia','Sánchez','Romero','1988-11-03','7713004003','patricia.s@agencia.com','SARP881103MDFNMC03','SARP881103MDFRMR03','Centro','Centro','Tlahuelilpan','42780','2019-08-12',30000.00,16.00,'Femenino','Gerente Administrativo','Administrativo'),
    ('Fernanda','Díaz','Morales','1990-05-22','7713004004','fernanda.d@agencia.com','DIMF900522MDFRRL04','DIMF900522MDFMRL04','Centro','Centro','Tlaxcoapan','42950','2020-01-20',21000.00,16.00,'Femenino','Administrador','Administrativo'),
    ('Ricardo','Torres','Mendoza','1994-07-09','7713004005','ricardo.t@agencia.com','TOMR940709HDFRNC05','TOMR940709HDFMDC05','Centro','Centro','Puebla','72190','2021-03-15',22000.00,16.00,'Masculino','Asesor de Ventas','Matutino'),
    ('Sofía','Reyes','Castillo','1996-02-28','7713004006','sofia.r@agencia.com','RECS960228MDFYTL06','RECS960228MDFCST06','Centro','Centro','Querétaro','76000','2021-09-03',18000.00,16.00,'Femenino','Asesor de Ventas','Vespertino'),
    ('Luis','García','Pérez','1991-12-17','7713004007','luis.g@agencia.com','GAPL911217HDFRRS07','GAPL911217HDFPRZ07','Centro','Centro','Toluca','50000','2017-04-10',17000.00,16.00,'Masculino','Asesor de Ventas','Matutino'),
    ('Ana','Cruz','Ortiz','1989-03-05','7713004008','ana.c@agencia.com','CUOA890305MDFRTZ08','CUOA890305MDFORT08','Del Valle','Del Valle','Iztapalapa','09000','2016-11-01',23000.00,16.00,'Femenino','Ejecutivo de Financiamiento','Mixto'),
    ('Carlos','Navarro','Flores','1983-10-29','7713004009','carlos.n@agencia.com','NAFC831029HDFLRS09','NAFC831029HDFFLS09','Centro','Centro','Pachuca de Soto','42000','2015-05-18',26000.00,16.00,'Masculino','Jefe de Taller','Taller'),
    ('Daniela','Márquez','León','1998-01-11','7713004010','daniela.m@agencia.com','MALD980111MDFRNL10','MALD980111MDFLLN10','Del Carmen','Del Carmen','Coyoacán','04360','2022-02-07',14000.00,16.00,'Femenino','Recepcionista','Administrativo'),
    ('Héctor','Rojas','Silva','1987-06-30','7713004011','hector.r@agencia.com','ROSH870630HDFJCT11','ROSH870630HDFSLV11','Centro','Centro','Naucalpan de Juárez','53370','2019-10-21',19000.00,16.00,'Masculino','Técnico Automotriz','Taller'),
    ('Paola','Méndez','Vega','1993-08-16','7713004012','paola.m@agencia.com','MEVP930816MDFGAA12','MEVP930816MDFVGA12','Centro','Centro','Tlaxcala','90000','2020-07-01',20000.00,16.00,'Femenino','Asesor de Servicio','Administrativo')
) v(nombre,ap_paterno,ap_materno,fecha_nacimiento,telefono,correo,rfc,curp,calle,colonia,municipio_nombre,codigo_postal,fecha_ingreso,salario_bruto,porcentaje_isr,genero_nombre,puesto_nombre,turno_nombre)
INNER JOIN Genero g ON g.nombre = v.genero_nombre
INNER JOIN Puesto p ON p.nombre = v.puesto_nombre
INNER JOIN Turno t ON t.nombre = v.turno_nombre
INNER JOIN Estado e ON e.nombre IN ('Hidalgo','Ciudad de México','Estado de México','Puebla','Querétaro','Tlaxcala')
INNER JOIN Municipio m ON m.nombre = v.municipio_nombre AND m.id_estado = e.id_estado
WHERE e.nombre = CASE
                    WHEN v.municipio_nombre IN ('Pachuca de Soto','Tula de Allende','Tlahuelilpan','Tlaxcoapan') THEN 'Hidalgo'
                    WHEN v.municipio_nombre IN ('Iztapalapa','Coyoacán') THEN 'Ciudad de México'
                    WHEN v.municipio_nombre IN ('Naucalpan de Juárez','Toluca') THEN 'Estado de México'
                    WHEN v.municipio_nombre = 'Puebla' THEN 'Puebla'
                    WHEN v.municipio_nombre = 'Querétaro' THEN 'Querétaro'
                    WHEN v.municipio_nombre = 'Tlaxcala' THEN 'Tlaxcala'
                  END;
GO

/*==============================================================================================
  05. MODELOS DE AUTOMÓVIL
==============================================================================================*/
INSERT INTO Modelo_Automovil
(nombre, version, descripcion, anio, precio_contado, precio_financiamiento, existencias, id_marca, id_tipo_vehiculo, id_proveedor)
SELECT v.nombre, v.version, v.descripcion, v.anio, v.precio_contado, v.precio_financiamiento, v.existencias, ma.id_marca, tv.id_tipo_vehiculo, pr.id_proveedor
FROM
(
    VALUES
    ('Jetta','Comfortline','Sedán con buen rendimiento y equipamiento',2025,395000.00,455000.00,3,'Volkswagen','Sedan','Distribuidora Volkswagen Hidalgo'),
    ('Versa','Sense','Sedán compacto para ciudad y carretera',2025,340000.00,395000.00,4,'Nissan','Sedan','Nissan Puebla Norte'),
    ('Camaro','LT','Sedán deportivo de alto desempeño',2025,830000.00,945000.00,2,'Chevrolet','Sedan','Grupo Automotriz CDMX Sur'),
    ('Mustang','EcoBoost','Sedán deportivo con diseño icónico',2025,780000.00,890000.00,2,'Ford','Sedan','Ford Centro Bajío'),
    ('Frontier','LE','Camioneta doble cabina de trabajo',2025,610000.00,705000.00,3,'Nissan','Camioneta','Nissan Puebla Norte'),
    ('Raptor','Raptor','Camioneta off-road de alto rendimiento',2025,980000.00,1125000.00,1,'Ford','Camioneta','Ford Centro Bajío'),
    ('Territory','Titanium','SUV para familia y ciudad',2025,730000.00,840000.00,3,'Ford','SUV','Ford Centro Bajío'),
    ('Tiguan','Life','SUV con equipamiento premium',2025,820000.00,945000.00,4,'Volkswagen','SUV','Distribuidora Volkswagen Hidalgo'),
    ('CR-V','Touring','SUV confiable y amplia',2025,810000.00,940000.00,2,'Honda','SUV','Honda del Valle'),
    ('Corolla','LE','Sedán eficiente y cómodo',2025,390000.00,450000.00,4,'Toyota','Sedan','Autos Querétaro Premium'),
    ('Mazda3','i Grand Touring','Sedán deportivo y elegante',2025,420000.00,485000.00,2,'Mazda','Sedan','Mazda México Oriente'),
    ('Sportage','EX','SUV compacto con gran equipamiento',2025,640000.00,735000.00,3,'Kia','SUV','Kia Tlaxcala Motors')
) v(nombre,version,descripcion,anio,precio_contado,precio_financiamiento,existencias,marca_nombre,tipo_nombre,proveedor_nombre)
INNER JOIN Marca ma ON ma.nombre = v.marca_nombre
INNER JOIN Tipo_Vehiculo tv ON tv.nombre = v.tipo_nombre
INNER JOIN Proveedor pr ON pr.nombre = v.proveedor_nombre;
GO

/*==============================================================================================
  06. MODELO - EQUIPAMIENTO
==============================================================================================*/
INSERT INTO Modelo_Equipamiento (id_modelo, id_equipamiento)
SELECT ma.id_modelo, e.id_equipamiento
FROM Modelo_Automovil ma
INNER JOIN Equipamiento e ON e.nombre IN ('Pantalla táctil','Bluetooth','Cámara de reversa')
WHERE ma.nombre IN ('Jetta','Versa','Corolla','Mazda3');
GO

INSERT INTO Modelo_Equipamiento (id_modelo, id_equipamiento)
SELECT ma.id_modelo, e.id_equipamiento
FROM Modelo_Automovil ma
INNER JOIN Equipamiento e ON e.nombre IN ('Control crucero','Faros LED','Control de estabilidad')
WHERE ma.nombre IN ('Tiguan','CR-V','Territory','Sportage');
GO

/*==============================================================================================
  07. AUTOMÓVILES
==============================================================================================*/
INSERT INTO Automovil
(codigo, numero_serie, vin, numero_motor, placas, color, transmision, condicion, kilometraje, estado_inventario, fecha_ingreso_agencia, meses_garantia, id_modelo)
SELECT v.codigo, v.numero_serie, v.vin, v.numero_motor, v.placas, v.color, v.transmision, v.condicion, v.kilometraje, v.estado_inventario, v.fecha_ingreso_agencia, v.meses_garantia, ma.id_modelo
FROM
(
    VALUES
    ('ASF-0001','SERIE-0001','VIN-0001','MOTOR-0001','HGO-111-A','Blanco','Automatica','Nuevo',0,'Vendido','2025-01-10',36,'Jetta'),
    ('ASF-0002','SERIE-0002','VIN-0002','MOTOR-0002','HGO-112-B','Negro','Automatica','Nuevo',0,'Vendido','2025-01-12',36,'Tiguan'),
    ('ASF-0003','SERIE-0003','VIN-0003','MOTOR-0003','CDMX-113-C','Rojo','Manual','Nuevo',0,'Vendido','2025-01-15',36,'Mustang'),
    ('ASF-0004','SERIE-0004','VIN-0004','MOTOR-0004','EDO-114-D','Azul','Automatica','Seminuevo',25000,'Vendido','2025-01-20',24,'CR-V'),
    ('ASF-0005','SERIE-0005','VIN-0005','MOTOR-0005','PUE-115-E','Negro','Automatica','Nuevo',0,'Vendido','2025-01-22',36,'Versa'),
    ('ASF-0006','SERIE-0006','VIN-0006','MOTOR-0006','TLX-116-F','Blanco','Manual','Nuevo',0,'Disponible','2025-02-05',36,'Frontier'),
    ('ASF-0007','SERIE-0007','VIN-0007','MOTOR-0007','QRO-117-G','Gris','Automatica','Nuevo',0,'Disponible','2025-02-10',36,'Corolla'),
    ('ASF-0008','SERIE-0008','VIN-0008','MOTOR-0008','HGO-118-H','Azul','Automatica','Nuevo',0,'Disponible','2025-02-11',36,'Mazda3'),
    ('ASF-0009','SERIE-0009','VIN-0009','MOTOR-0009','CDMX-119-I','Rojo','Automatica','Seminuevo',18000,'Disponible','2025-02-15',24,'Sportage'),
    ('ASF-0010','SERIE-0010','VIN-0010','MOTOR-0010','EDO-120-J','Negro','Manual','Nuevo',0,'Disponible','2025-02-18',36,'Raptor'),
    ('ASF-0011','SERIE-0011','VIN-0011','MOTOR-0011','PUE-121-K','Blanco','Automatica','Nuevo',0,'Disponible','2025-02-20',36,'Territory'),
    ('ASF-0012','SERIE-0012','VIN-0012','MOTOR-0012','TLX-122-L','Gris','Automatica','Seminuevo',15000,'Disponible','2025-02-25',24,'Jetta')
) v(codigo,numero_serie,vin,numero_motor,placas,color,transmision,condicion,kilometraje,estado_inventario,fecha_ingreso_agencia,meses_garantia,modelo_nombre)
INNER JOIN Modelo_Automovil ma ON ma.nombre = v.modelo_nombre;
GO

/*==============================================================================================
  08. VENTAS
==============================================================================================*/
INSERT INTO Venta
(folio, fecha_venta, precio_pactado, descuento, id_cliente, id_empleado, id_automovil, id_metodo_pago)
SELECT v.folio, v.fecha_venta, v.precio_pactado, v.descuento, c.id_cliente, e.id_empleado, a.id_automovil, mp.id_metodo_pago
FROM
(
    VALUES
    ('VTA-0001','2025-03-01',395000.00,15000.00,'roberto.h@correo.com','jose.hernandez@agencia.com','ASF-0001','Financiamiento'),
    ('VTA-0002','2025-03-05',820000.00,20000.00,'mfer.lc@correo.com','mariana.luna@agencia.com','ASF-0002','Financiamiento'),
    ('VTA-0003','2025-03-08',780000.00,10000.00,'lar.salas@correo.com','patricia.s@agencia.com','ASF-0003','Contado'),
    ('VTA-0004','2025-03-10',810000.00,18000.00,'ana.pd@correo.com','fernanda.d@agencia.com','ASF-0004','Financiamiento'),
    ('VTA-0005','2025-03-12',340000.00,5000.00,'jig.munoz@correo.com','ricardo.t@agencia.com','ASF-0005','Contado'),
    ('VTA-0006','2025-03-15',390000.00,8000.00,'c.torres@correo.com','sofia.r@agencia.com','ASF-0008','Financiamiento'),
    ('VTA-0007','2025-03-18',420000.00,10000.00,'cesperez@correo.com','luis.g@agencia.com','ASF-0007','Contado'),
    ('VTA-0008','2025-03-20',640000.00,12000.00,'lher.flores@correo.com','ana.c@agencia.com','ASF-0009','Financiamiento')
) v(folio,fecha_venta,precio_pactado,descuento,cliente_correo,empleado_correo,automovil_codigo,metodo_pago_nombre)
INNER JOIN Cliente c ON c.correo = v.cliente_correo
INNER JOIN Empleado e ON e.correo = v.empleado_correo
INNER JOIN Automovil a ON a.codigo = v.automovil_codigo
INNER JOIN Metodo_Pago mp ON mp.nombre = v.metodo_pago_nombre;
GO

/*==============================================================================================
  09. FINANCIAMIENTOS
==============================================================================================*/
INSERT INTO Financiamiento
(id_venta, id_banco, enganche, porcentaje_enganche, plazo_meses, tasa_anual, mensualidad, fecha_inicio, fecha_fin, estatus)
SELECT v.id_venta, b.id_banco, f.enganche, f.porcentaje_enganche, f.plazo_meses, f.tasa_anual, f.mensualidad, f.fecha_inicio, f.fecha_fin, f.estatus
FROM
(
    VALUES
    ('VTA-0001','BBVA México',90000.00,22.78,48,14.500,10350.00,'2025-03-01','2029-03-01','Activo'),
    ('VTA-0002','Banorte',120000.00,14.63,60,13.900,13800.00,'2025-03-05','2030-03-05','Activo'),
    ('VTA-0004','HSBC México',150000.00,18.50,48,12.900,16000.00,'2025-03-10','2029-03-10','Activo'),
    ('VTA-0006','Santander México',80000.00,20.51,36,15.100,12150.00,'2025-03-18','2028-03-18','Activo')
) f(folio,banco_nombre,enganche,porcentaje_enganche,plazo_meses,tasa_anual,mensualidad,fecha_inicio,fecha_fin,estatus)
INNER JOIN Venta v ON v.folio = f.folio
INNER JOIN Banco b ON b.nombre = f.banco_nombre;
GO

/*==============================================================================================
  10. PÓLIZAS
==============================================================================================*/
INSERT INTO Poliza
(numero_contrato, fecha_inicio, fecha_fin, tipo_poliza, prima_anual, estatus, id_venta, id_aseguradora)
SELECT p.numero_contrato, p.fecha_inicio, p.fecha_fin, p.tipo_poliza, p.prima_anual, p.estatus, v.id_venta, a.id_aseguradora
FROM
(
    VALUES
    ('CON-0001','2025-03-01','2026-03-01','Amplia',18500.00,'Vigente','VTA-0001','AXA Estado de México'),
    ('CON-0002','2025-03-05','2026-03-05','Limitada',13200.00,'Vigente','VTA-0002','GNP Estado de México'),
    ('CON-0003','2025-03-08','2026-03-08','Amplia',21000.00,'Vigente','VTA-0003','Qualitas CDMX'),
    ('CON-0004','2025-03-10','2026-03-10','Amplia',19800.00,'Vigente','VTA-0004','AXA Estado de México'),
    ('CON-0005','2025-03-12','2026-03-12','Limitada',12500.00,'Vigente','VTA-0005','GNP Seguros'),
    ('CON-0006','2025-03-15','2026-03-15','Amplia',17600.00,'Vigente','VTA-0006','Qualitas'),
    ('CON-0007','2025-03-18','2026-03-18','Responsabilidad Civil',9800.00,'Cancelada','VTA-0007','HDI Seguros'),
    ('CON-0008','2025-03-20','2026-03-20','Amplia',22400.00,'Renovada','VTA-0008','MAPFRE México')
) p(numero_contrato,fecha_inicio,fecha_fin,tipo_poliza,prima_anual,estatus,folio_venta,aseguradora_nombre)
INNER JOIN Venta v ON v.folio = p.folio_venta
INNER JOIN Aseguradora a ON a.nombre = p.aseguradora_nombre;
GO

/*==============================================================================================
  11. PÓLIZA - COBERTURA
==============================================================================================*/
INSERT INTO Poliza_Cobertura (id_poliza, id_cobertura)
SELECT p.id_poliza, c.id_cobertura
FROM Poliza p
INNER JOIN Cobertura c ON c.nombre = 'Amplia'
WHERE p.numero_contrato IN ('CON-0001','CON-0003','CON-0004','CON-0006','CON-0008');
GO

INSERT INTO Poliza_Cobertura (id_poliza, id_cobertura)
SELECT p.id_poliza, c.id_cobertura
FROM Poliza p
INNER JOIN Cobertura c ON c.nombre = 'Limitada'
WHERE p.numero_contrato IN ('CON-0002','CON-0005');
GO

INSERT INTO Poliza_Cobertura (id_poliza, id_cobertura)
SELECT p.id_poliza, c.id_cobertura
FROM Poliza p
INNER JOIN Cobertura c ON c.nombre = 'Responsabilidad Civil'
WHERE p.numero_contrato IN ('CON-0007');
GO

/*==============================================================================================
  12. SERVICIOS
==============================================================================================*/
INSERT INTO Servicio
(nombre, fecha_ingreso, fecha_entrega, costo, kilometraje_ingreso, observaciones, aplica_garantia, id_automovil, id_empleado, id_tipo_servicio)
SELECT v.nombre, v.fecha_ingreso, v.fecha_entrega, v.costo, v.kilometraje_ingreso, v.observaciones, v.aplica_garantia, a.id_automovil, e.id_empleado, ts.id_tipo_servicio
FROM
(
    VALUES
    ('Mantenimiento 10,000 km','2025-06-03','2025-06-05',12000.00,10000,'Servicio preventivo',1,'ASF-0001','jose.hernandez@agencia.com','Mantenimiento Preventivo'),
    ('Cambio de aceite y filtro','2025-06-06','2025-06-06',8500.00,12000,'Cambio de aceite sintético',1,'ASF-0002','carlos.n@agencia.com','Cambio de Aceite'),
    ('Diagnóstico eléctrico','2025-06-10','2025-07-02',18000.00,15000,'Se revisó módulo de control',1,'ASF-0003','hector.r@agencia.com','Diagnóstico'),
    ('Reparación de suspensión','2025-06-12','2025-07-04',35000.00,18000,'Cambio de amortiguadores y baleros',0,'ASF-0004','hector.r@agencia.com','Reparación'),
    ('Afinación mayor','2025-06-15','2025-06-18',14000.00,9000,'Bujías, filtros y limpieza',1,'ASF-0005','paola.m@agencia.com','Afinación'),
    ('Servicio de frenos','2025-06-18','2025-07-01',22000.00,22000,'Cambio de balatas y discos',1,'ASF-0006','jose.hernandez@agencia.com','Frenos'),
    ('Hojalatería y pintura','2025-06-20','2025-07-06',39000.00,26000,'Reparación de carrocería',0,'ASF-0007','carlos.n@agencia.com','Hojalatería'),
    ('Mantenimiento 20,000 km','2025-06-24','2025-06-27',16000.00,20000,'Preventivo intermedio',1,'ASF-0008','ana.c@agencia.com','Mantenimiento Preventivo'),
    ('Reparación de transmisión','2025-07-02','2025-07-08',40000.00,30000,'Servicio mayor',0,'ASF-0009','hector.r@agencia.com','Reparación'),
    ('Servicio de aire acondicionado','2025-07-05','2025-07-09',17000.00,24000,'Carga y revisión de sistema',1,'ASF-0010','paola.m@agencia.com','Aire Acondicionado'),
    ('Inspección general','2025-07-10','2025-07-10',10000.00,8000,'Inspección de entrega',1,'ASF-0011','ana.c@agencia.com','Inspección'),
    ('Cambio de llantas','2025-07-12','2025-07-12',19000.00,21000,'Cuatro llantas nuevas',1,'ASF-0012','jose.hernandez@agencia.com','Llantas')
) v(nombre,fecha_ingreso,fecha_entrega,costo,kilometraje_ingreso,observaciones,aplica_garantia,automovil_codigo,empleado_correo,tipo_servicio_nombre)
INNER JOIN Automovil a ON a.codigo = v.automovil_codigo
INNER JOIN Empleado e ON e.correo = v.empleado_correo
INNER JOIN Tipo_Servicio ts ON ts.nombre = v.tipo_servicio_nombre;
GO

/*==============================================================================================
  13. RENOVACIONES
==============================================================================================*/
INSERT INTO Renovacion (id_poliza, fecha, accion, observaciones)
SELECT p.id_poliza, v.fecha, v.accion, v.observaciones
FROM
(
    VALUES
    ('CON-0001','2026-03-01','Renovar','Renovación anual solicitada por el cliente'),
    ('CON-0002','2026-03-05','Renovar','Renovación en proceso'),
    ('CON-0003','2026-03-08','Cancelar','Cancelada por decisión del cliente'),
    ('CON-0004','2026-03-10','Renovar','Renovación con ampliación de cobertura')
) v(numero_contrato,fecha,accion,observaciones)
INNER JOIN Poliza p ON p.numero_contrato = v.numero_contrato;
GO

/*==============================================================================================
  14. VALIDACIÓN RÁPIDA
==============================================================================================*/
SELECT 'Proveedor' AS tabla, COUNT(*) AS registros FROM Proveedor
UNION ALL SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL SELECT 'Empleado', COUNT(*) FROM Empleado
UNION ALL SELECT 'Modelo_Automovil', COUNT(*) FROM Modelo_Automovil
UNION ALL SELECT 'Automovil', COUNT(*) FROM Automovil
UNION ALL SELECT 'Venta', COUNT(*) FROM Venta
UNION ALL SELECT 'Financiamiento', COUNT(*) FROM Financiamiento
UNION ALL SELECT 'Poliza', COUNT(*) FROM Poliza
UNION ALL SELECT 'Servicio', COUNT(*) FROM Servicio
UNION ALL SELECT 'Renovacion', COUNT(*) FROM Renovacion;
GO

PRINT '03_Insertar_Datos.sql ejecutado correctamente.';
GO
