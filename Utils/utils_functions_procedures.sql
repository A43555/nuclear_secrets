USE Conferencias_DB
GO
-------------------------(PROCEDURES)-------------------------
IF( OBJECT_ID('dbo.fun_has_Registo') IS NOT NULL) DROP FUNCTION dbo.fun_has_Registo
GO
CREATE FUNCTION dbo.fun_has_Registo(
		@email	VARCHAR(50)
	)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @amount INT, @result BIT
	SELECT @amount = COUNT(*) FROM Registo WHERE email = @email
	RETURN CASE @amount WHEN 0 THEN 0 ELSE 1 END
END
GO
-----
IF( OBJECT_ID('dbo.fun_get_id') IS NOT NULL) DROP FUNCTION dbo.fun_get_id
GO
CREATE FUNCTION dbo.fun_get_id(
		@email	VARCHAR(50)
	)
RETURNS INT
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN((SELECT _Utilizador.id FROM _Utilizador WHERE _Utilizador.email = @email))
END
GO
-----
IF( OBJECT_ID('dbo.fun_exists_Registo') IS NOT NULL) DROP FUNCTION dbo.fun_exists_Registo
GO
CREATE FUNCTION dbo.fun_exists_Registo(
		@email	VARCHAR(50),
		@nome	VARCHAR(50),
		@ano	INT	
	)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @amount INT, @result BIT
	SELECT @amount = COUNT(*) FROM Registo WHERE 
		email				=	@email	AND
		nome_conferencia	=	@nome	AND
		ano_conferencia		=	@ano
	RETURN CASE @amount WHEN 0 THEN 0 ELSE 1 END
END
GO
-----
IF( OBJECT_ID('dbo.fun_has_Conferencia_started') IS NOT NULL) DROP FUNCTION dbo.fun_has_Conferencia_started
GO
CREATE FUNCTION dbo.fun_has_Conferencia_started(
		@nome	VARCHAR(50),
		@ano	INT	
	)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @amount INT, @result BIT
	SELECT @amount = COUNT(*) FROM Artigo WHERE
		nome_conferencia = @nome AND
		ano_conferencia = @ano
	RETURN CASE @amount WHEN 0 THEN 0 ELSE 1 END
END
GO
-----
IF( OBJECT_ID('dbo.fun_has_Conferencia_started') IS NOT NULL) DROP FUNCTION dbo.fun_has_Conferencia_started
GO
CREATE FUNCTION dbo.fun_has_Conferencia_started(
		@nome	VARCHAR(50),
		@ano	INT	
	)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @amount INT, @result BIT
	SELECT @amount = COUNT(*) FROM Artigo WHERE
		nome_conferencia = @nome AND
		ano_conferencia = @ano
	RETURN CASE @amount WHEN 0 THEN 0 ELSE 1 END
END
GO
-----
IF( OBJECT_ID('dbo.fun_check_posicao') IS NOT NULL) DROP FUNCTION dbo.fun_check_posicao
GO
CREATE FUNCTION dbo.fun_check_posicao(
		@email_uti		VARCHAR(50),
		@nome_conf		VARCHAR(50),
		@ano_conf		INT,
		@posicao_uti	VARCHAR(15)
	)
RETURNS BIT
WITH EXECUTE AS CALLER
AS
BEGIN
	DECLARE @curr_pos VARCHAR(50), @result BIT
	SELECT @curr_pos = posicao FROM Registo WHERE 
		email				=	@email_uti	AND
		nome_conferencia	=	@nome_conf	AND
		ano_conferencia		=	@ano_conf
	RETURN CASE @curr_pos WHEN @posicao_uti THEN 1 ELSE 0 END
END
GO
-----
IF( OBJECT_ID('dbo.prc_make_Registo') IS NOT NULL) DROP PROCEDURE dbo.prc_make_Registo
GO
CREATE PROCEDURE dbo.prc_make_Registo(
		@email_uti		VARCHAR(50),
		@nome_conf		VARCHAR(50),
		@ano_conf		INT,
		@posicao_uti	VARCHAR(15),
		@result			BIT OUTPUT
	)
AS
BEGIN
	BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	SET @result = 0
	IF((SELECT dbo.fun_exists_Registo(@email_uti, @nome_conf, @ano_conf)) = 1)
	BEGIN
		IF((SELECT dbo.fun_check_posicao(@email_uti, @nome_conf, @ano_conf, 'utilizador')) = 1)
		BEGIN
			UPDATE _Registo SET posicao = @posicao_uti WHERE nome_conferencia = @nome_conf AND ano_conferencia = @ano_conf AND id_utilizador = (SELECT	(dbo.fun_get_id(@email_uti)))
			SET @result = 1
		END	
	END
	ELSE
	BEGIN
		INSERT INTO _Registo(id_utilizador, nome_conferencia, ano_conferencia, posicao) VALUES
			((dbo.fun_get_id(@email_uti)), @nome_conf, @ano_conf, @posicao_uti)
		SET @result = 1
	END
	COMMIT
	RETURN(@result)
END
GO