create database atv_trigger;
use atv_trigger;
CREATE TABLE produtos (
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
preco DECIMAL(10,2),
estoque INT
);
CREATE TABLE clientes (
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100),
email VARCHAR(100) UNIQUE
);
CREATE TABLE log_eventos (
id INT PRIMARY KEY AUTO_INCREMENT,
entidade VARCHAR(50),
acao VARCHAR(20),
descricao TEXT,
data_evento DATETIME DEFAULT CURRENT_TIMESTAMP
);
-- a
-- BEFORE antes/ AFTER depois
CREATE TRIGGER insert_produtos -- criar a triger
AFTER INSERT ON produtos -- e depois inserir dentro de produtos

BEGIN 
    INSERT INTO log_eventos (entidade, acao, descricao) -- inserir dentro de INSERT INTO
    VALUES ('produtos', 'INSERT', CONCAT('Produto cadastrado: ', NEW.nome, 'Preço: ', NEW.preco)); 
END;

-- b) Log do cadastro de clientes
CREATE TRIGGER insert_clientes 
AFTER INSERT ON clientes 
FOR EACH ROW
BEGIN
    INSERT INTO log_eventos (entidade, acao, descricao)
    VALUES ('clientes', 'INSERT', CONCAT('Cliente cadastrado: ', NEW.nome, ' | Email: ', NEW.email));
END;

-- c) Log da exclusão de produtos
CREATE TRIGGER delete_produtos
BEFORE DELETE ON produtos
FOR EACH ROW
BEGIN
    INSERT INTO log_eventos (entidade, acao, descricao)
    VALUES ('produtos', 'DELETE', CONCAT('Produto excluído: ', OLD.nome, ' | Preço: R$ ', OLD.preco));
END;

-- d) Log da exclusão de clientes
CREATE TRIGGER delete_clientes
BEFORE DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO log_eventos (entidade, acao, descricao)
    VALUES ('clientes', 'DELETE', CONCAT('Cliente excluído: ', OLD.nome, ' | Email: ', OLD.email));
END;
