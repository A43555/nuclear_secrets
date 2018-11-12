USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Revisor') IS NOT NULL) DROP VIEW Revisor 
GO
CREATE VIEW Revisor
AS
	SELECT
		email AS email_revisor,
		id_artigo
	FROM _Utilizador INNER JOIN _Revisor ON _Revisor.id_revisor = _Utilizador.id
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Revisor') IS NOT NULL) DROP VIEW trg_Insert_Revisor 
GO
CREATE TRIGGER trg_Insert_Revisor
ON Revisor
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

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

	INSERT INTO _Revisor(id_artigo, id_revisor)
		SELECT id_artigo, dbo.fun_get_id(email_revisor)
		FROM inserted

	UPDATE _Registo SET posicao = 'revisor'
		FROM _Registo  INNER JOIN  inserted ON
			id_utilizador = dbo.fun_get_id(inserted.email_revisor) 
		INNER JOIN _Artigo ON
			inserted.id_artigo = _Artigo.id AND
			_Registo.nome_conferencia	=	_Artigo.nome_conferencia AND
			_Registo.ano_conferencia	=	_Artigo.ano_conferencia

	INSERT INTO _Registo(nome_conferencia,ano_conferencia,id_utilizador,posicao)
		SELECT nome_conferencia, ano_conferencia, dbo.fun_get_id(email_revisor),'revisor' FROM _Artigo INNER JOIN inserted ON 
			_Artigo.id = inserted.id_artigo

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Revisor') IS NOT NULL) DROP VIEW trg_Delete_Revisor 
GO
CREATE TRIGGER trg_Delete_Revisor
ON Revisor
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE _Artigo.dataSubmissao < _Conferencia.limiteSubArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	UPDATE _Registo SET posicao = 'utilizador'
		FROM _Registo  INNER JOIN  deleted ON
			id_utilizador = dbo.fun_get_id(deleted.email_revisor) 
		INNER JOIN _Artigo ON
			deleted.id_artigo = _Artigo.id AND
			_Registo.nome_conferencia	=	_Artigo.nome_conferencia AND
			_Registo.ano_conferencia	=	_Artigo.ano_conferencia

	DELETE FROM _Revisor FROM _Revisor INNER JOIN deleted AS del ON
		_Revisor.id_revisor = dbo.fun_get_id(del.email_revisor) AND
		_Revisor.id_artigo = del.id_artigo

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Revisor') IS NOT NULL) DROP TRIGGER trg_Update_Revisor 
GO
CREATE TRIGGER trg_Update_Revisor
ON Revisor
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
ROLLBACK
GO