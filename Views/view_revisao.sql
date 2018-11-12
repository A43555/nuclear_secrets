USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
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
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Revisao') IS NOT NULL) DROP VIEW trg_Insert_Revisao 
GO
CREATE TRIGGER trg_Insert_Revisao
ON Revisao
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

IF((SELECT		nota		FROM	inserted) > 100 OR (SELECT		nota		FROM	inserted) < 0)
	ROLLBACK

IF( (SELECT limiteRevArtigo FROM Conferencia WHERE 
		nome	=	(SELECT		nome_conferencia	FROM	Artigo WHERE id = (SELECT id_artigo FROM inserted)) AND 
		ano		=	(SELECT		ano_conferencia	FROM	Artigo WHERE id = (SELECT id_artigo FROM inserted))
	) < (SELECT		dataRevisao		FROM	inserted) )
		ROLLBACK

	INSERT INTO _Revisao (id_artigo, id_revisor, texto, nota) VALUES(
		(SELECT		id_artigo			FROM	inserted),
		(SELECT		dbo.fun_get_id((SELECT email_revisor FROM inserted))),
		(SELECT		texto				FROM	inserted),
		(SELECT		nota				FROM	inserted)
	)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Revisao') IS NOT NULL) DROP VIEW trg_Delete_Revisao 
GO
CREATE TRIGGER trg_Delete_Revisao
ON Revisao
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	--???????????????????????????????????????????

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Revisao') IS NOT NULL) DROP TRIGGER trg_Update_Revisao 
GO
CREATE TRIGGER trg_Update_Revisao
ON Revisao
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	UPDATE _Revisao SET
		texto		=	(SELECT		texto		FROM	inserted),
		nota		=	(SELECT		nota		FROM	inserted)
	WHERE 
		id_artigo	=	(SELECT		id_artigo	FROM	deleted) AND
		id_revisor	=	dbo.fun_get_id((SELECT	email_revisor	FROM	deleted))

COMMIT
GO