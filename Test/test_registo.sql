USE Conferencias_DB
--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbina@email.com', 'Matumbina Pito Largo', 'Instituicao 1')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2010, 'C1', 'matumbino@email.com', '2010-01-01', '2010-12-01')


--Ao criar uma conferencia o utilizador presidente esta automaticamente registado como 'presidente'
SELECT * FROM Registo

--Regista um utilizador e falha a tentativa de registar outro como presidente
INSERT INTO Registo(email, nome_conferencia, ano_conferencia, posicao)
	VALUES('tiburcio@email.com', 'Conferencia 1', 2010, 'utilizador')
INSERT INTO Registo(email, nome_conferencia, ano_conferencia, posicao)
	VALUES('matumbina@email.com', 'Conferencia 1', 2010, 'presidente')
SELECT * FROM Registo

--Apagar um registo
DELETE FROM Registo WHERE email = 'tiburcio@email.com' AND nome_conferencia = 'Conferencia 1' AND ano_conferencia = 2010
SELECT * FROM Registo

-- Fazer update a um presidente de uma conferencia
UPDATE Conferencia SET email_presidente = 'tiburcio@email.com' WHERE nome = 'Conferencia 1' AND ano = 2010
SELECT * FROM Registo

-- falhar a tentativa de apagar o registo do presidente
DELETE FROM Registo WHERE email = 'tiburcio@email.com' AND nome_conferencia = 'Conferencia 1' AND ano_conferencia = 2010
SELECT * FROM Registo


--Finalizacao
DELETE FROM _Registo
DELETE FROM _Conferencia
DELETE FROM _Utilizador
DELETE FROM _Instituicao