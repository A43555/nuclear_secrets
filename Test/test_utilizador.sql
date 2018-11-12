USE Conferencias_DB
--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')

--Cria Utilizador
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
SELECT * FROM Utilizador

--Apaga um utilizador que nao esta em uso
DELETE FROM Utilizador WHERE email = 'tiburcio@email.com'
SELECT * FROM Utilizador

--Cria Conferencia
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2010, 'C1', 'matumbino@email.com', '2010-01-01', '2010-12-01')

--Tentativa de apagar um Utilizador numa Conferencia
DELETE FROM Conferencia WHERE nome = 'Conferencia 1' AND ano = 2010
DELETE FROM Utilizador WHERE email = 'matumbino@email.com'
SELECT * FROM Utilizador

--Finalizacao
DELETE FROM Instituicao WHERE nome = 'Instituicao 1'