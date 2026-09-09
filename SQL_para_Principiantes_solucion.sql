-- =====================================================================
-- SQL PARA PRINCIPIANTES - Caso de estudio ElectroHogar S.A.
-- Guion completo de la sesion: estructura, datos de ejemplo y solucion
-- de cada "TU RETO" y "practica de ejemplo" de la presentacion.
-- Motor: MySQL 8.0+
--
-- Notas de construccion (la presentacion muestra fragmentos aislados
-- por tema; aqui se ensamblan en un solo script ejecutable):
--   1. Las tablas se crean en orden de dependencia: departamentos antes
--      que empleados, y categorias antes que productos (en la
--      diapositiva 11-12 el CREATE TABLE empleados ya referencia
--      departamentos, aunque esa tabla se crea despues, en la
--      diapositiva 14; aqui se reordena para poder ejecutarse).
--   2. clientes incluye PRIMARY KEY AUTO_INCREMENT desde su creacion,
--      siguiendo el propio tip de la diapositiva 9 ("define una PRIMARY
--      KEY en toda tabla"), ya que la tabla ventas necesita
--      referenciarla con FOREIGN KEY.
--   3. productos guarda tanto id_categoria (FK real hacia categorias,
--      usada en el reto de agrupacion) como una columna de texto
--      "categoria" (usada en el reto de IN/LIKE de operadores, tal cual
--      la resuelve la propia diapositiva 28) porque el JOIN entre
--      productos y categorias se anuncia como "siguiente paso" en el
--      cierre del taller y todavia no se ha explicado.
--   4. Se usan ciudades sin tilde (Bogota, Medellin) para evitar
--      problemas de codificacion al ejecutar el script.
-- =====================================================================

DROP DATABASE IF EXISTS electrohogar;
CREATE DATABASE electrohogar;
USE electrohogar;

-- =====================================================================
-- SECCION 1 - DDL: estructura de la base de datos
-- =====================================================================

CREATE TABLE categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre       VARCHAR(60)  NOT NULL,
    descripcion  VARCHAR(200)
);

CREATE TABLE departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(80) NOT NULL
);

-- Reto de "Modificadores" (diapositiva 11-12): id autogenerado, nombre
-- obligatorio, correo que no se repite, salario nunca negativo y
-- departamento existente.
CREATE TABLE empleados (
    id_empleado        INT AUTO_INCREMENT PRIMARY KEY,
    nombre             VARCHAR(100)  NOT NULL,
    email              VARCHAR(150)  UNIQUE,
    salario            DECIMAL(10,2) CHECK (salario >= 0),
    id_departamento    INT,
    fecha_contratacion DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

-- Practica de ejemplo de DDL (diapositiva 14): ElectroHogar abre su
-- area de e-commerce y pide un dato nuevo en empleados.
ALTER TABLE empleados
    ADD COLUMN correo_corporativo VARCHAR(150);

-- Practica de ejemplo de "Modificadores" (diapositiva 10): nombre que
-- no se repite, stock nunca negativo, categoria existente y fecha de
-- registro automatica.
CREATE TABLE productos (
    id_producto    INT AUTO_INCREMENT PRIMARY KEY,
    nombre         VARCHAR(100)  NOT NULL UNIQUE,
    categoria      VARCHAR(50)   NOT NULL,
    precio         DECIMAL(10,2) NOT NULL,
    stock          INT           NOT NULL CHECK (stock >= 0),
    id_categoria   INT,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Reto de "Tipos de datos" (diapositiva 7-8): tabla clientes para el
-- programa de fidelizacion.
CREATE TABLE clientes (
    id_cliente         INT AUTO_INCREMENT PRIMARY KEY,
    nombre             VARCHAR(100) NOT NULL,
    email              VARCHAR(150),
    ciudad             VARCHAR(60),
    fecha_registro     DATE,
    acepta_promociones BOOLEAN
);

-- Reto de "DDL" (diapositiva 15-16), parte 1: el area comercial creo
-- por error la tabla productos_prueba. Se simula esa tabla para poder
-- resolver el reto de eliminarla por completo.
CREATE TABLE productos_prueba (
    id_prueba INT AUTO_INCREMENT PRIMARY KEY,
    nombre    VARCHAR(100)
);

-- Solucion del reto:
DROP TABLE productos_prueba;

-- Reto de "DDL" (diapositiva 15-16), parte 2: registrar el telefono de
-- cada cliente.
ALTER TABLE clientes
    ADD COLUMN telefono VARCHAR(20);

CREATE TABLE ventas (
    id_venta    INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT NOT NULL,
    id_empleado INT NOT NULL,
    fecha       DATE NOT NULL,
    total       DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE detalle_ventas (
    id_detalle      INT AUTO_INCREMENT PRIMARY KEY,
    id_venta        INT NOT NULL,
    id_producto     INT NOT NULL,
    cantidad        INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta)    REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- =====================================================================
-- SECCION 2 - Datos de ejemplo
-- =====================================================================

INSERT INTO categorias (nombre, descripcion) VALUES
    ('Tecnologia',        'Dispositivos electronicos y gadgets'),
    ('Audio y Video',     'Equipos de sonido e imagen'),
    ('Electrodomesticos', 'Linea blanca y equipos para el hogar'),
    ('Cuidado Personal',  'Electrodomesticos de cuidado personal');

INSERT INTO departamentos (nombre) VALUES
    ('Ventas'), ('Compras'), ('Recursos Humanos'),
    ('Contabilidad'), ('Sistemas'), ('E-commerce');

INSERT INTO empleados (nombre, email, salario, id_departamento) VALUES
    ('Mariana Suarez',  'mariana.suarez@electrohogar.com',  2800000.00, 1),
    ('Sebastian Ortiz', 'sebastian.ortiz@electrohogar.com', 2650000.00, 1),
    ('Camila Duarte',   'camila.duarte@electrohogar.com',   3100000.00, 2);

INSERT INTO clientes (nombre, email, ciudad, fecha_registro, acepta_promociones, telefono) VALUES
    ('Valentina Herrera', 'valentina.herrera@mail.com', 'Bogota',       '2025-03-10', TRUE,  '3101112233'),
    ('Andres Molina',     'andres.molina@mail.com',     'Bogota',       '2025-06-22', FALSE, '3102223344'),
    ('Camila Restrepo',   'camila.restrepo@mail.com',   'Medellin',     '2025-02-14', TRUE,  '3103334455'),
    ('Julian Vargas',     'julian.vargas@mail.com',     'Bogota',       '2025-08-05', TRUE,  '3104445566'),
    ('Natalia Pena',      'natalia.pena@mail.com',      'Cali',         '2025-04-18', FALSE, '3105556677'),
    ('Ricardo Salazar',   'ricardo.salazar@mail.com',   'Bogota',       '2025-09-30', TRUE,  '3106667788'),
    ('Laura Jimenez',     'laura.jimenez@mail.com',     'Bogota',       '2025-11-12', TRUE,  '3107778899'),
    ('Diego Fonseca',     'diego.fonseca@mail.com',     'Barranquilla', '2025-05-01', FALSE, '3108889900'),
    ('Monica Reyes',      'monica.reyes@mail.com',      'Bogota',       '2025-12-01', TRUE,  '3109990011');

INSERT INTO productos (nombre, categoria, precio, stock, id_categoria) VALUES
    ('Lavadora Carga Frontal 18kg',       'Electrodomesticos', 2350000.00, 12, 3),
    ('Nevera No Frost 300L',              'Electrodomesticos', 1980000.00,  8, 3),
    ('Horno Microondas Digital',          'Electrodomesticos',  420000.00, 25, 3),
    ('Televisor Smart TV 55 Pulgadas',    'Tecnologia',        1750000.00, 14, 1),
    ('Parlante Smart Bluetooth',          'Tecnologia',         320000.00, 40, 1),
    ('Portatil Ultradelgado 14 Pulgadas', 'Tecnologia',        3100000.00,  9, 1),
    ('Aspiradora Robot Smart',            'Electrodomesticos',  980000.00, 18, 3),
    ('Parlante Portatil Mini',            'Audio y Video',       95000.00, 60, 2),
    ('Audifonos Inalambricos',            'Audio y Video',      180000.00, 45, 2),
    ('Secadora de Cabello Profesional',   'Cuidado Personal',    85000.00, 70, 4),
    ('Plancha de Cabello Ceramica',       'Cuidado Personal',   120000.00, 50, 4);

-- Producto con id explicito (diapositiva 18): llega a la tienda y,
-- minutos despues, se le resta una unidad de stock en la seccion DML.
INSERT INTO productos (id_producto, nombre, categoria, precio, stock, id_categoria) VALUES
    (245, 'Refrigerador Inverter 400L', 'Electrodomesticos', 1899.90, 15, 3);

-- Producto con precio mal registrado (diapositiva 19), se corrige en DML.
INSERT INTO productos (id_producto, nombre, categoria, precio, stock, id_categoria) VALUES
    (310, 'Cable HDMI 2.1 Premium', 'Tecnologia', 45.90, 30, 1);

-- Producto descontinuado (diapositiva 19), se elimina en DML.
INSERT INTO productos (id_producto, nombre, categoria, precio, stock, id_categoria) VALUES
    (118, 'Ventilador de Techo Clasico', 'Electrodomesticos', 250000.00, 20, 3);

INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES
    (1, 1, '2026-01-05',  650000.00),
    (2, 2, '2026-01-10',  420000.00),
    (3, 1, '2026-01-18',  980000.00),
    (4, 3, '2025-12-20',  750000.00),
    (1, 2, '2026-02-03',  560000.00),
    (5, 1, '2026-01-22',  310000.00),
    (6, 3, '2026-01-27', 1250000.00),
    (2, 1, '2025-11-15',  890000.00),
    (7, 2, '2026-01-30',  505000.00),
    (3, 3, '2026-03-02',  670000.00);

-- Detalle ilustrativo de algunas ventas, para completar el modelo del
-- caso de estudio (los montos son independientes del total de
-- cabecera; ninguna consulta de la sesion pregunta por detalle_ventas).
INSERT INTO detalle_ventas (id_venta, id_producto, cantidad, precio_unitario) VALUES
    (1, 5,  1, 320000.00),
    (1, 9,  1, 180000.00),
    (2, 8,  2,  95000.00),
    (3, 7,  1, 980000.00),
    (5, 10, 1,  85000.00),
    (5, 11, 1, 120000.00),
    (7, 5,  1, 320000.00),
    (9, 3,  1, 420000.00);

-- =====================================================================
-- SECCION 3 - DML: manipulacion de datos
-- =====================================================================

-- Practica de ejemplo (diapositiva 18): reflejar en el inventario la
-- venta de una unidad del producto 245.
SELECT id_producto, stock FROM productos WHERE id_producto = 245;
UPDATE productos SET stock = stock - 1 WHERE id_producto = 245;
SELECT id_producto, stock FROM productos WHERE id_producto = 245;

-- Reto (diapositiva 19-20): el producto 310 deberia costar 549.00 y no
-- 45.90; el producto 118 esta descontinuado.
SELECT * FROM productos WHERE id_producto = 310;   -- confirma la fila antes de corregir
UPDATE productos SET precio = 549.00 WHERE id_producto = 310;
SELECT * FROM productos WHERE id_producto = 310;   -- confirma el cambio

SELECT * FROM productos WHERE id_producto = 118;   -- confirma que es exactamente la fila a eliminar
DELETE FROM productos WHERE id_producto = 118;

-- =====================================================================
-- SECCION 4 - DQL: consulta de datos
-- =====================================================================

-- Practica de ejemplo (diapositiva 22): productos con poco stock
-- (menos de 10 unidades) para generar un nuevo pedido a proveedores.
SELECT nombre, stock, precio
FROM productos
WHERE stock < 10
ORDER BY stock ASC;

-- Reto (diapositiva 23-24): 5 clientes mas recientes de Bogota.
SELECT nombre, fecha_registro
FROM clientes
WHERE ciudad = 'Bogota'
ORDER BY fecha_registro DESC
LIMIT 5;

-- =====================================================================
-- SECCION 5 - Operadores
-- =====================================================================

-- Practica de ejemplo (diapositiva 26): ventas superiores a $500.000
-- realizadas durante enero de 2026, para el cierre mensual de Contabilidad.
SELECT id_venta, fecha, total
FROM ventas
WHERE total > 500000
  AND fecha BETWEEN '2026-01-01' AND '2026-01-31'
ORDER BY fecha;

-- Reto (diapositiva 27-28): productos de Electrodomesticos o Tecnologia
-- cuyo nombre contenga la palabra "Smart", para una campana de Marketing.
SELECT nombre, precio, categoria
FROM productos
WHERE categoria IN ('Electrodomesticos', 'Tecnologia')
  AND nombre LIKE '%Smart%';

-- =====================================================================
-- SECCION 6 - Agrupacion y agregacion
-- =====================================================================

-- Practica de ejemplo (diapositiva 30): total vendido por cada
-- empleado, para calcular comisiones del mes.
SELECT
    id_empleado,
    COUNT(*)   AS num_ventas,
    SUM(total) AS total_vendido
FROM ventas
GROUP BY id_empleado
ORDER BY total_vendido DESC;

-- Reto (diapositiva 31-32): categorias cuyo precio promedio de producto
-- supera los $300.000, para revisar la estrategia de precios.
SELECT
    id_categoria,
    AVG(precio) AS precio_promedio
FROM productos
GROUP BY id_categoria
HAVING AVG(precio) > 300000;
