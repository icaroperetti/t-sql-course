---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	5 - Funções do SQL Server
--	DEMO 5.4:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	NULL Functions:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	ISNULL
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	ISNULL ( check_expression , replacement_value )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/isnull-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT ISNULL('Luiz Vitor', 'Vou substituir o valor do primeiro parâmetro!')

SELECT ISNULL(NULL, 'Vou substituir o valor do primeiro parâmetro!')

SELECT ISNULL('Luiz Vitor', 100)
GO

--	EXEMPLO 2.1:
DECLARE @VAR_TESTE INT = 1

SELECT @VAR_TESTE

IF (@VAR_TESTE <> NULL)
BEGIN
	SELECT 'O VALOR INFORMADO NÃO É NULL!'
END
ELSE
BEGIN
	SELECT 'O VALOR INFORMADO É NULL!'
END
GO

--	EXEMPLO 2.1:
DECLARE @VAR_TESTE INT

SELECT @VAR_TESTE

IF (@VAR_TESTE IS NOT NULL)
BEGIN
	SELECT 'O VALOR INFORMADO NÃO É NULL!'
END
ELSE
BEGIN
	SELECT 'O VALOR INFORMADO É NULL!'
END
GO

DECLARE @VAR_TESTE INT = 1

SELECT @VAR_TESTE

IF (@VAR_TESTE IS NOT NULL)
BEGIN
	SELECT 'O VALOR INFORMADO NÃO É NULL!'
END
ELSE
BEGIN
	SELECT 'O VALOR INFORMADO É NULL!'
END
GO

--	EXEMPLO 3:
DECLARE @VAR_TESTE VARCHAR(100) = 'Luiz Vitor'

SELECT ISNULL(@VAR_TESTE, 'Vou substituir o valor do primeiro parâmetro!')

SET @VAR_TESTE = NULL

SELECT ISNULL(@VAR_TESTE, 'Vou substituir o valor do primeiro parâmetro!')
GO

--	EXEMPLO 4:
DECLARE @VAR_TESTE VARCHAR(100) = 'Luiz Vitor'

SELECT 'Nome Cliente: ' + ISNULL(@VAR_TESTE, 'Cliente não encontrado!')

SET @VAR_TESTE = NULL

SELECT 'Nome Cliente: ' + @VAR_TESTE

SELECT 'Nome Cliente: ' + ISNULL(@VAR_TESTE, 'Cliente não encontrado!')
GO

--	EXEMPLO 5:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NULL,
	PRIMARY KEY(Id_Cliente)
)

INSERT INTO Cliente (FirstName, LastName)
VALUES
	('Luiz','Lima'),
	('Fabricio','Lima'),
	('Rodrigo', NULL),
	('Fabiano', NULL)

SELECT * FROM Cliente

SELECT
	Id_Cliente,
	FirstName,
	ISNULL(LastName, 'Não informado!') AS LastName,
	ISNULL(LastName, '') AS LastName2
FROM Cliente


---------------------------------------------------------------------------------------------------------------
--	COALESCE
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	COALESCE ( expression [ ,...n ] )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/language-elements/coalesce-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT COALESCE(1,2,3)

SELECT COALESCE(NULL,2,3)

SELECT COALESCE(NULL,NULL,3)

SELECT COALESCE(1,2,'Luiz')

SELECT COALESCE(NULL,NULL,NULL)

Msg 4127, Level 16, State 1, Line 145
At least one of the arguments to COALESCE must be an expression that is not the NULL constant.

GO

--	EXEMPLO 2:
DECLARE @VAR_TESTE_1 INT = 1, @VAR_TESTE_2 INT = 2, @VAR_TESTE_3 INT = 3

SELECT COALESCE(@VAR_TESTE_1,@VAR_TESTE_2,@VAR_TESTE_3)

SELECT @VAR_TESTE_1 = NULL, @VAR_TESTE_2 = NULL

SELECT COALESCE(@VAR_TESTE_1,@VAR_TESTE_2,@VAR_TESTE_3)

SELECT @VAR_TESTE_1 = NULL, @VAR_TESTE_2 = NULL, @VAR_TESTE_3 = NULL

SELECT COALESCE(@VAR_TESTE_1,@VAR_TESTE_2,@VAR_TESTE_3)

GO

--	EXEMPLO 3:
DROP TABLE IF EXISTS Teste_Coalesce
GO

CREATE TABLE Teste_Coalesce (
	Id INT IDENTITY(1,1) NOT NULL,
	Coluna_1 VARCHAR(100) NULL,
	Coluna_2 VARCHAR(100) NULL,
	Coluna_3 VARCHAR(100) NULL
)

INSERT INTO Teste_Coalesce
VALUES 
	('1','2','3'),
	('1','2',NULL),
	('1',NULL,NULL),
	(NULL,NULL,NULL)

SELECT * FROM Teste_Coalesce


SELECT *, COALESCE(Coluna_3, Coluna_2, Coluna_1) AS Teste_Coalesce
FROM Teste_Coalesce