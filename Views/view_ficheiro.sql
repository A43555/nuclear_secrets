USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Ficheiro') IS NOT NULL) DROP VIEW trg_Insert_Ficheiro 
GO
CREATE TRIGGER trg_Insert_Ficheiro
ON Ficheiro
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	INSERT INTO _Ficheiro (id, texto, id_artigo) VALUES(
		(SELECT		id			FROM	inserted),
		(SELECT		texto		FROM	inserted),
		(SELECT		id_artigo	FROM	inserted)
	)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Ficheiro') IS NOT NULL) DROP VIEW trg_Delete_Ficheiro 
GO
CREATE TRIGGER trg_Delete_Ficheiro
ON Ficheiro
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	
		--???????????????????????????????????????????

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Ficheiro') IS NOT NULL) DROP TRIGGER trg_Update_Ficheiro
GO
CREATE TRIGGER trg_Update_Ficheiro
ON Ficheiro
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Ficheiro SET
		texto	=	(SELECT		texto	FROM	inserted)
	WHERE 
		id		=	(SELECT		id	FROM	deleted)

COMMIT
GO