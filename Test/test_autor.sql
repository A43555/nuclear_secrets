USE Conferencias_DB

--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbina@email.com', 'Matumbina Pito Largo', 'Instituicao 1')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2018, 'C1', 'matumbino@email.com', '2018-12-01', '2018-12-31')
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (1, 'Resumo test', 'em revisao', 'Conferencia 1', 2018, '2018-01-01')
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (2, 'Resumo test', 'em revisao', 'Conferencia 1', 2018, '2018-12-03')
SELECT * FROM Artigo

--Cria 2 Autores
INSERT INTO Autor (email_autor, id_artigo)
	VALUES ('tiburcio@email.com', 1)
INSERT INTO Autor (email_autor, id_artigo)
	VALUES ('matumbina@email.com', 2)

--Finaliza