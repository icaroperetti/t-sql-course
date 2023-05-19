---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	5 - Funções do SQL Server
--	DEMO 5.1:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Casting and Conversion Functions:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	CAST:
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: CAST ( expression AS data_type [ ( length ) ] )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DECLARE @VAR_TESTE VARCHAR(10) = '156'

SELECT CAST(@VAR_TESTE AS INT) + 100

GO

--	EXEMPLO 2:
DECLARE @VAR_TESTE VARCHAR(10) = '156'

SELECT @VAR_TESTE + 100

GO

--	EXEMPLO 3:
DECLARE @VAR_TESTE VARCHAR(10) = '156A'

SELECT 100 + @VAR_TESTE

/*
Msg 245, Level 16, State 1, Line 49
Conversion failed when converting the varchar value '156A' to data type int.
*/

GO

--	EXEMPLO 4:
DECLARE @VAR_TESTE INT = 156

SELECT CAST(@VAR_TESTE AS VARCHAR(10)) + '100'

GO


--	EXEMPLO 5 - CONVERSÃO IMPLÍCITA:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL
)

INSERT INTO Cliente (Nm_Cliente)
VALUES('Luiz Vitor')

--	HABILITAR O PLANO DE EXECUÇÃO

--	TESTE 1 - NVARCHAR
DECLARE @Nm_Cliente NVARCHAR(100) = N'Luiz Vitor'

SELECT * 
FROM Cliente
WHERE Nm_Cliente = @Nm_Cliente
GO

--	TESTE 2 - VARCHAR
DECLARE @Nm_Cliente VARCHAR(100) = 'Luiz Vitor'

SELECT * 
FROM Cliente
WHERE Nm_Cliente = @Nm_Cliente
GO


--	CAST COM TIPOS DE DATA:

--	EXEMPLO 6:
DECLARE @VAR_TESTE DATETIME = GETDATE()

SELECT @VAR_TESTE

SELECT CAST(@VAR_TESTE AS DATE)

GO

SELECT CAST('20210626' AS DATE)

SELECT CAST('20210632' AS DATE)

/*
Msg 241, Level 16, State 1, Line 103
Conversion failed when converting date and/or time from character string.
*/

GO

--	EXEMPLO 7:
DECLARE @VAR_TESTE DATE = GETDATE()

SELECT @VAR_TESTE

SELECT CAST(@VAR_TESTE AS DATETIME)

GO

--	 EXEMPLO 8 - "ZERAR A HORA":
DECLARE @VAR_TESTE DATETIME = GETDATE()

SELECT @VAR_TESTE

--	SQL SERVER < 2008
SELECT CAST(FLOOR(CAST(@VAR_TESTE AS FLOAT)) AS DATETIME)

--	SQL SERVER >= 2008
SELECT CAST(CAST(@VAR_TESTE AS DATE) AS DATETIME)
GO


--	CAST COM TIPOS NUMERIC:

--	 EXEMPLO 9
DECLARE @VAR_TESTE NUMERIC(9,2) = 3.14

SELECT @VAR_TESTE

SELECT CAST(@VAR_TESTE AS NUMERIC(9,4))
GO

--	 EXEMPLO 10
DECLARE @VAR_TESTE NUMERIC(9,4) = 3.141254

SELECT @VAR_TESTE

SELECT CAST(@VAR_TESTE AS NUMERIC(9,2))
GO


--	 EXEMPLO 11 - COM EXPRESSÃO
DECLARE @VAR_TESTE INT = 10

SELECT CAST( ((@VAR_TESTE * 2 - 5) / 2 ) AS NUMERIC(9,2))
GO


--	 EXEMPLO 12 - CUIDADO COM FUNÇÕES NO WHERE! PROBLEMA DE PERFORMANCE!
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATETIME NOT NULL,
	PRIMARY KEY(Id_Cliente)
)

INSERT INTO Cliente (Nm_Cliente, Dt_Nascimento)
VALUES
	('Luiz Vitor', '19890914'),
	('Fabricio Lima', '19800504'),
	('Rodrigo Gomes', '19701029'),
	('Fabiano Amorim', '19600126')

CREATE NONCLUSTERED INDEX SK01_Dt_Nascimento
ON Cliente(Dt_Nascimento)
INCLUDE(Nm_Cliente)

SELECT * FROM Cliente

--	OBS: HABILITAR O PLANO DE EXECUÇÃO!

--	FILTRANDO POR DATA DE NASCIMENTO USANDO O CAST
DECLARE @VAR_DATE DATE = '19890914'

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente
WHERE CAST(Dt_Nascimento AS DATE) = @VAR_DATE
GO

--	FILTRANDO POR ANO USANDO O CAST
DECLARE @VAR_DATE DATE = '19890914'

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente
WHERE Dt_Nascimento = CAST(@VAR_DATE AS DATETIME)
GO


---------------------------------------------------------------------------------------------------------------
--	TRY_CAST:
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: TRY_CAST ( expression AS data_type [ ( length ) ] )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/try-cast-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	 EXEMPLO 1:
DECLARE @VAR_TESTE VARCHAR(10) = '156A'

SELECT CAST(@VAR_TESTE AS INT)

/*
Msg 245, Level 16, State 1, Line 136
Conversion failed when converting the varchar value '156A' to data type int.
*/

GO

DECLARE @VAR_TESTE VARCHAR(10) = '156A'
SELECT TRY_CAST(@VAR_TESTE AS INT)
GO


--	 EXEMPLO 2:
DECLARE @VAR_TESTE VARCHAR(10) = '156A'

SELECT TRY_CAST(@VAR_TESTE AS INT) + '100'

GO

DECLARE @VAR_TESTE VARCHAR(10) = '156A'

SELECT ISNULL(TRY_CAST(@VAR_TESTE AS INT), '') + '100'
GO


---------------------------------------------------------------------------------------------------------------
--	CONVERT
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: CONVERT ( data_type [ ( length ) ] , expression [ , style ] )
---------------------------------------------------------------------------------------------------------------
--	Referência (consultar o formato das datas nesse link também):
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1 - FORMATO DAS DATAS:

--	FORMATO: AAAA-MM-DD
SELECT CONVERT(VARCHAR(10), GETDATE(), 120)

--	FORMATO: AAAA-MM-DD hh:mi:ss (24h)
SELECT CONVERT(VARCHAR(20), GETDATE(), 120)

--	FORMATO: DD/MM/AAAA
SELECT CONVERT(VARCHAR(10), GETDATE(), 103)

--	FORMATO: DD/MM/AA
SELECT CONVERT(VARCHAR(20), GETDATE(), 3)

--	FORMATO: MM/DD/AAAA
SELECT CONVERT(VARCHAR(10), GETDATE(), 101)

--	FORMATO: MM/DD/AA
SELECT CONVERT(VARCHAR(10), GETDATE(), 1)
GO


--	EXEMPLO 2:
SELECT CONVERT( INT, '20671')
GO

--	EXEMPLO 3:
SELECT CONVERT( INT, 'test')

/*
Msg 245, Level 16, State 1, Line 218
Conversion failed when converting the varchar value 'test' to data type int.
*/
GO

---------------------------------------------------------------------------------------------------------------
--	TRY_CONVERT
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: TRY_CONVERT ( data_type [ ( length ) ], expression [, style ] )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/try-convert-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
SELECT TRY_CONVERT( INT, '20671')
GO

--	EXEMPLO 2:
SELECT TRY_CONVERT( INT, 'test')
GO

--	EXEMPLO 3:
SELECT TRY_CONVERT( INT, '100.50')
GO

--	EXEMPLO 4:
SELECT TRY_CONVERT( NUMERIC(5,2), '100.50')
GO


---------------------------------------------------------------------------------------------------------------
--	ISNUMERIC
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: ISNUMERIC ( expression )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/isnumeric-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
SELECT ISNUMERIC(10)

SELECT ISNUMERIC(150.26)

SELECT ISNUMERIC(-105)

SELECT ISNUMERIC(2 + 18)

SELECT ISNUMERIC('2' + '18')

SELECT ISNUMERIC('-A')

SELECT ISNUMERIC('Luiz')
GO

--	EXEMPLO 2:
DECLARE @VALOR_1 INT = 10 , @VALOR_2 INT = 50

SELECT ISNUMERIC(@VALOR_1)

SELECT ISNUMERIC(@VALOR_1 + @VALOR_2)
GO

--	EXEMPLO 3:
DECLARE @VALOR_1 VARCHAR(10) = '123456' , @VALOR_2 VARCHAR(10) = 'ABCD'

SELECT ISNUMERIC(@VALOR_1)

SELECT ISNUMERIC(@VALOR_2)

SELECT ISNUMERIC(@VALOR_1 + @VALOR_2)
GO

--	EXEMPLO 4:
DECLARE @VALOR_1 VARCHAR(10) = '123456' , @VALOR_2 VARCHAR(10) = 'ABCD'

IF (ISNUMERIC(@VALOR_1) = 1)
BEGIN
	SELECT 'O VALOR"' + @VALOR_1 + '" É DO TIPO NUMERIC!'
END
ELSE
BEGIN
	SELECT 'O VALOR "' + @VALOR_1 + '" NÃO É DO TIPO NUMERIC!'
END

IF (ISNUMERIC(@VALOR_2) = 1)
BEGIN
	SELECT 'O VALOR "' + @VALOR_2 + '" É DO TIPO NUMERIC!'
END
ELSE
BEGIN
	SELECT 'O VALOR "' + @VALOR_2 + '" NÃO É DO TIPO NUMERIC!'
END