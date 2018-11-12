USE Conferencias_DB

--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbina@email.com', 'Matumbina Pito Largo', 'Instituicao 1')

--Cria duas Conferencias
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2010, 'C1', 'matumbino@email.com', '2010-01-01', '2010-12-01')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 2', 2011, 'C2', 'tiburcio@email.com', '2011-01-01', '2011-12-01')
SELECT * FROM Conferencia

--Faz Update ao presidente da conferencia 1
UPDATE Conferencia SET email_presidente = 'matumbina@email.com' WHERE nome = 'Conferencia 1' AND ano = 2010
SELECT * FROM Conferencia

--Insere um Artigo na Conferencia 2, fazendo assim com que seja impossivel apaga-la
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (1, 'Resumo test', 'em revisao', 'Conferencia 2', 2011, '2010-12-01')
DELETE FROM Conferencia WHERE nome = 'Conferencia 2' AND ano = 2011
SELECT * FROM Conferencia

--Apaga a Conferencia 1
DELETE FROM Conferencia WHERE nome = 'Conferencia 1' AND ano = 2010
SELECT * FROM Conferencia

--Finaliza
DELETE FROM Artigo WHERE id = 1
DELETE FROM Conferencia WHERE nome = 'Conferencia 2' AND ano = 2011
SELECT * FROM Conferencia