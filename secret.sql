-- CLEAR INICIAL
DELETE FROM _Revisao
DELETE FROM _Revisor
DELETE FROM _Ficheiro
DELETE FROM _Autor
DELETE FROM _Artigo
DELETE FROM _Registo
DELETE FROM _Conferencia
DELETE FROM _Utilizador
DELETE FROM _Instituicao


-- 1) INSERT 3 Instituicoes
INSERT INTO Instituicao(nome,morada,pais) VALUES ('Inst_1','morada_1','pais_1'),('Inst_2','morada_2','pais_2'),('Inst_3','morada_?','pais_3')
SELECT * FROM Instituicao

-- 2) UPDATE 1 Instituicao
UPDATE Instituicao SET morada = 'morada_3' WHERE nome = 'Inst_3'
SELECT * FROM Instituicao

-- 3) DELETE 2 Instituicoes
DELETE FROM Instituicao WHERE nome != 'Inst_1'
SELECT * FROM Instituicao

-- 4) INSERT 3 Utilizadores
INSERT INTO Utilizador(email,nome,nome_instituicao) VALUES ('1@mail.com','nome_1','Inst_1'),('2@mail.com','nome_2','Inst_1'),('3@mail.com','nome_?','Inst_1')
SELECT * FROM Utilizador

-- 5) UPDATE 1 Utilizador
UPDATE Utilizador SET nome = 'nome_3' WHERE email = '3@mail.com'
SELECT * FROM Utilizador

-- 6) DELETE 1 Utilizador
DELETE FROM Utilizador WHERE email = '2@mail.com'
SELECT * FROM Utilizador

-- 7) INSERT 1 Conferencia (Cria um registo para o presidente)
INSERT INTO Conferencia(nome,ano,acronimo,email_presidente,limiteSubArtigo,limiteRevArtigo) VALUES ('Conf_1',2010,'C1','1@mail.com','10-10-2010','11-11-2010')
SELECT * FROM Conferencia
SELECT * FROM Registo

-- 8) Tentativa de UPDATE 1 Conferencia (Email nao exite por isso falha)
UPDATE Conferencia SET email_presidente = '2@mail.com'
SELECT * FROM Conferencia
SELECT * FROM Registo

-- 9) Update 1 Conferncia (Altera o presidente da conferencia, cria um novo registo para essa e coloca o presidente antigo apenas como utilizador)
UPDATE Conferencia SET email_presidente = '3@mail.com'
SELECT * FROM Conferencia
SELECT * FROM Registo

-- 10) Tentativa de Remover utilizador (Existe um registo para este por isso nao funciona)
DELETE FROM Utilizador WHERE email = '1@mail.com'
SELECT * FROM Utilizador
SELECT * FROM Registo

-- 11) Remover um registo
EXEC Remove_Registo
	@email_utilizador = '1@mail.com',
	@nome_Conferencia = 'Conf_1',
	@ano_conferencia = 2010
SELECT * FROM Utilizador
SELECT * FROM Registo

-- 12) Remover um utilizador ja sem registo
DELETE FROM Utilizador WHERE email = '1@mail.com'
SELECT * FROM Utilizador
SELECT * FROM Registo

-- 13) Tentativa de remover um Registo de um presidente
EXEC Remove_Registo
	@email_utilizador = '1@mail.com',
	@nome_Conferencia = 'Conf_1',
	@ano_conferencia = 2010
SELECT * FROM Utilizador
SELECT * FROM Registo

-- 14) Registar os 2 novos utilizadores
INSERT INTO Utilizador(email,nome,nome_instituicao) VALUES ('1@mail.com','nome_1','Inst_1'),('2@mail.com','nome_2','Inst_1')
EXEC Add_Registo
	@email_utilizador = '1@mail.com',
	@nome_Conferencia = 'Conf_1',
	@ano_conferencia = 2010
EXEC Add_Registo
	@email_utilizador = '2@mail.com',
	@nome_Conferencia = 'Conf_1',
	@ano_conferencia = 2010
SELECT * FROM Utilizador
SELECT * FROM Registo

-- 15) Apagar uma conferencia e registos
DELETE FROM Conferencia WHERE nome = 'Conf_1'
SELECT * FROM Conferencia
SELECT * FROM Registo
SELECT * FROM Utilizador

-- 16) Criar conferencia e Tentativa de adicionar um artigo APOS A DATA LIMITE DE SUBMISSAO
INSERT INTO Conferencia(nome,ano,acronimo,email_presidente,limiteSubArtigo,limiteRevArtigo) VALUES ('Conf_1',2010,'C1','1@mail.com','02-02-2010','11-11-2010')
EXEC Add_Artigo
	@email_autor = '3@mail.com',
	@id_artigo = 1,
	@id_ficheiro = 1,
	@texto_ficheiro = 'texto de ficheiro',
	@resumo_artigo = 'um artigo de testes',
	@nome_conferencia = 'Conf_1',
	@ano_conferencia = 2010,
	@data_sublissao_artigo = '03-03-2010'
SELECT * FROM Conferencia
SELECT * FROM Artigo

-- 17) Adicionar um artigo
EXEC Add_Artigo
	@email_autor = '3@mail.com',
	@id_artigo = 1,
	@id_ficheiro = 1,
	@texto_ficheiro = 'texto de ficheiro',
	@resumo_artigo = 'um artigo de testes',
	@nome_conferencia = 'Conf_1',
	@ano_conferencia = 2010,
	@data_sublissao_artigo = '01-01-2010'
SELECT * FROM Artigo
SELECT * FROM Registo
SELECT * FROM Ficheiro
SELECT * FROM Autor


-- 17) Tentativa de apagar a conferencia contendo esta um artigo
DELETE FROM Conferencia WHERE nome = 'Conf_1'
SELECT * FROM Conferencia
SELECT * FROM Artigo

-- 18) Tentativa de Alterar um artigo numa data posterior a do limite das submissoes
UPDATE Artigo SET dataSubmissao = '04-04-2010', resumo = 'novo resumo'  WHERE id = 1
SELECT * FROM Artigo

-- 19) Alterar um artigo numa data anterior a do limite das submissoes
UPDATE Artigo SET dataSubmissao = '01-01-2010', resumo = 'novo resumo' WHERE id = 1
SELECT * FROM Artigo

-- 20) Apagar um artigo dentro da data anterior a do limite das submissoes
DELETE FROM Artigo WHERE id = 1
SELECT * FROM Artigo
SELECT * FROM Autor
SELECT * FROM Registo
SELECT * FROM Ficheiro

-- 21) Apagar uma conferencia agora vazia
DELETE FROM Conferencia WHERE nome = 'Conf_1'
SELECT * FROM Conferencia
SELECT * FROM Artigo

-- 22) Criar conferenci/artigo e acrescentar dois novos ficheiro
INSERT INTO Conferencia(nome,ano,acronimo,email_presidente,limiteSubArtigo,limiteRevArtigo) VALUES ('Conf_1',2010,'C1','1@mail.com','02-02-2010','11-11-2010')
EXEC Add_Artigo
	@email_autor = '3@mail.com',
	@id_artigo = 1,
	@id_ficheiro = 1,
	@texto_ficheiro = 'texto de ficheiro',
	@resumo_artigo = 'um artigo de testes',
	@nome_conferencia = 'Conf_1',
	@ano_conferencia = 2010,
	@data_sublissao_artigo = '01-01-2010'
INSERT INTO Ficheiro(id,id_artigo,texto) VALUES(2,1,'outro texto de ficheiro'),(3,1,'mais um texto')
SELECT * FROM Artigo
SELECT * FROM Autor
SELECT * FROM Registo
SELECT * FROM Ficheiro

-- 22) Criar um novo autor
INSERT INTO Autor(email_autor,id_artigo) VALUES('2@mail.com',1)
SELECT * FROM Artigo
SELECT * FROM Autor
SELECT * FROM Registo

-- 23) Remover um autor (A posicao no registo muda de autor para utilizador)
DELETE FROM Autor WHERE email_autor = '2@mail.com'
SELECT * FROM Autor
SELECT * FROM Registo

-- 24) Adicionar um revisor ao artigo
INSERT INTO Utilizador(email,nome,nome_instituicao) VALUES ('4@mail.com','nome_4','Inst_1')
INSERT INTO Revisor(email_revisor,id_artigo) VALUEs('4@mail.com',1)
SELECT * FROM Revisor
SELECT * FROM Artigo

-- 25) Tentativa de adicionar uma revisao nao aindadentro da data de revisao
INSERT INTO Revisao(id_artigo,email_revisor,nota,texto,dataRevisao) VALUES (1,'4@mail.com',15,'texto de revisao','01-01-2010')
SELECT * FROM Revisor
SELECT * FROM Revisao

-- 26) Fechar artigo para alteracao
EXEC Fechar_Submissao
	@id_artigo = 1,
	@data_atual = '05-05-2010'
SELECT * FROM Artigo
SELECT * FROM Conferencia

-- 27) Tentativa de adicionar outro autor pos data limite
INSERT INTO Autor(email_autor,id_artigo) VALUES ('2@mail.com',1)
SELECT * FROM Artigo
SELECT * FROM Autor
SELECT * FROM Registo

-- 28) Adicionar uma revisao dentro da data
INSERT INTO Revisao(id_artigo,email_revisor,nota,texto,dataRevisao) VALUES (1,'4@mail.com',15,'texto de revisao','04-04-2010')
SELECT * FROM Revisor
SELECT * FROM Revisao

-- 29) Remover uma revisao
DELETE FROM Revisao WHERE email_revisor = '4@mail.com'
SELECT * FROM Revisor
SELECT * FROM Revisao

-- 30) Tentativa de adiconar uma revisao fora da data limite
INSERT INTO Revisao(id_artigo,email_revisor,nota,texto,dataRevisao) VALUES (1,'4@mail.com',15,'texto de revisao','12-12-2010')
SELECT * FROM Revisor
SELECT * FROM Revisao

-- 31) Tentativa de colocar um revisor como presidente
UPDATE Conferencia SET email_presidente = '4@mail.com' WHERE nome = 'Conf_1'
SELECT * FROM Conferencia
SELECT * FROM Registo
SELECT * FROM Revisor

-- 31) Tentativa de colocar um utilizador como presidente
UPDATE Conferencia SET email_presidente = '2@mail.com' WHERE nome = 'Conf_1'
SELECT * FROM Conferencia
SELECT * FROM Registo


-- 32) Alterar 1 nova revisao dentro da data
INSERT INTO Revisao(id_artigo,email_revisor,nota,texto,dataRevisao) VALUES (1,'4@mail.com',15,'texto de revisao','04-04-2010')
UPDATE Revisao SET nota = 17 WHERE id_artigo = 1
SELECT * FROM Artigo
SELECT * FROM Revisor
SELECT * FROM Revisao

-- 33) Fechar a submissao para revisoes
EXEC Fechar_Revisao
@id_artigo = 1,
@data_atual = '12-12-2010'
SELECT * FROM Artigo
SELECT * FROM Revisao


-- 34) Tentativa de Alterar a revisao ja fora da data
UPDATE Revisao SET nota = 17 WHERE id_artigo = 1
SELECT * FROM Artigo
SELECT * FROM Revisor
SELECT * FROM Revisao

-- FORCE CLEAR 
DELETE FROM _Revisao
DELETE FROM _Revisor
DELETE FROM _Ficheiro
DELETE FROM _Autor
DELETE FROM _Artigo
DELETE FROM _Registo
DELETE FROM _Conferencia
DELETE FROM _Utilizador
DELETE FROM _Instituicao

-- 35) Criar ambiente para teste das funcoes average
INSERT INTO Instituicao(nome,morada,pais) VALUES ('Inst_1','morada_1','pais_1')
INSERT INTO Utilizador(email,nome,nome_instituicao) VALUES	('1@mail.com','nome_1','Inst_1'),('2@mail.com','nome_2','Inst_1'),
															('3@mail.com','nome_3','Inst_1'),('4@mail.com','nome_4','Inst_1'),
															('5@mail.com','nome_5','Inst_1'),('6@mail.com','nome_6','Inst_1'),
															('7@mail.com','nome_7','Inst_1'),('8@mail.com','nome_8','Inst_1')
INSERT INTO Conferencia(nome,ano,acronimo,email_presidente,limiteSubArtigo,limiteRevArtigo) VALUES ('Conf_1',2010,'C1','1@mail.com','02-02-2010','11-11-2010')
EXEC Add_Artigo
	@email_autor = '3@mail.com',
	@id_artigo = 1,
	@id_ficheiro = 1,
	@texto_ficheiro = 'texto de ficheiro',
	@resumo_artigo = 'um artigo de testes',
	@nome_conferencia = 'Conf_1',
	@ano_conferencia = 2010,
	@data_sublissao_artigo = '01-01-2010'
EXEC Add_Artigo
	@email_autor = '5@mail.com',
	@id_artigo = 2,
	@id_ficheiro = 3,
	@texto_ficheiro = 'texto de ficheiro',
	@resumo_artigo = 'um artigo de testes',
	@nome_conferencia = 'Conf_1',
	@ano_conferencia = 2010,
	@data_sublissao_artigo = '01-01-2010'
INSERT INTO Revisor(id_artigo,email_revisor) VALUES(1,'2@mail.com'),(1,'4@mail.com')
INSERT INTO Revisor(id_artigo,email_revisor) VALUES(2,'6@mail.com'),(2,'7@mail.com'),(2,'8@mail.com')
INSERT INTO Revisao(id_artigo,email_revisor,dataRevisao,nota,texto) VALUES (1,'2@mail.com','05-05-2010',25,'texto'),(1,'4@mail.com','05-05-2010',25,'texto')
INSERT INTO Revisao(id_artigo,email_revisor,dataRevisao,nota,texto) VALUES	(2,'6@mail.com','05-05-2010',10,'texto'),
																			(2,'7@mail.com','05-05-2010',20,'texto'),(2,'8@mail.com','05-05-2010',20,'texto')
EXEC dbo.prc_CutOff
	@id = 1,
	@cutOff = 50
SELECT * FROM Artigo
SELECT * FROM Revisao