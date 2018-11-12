USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Autor') IS NOT NULL) DROP VIEW Autor 
GO
CREATE VIEW Autor
AS
	SELECT
		email AS email_autor,
		id_artigo
	FROM _Utilizador INNER JOIN _Autor ON _Autor.id_autor = _Utilizador.id
GO
-------------------------(TRIGGERS)-------------------------
IF( OBJECT_ID('trg_Insert_Autor') IS NOT NULL) DROP VIEW trg_Insert_Autor 
GO
CREATE TRIGGER trg_Insert_Autor
ON Autor
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	DECLARE @id_art INT, @nome VARCHAR(50), @ano INT, @bool BIT, @email VARCHAR(50)
	SELECT	@id_art		=	id_artigo			FROM	 inserted
	SELECT	@nome = nome_conferencia, @ano = ano_conferencia FROM Artigo WHERE id = @id_art
	SELECT @email = email_autor FROM inserted

	EXEC dbo.prc_make_Registo
		@email_uti		=	@email,
		@nome_conf		=	@nome,
		@ano_conf		=	@ano,
		@posicao_uti	=	'autor',
		@result			=	@bool
	
	IF(@bool = 0)
		ROLLBACK	

	INSERT INTO _Autor (id_artigo, id_autor) VALUES(
		(SELECT		id_artigo	FROM	inserted),
		(SELECT		(dbo.fun_get_id(@email)))
	)

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Autor') IS NOT NULL) DROP VIEW trg_Delete_Autor 
GO
CREATE TRIGGER trg_Delete_Autor
ON Autor
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	--???????????????????????????????????????????

COMMIT
GO
-----
IF( OBJECT_ID('trg_Update_Autor') IS NOT NULL) DROP TRIGGER trg_Update_Autor 
GO
CREATE TRIGGER trg_Update_Autor
ON Autor
INSTEAD OF UPDATE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

ROLLBACK

COMMIT
GO