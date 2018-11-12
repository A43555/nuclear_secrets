USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Instituicao') IS NOT NULL) DROP VIEW trg_Insert_Instituicao 
GO
CREATE TRIGGER trg_Insert_Instituicao
ON Instituicao
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	INSERT INTO _Instituicao (nome, pais, morada) VALUES(
		(SELECT		nome	FROM	inserted),
		(SELECT		pais	FROM	inserted),
		(SELECT		morada	FROM	inserted)
	)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Instituicao') IS NOT NULL) DROP VIEW trg_Delete_Instituicao 
GO
CREATE TRIGGER trg_Delete_Instituicao
ON Instituicao
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	DECLARE @cnt INT
	SELECT @cnt = COUNT(*) FROM Utilizador WHERE nome_instituicao = (SELECT nome FROM deleted)

	IF(@cnt > 0)
	BEGIN
		RAISERROR('Instituicao Em uso!', 16, 1)
	END
	ELSE
		DELETE FROM Instituicao WHERE nome = (SELECT nome FROM deleted)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Instituicao') IS NOT NULL) DROP TRIGGER trg_Update_Instituicao 
GO
CREATE TRIGGER trg_Update_Instituicao
ON Instituicao
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Instituicao SET
		pais	=	(SELECT		pais	FROM	inserted),
		morada	=	(SELECT		morada	FROM	inserted)
	WHERE 
		nome	=	(SELECT		nome	FROM	deleted)

COMMIT
GO