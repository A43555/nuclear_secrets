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