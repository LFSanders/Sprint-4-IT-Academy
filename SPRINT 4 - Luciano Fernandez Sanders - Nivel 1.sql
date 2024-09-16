-- drop database transactions_2;

-- Creo la base de datos
CREATE DATABASE transactions_2; -- Le voy a llamar a esta base de datos transactions_2
USE transactions_2; -- Indico que voy a usar esta base de datos

-- Creo la tabla transaction
   CREATE TABLE IF NOT EXISTS transaction (
        id VARCHAR(255) NOT NULL PRIMARY KEY,
        credit_card VARCHAR(15) NULL,
        company_id VARCHAR(20) NULL,
        timestamp TIMESTAMP NULL,
		amount DECIMAL(10, 2) NULL,
        declined BOOLEAN NULL,
        product_ids VARCHAR(15) NULL,
        user_id INT NULL, 
        lat FLOAT null,
        longitude FLOAT null
        
        );

    CREATE TABLE IF NOT EXISTS company (
        id VARCHAR(15) PRIMARY KEY,
        company_name VARCHAR(255) ,
        phone VARCHAR(15) ,
        email VARCHAR(100) ,
        country VARCHAR(100) ,
        website VARCHAR(255) 
    );


        
	CREATE TABLE IF NOT EXISTS credit_card (
		id VARCHAR(100) PRIMARY KEY,
        user_id INT,
		iban VARCHAR(50) NOT NULL,
		pan VARCHAR(100),
		pin INT,
		cvv SMALLINT,
        track1 VARCHAR(255),
        track2 VARCHAR(255),
		expiring_date VARCHAR(10)
    );
    
    #Creo las 3 tablas de user
    
    CREATE TABLE IF NOT EXISTS user_usa (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );
    
	CREATE TABLE IF NOT EXISTS user_uk (
        id INT PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );

	CREATE TABLE IF NOT EXISTS user_ca (
        id VARCHAR(10) PRIMARY KEY,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255)
    );
    
    #Creo una tabla que sea de users all para introducir todos los datos de las 3 tablas de users que tengo. Asi tengo una tabla general que la podre relacionar efectivamente
    #Con la tabla transaction 
    
	CREATE TABLE IF NOT EXISTS users_all (
        id INT auto_increment,
        name VARCHAR(100),
        surname VARCHAR(100),
        phone VARCHAR(150),
        email VARCHAR(150),
        birth_date VARCHAR(100),
        country VARCHAR(150),
        city VARCHAR(150),
        postal_code VARCHAR(100),
        address VARCHAR(255),
        PRIMARY KEY(ID)
    );
    
    #Luego la tabla products
	CREATE TABLE IF NOT EXISTS products (
        id INT PRIMARY KEY,
        product_name VARCHAR(100),
        price DECIMAL(10,2),
        colour VARCHAR(100),
        weight FLOAT,
        warehouse_id VARCHAR(255)
	);


/*Una vez creadas todas las tablas, empezaremos con la carga de los csv,
luego de cargar los datos, haremos la relacion de las tablas 
*/

SHOW VARIABLES LIKE "secure_file_priv";


#Aqui la separacion no es por comas, es por punto y coma...
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\transactions.csv"
INTO TABLE transaction
FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

SELECT * 
FROM transaction;  -- Comprobamos que haya cargado con exito.

LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\companies.csv" 
INTO TABLE company
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT * 
FROM company;  -- Comprobamos que haya cargado con exito.

#Cargado correctamente
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\credit_cards.csv"
INTO TABLE credit_card
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT * 
FROM credit_card;  -- Comprobamos que haya cargado con exito.


#En este caso los datos de la tabla products, en el campo 'price' estaban con el signo $(dolar) y no se puede insertar un signo dolar dentro de un campo DECIMAL 
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\products.csv"
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT * 
FROM products;  -- Comprobamos que haya cargado con exito.


#Aqui lo que paso es que, como tengo el campo birth_date entre comillas, supongo(no lo se), que solamente toma una sola vez las (" ") y lo que hice fue,
#Dentro del archivo de csv de users_ca, borrar manualmente las comillas y las comas que habia dentro del campo ADRESS, asi pude cargar el archivo csv
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\users_ca.csv"
INTO TABLE user_ca
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
IGNORE 1 LINES;

SELECT * 
FROM user_ca;  -- Comprobamos que haya cargado con exito.


#Lo mismo con users_uk
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\users_uk.csv"
INTO TABLE user_uk
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

SELECT * 
FROM user_uk; -- Comprobamos que haya cargado con exito.
 
LOAD DATA INFILE "C:\\ProgramData\\MySQL\\MySQL Server 9.0\\Uploads\\users_usa.csv"
INTO TABLE user_usa
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES;

SELECT * 
FROM user_usa; -- Comprobamos que haya cargado con exito.

-- Una vez cargado con exito los csv, procedere a cargar con datos la tabla que cree que se llama user_all para poder relacionar estas tablas con la tabla transaction.

-- Insertar los usuarios de United States
INSERT INTO users_all (id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SELECT id, name, surname, phone, email, birth_date, 'United States' AS country, city, postal_code, address
FROM user_usa;


-- Insertar los usuarios de United Kingdom
INSERT INTO users_all (id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SELECT id, name, surname, phone, email, birth_date, 'United Kingdom' AS country, city, postal_code, address
FROM user_uk;


-- Insertar los usuarios de Canada
INSERT INTO users_all (id, name, surname, phone, email, birth_date, country, city, postal_code, address)
SELECT id, name, surname, phone, email, birth_date, 'Canada' AS country, city, postal_code, address
FROM user_ca;



-- Comprobamos -- 

SELECT *
FROM users_all
order by id asc;


#Una vez que cargue los datos, empezare a relacionar las tablas

-- credit_card
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card
FOREIGN KEY (credit_card)
REFERENCES credit_card(id);

-- company
ALTER TABLE transaction
ADD CONSTRAINT fk_company
FOREIGN KEY (company_id)
REFERENCES company(id);

-- users
ALTER TABLE transaction
ADD CONSTRAINT fk_users_all
FOREIGN KEY (user_id)
REFERENCES users_all(id);

-- Ejercicio 1 Realice una subconsulta que muestre a todos los usuarios con más de 30 transacciones utilizando al menos 2 tablas.
SELECT *
FROM users_all
WHERE id IN (
    SELECT user_id
    FROM transaction
    GROUP BY user_id
    HAVING COUNT(company_id) > 30
);
-- Los usuarios que tienen mas de 30 transacciones son con el id 92,267,272,275 -- 

-- Ejercicio 2 Muestra el promedio del propietario de la tarjeta de crédito IBAN en Donec Ltd, utiliza al menos 2 tablas.

SELECT avg(amount), credit_card.iban
FROM transaction
JOIN company
ON transaction.company_id = company.id
JOIN credit_card 
ON transaction.credit_card = credit_card.id
JOIN users_all
ON credit_card.user_id = users_all.id
WHERE company.company_name = "Donec ltd"
GROUP BY credit_card.iban;

SELECT *
FROM transaction
WHERE company_id = "b-2242";

SELECT avg(amount), credit_card.iban
FROM transaction
JOIN company
ON transaction.company_id = company.id
JOIN credit_card 
ON transaction.credit_card = credit_card.id
JOIN users_all
ON credit_card.user_id = users_all.id
WHERE company.company_name = "Donec ltd" and declined = 0
GROUP BY credit_card.iban;




















    


    
    
