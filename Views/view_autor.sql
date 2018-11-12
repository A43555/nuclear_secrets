USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Autor') IS NOT NULL) DROP VIEW Autor 
GO
CREATE VIEW Autor
AS
	SELECT
		email AS email_autor,
		id_artigo
	FROM _Utilizador INNER JOIN _Autor ON _Autor.id_autor = _Utilizador.id
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Autor') IS NOT NULL) DROP VIEW trg_Insert_Autor 
GO
CREATE TRIGGER trg_Insert_Autor
ON Autor
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	IF EXISTS(
		SELECT * FROM _Artigo INNER JOIN inserted ON 
			_Artigo.id = inserted.id_artigo 
		INNER JOIN _Registo ON
			_Registo.nome_conferencia = _Artigo.nome_conferencia AND
			_Registo.ano_conferencia = _Artigo.ano_conferencia
		WHERE _Registo.posicao != 'utilizador'
	)
	BEGIN
		ROLLBACK
		RETURN
	END 

	INSERT INTO _Autor(id_artigo, id_autor)
		SELECT id_artigo, dbo.fun_get_id(email_autor)
		FROM inserted

	UPDATE _Registo SET posicao = 'autor'
		FROM _Registo  INNER JOIN  inserted ON
			id_utilizador = dbo.fun_get_id(inserted.email_autor) 
		INNER JOIN _Artigo ON
			inserted.id_artigo = _Artigo.id AND
			_Registo.nome_conferencia	=	_Artigo.nome_conferencia AND
			_Registo.ano_conferencia	=	_Artigo.ano_conferencia

	INSERT INTO _Registo(nome_conferencia,ano_conferencia,id_utilizador,posicao)
		SELECT nome_conferencia, ano_conferencia, dbo.fun_get_id(email_autor),'autor' FROM _Artigo INNER JOIN inserted ON 
			_Artigo.id = inserted.id_artigo

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Autor') IS NOT NULL) DROP VIEW trg_Delete_Autor 
GO
CREATE TRIGGER trg_Delete_Autor
ON Autor
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao > _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	UPDATE _Registo SET posicao = 'utilizador'
		FROM _Registo  INNER JOIN  deleted ON
			id_utilizador = dbo.fun_get_id(deleted.email_autor) 
		INNER JOIN _Artigo ON
			deleted.id_artigo = _Artigo.id AND
			_Registo.nome_conferencia	=	_Artigo.nome_conferencia AND
			_Registo.ano_conferencia	=	_Artigo.ano_conferencia

	DELETE FROM _Autor FROM _Autor INNER JOIN deleted AS del ON
		_Autor.id_autor = dbo.fun_get_id(del.email_autor) AND
		_Autor.id_artigo = del.id_artigo

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Autor') IS NOT NULL) DROP TRIGGER trg_Update_Autor 
GO
CREATE TRIGGER trg_Update_Autor
ON Autor
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
ROLLBACK
GO