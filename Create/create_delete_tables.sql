USE master
IF EXISTS(SELECT * FROM sys.databases WHERE NAME='Conferencias_DB')
	DROP DATABASE Conferencias_DB
CREATE DATABASE Conferencias_DB
GO

USE Conferencias_DB

IF OBJECT_ID('_Instituicao') IS NOT NULL
	DROP TABLE _Instituicao

IF OBJECT_ID('_Utilizador') IS NOT NULL
	DROP TABLE _Utilizador

IF OBJECT_ID('_Conferencia') IS NOT NULL
	DROP TABLE _Conferencia

IF OBJECT_ID('_Registo') IS NOT NULL
	DROP TABLE _Registo

IF OBJECT_ID('_Artigo') IS NOT NULL
	DROP TABLE _Artigo

IF OBJECT_ID('_Autor') IS NOT NULL
	DROP TABLE _Autor

IF OBJECT_ID('_Ficheiro') IS NOT NULL
	DROP TABLE _Ficheiro

IF OBJECT_ID('_Revisor') IS NOT NULL
	DROP TABLE _Revisor

IF OBJECT_ID('_Revisao') IS NOT NULL
	DROP TABLE _Revisao

CREATE TABLE _Instituicao(
	nome			VARCHAR(50)						UNIQUE NOT NULL,
	pais			VARCHAR(50)						NOT NULL,
	morada			VARCHAR(50)						NOT NULL,

	PRIMARY KEY (nome)
)

CREATE TABLE _Utilizador(
	id						INT	IDENTITY(1,1)		NOT NULL,
	email					VARCHAR(50)				UNIQUE NOT NULL,
	nome					VARCHAR(50)				NOT NULL,
	nome_instituicao		VARCHAR(50)				NOT NULL,

	
	PRIMARY KEY (id),
	FOREIGN KEY	(nome_instituicao)					REFERENCES _Instituicao(nome)
)

CREATE TABLE _Conferencia(
	nome					VARCHAR(50)				NOT NULL,
	ano						INT						CHECK (ano >= 1990 AND ano <= 2030),
	acronimo				VARCHAR(7)				,
	id_presidente			INT						NOT NULL,
	limiteSubArtigo			DATE					NOT NULL,
	limiteRevArtigo			DATE					NOT NULL,

	PRIMARY KEY	(nome, ano),
	FOREIGN KEY	(id_presidente)					REFERENCES	_Utilizador(id)
)

CREATE TABLE _Registo(
	id_utilizador			INT						NOT NULL,
	nome_conferencia		VARCHAR(50)				NOT NULL,
	ano_conferencia			INT						NOT NULL,
	posicao					VARCHAR(15)				CHECK (posicao IN('presidente','revisor','autor', 'utilizador')),

	PRIMARY KEY	(id_utilizador, nome_conferencia, ano_conferencia),
	FOREIGN KEY	(id_utilizador)						REFERENCES	_Utilizador(id),
	FOREIGN KEY	(nome_conferencia, ano_conferencia)	REFERENCES	_Conferencia(nome, ano)
)

CREATE TABLE _Artigo(
	id						INT						NOT NULL,
	resumo					VARCHAR(50)				NOT NULL,
	estado					VARCHAR(15)				CHECK (estado IN('em revisao','aceite','rejeitado')),
	nome_conferencia		VARCHAR(50)				NOT NULL,
	ano_conferencia			INT						NOT NULL, 
	dataSubmissao			DATE					NOT NULL,

	PRIMARY KEY	(id),
	FOREIGN KEY	(nome_conferencia, ano_conferencia)	REFERENCES	_Conferencia(nome, ano)
)

CREATE TABLE _Autor(
	id_artigo				INT						NOT NULL,
	id_autor				INT						NOT NULL,

	PRIMARY KEY	(id_artigo,id_autor),
	FOREIGN KEY	(id_artigo)							REFERENCES	_Artigo(id),
	FOREIGN KEY	(id_autor)							REFERENCES	_Utilizador(id)
)

CREATE TABLE _Ficheiro(
	id						INT						NOT NULL,
	texto					VARCHAR(50)				NOT NULL,
	id_artigo				INT						NOT NULL,

	PRIMARY KEY (id),
	FOREIGN KEY (id_artigo)							REFERENCES _Artigo(id)
)

CREATE TABLE _Revisor(
	id_artigo				INT						NOT NULL,
	id_revisor				INT						NOT NULL,

	PRIMARY KEY	(id_artigo, id_revisor),
	FOREIGN KEY	(id_artigo)							REFERENCES	_Artigo(id),
	FOREIGN KEY	(id_revisor)						REFERENCES	_Utilizador(id)
)

CREATE TABLE _Revisao(
	id_artigo				INT						NOT NULL,
	id_revisor				INT						NOT NULL,
	texto					VARCHAR(50)				NOT NULL,
	nota					INT						CHECK (nota >= 0 AND nota <=100),
	dataRevisao				DATE					NOT NULL
	
	PRIMARY KEY	(id_artigo, id_revisor),
	FOREIGN KEY (id_artigo, id_revisor)			REFERENCES	_Revisor(id_artigo, id_revisor)
)