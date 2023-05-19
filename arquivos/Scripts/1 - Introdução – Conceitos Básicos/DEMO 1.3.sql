---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	1 - Introdução – Conceitos Básicos
--	DEMO 1.3:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Schemas

--	Utilizado para agrupar os objetos (tabelas, views, procedures, etc.) 
--	dentro do banco de dados, como se fosse um CONTAINER.

--	O schema default é o “dbo”. Uma database pode conter vários “schemas”.

--	Maior facilidade para segregar o controle de acesso dos usuários nos objetos.
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

CREATE SCHEMA [Vendas]
GO

CREATE SCHEMA [RH]
GO

DROP TABLE IF EXISTS [Vendas].[Estoque]
GO

CREATE TABLE [Vendas].[Estoque] (
	IdProduto INT NOT NULL,
	IdQtde INT NOT NULL
)

DROP TABLE IF EXISTS [Vendas].[Vendedor]
GO

CREATE TABLE [Vendas].[Vendedor] (
	IdVendedor INT IDENTITY(1,1) NOT NULL,
	NmVendedor VARCHAR(100) NOT NULL,
	CPF CPF,
	DtNascimento DATE
)

DROP TABLE IF EXISTS [RH].[Funcionario]
GO

CREATE TABLE [RH].[Funcionario] (
	IdFuncionario INT IDENTITY(1,1) NOT NULL,
	NmFuncionario VARCHAR(100) NOT NULL,
	CPF CPF,
	DtNascimento DATE NOT NULL,
	VlSalario NUMERIC(9,2) NOT NULL
)

DROP TABLE IF EXISTS [RH].[Ferias]
GO

CREATE TABLE [RH].[Ferias] (
	IdFuncionario INT NOT NULL,
	FlStatus TINYINT NOT NULL,
	DtInicio DATE NOT NULL,
	DtFim DATE NOT NULL
)

-- SCHEMA "dbo":
SELECT * FROM [dbo].[Cliente]

SELECT * FROM [Cliente]

-- [Vendas].[Estoque] 
SELECT * FROM [Estoque] 

/*
Msg 208, Level 16, State 1, Line 69
Invalid object name 'Estoque'.
*/

SELECT * FROM [Vendas].[Estoque] 

--	OBS: MOSTRAR A OPÇÃO DE SCHEMA DEFAULT DO USUÁRIO

--	CONTROLE DE ACESSO:

--	1) CONECTAR COM O USUÁRIO "teste" E EXECUTAR OS COMANDOS ABAIXO EM OUTRA QUERY
USE Treinamento_TSQL
GO

SELECT * FROM [Vendas].[Estoque] 

SELECT * FROM [Vendas].[Vendedor]

SELECT * FROM [RH].[Funcionario]

SELECT * FROM [RH].[Ferias]

/*
Msg 229, Level 14, State 5, Line 3
The SELECT permission was denied on the object 'Estoque', database 'Treinamento_TSQL', schema 'Vendas'.
Msg 229, Level 14, State 5, Line 5
The SELECT permission was denied on the object 'Vendedor', database 'Treinamento_TSQL', schema 'Vendas'.
Msg 229, Level 14, State 5, Line 7
The SELECT permission was denied on the object 'Funcionario', database 'Treinamento_TSQL', schema 'RH'.
Msg 229, Level 14, State 5, Line 9
The SELECT permission was denied on the object 'Ferias', database 'Treinamento_TSQL', schema 'RH'.
*/

--	2) LIBERAR O ACESSO DE LEITURA
USE Treinamento_TSQL
GO

GRANT SELECT ON [Vendas].[Estoque] TO [teste]

GRANT SELECT ON SCHEMA::[Vendas] TO [teste]


--	RETIRAR O ACESSO QUE FOI DADO ANTERIORMENTE
REVOKE SELECT ON [Vendas].[Estoque] TO [teste]

REVOKE SELECT ON SCHEMA::[Vendas] TO [teste]


---------------------------------------------------------------------------------------------------------------
--	Criando Tabelas e Tabelas Temporárias

--	Referências:
--	https://luizlima.net/dicas-t-sql-tabelas-temporarias-parte-1-tabelas-locais/
--	https://luizlima.net/dicas-t-sql-tabelas-temporarias-parte-2-tabelas-globais/
--	https://luizlima.net/dicas-t-sql-tabelas-temporarias-parte-3-tabelas-variaveis/
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
-- CRIANDO UMA TABELA
---------------------------------------------------------------------------------------------------------------
USE Treinamento_TSQL
GO

/*
Fl_Sexo:
	0 -> Feminino
	1 -> Masculino
*/

DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO [dbo].[Cliente]
VALUES('Fabrício Lima','19800106',1)

INSERT INTO [dbo].[Cliente]
VALUES('Luiz Lima','19890922',1)

SELECT * FROM [Cliente]

--	1) ALTERAÇÃO EM TABELAS:
--	INSERIR COLUNA
ALTER TABLE [Cliente]
ADD Telefone VARCHAR(9) NULL

SELECT * FROM [Cliente]

--	ALTERAR COLUNA - TIPO DE DADOS - CUIDADO COM TABELAS GRANDES!!!
ALTER TABLE [Cliente]
ALTER COLUMN Telefone VARCHAR(11) NULL

ALTER TABLE [Cliente]
ALTER COLUMN Id_Cliente BIGINT NOT NULL

SELECT * FROM [Cliente]

--	ALTERAR COLUNA - NOME COLUNA - CUIDADO!!!
EXEC sp_rename 'Cliente.Telefone', 'Celular', 'column';

--	Caution: Changing any part of an object name could break scripts and stored procedures.

SELECT * FROM [Cliente]

--	DELETAR COLUNA
ALTER TABLE [Cliente]
DROP COLUMN Celular

SELECT * FROM [Cliente]


--	2) CRIANDO TABELA COM PALAVRAS RESERVADAS. NÃO FAÇA ISSO!!!

DROP TABLE IF EXISTS "FROM"
GO

CREATE TABLE "FROM" (
	"SELECT" VARCHAR(100),
	"WHERE" VARCHAR(100),
	[GROUP BY] VARCHAR(100),
	[ORDER BY] VARCHAR(100)
)

INSERT INTO "FROM"
VALUES('SELECT','WHERE','GROUP BY ','ORDER BY')

SELECT "SELECT", [GROUP BY], [ORDER BY]
FROM "FROM"
GROUP BY "SELECT", [GROUP BY], [ORDER BY]
ORDER BY [ORDER BY]

DROP TABLE "FROM"

--	3) TENTAR CRIAR UMA TABELA COM O USUÁRIO "teste" QUE NÃO TEM PERMISSÃO PARA ISSO NA BASE DO TREINAMENTO!

---------------------------------------------------------------------------------------------------------------
-- CRIANDO UMA TABELA TEMPORÁRIA - LOCAL
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #Cliente

CREATE TABLE #Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO #Cliente
VALUES('Luiz Lima','19890520',1)

SELECT * FROM #Cliente

--	1) ABRIR OUTRA QUERY E CRIAR A MESMA TABELA E CONFERIR NA BASE TEMPDB NO OBJECT EXPLORER
--	OBS: VERIFICAR O NOME DINÂMICO DA TABELA NO TEMPBD
SELECT * FROM [dbo].[#Cliente____________________________________________________________________________________________________________00000000002D]

DROP TABLE #Cliente

--	2) TENTAR ACESSAR A TABELA TEMPORÁRIA ATRAVÉS DE OUTRA QUERY

--	3) EXEMPLO PERFORMANCE
--	Pode ajudar na performance (Tuning) quando precisamos acessar o mesmo dado várias vezes.

--	ACESSANDO A TABELA PRINCIPAL
SELECT * FROM [Cliente]
WHERE Dt_Nascimento >= '19800101'

...

SELECT * FROM [Cliente]
WHERE Dt_Nascimento >= '19800101'

...

SELECT * FROM [Cliente]
WHERE Dt_Nascimento >= '19800101'

--	FAZER O SELECT SOMENTE UMA VEZ E GUARDAR EM UMA TABELA TEMPORÁRIA
DROP TABLE IF EXISTS #TEMP_Cliente

SELECT * 
INTO #TEMP_Cliente
FROM [Cliente]
WHERE Dt_Nascimento >= '19800101'

SET STATISTICS IO ON

SELECT * FROM #TEMP_Cliente

/*
(2 rows affected)
Table '#TEMP_Cliente_______________________________________________________________________________________________________00000000002B'. Scan count 1, logical reads 1, physical reads 0, page server reads 0, read-ahead reads 0, page server read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob page server reads 0, lob read-ahead reads 0, lob page server read-ahead reads 0.
*/

...

SELECT * FROM #TEMP_Cliente

...

SELECT * FROM #TEMP_Cliente


DROP TABLE #TEMP_Cliente

SET STATISTICS IO OFF

DROP TABLE IF EXISTS #TEMP_Cliente

---------------------------------------------------------------------------------------------------------------
-- CRIANDO UMA TABELA TEMPORÁRIA - GLOBAL
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS ##Cliente

CREATE TABLE ##Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO ##Cliente
VALUES('Luiz Lima','19890520',1)

SELECT * FROM ##Cliente

--	1) FAZER UM SELECT NA TABELA EM OUTRA QUERY

--	2) DELETAR O REGISTRO EM OUTRA QUERY
DELETE FROM ##Cliente 

DROP TABLE IF EXISTS ##Cliente

---------------------------------------------------------------------------------------------------------------
-- CRIANDO UMA TABELA TEMPORÁRIA - VARIÁVEL
---------------------------------------------------------------------------------------------------------------
USE Treinamento_TSQL

DECLARE @Cliente TABLE (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO @Cliente
VALUES('Luiz Lima','19890520',1)

SELECT * FROM @Cliente

GO

SELECT * FROM @Cliente

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 1 - VARIÁVEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @MySalary INT = 100000;

BEGIN TRAN
	SET @MySalary = @MySalary * 2;
ROLLBACK;

-- RESULTADO
SELECT @MySalary
GO

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 2 - TABELAS VARIÁVEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @People TABLE (Name VARCHAR(50));

BEGIN TRAN
	INSERT INTO @People VALUES ('Bill Gates');
	INSERT INTO @People VALUES ('Melinda Gates');
	INSERT INTO @People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM @People;
GO

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 3 - TABELAS TEMPORÁRIAS LOCAIS:
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #People

CREATE TABLE #People (
	Name VARCHAR(50)
);

BEGIN TRAN
	INSERT INTO #People VALUES ('Bill Gates');
	INSERT INTO #People VALUES ('Melinda Gates');
	INSERT INTO #People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM #People;

DROP TABLE IF EXISTS #People
GO

---------------------------------------------------------------------------------------------------------------
--	Criando uma nova base de dados
---------------------------------------------------------------------------------------------------------------
CREATE DATABASE [Teste_New_Database] 
ON  PRIMARY ( 
	NAME = N'Teste_New_Database', 
	FILENAME = N'C:\SQLServer\Data\Teste_New_Database.mdf' , 
	SIZE = 102400KB , FILEGROWTH = 102400KB 
)
LOG ON ( 
	NAME = N'Teste_New_Database_log', 
	FILENAME = N'C:\SQLServer\Log\Teste_New_Database_log.ldf' , 
	SIZE = 30720KB , FILEGROWTH = 30720KB 
)
-- COLLATE Latin1_General_CI_AS
GO

DROP DATABASE [Teste_New_Database]

---------------------------------------------------------------------------------------------------------------
--	COLLATION E COLLATE

--	Case Sensitive (CS): 'A' <> 'a'

--	Case Insensitive (CI): 'A' = 'a'

--	Accent Sensitive (AS): 'á' <> 'a'

--	Accent Insensitive (AI): 'á' = 'a'
---------------------------------------------------------------------------------------------------------------

--	COLLATION: SQL_Latin1_General_CP1_CI_AS
SELECT * 
FROM [Cliente]

--	CI: CASE INSENSITIVE
SELECT * 
FROM Cliente
WHERE Nm_Cliente = 'Luiz Lima'

SELECT * 
FROM Cliente
WHERE Nm_Cliente = 'luiz lima'

--	AS: ACCENT SENSITIVE
SELECT * 
FROM Cliente
WHERE Nm_Cliente = 'Fabrício Lima'

SELECT * 
FROM Cliente
WHERE Nm_Cliente = 'Fabricio Lima'

-- COLLATE
SELECT * 
FROM Cliente
WHERE Nm_Cliente COLLATE Latin1_General_CI_AI = 'Fabricio Lima'