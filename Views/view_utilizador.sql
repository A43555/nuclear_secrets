USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Utilizador') IS NOT NULL) DROP TRIGGER trg_Insert_Utilizador 
GO
CREATE TRIGGER trg_Insert_Utilizador
ON Utilizador
INSTEAD OF INSERT
AS BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
	INSERT INTO _Utilizador (email, nome, nome_instituicao) VALUES(
		(SELECT		email				FROM	inserted),
		(SELECT		nome				FROM	inserted),
		(SELECT		nome_instituicao	FROM	inserted)
	)

COMMIT 
GO
-----
IF( OBJECT_ID('trg_Delete_Utilizador') IS NOT NULL) DROP TRIGGER trg_Delete_Utilizador 
GO
CREATE TRIGGER trg_Delete_Utilizador
ON Utilizador
INSTEAD OF DELETE
AS BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF ( (dbo.fun_has_Registo( (SELECT email FROM deleted))) = 0)
		DELETE FROM _Utilizador WHERE email = (SELECT email FROM deleted)

COMMIT 
GO
-----
IF( OBJECT_ID('trg_Update_Utilizador') IS NOT NULL) DROP TRIGGER trg_Update_Utilizador 
GO
CREATE TRIGGER trg_Update_Utilizador
ON Utilizador
INSTEAD OF UPDATE
AS BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Utilizador SET
		nome				=	(SELECT		nome				FROM	inserted),
		nome_instituicao	=	(SELECT		nome_instituicao	FROM	inserted)
	WHERE 
		email	=	(SELECT		email	FROM	deleted)

COMMIT 
GO