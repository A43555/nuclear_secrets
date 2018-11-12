USE Conferencias_DB

--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbina@email.com', 'Matumbina Pito Largo', 'Instituicao 1')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2010, 'C1', 'matumbino@email.com', '2018-01-01', '2018-12-01')
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (1, 'Resumo test', 'em revisao', 'Conferencia 1', 2018, '2018-01-01')

--Cria 2 Reviasoes
INSERT INTO Revisao(id_artigo, email_revisor, texto, nota, dataRevisao)
	VALUES (1, 'matumbina@email.com', 'Revisao do artigo 1', 50, '2018-03-01')
INSERT INTO Revisao(id_artigo, email_revisor, texto, nota, dataRevisao)
	VALUES (1, 'tiburcio@email.com', 'Revisao do artigo 1', 75, '2018-04-01')

--Update a Revisao do Tiburcio
UPDATE Revisao SET texto = 'Nova revisao', nota = 60, dataRevisao = '2018-05-01'

