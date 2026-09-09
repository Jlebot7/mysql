-- ==========================================================
-- RETO: Creación de la tabla 'empleados' para ElectroHogar
-- ==========================================================

-- 1. Tabla referencial 'departamentos' (requerida para la llave foránea)
CREATE TABLE IF NOT EXISTS departamentos (
    id_departamento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- 2. Tabla 'empleados' con todas las restricciones solicitadas
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    salario DECIMAL(10, 2) CHECK (salario >= 0),
    id_departamento INT NOT NULL,
    fecha_contratacion DATE NOT NULL,
    CONSTRAINT fk_empleado_departamento 
        FOREIGN KEY (id_departamento) 
        REFERENCES departamentos(id_departamento)
);

