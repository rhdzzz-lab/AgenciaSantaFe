/* Agencia SantaFe - 02_Insertar_Catalogos.sql
   Ejecutar después de 01_Crear_BaseDeDatos.sql
   Microsoft SQL Server 2022
*/
USE AgenciaSantaFe;
GO
SET NOCOUNT ON;
GO

/* ESTADOS */
INSERT INTO Estado (nombre, abreviatura) VALUES
('Aguascalientes','AGS'),('Baja California','BC'),('Baja California Sur','BCS'),
('Campeche','CAM'),('Chiapas','CHIS'),('Chihuahua','CHIH'),('Ciudad de México','CDMX'),
('Coahuila','COAH'),('Colima','COL'),('Durango','DGO'),('Estado de México','EDOMEX'),
('Guanajuato','GTO'),('Guerrero','GRO'),('Hidalgo','HGO'),('Jalisco','JAL'),
('Michoacán','MICH'),('Morelos','MOR'),('Nayarit','NAY'),('Nuevo León','NL'),
('Oaxaca','OAX'),('Puebla','PUE'),('Querétaro','QRO'),('Quintana Roo','QROO'),
('San Luis Potosí','SLP'),('Sinaloa','SIN'),('Sonora','SON'),('Tabasco','TAB'),
('Tamaulipas','TAMPS'),('Tlaxcala','TLAX'),('Veracruz','VER'),('Yucatán','YUC'),('Zacatecas','ZAC');
GO

/* MUNICIPIOS NECESARIOS PARA LAS CONSULTAS */
INSERT INTO Municipio (id_estado,nombre)
SELECT e.id_estado,v.nombre
FROM Estado e
JOIN (VALUES
('Hidalgo','Pachuca de Soto'),('Hidalgo','Tula de Allende'),('Hidalgo','Tlahuelilpan'),
('Hidalgo','Tlaxcoapan'),('Hidalgo','Tepeji del Río de Ocampo'),('Hidalgo','Actopan'),
('Hidalgo','Ixmiquilpan'),('Hidalgo','Tulancingo de Bravo'),('Hidalgo','Mineral de la Reforma'),
('Ciudad de México','Álvaro Obregón'),('Ciudad de México','Benito Juárez'),
('Ciudad de México','Coyoacán'),('Ciudad de México','Cuauhtémoc'),
('Ciudad de México','Gustavo A. Madero'),('Ciudad de México','Iztapalapa'),
('Ciudad de México','Miguel Hidalgo'),('Ciudad de México','Tlalpan'),
('Estado de México','Ecatepec de Morelos'),('Estado de México','Naucalpan de Juárez'),
('Estado de México','Tlalnepantla de Baz'),('Estado de México','Toluca'),('Estado de México','Metepec'),
('Puebla','Puebla'),('Puebla','Atlixco'),('Puebla','Tehuacán'),
('Tlaxcala','Tlaxcala'),('Tlaxcala','Apizaco'),('Tlaxcala','Huamantla'),
('Querétaro','Querétaro'),('Querétaro','San Juan del Río'),('Querétaro','El Marqués'),
('Jalisco','Guadalajara'),('Jalisco','Zapopan'),('Nuevo León','Monterrey'),
('Guanajuato','León'),('Chihuahua','Chihuahua'),('Veracruz','Veracruz'),
('Yucatán','Mérida'),('Oaxaca','Oaxaca de Juárez'),('San Luis Potosí','San Luis Potosí'),
('Aguascalientes','Aguascalientes'),('Morelos','Cuernavaca'),('Michoacán','Morelia'),
('Guerrero','Acapulco de Juárez'),('Sinaloa','Culiacán'),('Sonora','Hermosillo'),
('Tamaulipas','Tampico'),('Zacatecas','Zacatecas')
) v(estado_nombre,nombre) ON e.nombre=v.estado_nombre;
GO

/* GENEROS */
INSERT INTO Genero(nombre) VALUES ('Femenino'),('Masculino');
GO

/* MARCAS */
INSERT INTO Marca(nombre,pais_origen) VALUES
('Volkswagen','Alemania'),('Honda','Japón'),('Ford','Estados Unidos'),('Toyota','Japón'),
('Nissan','Japón'),('Chevrolet','Estados Unidos'),('Mazda','Japón'),('Kia','Corea del Sur'),
('Hyundai','Corea del Sur'),('SEAT','España'),('Audi','Alemania'),('BMW','Alemania'),
('Mercedes-Benz','Alemania'),('Jeep','Estados Unidos'),('RAM','Estados Unidos'),
('Mitsubishi','Japón'),('Suzuki','Japón'),('MG','Reino Unido'),('Subaru','Japón'),('Volvo','Suecia');
GO

/* TIPOS DE VEHICULO */
INSERT INTO Tipo_Vehiculo(nombre,descripcion) VALUES
('Sedan','Automóvil de cuatro puertas'),('SUV','Vehículo utilitario deportivo'),
('Camioneta','Vehículo multipropósito o de carga'),('Hatchback','Automóvil compacto con puerta trasera'),
('Coupe','Automóvil deportivo de dos puertas'),('Pickup','Camioneta con caja de carga');
GO

/* PUESTOS */
INSERT INTO Puesto(nombre,salario_base) VALUES
('Gerente General',45000),('Gerente de Ventas',32000),('Gerente Administrativo',30000),
('Asesor de Ventas',18000),('Ejecutivo de Financiamiento',22000),('Administrador',20000),
('Contador',23000),('Recursos Humanos',21000),('Recepcionista',12000),('Jefe de Taller',26000),
('Mecánico',17000),('Técnico Automotriz',19000),('Asesor de Servicio',18000),('Almacenista',14000),
('Auxiliar Administrativo',13000),('Marketing',20000),('Compras',21000),('Caja',14500),
('Lavador Automotriz',11000),('Seguridad',11500);
GO

/* TURNOS */
INSERT INTO Turno(nombre,hora_inicio,hora_fin) VALUES
('Matutino','08:00','16:00'),('Vespertino','13:00','21:00'),('Mixto','09:00','18:00'),
('Administrativo','08:30','17:30'),('Taller','08:00','17:00');
GO

/* BANCOS */
INSERT INTO Banco(nombre,rfc,telefono,correo,id_estado)
SELECT v.nombre,v.rfc,v.telefono,v.correo,e.id_estado FROM (VALUES
('BBVA México','BBA830831LJ2','8002262663','atencion@bbva.com','Ciudad de México'),
('Banorte','BNO670315CD0','8002266783','atencion@banorte.com','Nuevo León'),
('Santander México','SMN930802FQ1','8005010000','atencion@santander.com.mx','Ciudad de México'),
('HSBC México','HMI850101NQ3','8007124825','atencion@hsbc.com.mx','Ciudad de México'),
('Scotiabank México','SME970104A01','8007045900','contacto@scotiabank.com.mx','Ciudad de México'),
('BanBajío','BBA940906KJ7','4777104600','contacto@banbajio.com','Guanajuato'),
('Inbursa','IIN920610P76','5554478000','contacto@inbursa.com','Ciudad de México'),
('Afirme','AFI921110QG2','8183183900','contacto@afirme.com','Nuevo León'),
('Banco Azteca','BAZ9509048R2','5554478810','contacto@bancoazteca.com.mx','Ciudad de México'),
('Citibanamex','CIT880110B87','5512262639','atencion@citibanamex.com','Ciudad de México'),
('Hey Banco','HBA1901014C8','8143302222','contacto@heybanco.com','Nuevo León'),
('Banregio','BRG970209A45','8181232000','contacto@banregio.com','Nuevo León')
) v(nombre,rfc,telefono,correo,estado_nombre) JOIN Estado e ON e.nombre=v.estado_nombre;
GO

/* ASEGURADORAS */
INSERT INTO Aseguradora(nombre,rfc,telefono,correo,calle,colonia,id_municipio,codigo_postal,ejecutivo)
SELECT v.nombre,v.rfc,v.telefono,v.correo,v.calle,v.colonia,m.id_municipio,v.cp,v.ejecutivo
FROM (VALUES
('AXA Seguros','AXA000000001','8009001292','contacto@axa.com.mx','Av. Reforma 250','Cuauhtémoc','06600','Ejecutivo 01'),
('GNP Seguros','GNP000000002','8004009000','contacto@gnp.com.mx','Av. Cerro de las Torres 395','Campestre Churubusco','04200','Ejecutivo 02'),
('Qualitas','QUA000000003','8008002880','contacto@qualitas.com.mx','José Vasconcelos 200','Condesa','06140','Ejecutivo 03'),
('HDI Seguros','HDI000000004','8000196000','contacto@hdi.com.mx','Av. Insurgentes Sur 1800','Florida','01030','Ejecutivo 04'),
('MAPFRE México','MAP000000005','8000627373','contacto@mapfre.com.mx','Av. Revolución 507','San Pedro de los Pinos','03800','Ejecutivo 05'),
('Zurich México','ZUR000000006','8002881000','contacto@zurich.com','Av. Ejército Nacional 843','Granada','11520','Ejecutivo 06'),
('Chubb México','CHU000000007','8002232000','contacto@chubb.com','Paseo de la Reforma 250','Cuauhtémoc','06600','Ejecutivo 07'),
('ANA Seguros','ANA000000008','8009112627','contacto@anaseguros.com.mx','Av. Vallarta 650','Centro','44100','Ejecutivo 08'),
('General de Seguros','GEN000000009','8002884727','contacto@generalseguros.com','Av. Patriotismo 201','Escandón','11800','Ejecutivo 09'),
('Seguros Atlas','ATL000000010','8008493911','contacto@segurosatlas.com.mx','Av. Insurgentes Sur 600','Del Valle','03100','Ejecutivo 10')
) v(nombre,rfc,telefono,correo,calle,colonia,municipio_nombre,cp,ejecutivo)
JOIN Municipio m ON m.nombre=v.municipio_nombre;
GO

/* COBERTURAS */
INSERT INTO Cobertura(nombre,descripcion,monto_maximo) VALUES
('Amplia','Daños materiales, robo total, responsabilidad civil y asistencia vial.',1000000),
('Limitada','Robo total y responsabilidad civil.',600000),
('Responsabilidad Civil','Daños ocasionados a terceros.',500000),
('Daños Materiales','Protección por daños materiales.',800000),
('Robo Total','Protección contra robo total.',900000),
('Asistencia Vial','Servicios de asistencia vial.',100000),
('Gastos Médicos','Protección para ocupantes.',500000),
('Cristales','Reparación o sustitución de cristales.',100000),
('Auto Sustituto','Vehículo sustituto durante reparación.',80000),
('Cobertura Total','Paquete integral de coberturas.',1500000);
GO

/* METODOS DE PAGO */
INSERT INTO Metodo_Pago(nombre) VALUES
('Contado'),('Transferencia'),('Cheque'),('Tarjeta de Crédito'),('Tarjeta de Débito'),('Financiamiento');
GO

/* TIPOS DE SERVICIO */
INSERT INTO Tipo_Servicio(nombre,descripcion) VALUES
('Mantenimiento Preventivo','Servicio programado de mantenimiento.'),
('Mantenimiento Correctivo','Corrección de una falla detectada.'),
('Reparación','Solución de una avería.'),('Garantía','Servicio cubierto por garantía.'),
('Afinación','Revisión y ajuste del motor.'),('Frenos','Servicio del sistema de frenado.'),
('Suspensión','Servicio del sistema de suspensión.'),('Diagnóstico','Diagnóstico automotriz.'),
('Hojalatería','Reparación de carrocería.'),('Pintura','Trabajos de pintura.'),
('Aire Acondicionado','Servicio del sistema de climatización.'),('Eléctrico','Servicio del sistema eléctrico.'),
('Llantas','Montaje, balanceo y alineación.'),('Cambio de Aceite','Cambio de aceite y filtro.'),
('Inspección','Revisión general del vehículo.');
GO

/* EQUIPAMIENTO */
INSERT INTO Equipamiento(nombre,descripcion) VALUES
('Aire acondicionado automático','Climatización automática'),('Control crucero','Control de velocidad'),
('Cámara de reversa','Asistencia de estacionamiento'),('Sensores de estacionamiento','Sensores delanteros y traseros'),
('Pantalla táctil','Sistema multimedia'),('Apple CarPlay','Integración Apple'),('Android Auto','Integración Android'),
('Bluetooth','Conectividad inalámbrica'),('Quemacocos','Techo corredizo o panorámico'),
('Asientos de piel','Tapizado de piel'),('Asientos eléctricos','Ajuste eléctrico'),
('Calefacción de asientos','Calefacción de asientos'),('Faros LED','Iluminación LED'),
('Luces automáticas','Activación automática'),('Limpiaparabrisas automático','Sensor de lluvia'),
('Control de estabilidad','Estabilidad electrónica'),('Control de tracción','Control de adherencia'),
('Frenado autónomo','Asistencia de frenado'),('Alerta de punto ciego','Detección de punto ciego'),
('Asistente de carril','Asistencia para mantenerse en carril');
GO

/* VALIDACIÓN */
SELECT 'Estado' AS tabla,COUNT(*) AS registros FROM Estado
UNION ALL SELECT 'Municipio',COUNT(*) FROM Municipio
UNION ALL SELECT 'Genero',COUNT(*) FROM Genero
UNION ALL SELECT 'Marca',COUNT(*) FROM Marca
UNION ALL SELECT 'Tipo_Vehiculo',COUNT(*) FROM Tipo_Vehiculo
UNION ALL SELECT 'Puesto',COUNT(*) FROM Puesto
UNION ALL SELECT 'Turno',COUNT(*) FROM Turno
UNION ALL SELECT 'Banco',COUNT(*) FROM Banco
UNION ALL SELECT 'Aseguradora',COUNT(*) FROM Aseguradora
UNION ALL SELECT 'Cobertura',COUNT(*) FROM Cobertura
UNION ALL SELECT 'Metodo_Pago',COUNT(*) FROM Metodo_Pago
UNION ALL SELECT 'Tipo_Servicio',COUNT(*) FROM Tipo_Servicio
UNION ALL SELECT 'Equipamiento',COUNT(*) FROM Equipamiento;
GO

PRINT '02_Insertar_Catalogos.sql ejecutado correctamente.';
GO
