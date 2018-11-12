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
IF( OBJECT_ID('trg_Insert_Revisao') IS NOT NULL) DROP TRIGGER trg_Insert_Revisao 
GO
CREATE TRIGGER trg_Insert_Revisao
ON Revisao
INSTEAD OF INSERT
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON

	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE inserted.dataRevisao > _Conferencia.limiteRevArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	INSERT INTO _Revisao(id_artigo, id_revisor, texto, nota, dataRevisao)
		SELECT id_artigo, dbo.fun_get_id(email_revisor), texto, nota, dataRevisao
		FROM inserted

COMMIT
GO
-----
IF( OBJECT_ID('trg_Delete_Revisao') IS NOT NULL) DROP TRIGGER trg_Delete_Revisao 
GO
CREATE TRIGGER trg_Delete_Revisao
ON Revisao
INSTEAD OF DELETE
AS
BEGIN TRANSACTION; SET XACT_ABORT ON; SET NOCOUNT ON
	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE inserted.dataRevisao > _Conferencia.limiteRevArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	DELETE FROM _Revisao FROM _Revisao INNER JOIN deleted AS del ON
		_Revisao.id_artigo = _Revisao.id_artigo AND
		_Revisao.id_revisor = dbo.fun_get_id(email_revisor)
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
	IF EXISTS( SELECT * FROM inserted INNER JOIN _Artigo ON inserted.id_artigo = _Artigo.id INNER JOIN _Conferencia ON
				_Artigo.nome_conferencia = nome AND
				_Artigo.ano_conferencia = ano
				WHERE inserted.dataRevisao > _Conferencia.limiteRevArtigo
	)
	BEGIN
		ROLLBACK
		RETURN
	END

	UPDATE _Revisao SET
		nota = inserted.nota,
		texto = inserted.texto
	FROM inserted INNER JOIN deleted ON
		inserted.id_artigo = deleted.id_artigo AND
		inserted.email_revisor = deleted.email_revisor
COMMIT
GO