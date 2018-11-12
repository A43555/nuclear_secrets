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

SELECT * FROM Conferencia
SELECT * FROM Registo

DELETE FROM _Registo
DELETE FROM Conferencia