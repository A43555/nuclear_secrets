USE Conferencias_DB
GO
USE Conferencias_DB
GO
-------------------------(STRUCTURE)-------------------------
IF( OBJECT_ID('Instituicao') IS NOT NULL) DROP VIEW Instituicao 
GO
CREATE VIEW Instituicao
AS
	SELECT 
		nome,
		pais,
		morada
	FROM _Instituicao
GO
-------------------------(TRIGGERS)-------------------------
