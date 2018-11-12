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
	DECLARE @data_sub DATE, @data_rev DATE
	SELECT @data_sub = limiteSubArtigo, @data_rev = limiteRevArtigo FROM inserted
	IF (@data_rev < @data_sub) ROLLBACK

	INSERT INTO _Conferencia (nome, ano, acronimo, id_presidente, limiteSubArtigo, limiteRevArtigo) 
		VALUES  ((SELECT	nome				FROM	inserted),
				 (SELECT	ano					FROM	inserted),
				 (SELECT	acronimo			FROM	inserted),
				 (SELECT	(dbo.fun_get_id((SELECT email_presidente FROM inserted)))),
				 (SELECT	limiteSubArtigo		FROM	inserted),
				 (SELECT	limiteRevArtigo		FROM	inserted))

	INSERT INTO _Registo (id_utilizador, nome_conferencia, ano_conferencia, posicao)
		VALUES ((dbo.fun_get_id((SELECT email_presidente FROM inserted))),
				(SELECT nome					FROM inserted),
				(SELECT ano						FROM inserted),
				('presidente'))
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
	
		--???????????????????????????????????????????

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
	DECLARE @new_pres VARCHAR(50), @nome VARCHAR(50), @ano INT, @bool BIT
	SELECT	@new_pres	=	email_presidente	FROM	 inserted
	SELECT	@nome		=	nome				FROM	 deleted
	SELECT	@ano		=	ano					FROM	 deleted

	EXEC dbo.prc_make_Registo
		@email_uti		=	@new_pres,
		@nome_conf		=	@nome,
		@ano_conf		=	@ano,
		@posicao_uti	=	'presidente',
		@result			=	@bool
	
	IF(@bool = 0)
		RAISERROR('Invalid user email',16,3)	
	ELSE
	BEGIN
		UPDATE _Registo SET posicao = 'utilizador' WHERE  
			id_utilizador		=	(SELECT	(dbo.fun_get_id((SELECT email_presidente FROM deleted)))) AND 
			ano_conferencia		=	@ano AND
			nome_conferencia	=	@nome

		UPDATE _Conferencia SET id_presidente = (SELECT	(dbo.fun_get_id(@new_pres))) WHERE  
			nome	=	@nome AND
			ano		=	@ano
	END
COMMIT
GO