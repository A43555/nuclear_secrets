USE Conferencias_DB

INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
--INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES
	('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1'), 
	('matumbina@email.com', 'Matumbina Pito Largo', 'Instituicao 1'),
	('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')


INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo)
	VALUES ('Conf 1', 2010, 'C1', 'tiburcio@email.com', '2010-01-01', '2010-02-01'),
	('Conf 2', 2010, 'C2', 'tiburcio@email.com', '2010-01-01', '2010-02-01')

INSERT INTO _Artigo(id,nome_conferencia,ano_conferencia,resumo,estado,dataSubmissao) VALUES
	(1,'Conf 1',2010,'ffff','aceite','11-11-1111')


INSERT INTO _Registo(id_utilizador,nome_conferencia,ano_conferencia,posicao) VALUES (2, 'Conf 1',2010,'autor')

SELECT * FROM Conferencia
SELECT * FROM Registo
UPDATE Conferencia SET email_presidente = 'matumbina@email.com' WHERE nome = 'Conf 1'
SELECT * FROM Conferencia
SELECT * FROM Registo
DELETE FROM Conferencia
SELECT * FROM Conferencia 
SELECT * FROM Registo

DELETE FROM _Artigo