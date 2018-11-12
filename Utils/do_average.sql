USE Conferencias_DB
GO

IF OBJECT_ID('Cut_Off') IS NOT NULL
	DROP PROCEDURE Cut_Off
GO

IF OBJECT_ID('dbo.Do_Average') IS NOT NULL
	DROP FUNCTION dbo.Do_Average
GO


CREATE PROCEDURE Cut_Off
	@nomeConf VARCHAR (50),
	@anoConf INT,
	@toCut INT = 50
AS
	BEGIN TRANSACTION
	SET XACT_ABORT ON
	SET NOCOUNT ON
	DECLARE @Average INT
	DECLARE @idArtigo INT
	DECLARE @bool INT

	SELECT * INTO Artigo_Conf FROM Artigo WHERE nome_conferencia = @nomeConf AND ano_conferencia = @anoConf

	DECLARE iter_artigos CURSOR LOCAL FORWARD_ONLY
	FOR SELECT [id] FROM Artigo_Conf
	OPEN iter_artigos
	DECLARE @curr INT = 0
	FETCH NEXT FROM iter_artigos INTO @curr
	SELECT @bool = dbo.Do_Average(@curr, @toCut)
	IF (@bool = 1) UPDATE _Artigo SET estado = 'aceite' WHERE nome_conferencia = @nomeConf AND ano_conferencia = @anoConf
	WHILE @@FETCH_STATUS = 0
		BEGIN
			FETCH NEXT FROM iter_artigos INTO @curr
			SELECT @bool = dbo.Do_Average(@curr, @toCut)
			IF (@bool = 1) UPDATE _Artigo SET estado = 'aceite' WHERE nome_conferencia = @nomeConf AND ano_conferencia = @anoConf
		END
	CLOSE iter_artigos
	DEALLOCATE iter_artigos
	COMMIT
GO

CREATE FUNCTION dbo.Do_Average(@idArtigo INT, @toCut INT)
RETURNS INT
WITH EXECUTE AS CALLER
AS
	BEGIN
		DECLARE @Notas Table(nota INT)
		INSERT INTO @Notas SELECT [nota] FROM Revisao WHERE id_artigo = @idArtigo
		DECLARE @avrg INT = 0
		DECLARE @agragte INT = 0
		DECLARE @count INT = 0

		DECLARE iter_notas CURSOR FORWARD_ONLY
		FOR SELECT nota FROM @Notas
		OPEN iter_notas
		DECLARE @current INT = 0
		FETCH NEXT FROM iter_notas INTO @current
		SET @agragte = @agragte + @current
		SET @count = @count + 1
		WHILE @@FETCH_STATUS = 0
			BEGIN
				FETCH NEXT FROM iter_notas INTO @current
				SET @agragte = @agragte + @current
				SET @count = @count + 1
				
			END
		SET @avrg = @agragte / @count
		CLOSE iter_notas
		DEALLOCATE iter_notas

		IF (@avrg > @toCut)
			RETURN (1)

		RETURN(0)
	END
GO