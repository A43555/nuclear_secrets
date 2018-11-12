USE Conferencias_DB

INSERT INTO Instituicao(nome, pais, morada) VALUES ('Instituicao 1', 'Portugal', 'Rua X')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('matumbino@email.com', 'Matumbino Chota Grande', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Utilizador(email, nome, nome_instituicao) VALUES('tiburcio222@email.com', 'Tiburcio Balde', 'Instituicao 1')
INSERT INTO Conferencia(nome, ano, acronimo, email_presidente, limiteSubArtigo, limiteRevArtigo) 
	VALUES('Conferencia 1', 2018, 'C1', 'matumbino@email.com', '2018-12-01', '2018-12-31')

Exec Add_Artigo
	@email_autor = 'tiburcio@email.com',
	@id_artigo = 1,
	@id_ficheiro = 1,
	@texto_ficheiro = 'Nothing',
	@resumo_artigo = 'Resumo',
	@estado_artigo = 'em revisao',
	@nome_conferencia  = 'Conferencia 1',
	@ano_conferencia = 2018,
	@data_sublissao_artigo = '2018-01-01'

UPDATE Artigo SET resumo = 'Novo Resumo', estado = 'aceite', dataSubmissao = '2018-02-01' WHERE id = 1


INSERT INTO Autor(email_autor,id_artigo) VALUES ('tiburcio222@email.com',1)

DELETE FROM Instituicao
DELETE FROM Utilizador
DELETE FRom Conferencia
DELETE FROM _Registo


DELETE FROM Artigo

USE Conferencias_DB
DELETE FROM Artigo

SELECT * FROM Instituicao

SELECT * FROM Utilizador

SELECT * FROM Conferencia

SELECT * FROM Registo

SELECT * FROM Artigo

SELECT * FROM Autor

SELECT * FROM Revisor