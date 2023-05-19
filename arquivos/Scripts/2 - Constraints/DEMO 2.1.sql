---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	2 - Constraints
--	DEMO 2.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	Criando Índices
---------------------------------------------------------------------------------------------------------------
--	Referências:

--	Dirceu Resende
--	Entendendo o funcionamento dos índices no SQL Server
--	https://www.dirceuresende.com/blog/entendendo-o-funcionamento-dos-indices-no-sql-server/

--	Fabricio Lima
--	Breve introdução sobre índices - Heap, Clustered e Nonclustered
--	https://www.youtube.com/watch?v=lPwjhtHEfw0&t=1s
---------------------------------------------------------------------------------------------------------------

/*
OBS: Colunas que são dos tipos de dados ntext, text, varchar(max), nvarchar(max), varbinary(max), xml ou image 
	 NÃO podem ser especificadas como colunas de um índice.
*/

--	1) CLUSTERED INDEX
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	Dt_Cadastro DATETIME NOT NULL CONSTRAINT DF_DtCadastro DEFAULT(GETDATE())
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

--	EXECUTAR O SELECT E CONFERIR O PLANO DE EXECUÇÃO
SELECT Nm_Cliente 
FROM [dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'

--	CRIA O ÍNDICE
CREATE CLUSTERED INDEX [IX_Nm_Cliente]
ON [dbo].[Cliente] (Nm_Cliente)
-- WITH(FILLFACTOR = 90, DATA_COMPRESSION = PAGE, ONLINE = ON)

--	EXECUTAR O SELECT E CONFERIR O PLANO DE EXECUÇÃO
SELECT Nm_Cliente 
FROM [dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'

DROP INDEX [dbo].[Cliente].[IX_Nm_Cliente]

GO


--	2) NONCLUSTERED INDEX
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	Dt_Cadastro DATETIME NOT NULL CONSTRAINT DF_DtCadastro DEFAULT(GETDATE())
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

--	EXECUTAR O SELECT E CONFERIR O PLANO DE EXECUÇÃO
SELECT Nm_Cliente 
FROM [dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'

--	CRIA O ÍNDICE
CREATE NONCLUSTERED INDEX [IX_Nm_Cliente]
ON [dbo].[Cliente] (Nm_Cliente)
-- WITH(FILLFACTOR = 90, DATA_COMPRESSION = PAGE, ONLINE = ON)

--	EXECUTAR O SELECT E CONFERIR O PLANO DE EXECUÇÃO
SELECT Nm_Cliente 
FROM [dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'


---------------------------------------------------------------------------------------------------------------
--	Constraints
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/alter-table-table-constraint-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Primary Key
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/tables/create-primary-keys?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	1) Definindo na Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	CONSTRAINT [PK_Cliente] PRIMARY KEY(Id_Cliente)
)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO "DUPLICADO"
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

GO

--	2) Definindo APÓS a Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Primary Key
ALTER TABLE [Cliente]
ADD CONSTRAINT [PK_Cliente]
PRIMARY KEY(Id_Cliente)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

--	3) Tentando Definir uma Segunda Primary Key
ALTER TABLE [Cliente]
ADD CONSTRAINT [PK_Cliente]
PRIMARY KEY(Nm_Cliente)

/*
Msg 1779, Level 16, State 0, Line 59
Table 'Cliente' already has a primary key defined on it.
Msg 1750, Level 16, State 0, Line 59
Could not create constraint or index. See previous errors.
*/

--	4) Tentando utilizar uma coluna que aceita NULL
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Primary Key
ALTER TABLE [Cliente]
ADD CONSTRAINT [PK_Cliente]
PRIMARY KEY(Nm_Cliente)

/*
Msg 8111, Level 16, State 1, Line 85
Cannot define PRIMARY KEY constraint on nullable column in table 'Cliente'.
Msg 1750, Level 16, State 0, Line 85
Could not create constraint or index. See previous errors.
*/

--	5) Tentando inserir um registro duplicado
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Primary Key
ALTER TABLE [Cliente]
ADD CONSTRAINT [PK_Cliente]
PRIMARY KEY(Nm_Cliente)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO DUPLICADO
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 2627, Level 14, State 1, Line 123
Violation of PRIMARY KEY constraint 'PK_Cliente'. Cannot insert duplicate key in object 'dbo.Cliente'. 
The duplicate key value is (Fabrício Lima).
*/

SELECT * FROM [dbo].[Cliente]

--	6) Utilizando uma Primary Key Composta
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Primary Key
ALTER TABLE [Cliente]
ADD CONSTRAINT [PK_Cliente]
PRIMARY KEY(Nm_Cliente, Dt_Nascimento)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19850106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO DUPLICADO
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 2627, Level 14, State 1, Line 155
Violation of PRIMARY KEY constraint 'PK_Cliente'. Cannot insert duplicate key in object 'dbo.Cliente'. 
The duplicate key value is (Fabrício Lima, 1980-01-06).
*/


---------------------------------------------------------------------------------------------------------------
--	Unique Constraint
---------------------------------------------------------------------------------------------------------------

--	1) Definindo na Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	CONSTRAINT [UQ_Cliente] UNIQUE(Id_Cliente)
)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO "DUPLICADO"
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

GO


--	2) Definindo APÓS a Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Unique Constraint
ALTER TABLE [Cliente]
ADD CONSTRAINT [UQ_Cliente]
UNIQUE(Id_Cliente)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]


--	3) Tentando Definir uma segunda Unique Constraint
ALTER TABLE [Cliente]
ADD CONSTRAINT [UQ_Nm_Cliente]
UNIQUE(Nm_Cliente)


--	4) Tentando utilizar uma coluna que aceita NULL
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Unique Constraint
ALTER TABLE [Cliente]
ADD CONSTRAINT [UQ_Cliente]
UNIQUE(Nm_Cliente)

INSERT INTO [dbo].[Cliente]
VALUES(NULL, '19800106', 1)

SELECT * FROM [dbo].[Cliente]

--	Adicionando mais uma linha NULL
INSERT INTO [dbo].[Cliente]
VALUES(NULL, '19800525', 1)

SELECT * FROM [dbo].[Cliente]

/*
Msg 2627, Level 14, State 1, Line 239
Violation of UNIQUE KEY constraint 'UQ_Cliente'. Cannot insert duplicate key in object 'dbo.Cliente'. 
The duplicate key value is (<NULL>).
*/


--	5) Tentando inserir um registro duplicado
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Unique Constraint
ALTER TABLE [Cliente]
ADD CONSTRAINT [UQ_Cliente]
UNIQUE(Nm_Cliente)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO DUPLICADO
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 2627, Level 14, State 1, Line 258
Violation of UNIQUE KEY constraint 'UQ_Cliente'. Cannot insert duplicate key in object 'dbo.Cliente'. 
The duplicate key value is (Fabrício Lima).
*/

SELECT * FROM [dbo].[Cliente]


--	6) Utilizando uma Unique Constraint Composta
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

--	Adicionando a Unique Constraint
ALTER TABLE [Cliente]
ADD CONSTRAINT [UQ_Cliente]
UNIQUE(Nm_Cliente, Dt_Nascimento)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

SELECT * FROM [dbo].[Cliente]

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19850106', 1)

SELECT * FROM [dbo].[Cliente]

-- INSERIR REGISTRO DUPLICADO
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 2627, Level 14, State 1, Line 290
Violation of UNIQUE KEY constraint 'UQ_Cliente'. Cannot insert duplicate key in object 'dbo.Cliente'. 
The duplicate key value is (Fabrício Lima, 1980-01-06).
*/


--	7) Primary Key + Unique
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(Id_Cliente),
	CONSTRAINT UQ_Nm_Cliente UNIQUE(Nm_Cliente)
)

--	INSERE ALGUNS REGISTROS
INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 2627, Level 14, State 1, Line 447
Violation of UNIQUE KEY constraint 'UQ_Nm_Cliente'. 
Cannot insert duplicate key in object 'dbo.Cliente'. The duplicate key value is (Fabrício Lima).
*/

SELECT * FROM [dbo].[Cliente]


---------------------------------------------------------------------------------------------------------------
--	Foreign Key
---------------------------------------------------------------------------------------------------------------
--	Referência
--	https://docs.microsoft.com/pt-br/sql/relational-databases/tables/create-foreign-key-relationships?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	1) TESTE FOREIGN KEY
DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]
GO

CREATE TABLE [dbo].[Tipo_Produto] (
	Id_Tipo_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Tipo_Produto VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Tipo_Produto] PRIMARY KEY (Id_Tipo_Produto)
)

INSERT INTO [dbo].[Tipo_Produto]
VALUES('Celular'),('Video Game')

SELECT * FROM [dbo].[Tipo_Produto]

CREATE TABLE [dbo].[Produto] (
	Id_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Produto VARCHAR(100) NOT NULL,
	Id_Tipo_Produto INT NOT NULL,	
	CONSTRAINT [PK_Produto] PRIMARY KEY (Id_Produto)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

--	ADICIONA ALGUNS PRODUTOS
INSERT INTO [dbo].[Produto]
VALUES
	('Samsung Galaxy', 1),('Iphone', 1),
	('Playstation', 2),('Xbox', 2)

SELECT * FROM [dbo].[Produto]

--	TENTA INSERIR UM TIPO DE PRODUTO INEXISTENTE
INSERT INTO [dbo].[Produto]
VALUES ('Notebook Dell', 3)

/*
Msg 547, Level 16, State 0, Line 355
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Tipo_Produto". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Tipo_Produto", column 'Id_Tipo_Produto'.
*/

--	TENTA FAZER UPDATE COM UM TIPO DE PRODUTO INEXISTENTE
UPDATE [dbo].[Produto]
SET Id_Tipo_Produto = 10
WHERE Id_Produto = 2

/*
Msg 547, Level 16, State 0, Line 479
The UPDATE statement conflicted with the FOREIGN KEY constraint "FK_Tipo_Produto". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Tipo_Produto", column 'Id_Tipo_Produto'.
*/


--	2) FOREIGN KEY - INSERINDO COLUNAS COM O VALOR NULL
DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]
GO

CREATE TABLE [dbo].[Tipo_Produto] (
	Id_Tipo_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Tipo_Produto VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Tipo_Produto] PRIMARY KEY (Id_Tipo_Produto)
)

CREATE TABLE [dbo].[Produto] (
	Id_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Produto VARCHAR(100) NOT NULL,
	Id_Tipo_Produto INT NULL,	
	CONSTRAINT [PK_Produto] PRIMARY KEY (Id_Produto)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

INSERT INTO [dbo].[Produto]
VALUES ('Notebook Dell', NULL)

SELECT * FROM [dbo].[Produto]

INSERT INTO [dbo].[Produto]
VALUES ('Notebook HP', NULL)

SELECT * FROM [dbo].[Produto]

INSERT INTO [dbo].[Produto]
VALUES ('Notebook HP', 1)

SELECT * FROM [dbo].[Produto]


--	3) TABELA COM MAIS DE UMA FOREIGN KEY
--	TABELA TIPO PRODUTO:
DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]
DROP TABLE IF EXISTS [dbo].[Fornecedor]
GO

CREATE TABLE [dbo].[Tipo_Produto] (
	Id_Tipo_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Tipo_Produto VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Tipo_Produto] PRIMARY KEY (Id_Tipo_Produto)
)

INSERT INTO [dbo].[Tipo_Produto]
VALUES('Celular'),('Video Game')

--	TABELA FORNECEDOR:
CREATE TABLE [dbo].[Fornecedor] (
	Id_Fornecedor INT IDENTITY(1,1) NOT NULL,
	Nm_Fornecedor VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Fornecedor] PRIMARY KEY (Id_Fornecedor)
)

INSERT INTO [dbo].[Fornecedor]
VALUES('Sony'),('Microsoft')

SELECT * FROM [dbo].[Fornecedor]

--	TABELA PRODUTO:
DROP TABLE IF EXISTS [dbo].[Produto]

CREATE TABLE [dbo].[Produto] (
	Id_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Produto VARCHAR(100) NOT NULL,
	Id_Tipo_Produto INT NOT NULL,	
	Id_Fornecedor INT NOT NULL,
	CONSTRAINT [PK_Produto] PRIMARY KEY (Id_Produto)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Fornecedor]
FOREIGN KEY ([Id_Fornecedor])
REFERENCES [Fornecedor] ([Id_Fornecedor])

SELECT * FROM [dbo].[Tipo_Produto]
SELECT * FROM [dbo].[Fornecedor]

--	ADICIONA ALGUNS PRODUTOS
INSERT INTO [dbo].[Produto](Nm_Produto, Id_Tipo_Produto, Id_Fornecedor)
VALUES
	('Sony Cell', 1, 1),('Microsoft Cell', 1, 2),
	('Playstation', 2, 1),('Xbox', 2, 2)

SELECT * FROM [dbo].[Produto]

--	TENTA INSERIR UM TIPO DE PRODUTO INEXISTENTE
--	TIPO DE PRODUTO
INSERT INTO [dbo].[Produto](Nm_Produto, Id_Tipo_Produto, Id_Fornecedor)
VALUES ('Notebook Dell', 3, 1)

/*
Msg 547, Level 16, State 0, Line 467
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Tipo_Produto". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Tipo_Produto", column 'Id_Tipo_Produto'.
*/

--	FORNECEDOR
INSERT INTO [dbo].[Produto](Nm_Produto, Id_Tipo_Produto, Id_Fornecedor)
VALUES ('Notebook Dell', 1, 3)

/*
Msg 547, Level 16, State 0, Line 477
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Fornecedor". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Fornecedor", column 'Id_Fornecedor'.
*/

--	RETORNANDO A DESCRIÇÃO DAS OUTRAS TABELAS (USANDO JOINS - UNINDO TABELAS)
SELECT 
	P.Id_Produto, P.Nm_Produto, 
	T.Id_Tipo_Produto, T.Nm_Tipo_Produto,
	F.Id_Fornecedor, F.Nm_Fornecedor
FROM [dbo].[Produto] P
JOIN [dbo].[Tipo_Produto] T ON P.Id_Tipo_Produto = T.Id_Tipo_Produto
JOIN [dbo].[Fornecedor] F ON P.Id_Fornecedor = F.Id_Fornecedor
ORDER BY P.Nm_Produto


--	4) FOREIGN KEY REFERENCIANDO A PROPRIA TABELA
DROP TABLE IF EXISTS [dbo].[Funcionario]
GO

CREATE TABLE [dbo].[Funcionario] (
	Id_Funcionario INT IDENTITY(1,1) NOT NULL,
	Nm_Funcionario VARCHAR(100) NOT NULL,
	Id_Gerente INT NULL,
	CONSTRAINT [PK_Funcionario] PRIMARY KEY (Id_Funcionario)
)

ALTER TABLE [dbo].[Funcionario]
ADD CONSTRAINT [FK_Gerente]
FOREIGN KEY ([Id_Gerente])
REFERENCES [Funcionario] ([Id_Funcionario])

--	INSERE ALGUNS REGISTROS
INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Id_Gerente)
VALUES('Fabrício Lima', NULL)

SELECT * FROM [dbo].[Funcionario]

INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Id_Gerente)
VALUES('Luiz Lima', 1)

SELECT * FROM [dbo].[Funcionario]

INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Id_Gerente)
VALUES('Dirceu Resende', 10)

/*
Msg 547, Level 16, State 0, Line 525
The INSERT statement conflicted with the FOREIGN KEY SAME TABLE constraint "FK_Gerente". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Funcionario", column 'Id_Funcionario'.
*/

--	RETORNANDO A DESCRIÇÃO INCLUINDO O GERENTE (USANDO JOINS - UNINDO TABELAS)
--	JOIN
SELECT 
	F.Id_Funcionario, F.Nm_Funcionario,
	G.Id_Funcionario, G.Nm_Funcionario AS Nm_Gerente	
FROM [dbo].[Funcionario] F
JOIN [dbo].[Funcionario] G ON F.Id_Gerente = G.Id_Funcionario
ORDER BY F.Nm_Funcionario

--	USANDO LEFT JOIN PARA RETORNAR TODOS OS FUNCIONARIOS
SELECT 
	F.Id_Funcionario, F.Nm_Funcionario,
	F.Id_Gerente, G.Nm_Funcionario AS Nm_Gerente	
FROM [dbo].[Funcionario] F
LEFT JOIN [dbo].[Funcionario] G ON F.Id_Gerente = G.Id_Funcionario
ORDER BY F.Nm_Funcionario


--	5) FOREIGN KEY REFENCIANDO COLUNA UNIQUE
--	TABELA TIPO PRODUTO:
DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]
GO

CREATE TABLE [dbo].[Tipo_Produto] (
	Id_Tipo_Produto INT NULL,
	Nm_Tipo_Produto VARCHAR(100) NOT NULL,
	CONSTRAINT [UQ_Tipo_Produto] UNIQUE (Id_Tipo_Produto)
)

INSERT INTO [dbo].[Tipo_Produto]
VALUES(1, 'Celular'),(2, 'Video Game'),(NULL, 'Desconhecido')

SELECT * FROM [dbo].[Tipo_Produto]

--	TABELA PRODUTO:
DROP TABLE IF EXISTS [dbo].[Produto]

CREATE TABLE [dbo].[Produto] (
	Id_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Produto VARCHAR(100) NOT NULL,
	Id_Tipo_Produto INT NULL
	CONSTRAINT [PK_Produto] PRIMARY KEY (Id_Produto)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

INSERT INTO [dbo].[Produto](Nm_Produto, Id_Tipo_Produto)
VALUES ('Iphone', 1),('Sei la', NULL)

SELECT * FROM [dbo].[Produto]


--	6) EXCLUIR TABELA QUE ESTÁ SENDO REFERENCIADA POR OUTRA
--	TABELA TIPO PRODUTO:
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]

/*
Msg 3726, Level 16, State 1, Line 591
Could not drop object 'dbo.Tipo_Produto' because it is referenced by a FOREIGN KEY constraint.
*/

DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]

SELECT * FROM [dbo].[Produto]
SELECT * FROM [dbo].[Tipo_Produto]


--	7) FOREIGN KEY x DELETE
DROP TABLE IF EXISTS [dbo].[Log_App_Details]
DROP TABLE IF EXISTS [dbo].[Log_App]
GO

CREATE TABLE [dbo].[Log_App] (
	Id_Log_App INT IDENTITY(1,1) NOT NULL,
	Dt_Log DATETIME NOT NULL DEFAULT(GETDATE()),
	Ds_Origem VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Log_App] PRIMARY KEY (Id_Log_App)
)

INSERT INTO [dbo].[Log_App] (Ds_Origem)
VALUES('Log - Tela 1'),('Log - Tela 2'),('Log - Tela 3'),('Log - Tela 4'),('Log - Tela 5')

CREATE TABLE [dbo].[Log_App_Details] (
	Id_Log_App_Details INT IDENTITY(1,1) NOT NULL,
	Id_Log_App INT NOT NULL,
	Ds_Detalhes VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Log_App_Details] PRIMARY KEY (Id_Log_App_Details)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Log_App_Details]
ADD CONSTRAINT [FK_Log_App_Details_Id_Log]
FOREIGN KEY ([Id_Log_App])
REFERENCES [Log_App] ([Id_Log_App])

--	ADICIONA ALGUNS PRODUTOS
INSERT INTO [dbo].[Log_App_Details] (Id_Log_App, Ds_Detalhes)
VALUES
	(1, 'Alteracao Nome Cliente'),(1, 'Alteracao Telefone'),
	(2, 'Alteracao Nome Endereco'),(2, 'Alteracao Telefone')

SELECT * FROM [dbo].[Log_App]
SELECT * FROM [dbo].[Log_App_Details]


--	7.1) TENTAR DELETAR REGISTRO DA TABELA LOG "Log_App"
DELETE [dbo].[Log_App]
WHERE Id_Log_App = 1

/*
Msg 547, Level 16, State 0, Line 770
The DELETE statement conflicted with the REFERENCE constraint "FK_Log_App_Details_Id_Log". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Log_App_Details", column 'Id_Log_App'.
*/

--	7.2) DELETAR REGISTRO DA TABELA "Log_App_Details" E DEPOIS DA TABELA "Log_App"
DELETE [dbo].[Log_App_Details]
WHERE Id_Log_App = 1

DELETE [dbo].[Log_App]
WHERE Id_Log_App = 1

SELECT * FROM [dbo].[Log_App]
SELECT * FROM [dbo].[Log_App_Details]


--	7.3) DELETAR REGISTRO DA TABELA "Log_App" USANDO "NOCHECK" -> 
--	BAD PRACTICE - CUIDADO, POIS PODE AFETAR A CONSISTENCIA DA TABELA!!!
--	VALIDA AS INFORMACOES DOS LOGS
SELECT *
FROM [dbo].[Log_App_Details] D
JOIN [dbo].[Log_App] L ON L.[Id_Log_App] = D.[Id_Log_App]
WHERE D.Id_Log_App = 2

--	DESABILITA A FOREIGN KEY
ALTER TABLE [dbo].[Log_App_Details]
NOCHECK CONSTRAINT FK_Log_App_Details_Id_Log;  
GO  

--	 DELETA O REGISTRO NA TABELA "Log_App"
DELETE [dbo].[Log_App]
WHERE Id_Log_App = 2

SELECT * FROM [dbo].[Log_App]
SELECT * FROM [dbo].[Log_App_Details]

--	HABILITA A FOREIGN KEY
ALTER TABLE [dbo].[Log_App_Details]
CHECK CONSTRAINT FK_Log_App_Details_Id_Log
GO  

SELECT * FROM [dbo].[Log_App]
SELECT * FROM [dbo].[Log_App_Details]

--	VALIDA AS INFORMACOES DOS LOGS
SELECT *
FROM [dbo].[Log_App_Details] D
JOIN [dbo].[Log_App] L ON L.[Id_Log_App] = D.[Id_Log_App]
WHERE D.Id_Log_App = 2

SELECT *
FROM [dbo].[Log_App_Details] D
LEFT JOIN [dbo].[Log_App] L ON L.[Id_Log_App] = D.[Id_Log_App]
WHERE D.Id_Log_App = 2


---------------------------------------------------------------------------------------------------------------
--	Check Constraint
---------------------------------------------------------------------------------------------------------------

-- EXEMPLO 1:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario
CHECK(Vl_Salario > 0.00)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 50000.00)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 1000.00)

INSERT INTO [dbo].[Cliente]
VALUES('Fabiano Amorim', '19750409', 20000.00)

SELECT * FROM [dbo].[Cliente]

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19700502', 0.00)

INSERT INTO [dbo].[Cliente]
VALUES('Rodrigo Ribeiro', '19500315', -100.00)

--	O VALOR NULL SERÁ INSERIDO???
INSERT INTO [dbo].[Cliente]
VALUES('Rodrigo Ribeiro', '19500315', NULL)

SELECT * FROM [dbo].[Cliente]

UPDATE [dbo].[Cliente]
SET Vl_Salario = 0.00
WHERE Nm_Cliente = 'Fabiano Amorim'

UPDATE [dbo].[Cliente]
SET Vl_Salario = NULL
WHERE Nm_Cliente = 'Fabiano Amorim'

SELECT * FROM [dbo].[Cliente]

GO

--	EXEMPLO 2 - USANDO EXPRESSÃO - AND:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario_Dt_Nascimento
CHECK(Vl_Salario > 0.00 AND Dt_Nascimento >= '19800101')

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 1000.00)

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19700502', 5000.00)

/*
Msg 547, Level 16, State 0, Line 942
The INSERT statement conflicted with the CHECK constraint "CHK_Vl_Salario_Dt_Nascimento". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Cliente".
*/

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 3 - USANDO EXPRESSÃO - OR:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario_Dt_Nascimento
CHECK(Vl_Salario > 0.00 OR Dt_Nascimento >= '19800101')

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 1000.00)

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19700502', 5000.00)

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 4 - SELECT X DELETE - NÃO FAZEM DIFERENÇA NO CHECK:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario_Dt_Nascimento
CHECK(Vl_Salario > 0.00)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 1000.00)

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19700502', 5000.00)

--	SELECT
SELECT * FROM [dbo].[Cliente]

--	DELETE
DELETE [dbo].[Cliente]
WHERE Id_Cliente = 2


--	EXEMPLO 5 - CRIANDO UMA CHECK CONSTRAINT EM UMA TABELA COM REGISTROS "INVALIDOS" PARA A NOVA CHECK:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19700502', 0.00)

INSERT INTO [dbo].[Cliente]
VALUES('Rodrigo Ribeiro', '19500315', -100.00)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19700502', 200.00)

SELECT * FROM [dbo].[Cliente]

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario
CHECK(Vl_Salario > 0.00)

/*
Msg 547, Level 16, State 0, Line 852
The ALTER TABLE statement conflicted with the CHECK constraint "CHK_Vl_Salario". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Cliente", column 'Vl_Salario'.
*/

--	COMO CORRIGIR OS REGISTROS "INVALIDOS"??? ALGUMA SUGESTÃO???



--	IDENTIFICAR OS REGISTROS INVÁLIDOS!
--	INSERIR EM UMA TABELA DE BKP PARA VALIDAR POSTERIORMENTE SE FOR NECESSARIO.
DROP TABLE IF EXISTS [dbo].[BKP20210623_Cliente_CHECK_VL_SALARIO]

SELECT * 
INTO [BKP20210623_Cliente_CHECK_VL_SALARIO]
FROM [dbo].[Cliente]
WHERE Vl_Salario <= 0.00

SELECT * FROM [BKP20210623_Cliente_CHECK_VL_SALARIO]

UPDATE [dbo].[Cliente]
SET Vl_Salario = NULL
WHERE Vl_Salario <= 0.00

SELECT * FROM [dbo].[Cliente]

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario
CHECK(Vl_Salario > 0.00)

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 6 - DESABILITANDO UM CHECK CONSTRAINT ->
--	BAD PRACTICE - CUIDADO, POIS PODE AFETAR A CONSISTENCIA DA TABELA!!!
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

ALTER TABLE [dbo].[Cliente]
ADD CONSTRAINT CHK_Vl_Salario
CHECK(Vl_Salario > 0.00)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 100.00)

INSERT INTO [dbo].[Cliente]
VALUES('Fabricio Lima', '19891026', 0.00)

/*
The INSERT statement conflicted with the CHECK constraint "CHK_Vl_Salario". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Cliente", column 'Vl_Salario'.
*/

SELECT * FROM [dbo].[Cliente]

--	 DESABILITA A CONSTRAINT
ALTER TABLE [dbo].[Cliente] 
NOCHECK CONSTRAINT CHK_Vl_Salario;  
GO  

-- FAZ UM UPDATE "INVALIDO"
UPDATE [dbo].[Cliente]
SET Vl_Salario = 0.00
WHERE Id_Cliente = 1

-- INSERE UM REGISTRO "INVALIDO"
INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima', '19891026', 0.00)

SELECT * FROM [dbo].[Cliente]

--	 TENTA HABILITAR NOVAMENTE A CONSTRAINT
ALTER TABLE [dbo].[Cliente] 
CHECK CONSTRAINT CHK_Vl_Salario;  

SELECT * FROM [dbo].[Cliente]

-- INSERE UM REGISTRO "INVALIDO"
INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19891026', 0.00)

/*
The INSERT statement conflicted with the CHECK constraint "CHK_Vl_Salario". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Cliente", column 'Vl_Salario'.
*/

INSERT INTO [dbo].[Cliente]
VALUES('Dirceu Resende', '19891026', 1.99)

SELECT * FROM [dbo].[Cliente]


---------------------------------------------------------------------------------------------------------------
--	Default Constraint
---------------------------------------------------------------------------------------------------------------
--	Definindo na Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	--Dt_Cadastro DATETIME NOT NULL DEFAULT(GETDATE())
	Dt_Cadastro DATETIME NOT NULL CONSTRAINT DF_DtCadastro DEFAULT(GETDATE())
)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 213, Level 16, State 1, Line 47
Column name or number of supplied values does not match table definition.
*/

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

SELECT * FROM [Cliente]

GO

--	Definindo APÓS a Criação da Tabela
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	Dt_Cadastro DATETIME NOT NULL
)

--	Adicionando a Constraint DEFAULT
ALTER TABLE [Cliente]
ADD CONSTRAINT [DF_DtCadastro]
DEFAULT(GETDATE()) FOR [Dt_Cadastro]

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima', '19800106', 1)

/*
Msg 213, Level 16, State 1, Line 47
Column name or number of supplied values does not match table definition.
*/

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

SELECT * FROM [Cliente]

--	Deletando a Constraint Default
ALTER TABLE [Cliente]
DROP CONSTRAINT [DF_DtCadastro]