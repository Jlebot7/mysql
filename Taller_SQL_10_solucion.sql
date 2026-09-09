-- =====================================================================
-- TALLER PRACTICO DE SQL - TechStore
-- Solucion de los 10 ejercicios de "Taller_SQL_10.pdf"
-- Motor: MySQL 8.0+
--
-- Orden de las secciones = orden de los ejercicios del documento.
-- Cada bloque usa los datos generados en los ejercicios anteriores,
-- tal como pide la consigna general del taller.
-- =====================================================================

-- ---------------------------------------------------------------------
-- EJERCICIO 01 - Construir la base
-- Crear la base de datos y las 3 tablas relacionadas con sus llaves.
-- ---------------------------------------------------------------------
DROP DATABASE IF EXISTS techstore;
CREATE DATABASE techstore;
USE techstore;

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(60)   NOT NULL,
    categoria   VARCHAR(50)   NOT NULL,
    precio      DECIMAL(10,2) NOT NULL,
    stock       INT           NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre     VARCHAR(100) NOT NULL,
    email      VARCHAR(150) NOT NULL,
    ciudad     VARCHAR(60)  NOT NULL
);

CREATE TABLE ventas (
    id_venta    INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT  NOT NULL,
    id_producto INT  NOT NULL,
    cantidad    INT  NOT NULL,
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (id_cliente)  REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ---------------------------------------------------------------------
-- EJERCICIO 02 - Modificar una estructura
-- Registrar telefono en clientes y ampliar el tamano de nombre en
-- productos, sin recrear ninguna tabla.
-- ---------------------------------------------------------------------
ALTER TABLE clientes
    ADD COLUMN telefono VARCHAR(20);

ALTER TABLE productos
    MODIFY COLUMN nombre VARCHAR(120) NOT NULL;

-- ---------------------------------------------------------------------
-- EJERCICIO 03 - Cargar productos y clientes
-- Minimo 8 productos y 6 clientes; varias categorias, ciudades y
-- rangos de precio se repiten a proposito.
-- ---------------------------------------------------------------------
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
    ('Mouse Inalambrico Ergonomico',      'Perifericos',     45000.00, 120),
    ('Teclado Mecanico RGB',              'Perifericos',    189000.00,  60),
    ('Monitor Curvo 27 Pulgadas',         'Monitores',      890000.00,  25),
    ('Monitor LED 24 Pulgadas',           'Monitores',      560000.00,  40),
    ('Computador de Escritorio Ryzen 5',  'Computadores',  2350000.00,  15),
    ('Disco Solido SSD 1TB',              'Almacenamiento', 320000.00,  80),
    ('Memoria RAM 16GB DDR4',             'Componentes',    210000.00,  95),
    ('Audifonos Bluetooth Smart Sound',   'Audio',          150000.00,  55),
    ('Cargador Universal USB-C',          'Accesorios',      35000.00, 200);

INSERT INTO clientes (nombre, email, ciudad, telefono) VALUES
    ('Laura Gomez',    'laura.gomez@correo.com',    'Bucaramanga', '3001234567'),
    ('Carlos Ramirez', 'carlos.ramirez@correo.com', 'Bogota',      '3012345678'),
    ('Ana Torres',     'ana.torres@correo.com',     'Medellin',    '3023456789'),
    ('Jorge Pena',     'jorge.pena@correo.com',     'Cali',        '3034567890'),
    ('Diana Rojas',    'diana.rojas@correo.com',    'Cucuta',      '3045678901'),
    ('Andres Blanco',  'andres.blanco@correo.com',  'Bucaramanga', '3056789012');

-- ---------------------------------------------------------------------
-- EJERCICIO 04 - Registrar ventas con sentido
-- Minimo 12 ventas usando ids existentes; clientes y productos se
-- repiten; cantidades positivas y fechas razonables.
-- ---------------------------------------------------------------------
-- Pista aplicada: antes de insertar, se comprueba que los ids existen.
SELECT id_cliente, nombre FROM clientes;
SELECT id_producto, nombre FROM productos;

INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
    (1, 1, 2, '2025-01-10'),
    (2, 2, 1, '2025-01-12'),
    (3, 3, 1, '2025-01-15'),
    (1, 4, 1, '2025-01-20'),
    (4, 5, 1, '2025-02-02'),
    (5, 6, 3, '2025-02-05'),
    (6, 7, 2, '2025-02-10'),
    (2, 1, 1, '2025-02-14'),
    (3, 9, 4, '2025-02-18'),
    (1, 6, 1, '2025-03-01'),
    (4, 2, 2, '2025-03-05'),
    (5, 4, 1, '2025-03-08'),
    (6, 8, 1, '2025-03-12'),
    (2, 9, 2, '2025-03-15');

-- ---------------------------------------------------------------------
-- EJERCICIO 05 - Corregir y eliminar con seguridad
-- ---------------------------------------------------------------------
-- 5.1 Corregir el precio de un producto concreto (quedo mal registrado).
SELECT * FROM productos WHERE id_producto = 3;                 -- verificar antes
UPDATE productos SET precio = 950000.00 WHERE id_producto = 3;
SELECT * FROM productos WHERE id_producto = 3;                 -- verificar despues

-- 5.2 Ajustar el stock de otro producto tras una venta
--     (venta 6: 3 unidades del Disco Solido SSD, id_producto = 6).
SELECT id_producto, stock FROM productos WHERE id_producto = 6;
UPDATE productos SET stock = stock - 3 WHERE id_producto = 6;
SELECT id_producto, stock FROM productos WHERE id_producto = 6;

-- 5.3 Eliminar un registro creado por error (producto duplicado).
INSERT INTO productos (nombre, categoria, precio, stock)
VALUES ('Mouse Inalambrico Ergonomico DUPLICADO', 'Perifericos', 45000.00, 120);

SELECT * FROM productos WHERE nombre = 'Mouse Inalambrico Ergonomico DUPLICADO'; -- confirma que es 1 sola fila
DELETE FROM productos WHERE nombre = 'Mouse Inalambrico Ergonomico DUPLICADO';

-- ---------------------------------------------------------------------
-- EJERCICIO 06 - Primera exploracion
-- ---------------------------------------------------------------------
-- Ver todos los productos
SELECT * FROM productos;

-- Mostrar solo nombre y precio
SELECT nombre, precio FROM productos;

-- Presentar el precio con un alias mas comprensible
SELECT nombre, precio AS precio_unitario FROM productos;

-- ---------------------------------------------------------------------
-- EJERCICIO 07 - Filtrar por una condicion
-- ---------------------------------------------------------------------
-- Productos con precio superior a un umbral
SELECT * FROM productos WHERE precio > 500000;

-- Clientes de una ciudad concreta
SELECT * FROM clientes WHERE ciudad = 'Bucaramanga';

-- Productos de una categoria determinada
SELECT * FROM productos WHERE categoria = 'Perifericos';

-- ---------------------------------------------------------------------
-- EJERCICIO 08 - Combinar condiciones
-- ---------------------------------------------------------------------
-- Categoria concreta Y precio por debajo de cierto valor
SELECT * FROM productos WHERE categoria = 'Perifericos' AND precio < 100000;

-- Clientes de dos ciudades posibles
SELECT * FROM clientes WHERE ciudad = 'Bogota' OR ciudad = 'Medellin';

-- ---------------------------------------------------------------------
-- EJERCICIO 09 - Buscar por rangos y texto
-- ---------------------------------------------------------------------
-- Productos dentro de un rango de precios
SELECT * FROM productos WHERE precio BETWEEN 100000 AND 400000;

-- Productos de un conjunto de categorias
SELECT * FROM productos WHERE categoria IN ('Perifericos', 'Audio', 'Accesorios');

-- Productos cuyo nombre contenga una palabra indicada
SELECT * FROM productos WHERE nombre LIKE '%Monitor%';

-- ---------------------------------------------------------------------
-- EJERCICIO 10 - Ordenar resultados
-- ---------------------------------------------------------------------
-- Del mas barato al mas caro
SELECT * FROM productos ORDER BY precio ASC;

-- Del mayor stock al menor
SELECT * FROM productos ORDER BY stock DESC;

-- Combinando un filtro con un ordenamiento
SELECT * FROM productos WHERE categoria = 'Perifericos' ORDER BY precio ASC;
