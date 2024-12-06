/*
Estudiante: Xandher Benavides
Evaluación: Taller 10%
Profesor: Julio Castillo
*/

-- CREACIÓN DE LA BASE DE DATOS
	DROP DATABASE IF EXISTS libreria;
	CREATE DATABASE libreria;
	USE libreria;

-- CREACIÓN DE LAS TABLAS
	CREATE TABLE IF NOT EXISTS libros(
		id_libro INT NOT NULL AUTO_INCREMENT,
		titulo VARCHAR(100),
		autor VARCHAR(50),
		precio DECIMAL (10, 2),
        	stock INT,
		anno INT,
		editorial VARCHAR(100),
		PRIMARY KEY(id_libro)
	) ENGINE=INNODB;

	CREATE TABLE IF NOT EXISTS control(
		id INT NOT NULL AUTO_INCREMENT,
		fecha DATE,
		hora TIME,
		usuario VARCHAR(50),
		libro_afectado INT,
		nuevo_precio DECIMAL (10, 2),
		precio_anterior DECIMAL (10, 2),
		PRIMARY KEY(id)
	) ENGINE=INNODB;

-- CREAMOS UN PROCEDIMIENTO ALMACENADO PARA INSERTAR LOS LIBROS
	DELIMITER $
		CREATE PROCEDURE insertar_libro(
			IN p_titulo VARCHAR(100),
			IN p_autor VARCHAR(50),
			IN p_precio DECIMAL (10, 2),
	        	IN p_stock INT,
			IN p_anno INT,
			IN p_editorial VARCHAR(100)
		)
		BEGIN
			INSERT INTO libros(titulo, autor, precio, stock, anno, editorial)
				VALUES(p_titulo, p_autor, p_precio, p_stock, p_anno, p_editorial);
		END $$
	DELIMITER ;

-- LLAMAMOS AL PROCEDIMIENTO ALMACENADO PARA INSERTAR LOS LIBROS
	CALL insertar_libro('Don Quijote de la Mancha', 'Miguel de Cervantes', 15.99, 5, 1605, 'Francisco de Robles');
	CALL insertar_libro('Cien años de soledad', 'Gabriel García Márquez', 20.50, 11, 1967, 'Editorial Sudamericana');
	CALL insertar_libro('Matar a un ruiseñor', 'Harper Lee', 18.75, 20, 1960, 'J.B. Lippincott & Co.');
	CALL insertar_libro('El gran Gatsby', 'F. Scott Fitzgerald', 22.99, 7, 1925, 'Charles Scribner\'s Sons'); -- SE UTILIZA \ PARA HACER ESCAPAR LA COMILLA SIMPLE SIGUIENTE
	CALL insertar_libro('Orgullo y prejuicio', 'Jane Austen', 30.00, 4, 1813, 'T. Egerton, Whitehall');
	CALL insertar_libro('Crimen y castigo', 'Fyodor Dostoyevsky', 15.45, 2, 1866, 'The Russian Messenger');
	CALL insertar_libro('El hobbit', 'J.R.R. Tolkien', 28.20, 13, 1937, 'George Allen & Unwin');
	CALL insertar_libro('Jane Eyre', 'Charlotte Brontë', 21.00, 5, 1847, 'Smith, Elder & Co.');
	CALL insertar_libro('El viejo y el mar', 'Ernest Hemingway', 17.50, 8, 1952, 'Charles Scribner\'s Sons');
	CALL insertar_libro('1984', 'George Orwell', 24.99, 7, 1949, 'Secker & Warburg');
	CALL insertar_libro('El principito', 'Antoine de Saint-Exupéry', 20.00, 9, 1943, 'Reynal & Hitchcock');
	CALL insertar_libro('La sombra del viento', 'Carlos Ruiz Zafón', 24.75, 17, 2001, 'Editorial Planeta');
	CALL insertar_libro('Drácula', 'Bram Stoker', 26.99, 6, 1897, 'Archibald Constable and Company');
	CALL insertar_libro('Harry Potter y la piedra filosofal', 'J.K. Rowling', 23.50, 14, 1997, 'Bloomsbury');
	CALL insertar_libro('El nombre de la rosa', 'Umberto Eco', 22.50, 6, 1980, 'Bompiani');

    	SELECT * FROM libros;
    
-- CREAMOS EL DISPARADOR PARA QUE CUANDO SE ACTUALICE EL PRECIO EN LA TABLA LIBROS, SE GUARDE EL PRECIO ANTERIOR EN LA TABLA CONTROL
    	DELIMITER $$ 
		CREATE TRIGGER upd_precio AFTER UPDATE ON libros
			FOR EACH ROW
				BEGIN 
					IF NEW.precio != OLD.precio THEN 
						INSERT INTO control(fecha, hora, usuario, libro_afectado, nuevo_precio, precio_anterior)
						VALUES(CURDATE(), CURTIME(), CURRENT_USER(), OLD.id_libro, NEW.precio, OLD.precio);
					END IF;
				END $$
	DELIMITER ;
        -- USAMOS DELIMITER PARA PERMITIR ; DENTRO DEL CUERPO DEL TRIGGER
        -- SE AÑADIÓ UN BLOQUE COMPLETO BEGIN/END PARA ENVOLVER LA SENTENCIA IF
        -- AGREGAMOS UN CONDICIONAL PARA ESPECIFICAR QUE SOLO SE ACTIVE CUANDO ES MODIFICADO EL CAMPO DE PRECIO
        
-- PROBAMOS QUE FUNCIONE CORRECTAMENTE
	UPDATE libros SET precio=100.99 WHERE id_libro=1;
	SELECT * FROM libros;
    	SELECT * FROM control;
	
    	UPDATE libros SET precio=77.99 WHERE id_libro=5;
	SELECT * FROM libros;
    	SELECT * FROM control;
    
