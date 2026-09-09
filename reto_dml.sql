INSERT INTO productos (nombre, precio, stock, id_categoria)
VALUES ('Refrigerador Inverter 400L', 1899.90, 15, 3);

UPDATE productos
SET stock = stock - 1
WHERE id_producto = 245;

