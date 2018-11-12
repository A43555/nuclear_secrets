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

	DECLARE @id_art	INT, @nome VARCHAR(50), @ano INT, @bool BIT, @email VARCHAR(50)
	SELECT	@id_art		=	id_artigo			FROM	 inserted
	SELECT	@nome		=	nome_conferencia,	@ano = ano_conferencia FROM Artigo WHERE id = @id_art
	SELECT	@email		=	email_revisor		FROM	 inserted

	EXEC dbo.prc_make_Registo
		@email_uti		=	@email,
		@nome_conf		=	@nome,
		@ano_conf		=	@ano,
		@posicao_uti	=	'revisor',
		@result			=	@bool
	
	IF(@bool = 0)
		ROLLBACK	

	INSERT INTO _Revisor (id_artigo, id_revisor) VALUES(
		(SELECT		id_artigo	FROM	inserted),
		(SELECT		(dbo.fun_get_id(@email)))
	)

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

	--???????????????????????????????????????????

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

COMMIT
GO