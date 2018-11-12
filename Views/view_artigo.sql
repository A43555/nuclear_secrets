USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Artigo') IS NOT NULL) DROP VIEW trg_Insert_Artigo 
GO
CREATE TRIGGER trg_Insert_Artigo
ON Artigo
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF((SELECT estado FROM inserted) != 'em revisao')
		ROLLBACK
	
	IF( (SELECT limiteSubArtigo FROM Conferencia WHERE 
		nome	=	(SELECT		nome_conferencia	FROM	inserted) AND 
		ano		=	(SELECT		ano_conferencia		FROM	inserted)
	) < (SELECT		dataSubmissao		FROM	inserted) )
		ROLLBACK

	INSERT INTO _Artigo (id, resumo, estado, nome_conferencia, ano_conferencia, dataSubmissao) VALUES(
		(SELECT		id					FROM	inserted),
		(SELECT		resumo				FROM	inserted),
		(SELECT		estado				FROM	inserted),
		(SELECT		nome_conferencia	FROM	inserted),
		(SELECT		ano_conferencia		FROM	inserted),
		(SELECT		dataSubmissao		FROM	inserted)
	)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Artigo') IS NOT NULL) DROP VIEW trg_Delete_Artigo 
GO
CREATE TRIGGER trg_Delete_Artigo
ON Artigo
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	--???????????????????????????????????????????

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Artigo') IS NOT NULL) DROP TRIGGER trg_Update_Artigo 
GO
CREATE TRIGGER trg_Update_Artigo
ON Artigo
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Artigo SET
		resumo	=	(SELECT		resumo	FROM	inserted)
	WHERE 
		id		=	(SELECT		id		FROM	deleted)

COMMIT
GO