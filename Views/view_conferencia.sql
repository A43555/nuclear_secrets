USE Conferencias_DB
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Conferencia') IS NOT NULL)
	DROP TRIGGER trg_Insert_Conferencia
GO
CREATE TRIGGER trg_Insert_Conferencia
ON Conferencia
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS(SELECT * FROM inserted WHERE limiteSubArtigo > limiteRevArtigo)
	BEGIN
		ROLLBACK
		RETURN
	END

	INSERT INTO _Conferencia (nome, ano, acronimo, id_presidente, limiteSubArtigo, limiteRevArtigo) 
		SELECT nome, ano, acronimo, dbo.fun_get_id(email_presidente), limiteSubArtigo, limiteRevArtigo 
			FROM inserted

	INSERT INTO _Registo (id_utilizador, nome_conferencia, ano_conferencia, posicao) 
		SELECT dbo.fun_get_id(email_presidente), nome, ano, 'presidente' 
			FROM inserted

COMMIT
GO
---
IF( OBJECT_ID('trg_Delete_Conferencia') IS NOT NULL)
	DROP TRIGGER trg_Delete_Conferencia
GO
CREATE TRIGGER trg_Delete_Conferencia
ON Conferencia
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS(SELECT nome, ano FROM deleted INNER JOIN _Artigo ON
		deleted.nome	=	_Artigo.nome_conferencia AND
		deleted.ano		=	_Artigo.ano_conferencia 
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	DELETE FROM _Registo FROM _Registo INNER JOIN deleted AS del ON
		_Registo.nome_conferencia = del.nome AND
		_Registo.ano_conferencia = del.ano

	DELETE FROM _Conferencia FROM _Conferencia INNER JOIN deleted AS sd ON 
		_Conferencia.nome	=	sd.nome AND
		_Conferencia.ano	=	sd.ano

COMMIT
GO
---
IF( OBJECT_ID('trg_Update_Conferencia') IS NOT NULL)
	DROP TRIGGER trg_Update_Conferencia
GO
CREATE TRIGGER trg_Update_Conferencia
ON Conferencia
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS(
		SELECT * FROM _Registo INNER JOIN deleted ON
			_Registo.nome_conferencia = deleted.nome AND
			_Registo.ano_conferencia = deleted.ano
		INNER JOIN inserted ON
			_Registo.id_utilizador = dbo.fun_get_id(inserted.email_presidente)
		WHERE _Registo.posicao != 'utilizador'
	)
	BEGIN
		ROLLBACK
		RETURN
	END 


	-- PRESIDENTE.registo.posicao => UTILIZADOR 
	UPDATE _Registo SET posicao = 'utilizador'
		FROM _Registo INNER JOIN deleted ON 
			id_utilizador = dbo.fun_get_id(email_presidente) AND 
			nome_conferencia = nome AND
			ano_conferencia = ano

	-- OLD UTILIZADOR.registo.posicao => PRESIDENTE
	UPDATE _Registo SET posicao = 'presidente'
		FROM _Registo  INNER JOIN  inserted ON
			id_utilizador = dbo.fun_get_id(inserted.email_presidente) INNER JOIN
		deleted ON
			nome_conferencia	=	deleted.nome AND
			ano_conferencia		=	deleted.ano 

	-- NEW UTILIZADOR.registo.posicao => PRESIDENTE
	INSERT INTO _Registo(id_utilizador, nome_conferencia, ano_conferencia, posicao)
		SELECT dbo.fun_get_id(inserted.email_presidente), deleted.nome, deleted.ano, 'presidente' FROM inserted INNER JOIN deleted ON
			inserted.nome	=	deleted.nome AND
			inserted.ano	=	deleted.ano
		EXCEPT SELECT id_utilizador, nome_conferencia, ano_conferencia, posicao FROM _Registo INNER JOIN inserted ON
			_Registo.id_utilizador = dbo.fun_get_id(inserted.email_presidente)
		INNER JOIN deleted ON
			inserted.nome	=	deleted.nome AND
			inserted.ano	=	deleted.ano

	-- CONFERENCIA.presidente => utilizadores
	UPDATE _Conferencia SET 
		acronimo = inserted.nome,
		id_presidente = dbo.fun_get_id(inserted.email_presidente) 
	FROM inserted

COMMIT
GO