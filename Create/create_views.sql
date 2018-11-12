USE Conferencias_DB

-------------------------(INSTITUICAO)-------------------------
IF( OBJECT_ID('Instituicao') IS NOT NULL) DROP VIEW Instituicao 
GO
CREATE VIEW Instituicao
AS
	SELECT 
		nome,
		pais,
		morada
	FROM _Instituicao
GO
-------------------------(UTILIZADOR)-------------------------
IF( OBJECT_ID('Utilizador') IS NOT NULL) DROP VIEW Utilizador 
GO
CREATE VIEW Utilizador
AS
	SELECT
		email,
		nome,
		nome_instituicao
	FROM _Utilizador
GO
-------------------------(CONFERENCIA)-------------------------
IF( OBJECT_ID('Conferencia') IS NOT NULL) DROP VIEW Conferencia
GO
CREATE VIEW Conferencia
AS
SELECT	_Conferencia.nome AS nome, 
		ano, 
		acronimo, 
		email AS email_presidente, 
		limiteSubArtigo,
		limiteRevArtigo
FROM (_Conferencia INNER JOIN _Utilizador ON _Utilizador.id = _Conferencia.id_presidente)
GO
-------------------------(REGISTO)-------------------------
IF( OBJECT_ID('Registo') IS NOT NULL) DROP VIEW Registo
GO
CREATE VIEW Registo
AS
	SELECT 
		email,
		nome_conferencia, 
		ano_conferencia, 
		posicao
	FROM (_Registo INNER JOIN _Utilizador ON _Utilizador.id = _Registo.id_utilizador)
GO
-------------------------(ARTIGO)-------------------------
IF( OBJECT_ID('Artigo') IS NOT NULL) DROP VIEW Artigo 
GO
CREATE VIEW Artigo
AS
	SELECT 
		id,
		resumo,
		estado,
		nome_conferencia,
		ano_conferencia, 
		dataSubmissao
	FROM _Artigo
GO
-------------------------(AUTOR)-------------------------
IF( OBJECT_ID('Autor') IS NOT NULL) DROP VIEW Autor 
GO
CREATE VIEW Autor
AS
	SELECT
		email AS email_autor,
		id_artigo
	FROM _Utilizador INNER JOIN _Autor ON _Autor.id_autor = _Utilizador.id
GO
-------------------------(FICHEIRO)-------------------------
IF( OBJECT_ID('Ficheiro') IS NOT NULL) DROP VIEW Ficheiro 
GO
CREATE VIEW Ficheiro
AS
	SELECT 
		id,
		texto,
		id_artigo
	FROM _Ficheiro
GO
-------------------------(REVISOR)-------------------------
IF( OBJECT_ID('Revisor') IS NOT NULL) DROP VIEW Revisor 
GO
CREATE VIEW Revisor
AS
	SELECT
		email AS email_revisor,
		id_artigo
	FROM _Utilizador INNER JOIN _Revisor ON _Revisor.id_revisor = _Utilizador.id
GO
-------------------------(REVISAO)-------------------------
IF( OBJECT_ID('Revisao') IS NOT NULL) DROP VIEW Revisao 
GO
CREATE VIEW Revisao
AS
	SELECT
		_Revisor.id_artigo	AS	id_artigo,
		email				AS	email_revisor,
		texto,
		nota,
		dataRevisao
	FROM _Revisor INNER JOIN _Revisao ON _Revisao.id_revisor = _Revisor.id_revisor INNER JOIN _Utilizador ON _Utilizador.id = _Revisor.id_revisor
GO