---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	7 - Programação T-SQL
--	DEMO 7.2:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	IDENTITY 
---------------------------------------------------------------------------------------------------------------				
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/create-table-transact-sql-identity-property?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES
	('Fabrício Lima', 30000.00),
	('Luiz Lima', 1000.00),
	('Fabiano Amorim', 100000.00),
	('Dirceu Resende', 50000.00),
	('Rodrigo Ribeiro', 10000.00)

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 1 - IDENTITY x FALHA INSERT:
--	TENTAR INSERIR MAIS DE UMA VEZ!!!
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES ('Gustavo Larocca', NULL)

/*
Msg 515, Level 16, State 2, Line 40
Cannot insert the value NULL into column 'Vl_Salario', 
table 'Treinamento_TSQL.dbo.Cliente'; column does not allow nulls. INSERT fails.
The statement has been terminated.
*/

--	INSERIR NOVAMENTE E CONFERIR O VALOR DA COLUNA "Id_Cliente"
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES ('Gustavo Larocca', 5000.00)

SELECT * FROM [dbo].[Cliente]
GO


--	EXEMPLO 2 - IDENTITY x TRUNCATE:
--	COMENTAR SOBRE O RESET NO IDENTITY!
TRUNCATE TABLE [dbo].[Cliente]

SELECT * FROM [dbo].[Cliente]

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES
	('Fabrício Lima', 30000.00),
	('Luiz Lima', 1000.00),
	('Fabiano Amorim', 100000.00),
	('Dirceu Resende', 50000.00),
	('Rodrigo Ribeiro', 10000.00)

SELECT * FROM [dbo].[Cliente]
GO


--	EXEMPLO 3 - IDENTITY x SCOPE_IDENTITY:
--	Referências:
--	SCOPE_IDENTITY()
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/scope-identity-transact-sql?view=sql-server-ver15

--	@@IDENTITY
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/identity-transact-sql?view=sql-server-ver15

SELECT * FROM [dbo].[Cliente]

DECLARE @NEW_ID INT

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES ('Gustavo Larocca', 5000.00)

SELECT @NEW_ID = SCOPE_IDENTITY()

SELECT @NEW_ID

SELECT * FROM [dbo].[Cliente]

SELECT @@IDENTITY


--	EXEMPLO 4 - IDENTITY x IDENTITY_INSERT:
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/set-identity-insert-transact-sql?view=sql-server-ver15

SELECT * FROM [dbo].[Cliente]

--	4.1) SEM ESPECIFICAR AS COLUNAS
SET IDENTITY_INSERT [dbo].[Cliente] ON;

INSERT INTO [dbo].[Cliente]
VALUES (7, 'Raiane Flores', 5000.00)

SET IDENTITY_INSERT [dbo].[Cliente] OFF;
GO
/*
Msg 8101, Level 16, State 1, Line 110
An explicit value for the identity column in table 'dbo.Cliente' 
can only be specified when a column list is used and IDENTITY_INSERT is ON.
*/

SELECT * FROM [dbo].[Cliente]


--	4.2) ESPECIFICANDO AS COLUNAS
SET IDENTITY_INSERT [dbo].[Cliente] ON;

INSERT INTO [dbo].[Cliente] (Id_Cliente, Nm_Cliente, Vl_Salario)
VALUES (7, 'Raiane Flores', 5000.00)

SET IDENTITY_INSERT [dbo].[Cliente] OFF;

SELECT * FROM [dbo].[Cliente]

--	TENTAR INSERIR OUTRO REGISTRO ESPECIFICANDO O IDENTITY
INSERT INTO [dbo].[Cliente] (Id_Cliente, Nm_Cliente, Vl_Salario)
VALUES (8, 'Gaby Saraiva', 5000.00)

/*
Msg 544, Level 16, State 1, Line 135
Cannot insert explicit value for identity column 
in table 'Cliente' when IDENTITY_INSERT is set to OFF.
*/


--	EXEMPLO 5 - IDENTITY - CUIDADO: NÃO GARANTE REGISTROS ÚNICOS!!!

--	INSERINDO VÁRIOS CLIENTES COM O MESMO ID_CLIENTE
SET IDENTITY_INSERT [dbo].[Cliente] ON;

INSERT INTO [dbo].[Cliente] (Id_Cliente, Nm_Cliente, Vl_Salario)
VALUES (7, 'Walter Cutini', 5000.00)

INSERT INTO [dbo].[Cliente] (Id_Cliente, Nm_Cliente, Vl_Salario)
VALUES (7, 'Eduardo Rabelo', 5000.00)

INSERT INTO [dbo].[Cliente] (Id_Cliente, Nm_Cliente, Vl_Salario)
VALUES (7, 'Taiany Coelho', 5000.00)

SET IDENTITY_INSERT [dbo].[Cliente] OFF;

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 6 - IDENTITY x CHECKIDENT:
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/database-console-commands/dbcc-checkident-transact-sql?view=sql-server-ver15

--	ALTERAR O VALOR DO SEED DO IDENTITY
DBCC CHECKIDENT ('dbo.Cliente', RESEED, 99);

/*
Checking identity information: current identity value '7'.
DBCC execution completed. If DBCC printed error messages, contact your system administrator.
*/

SELECT * FROM [dbo].[Cliente]

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES ('Gaby Saraiva', 5000.00)

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 7 - IDENTITY x IDENT_CURRENT:
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/ident-current-transact-sql?view=sql-server-ver15

SELECT * FROM [dbo].[Cliente]

SELECT IDENT_CURRENT('dbo.Cliente')

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES ('Eduardo Roedel', 20000.00)

SELECT * FROM [dbo].[Cliente]

SELECT IDENT_CURRENT('dbo.Cliente')


--	EXEMPLO 8 - IDENTITY x SELECT INTO:
DROP TABLE IF EXISTS CLIENTE_IDENTITY

SELECT
	IDENTITY(INT,1,1) AS ID,
	Nm_Cliente
INTO CLIENTE_IDENTITY
FROM [dbo].[Cliente]

SELECT * FROM CLIENTE_IDENTITY

DROP TABLE IF EXISTS CLIENTE_IDENTITY


--	EXEMPLO 9 - IDENTITY x ALTERANDO O SEED E INCREMENT:

--	9.1) INCREMENT = 10
DROP TABLE IF EXISTS CLIENTE_IDENTITY

SELECT
	IDENTITY(INT,1,10) AS ID,
	Nm_Cliente
INTO CLIENTE_IDENTITY
FROM [dbo].[Cliente]

SELECT * FROM CLIENTE_IDENTITY

DROP TABLE IF EXISTS CLIENTE_IDENTITY


--	9.1) SEED = 1000 / INCREMENT = 10
DROP TABLE IF EXISTS CLIENTE_IDENTITY

SELECT
	IDENTITY(INT,1000,10) AS ID,
	Nm_Cliente
INTO CLIENTE_IDENTITY
FROM [dbo].[Cliente]

SELECT * FROM CLIENTE_IDENTITY

DROP TABLE IF EXISTS CLIENTE_IDENTITY
GO


--	EXEMPLO 10 - LISTANDO AS COLUNAS COM IDENTIY
SELECT OBJECT_NAME(object_id) AS Nm_Tabela, * 
FROM sys.identity_columns


---------------------------------------------------------------------------------------------------------------
--	SEQUENCE 
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/create-sequence-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-2012-trabalhando-com-sequences-e-comparacoes-com-identity/
--	https://www.dirceuresende.com/blog/utilizando-sequences-em-user-defined-functions-no-sql-server/
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1 - CRIANDO UM SEQUENCE:
DROP SEQUENCE IF EXISTS dbo.SeqID
GO

CREATE SEQUENCE dbo.SeqID
AS [INT]
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999999
	CYCLE
	-- CACHE
GO


--	EXEMPLO 2 - BUSCANDO O PRÓXIMO VALOR DO SEQUENCE
SELECT NEXT VALUE FOR dbo.SeqID
GO


--	EXEMPLO 3 - UTILIZANDO O SEQUENCE PARA INSERIR REGISTROS EM UMA TABELA
--	OBS: EXECUTAR O SCRIPT ABAIXO MAIS DE UMA VEZ E VALIDAR A COLUNA "Id_Cliente"!

DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Vl_Salario)
SELECT NEXT VALUE FOR dbo.SeqID, Nm_Cliente, Vl_Salario
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE
GO


--	EXEMPLO 4 - UTILIZANDO O SEQUENCE COMO DEFAULT

--	TENTANDO UTILIZAR UM SEQUENCE COM TABELAS TEMPORÁRIAS
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT DEFAULT NEXT VALUE FOR dbo.SeqID,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

/*
Msg 208, Level 16, State 1, Line 304
Invalid object name 'dbo.SeqID'.
*/
GO

--	UTILIZANDO UMA TABELA PERMANENTE
--	EXECUTAR MAIS DE UMA VEZ

DROP TABLE IF EXISTS TEMP_CLIENTE
GO

CREATE TABLE TEMP_CLIENTE (
	Id_Cliente INT DEFAULT NEXT VALUE FOR dbo.SeqID,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

--	INSERINDO REGISTROS NA TABELA
INSERT INTO TEMP_CLIENTE (Nm_Cliente, Vl_Salario)
SELECT Nm_Cliente, Vl_Salario
FROM [dbo].[Cliente]

SELECT * FROM TEMP_CLIENTE
GO


--	EXEMPLO 5 - REINICIAR O SEQUENCE

--	REINICIANDO COM O VALOR 1
ALTER SEQUENCE dbo.SeqID RESTART WITH 1

--	EXECUTAR MAIS DE UMA VEZ
SELECT NEXT VALUE FOR dbo.SeqID
GO

--	REINICIANDO COM O VALOR 100
ALTER SEQUENCE dbo.SeqID RESTART WITH 100

--	EXECUTAR MAIS DE UMA VEZ
SELECT NEXT VALUE FOR dbo.SeqID
GO


--	EXEMPLO 6 - SEQUENCE NÃO SÃO "UNIQUE" POR PADRÃO
TRUNCATE TABLE TEMP_CLIENTE

ALTER SEQUENCE dbo.SeqID RESTART WITH 100

INSERT INTO TEMP_CLIENTE (Nm_Cliente, Vl_Salario)
SELECT Nm_Cliente, Vl_Salario
FROM [dbo].[Cliente]

SELECT * FROM TEMP_CLIENTE

--	REINICIA O SEQUENCE E INSERE OS CLIENTES NOVAMENTE
ALTER SEQUENCE dbo.SeqID RESTART WITH 100

INSERT INTO TEMP_CLIENTE (Nm_Cliente, Vl_Salario)
SELECT Nm_Cliente, Vl_Salario
FROM [dbo].[Cliente]

SELECT * FROM TEMP_CLIENTE


--	EXEMPLO 7 - MAXVALUE x CYCLE:
DROP SEQUENCE IF EXISTS dbo.SeqID_Cycle

GO

CREATE SEQUENCE dbo.SeqID_Cycle
AS [INT]
	START WITH 1
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 5
	CYCLE
	-- CACHE
GO

--	BUSCA OS PRÓXIMOS VALORES
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 1
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 2
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 3
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 4
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 5

--- CYCLE

SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 1
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 2
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 3
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 4
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 5
SELECT NEXT VALUE FOR dbo.SeqID_Cycle	-- 1
GO


--	EXEMPLO 8 - SEQUENCE x INCREMENT:
DROP SEQUENCE IF EXISTS dbo.SeqID_Increment

GO

CREATE SEQUENCE dbo.SeqID_Increment
AS [INT]
	START WITH 1
	INCREMENT BY 10
GO

--	EXECUTAR MAIS DE UMA VEZ
SELECT NEXT VALUE FOR dbo.SeqID_Increment
GO


--	EXEMPLO 9 - LISTANDO OS SEQUENCES
SELECT 
	name,
	type_desc,
	create_date,
	start_value,
	increment,
	minimum_value,
	maximum_value,
	is_cycling,
	is_cached,
	current_value
FROM sys.sequences
GO


---------------------------------------------------------------------------------------------------------------
--	COLUNAS CALCULADAS 
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/tables/specify-computed-columns-in-a-table?view=sql-server-ver15
--	https://www.sqlshack.com/an-overview-of-computed-columns-in-sql-server/
--	https://www.sqlshack.com/how-to-create-indexes-on-sql-server-computed-columns/
--	https://www.dirceuresende.com/blog/sql-server-utilizando-colunas-calculadas-ou-colunas-computadas-para-performance-tuning/
--	https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/deterministic-and-nondeterministic-functions?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	CRIA A TABELA DE EXEMPLO:
DROP TABLE IF EXISTS Estoque
GO

CREATE TABLE Estoque (
	Id_Estoque INT IDENTITY(1,1) NOT NULL,
	Id_Produto INT NOT NULL,
	Qtde_Produto INT NOT NULL,
	Vl_Produto NUMERIC(9,2) NOT NULL
)

INSERT INTO Estoque (Id_Produto, Qtde_Produto, Vl_Produto)
VALUES
	(1, 10, 100.00),(2, 50, 500.00),(3, 100, 50.00),(4, 200, 35.00),(5, 1000, 10.00)

SELECT * FROM Estoque
GO


--	EXEMPLO 1 - CALCULANDO O VALOR TOTAL:
SELECT *, (Qtde_Produto * Vl_Produto) AS Vl_Total
FROM Estoque
GO


--	EXEMPLO 2 - CALCULANDO O VALOR TOTAL:

--	ADICIONA A COLUNA CALCULADA NA TABELA! (DETERMINÍSTICA!)
ALTER TABLE Estoque
ADD Vl_Total AS (Qtde_Produto * Vl_Produto) PERSISTED
GO

--	CRIANDO INDICE NA COLUNA CALCULADA
CREATE NONCLUSTERED INDEX SK01_VlTotal
ON Estoque (Vl_Total)
GO

SELECT *
FROM Estoque

--	CTRL+M -> MOSTRAR O PLANO DE EXECUÇÃO USANDO O INDICE DA COLUNA CALCULADA
SELECT SUM(Vl_Total) 
FROM Estoque

GO

--	"ALT+F1" NA TABELA "Estoque" PARA MOSTRAR A COLUNA "COMPUTED"


--	EXEMPLO 3 - LISTANDO AS "COLUNAS CALCULADAS" DO BANCO DE DADOS:
SELECT 
	OBJECT_NAME(object_id) AS Nm_Table, 
	name AS Nm_Column,
	definition,
	is_persisted
FROM sys.computed_columns


--	EXEMPLO 4 - VALIDANDO A ATUALIZACAO DO VALOR DA COLUNA CALCULADA
SELECT * FROM Estoque

UPDATE Estoque
SET Qtde_Produto = 100
WHERE Id_Estoque = 1

SELECT * FROM Estoque
GO


--	EXEMPLO 5 - COLUNA CALCULADA - NÃO DETERMINÍSTICA (IDADE) 
DROP TABLE IF EXISTS [dbo].[Funcionario]
GO

CREATE TABLE [dbo].[Funcionario] (
	Id_Funcionario INT IDENTITY(1,1) NOT NULL,
	Nm_Funcionario VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL
)

INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Dt_Nascimento)
VALUES
	('Fabrício Lima', '19800201'),
	('Luiz Lima', '19851210'),
	('Dirceu Resende', '19500625'),
	('Rodrigo Gomes', '19351005')
GO

SELECT * FROM [dbo].[Funcionario]
GO

--	TENTA CRIAR A COLUNA CALCULADA "IDADE" COMO "PERSISTED":
ALTER TABLE [dbo].[Funcionario]
ADD Idade AS DATEDIFF(YEAR, Dt_Nascimento, GETDATE()) PERSISTED
GO

/*
Msg 4936, Level 16, State 1, Line 538
Computed column 'Idade' in table 'Funcionario' cannot be persisted because the column is non-deterministic.
*/

--	CRIA A COLUNA CALCULADA "IDADE" COMO "NOT PERSISTED", POIS ELA É "NÃO-DETERMINÍSTICA":
ALTER TABLE [dbo].[Funcionario]
ADD Idade AS DATEDIFF(YEAR, Dt_Nascimento, GETDATE())
GO

SELECT * FROM [dbo].[Funcionario]
GO

--	TENTA CRIAR UM ÍNDICE
CREATE NONCLUSTERED INDEX SK01_Idade
ON [dbo].[Funcionario](Idade)

/*
Msg 2729, Level 16, State 1, Line 556
Column 'Idade' in table 'dbo.Funcionario' cannot be used in an index 
or statistics or as a partition key because it is non-deterministic.
*/
GO


--	EXEMPLO 6 - TENTA ATUALIZAR OU INSERIR VALOR NA COLUNA CALCULADA 
SELECT * FROM [dbo].[Funcionario]
GO

UPDATE [dbo].[Funcionario]
SET Idade = 30
WHERE Id_Funcionario = 1

/*
Msg 271, Level 16, State 1, Line 571
The column "Idade" cannot be modified because it is either a computed column or is the result of a UNION operator.
*/

INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Dt_Nascimento, Idade)
VALUES('Gustavo Larocca','20200101', 21)

/*
Msg 271, Level 16, State 1, Line 580
The column "Idade" cannot be modified because it is either a computed column or is the result of a UNION operator.
*/
GO


--	EXEMPLO 7 - UTILIZANDO COLUNAS CALCULADAS COM FUNÇÕES
DROP TABLE IF EXISTS Estoque
GO

CREATE TABLE Estoque (
	Id_Estoque INT IDENTITY(1,1) NOT NULL,
	Id_Produto INT NOT NULL,
	Qtde_Produto INT NOT NULL,
	Vl_Produto NUMERIC(9,2) NOT NULL
)

INSERT INTO Estoque (Id_Produto, Qtde_Produto, Vl_Produto)
VALUES
	(1, 10, 100.00),(2, 50, 500.00),(3, 100, 50.00),(4, 200, 35.00),(5, 1000, 10.00)

SELECT * FROM Estoque
GO

DROP FUNCTION IF EXISTS [dbo].[fncCalculaValorTotal]
GO

CREATE FUNCTION [dbo].[fncCalculaValorTotal] (
	@Qtde_Produto INT,
	@Vl_Produto NUMERIC(9,2)
)
RETURNS NUMERIC(9,2)
AS
BEGIN
	RETURN @Qtde_Produto * @Vl_Produto
END
GO

SELECT [dbo].[fncCalculaValorTotal](10, 100) AS Vl_Total


--	PROBLEMA DE PERFORMANCE - A FUNÇÃO É EXECUTADA PARA CADA LINHA A CADA EXECUÇÃO DA QUERY!
SELECT 
	*,
	[dbo].[fncCalculaValorTotal](Qtde_Produto, Vl_Produto) AS Vl_Total
FROM Estoque


--	RESOLVENDO O PROBLEMA -> CRIAR UMA COLUNA CALCULADA COM O RESULTADO DA FUNÇÃO!
ALTER TABLE Estoque
ADD Vl_Total AS [dbo].[fncCalculaValorTotal](Qtde_Produto, Vl_Produto) PERSISTED

/*
Msg 4936, Level 16, State 1, Line 633
Computed column 'Vl_Total' in table 'Estoque' cannot be persisted because the column is non-deterministic.
*/

GO

ALTER TABLE Estoque
ADD Vl_Total AS [dbo].[fncCalculaValorTotal](Qtde_Produto, Vl_Produto)
GO

SELECT * FROM Estoque