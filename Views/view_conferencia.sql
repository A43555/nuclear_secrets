USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Conferencia') IS NOT NULL)
	DROP VIEW Conferencia
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
		ROLLBACK

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

	DECLARE @SAFE_DELETE TABLE(nome VARCHAR(50), ano INT)

	INSERT INTO @SAFE_DELETE SELECT nome, ano FROM _Conferencia WHERE EXISTS (SELECT nome, ano FROM DELETED WHERE 
		_Conferencia.nome = DELETED.nome AND _Conferencia.ano = DELETED.ano EXCEPT SELECT nome_conferencia, ano_conferencia FROM _Artigo)

	IF EXISTS(SELECT * FROM @SAFE_DELETE)
		ROLLBACK

	DELETE FROM _Conferencia FROM _Conferencia INNER JOIN @SAFE_DELETE AS sd ON 
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

	-- Verifica se existem utilizadores autores ou revisores
	IF EXISTS(
		SELECT * FROM _Registo 
			INNER JOIN deleted ON 
				_Registo.nome_conferencia	=	deleted.nome AND
				_Registo.ano_conferencia	=	deleted.ano
			INNER JOIN inserted ON
				_Registo.id_utilizador = dbo.fun_get_id(inserted.email_presidente)
			WHERE _Registo.posicao != 'utilizador'
	) ROLLBACK

	-- Coloca como utilizador os antigos presidentes
	UPDATE _Registo SET posicao = 'utilizador' 
		WHERE EXISTS(
			SELECT nome, ano FROM _Registo INNER JOIN deleted ON
				_Registo.nome_conferencia = deleted.nome AND
				_Registo.ano_conferencia = deleted.ano
		)

	DECLARE @table TABLE(nome VARCHAR(50), ano INT)
	INSERT INTO @table SELECT nome, ano FROM _Registo INNER JOIN inserted ON
				_Registo.nome_conferencia = inserted.nome AND 
				_Registo.ano_conferencia = inserted.ano

	-- Coloca os utilizadores registados como presidentes
	UPDATE _Registo SET posicao = 'presidente'
		WHERE EXISTS(SELECT nome, ano FROM @table)

	-- Coloca os utilizadores nao registados como presidentes
	INSERT INTO _Registo(id_utilizador, nome_conferencia, ano_conferencia, posicao)
		SELECT dbo.fun_get_id(inserted.email_presidente), deleted.nome, deleted.ano, 'presidente' FROM deleted INNER JOIN inserted ON
			inserted.nome = deleted.nome AND 
			inserted.ano = deleted.ano
		EXCEPT SELECT nome, ano FROM @table

COMMIT
GO