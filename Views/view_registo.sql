USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Registo') IS NOT NULL)
	DROP VIEW Registo
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Registo') IS NOT NULL)
	DROP TRIGGER trg_Insert_Registo
GO
CREATE TRIGGER trg_Insert_Registo
ON Registo
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	IF((SELECT		posicao				FROM	inserted) != 'utilizador')
		RAISERROR('O registo apenas pode ser feito para utilizadores', 16, 2)
	ELSE
		INSERT INTO _Registo (id_utilizador, nome_conferencia, ano_conferencia, posicao) VALUES (
			(SELECT		(dbo.fun_get_id_Utilizador((SELECT email FROM inserted)))),
			(SELECT		nome_conferencia	FROM	inserted),
			(SELECT		ano_conferencia		FROM	inserted),
			(SELECT		posicao				FROM	inserted)
		)

COMMIT
GO
---
IF( OBJECT_ID('trg_Delete_Registo') IS NOT NULL)
	DROP TRIGGER trg_Delete_Registo
GO
CREATE TRIGGER trg_Delete_Registo
ON Registo
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	DECLARE @bool BIT
	SELECT @bool = dbo.fun_check_posicao(
			(SELECT email FROM deleted),
			(SELECT nome_conferencia FROM deleted),
			(SELECT ano_conferencia FROM deleted),
			'utilizador'
	)
	IF(@bool = 0)
		RAISERROR('Apenas pode remover registos com posicao utilizador',16,1)
	ELSE
		DELETE FROM _Registo WHERE id_utilizador = dbo.fun_get_id((SELECT email FROM deleted))
COMMIT
GO
---
IF( OBJECT_ID('trg_Update_Registo') IS NOT NULL)
	DROP TRIGGER trg_Update_Registo
GO
CREATE TRIGGER trg_Update_Registo
ON Registo
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
ROLLBACK
GO