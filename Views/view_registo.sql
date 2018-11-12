USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Registo') IS NOT NULL)
	DROP VIEW Registo
GO
CREATE VIEW Registo
AS
	SELECT 
		email,
		nome_conferencia, 
		ano_conferencia, 
		posicao
	FROM (_Registo INNER JOIN _Utilizador ON _Utilizador.id = _Registo.id_utilizador)
GO
