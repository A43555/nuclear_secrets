USE Conferencias_DB
--Inicia
--Insere 3 Instituicoes
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 2', 'Portugal', 'Rua Y')
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 3', 'Portugal', 'Rua Z')
SELECT * FROM Instituicao

--Faz update a Instituicao 1, e apaga a instituicao 3
DELETE FROM Instituicao WHERE nome = 'Instituicao 3'
UPDATE Instituicao SET morada = 'Rua A' WHERE nome = 'Instituicao 1'
SELECT * FROM Instituicao

--Tentativa de apagar a Instituicao 2, no entanto esta esta a ser utilizada
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 2')
DELETE FROM Instituicao WHERE nome = 'Instituicao 2'
SELECT * FROM Instituicao

--Apaga a Instituicao 2, pois esta ja nao esta a ser utilizada
DELETE FROM Utilizador WHERE email = 'matumbino@email.com'
DELETE FROM Instituicao WHERE nome = 'Instituicao 2'
SELECT * FROM Instituicao

--Finalizacao
DELETE FROM Instituicao WHERE nome = 'Instituicao 1'