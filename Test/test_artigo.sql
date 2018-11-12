USE Conferencias_DB

--Inicia
INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2018, 'C1', 'matumbino@email.com', '2018-12-01', '2018-12-31')

--Cria um Artigo
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (1, 'Resumo test', 'em revisao', 'Conferencia 1', 2018, '2018-01-01')
INSERT INTO Artigo(id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao)
	VALUES (2, 'Resumo test', 'em revisao', 'Conferencia 1', 2018, '2018-12-03')
SELECT * FROM Artigo

--Faz Update ao Artigo 1
UPDATE Artigo SET resumo = 'Novo Resumo', estado = 'aceite' WHERE id = 1
SELECT * FROM Artigo

--Tenta apagar um Artigo em uso
DELETE FROM Artigo WHERE id = 2
SELECT * FROM Artigo

--Apaga um Artigo que nao esta em uso
DELETE FROM Artigo WHERE id = 1
SELECT * FROM Artigo

--Finaliza
DELETE FROM Artigo WHERE id = 2