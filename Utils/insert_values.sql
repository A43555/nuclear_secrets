USE Conferencias_DB

INSERT INTO _Instituicao VALUES
	('Instituicao 1', 'Portugal','Rua X'),
	('Instituicao 2', 'Portugal','Rua Y'),
	('Instituicao 3', 'Portugal','Rua Z'),
	('Instituicao 4', 'Portugal','Rua A'),
	('Instituicao 5', 'Portugal','Rua B')

INSERT INTO _Utilizador VALUES
	('user1@email.com', 'Zacarias Mateus', 'Instituicao 1'),
	('user2@email.com', 'Diaogo Estronco', 'Instituicao 1'),
	('user3@email.com', 'Mariana Clacanhoto', 'Instituicao 1'),
	('user4@email.com', 'Matias Balde', 'Instituicao 2'),
	('user5@email.com', 'Ana Cabral', 'Instituicao 2'),
	('user6@email.com', 'Aladin Al-Muhamed', 'Instituicao 2'),
	('user7@email.com', 'Maria do Pito', 'Instituicao 3'),
	('user8@email.com', 'Raul Canilhas', 'Instituicao 3'),
	('user9@email.com', 'Ivan Siderov', 'Instituicao 3'),
	('user10@email.com', 'Makukula de Azevedo', 'Instituicao 4'),
	('user11@email.com', 'Joana Vasconcelos', 'Instituicao 4'),
	('user12@email.com', 'Carl Carlson', 'Instituicao 4'),
	('user13@email.com', 'Ping Xong Pi', 'Instituicao 5'),
	('user14@email.com', 'Elizabeth McFree', 'Instituicao 5'),
	('user15@email.com', 'Donald Obama', 'Instituicao 5')

INSERT INTO _Conferencia VALUES
	('Conferencia 1', 2010, 'C1', 1, '2010-01-01', '2010-02-01'),
	('Conferencia 2', 2011, 'C2', 4, '2011-01-01', '2011-02-01'),
	('Conferencia 3', 2012, 'C3', 7, '2012-01-01', '2012-02-01'),
	('Conferencia 4', 2013, 'C4', 10, '2014-01-01', '2013-02-01'),
	('Conferencia 5', 2014, 'C5', 13, '2014-01-01', '2014-02-01')

INSERT INTO _Registo VALUES
	(1, 'Conferencia 1', 2010, 'presidente'),
	(2, 'Conferencia 1', 2010, 'autor'),
	(3, 'Conferencia 1', 2010, 'revisor'),
	(4, 'Conferencia 2', 2011, 'presidente'),
	(5, 'Conferencia 2', 2011, 'autor'),
	(6, 'Conferencia 2', 2011, 'revisor'),
	(7, 'Conferencia 3', 2012, 'presidente'),
	(8, 'Conferencia 3', 2012, 'autor'),
	(9, 'Conferencia 3', 2012, 'revisor'),
	(10, 'Conferencia 4', 2013, 'presidente'),
	(11, 'Conferencia 4', 2013, 'autor'),
	(12, 'Conferencia 4', 2013, 'revisor'),
	(13, 'Conferencia 5', 2014, 'presidente'),
	(14, 'Conferencia 5', 2014, 'autor'),
	(15, 'Conferencia 5', 2014, 'revisor')

INSERT INTO _Artigo VALUES
	(1,'This is a summary 1.', 'em revisao', 'Conferencia 1', 2010, '2009-12-01'),
	(2,'This is a summary 2.', 'aceite', 'Conferencia 2', 2011, '2010-12-01'),
	(3,'This is a summary 3.', 'em revisao', 'Conferencia 3', 2012, '2011-12-01'),
	(4,'This is a summary 4.', 'rejeitado', 'Conferencia 4', 2013, '2012-12-01'),
	(5,'This is a summary 5.', 'aceite', 'Conferencia 5', 2014, '2013-12-01')

INSERT INTO _Autor VALUES
	(1, 2),
	(2, 5),
	(3, 8),
	(4, 11),
	(5, 14)

INSERT INTO _Ficheiro VALUES
	(1, 'This is text 1.', 1),
	(2, 'This is text 2.', 2),
	(3, 'This is text 3.', 3),
	(4, 'This is text 4.', 4),
	(5, 'This is text 5.', 5)

INSERT INTO _Revisor VALUES
	(1, 3),
	(1, 6),
	(1, 9),
	(1, 12),
	(1, 15)

INSERT INTO _Revisao VALUES
	(1, 3, 'This is revision 1', 45),
	(1, 6, 'This is revision 2', 50),
	(1, 9, 'This is revision 3', 62),
	(1, 12, 'This is revision 4', 73),
	(1, 15, 'This is revision 5', 90)