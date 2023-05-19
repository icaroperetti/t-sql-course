---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	5 - Funções do SQL Server
--	DEMO 5.5:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	String Functions:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	(+) / CONCAT
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	CONCAT ( string_value1, string_value2 [, string_valueN ] )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/concat-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1
SELECT 'Luiz' + 'Vitor' + 'França' + 'Lima'

SELECT 'Luiz ' + 'Vitor ' + 'França ' + 'Lima'

SELECT 'Luiz ' + 100

/*
Msg 245, Level 16, State 1, Line 26
Conversion failed when converting the varchar value 'Luiz ' to data type int.
*/

--	CAST
SELECT 'Luiz ' + CAST(100 AS VARCHAR)

GO
DECLARE @VAR_VALOR INT = 100

SELECT 'Luiz ' + @VAR_VALOR

/*
Msg 245, Level 16, State 1, Line 38
Conversion failed when converting the varchar value 'Luiz ' to data type int.
*/

GO
DECLARE @VAR_VALOR INT = 100

SELECT 'Luiz ' + CAST(@VAR_VALOR AS VARCHAR)

GO


--	EXEMPLO 2
DECLARE @VAR_NOME_1 VARCHAR(50) = 'Luiz', @VAR_NOME_2 VARCHAR(50) = 'Lima'

SELECT @VAR_NOME_1 + ' ' + @VAR_NOME_2

GO
--	NULL
DECLARE @VAR_NOME_1 VARCHAR(50) = 'Luiz', @VAR_NOME_2 VARCHAR(50) = NULL

SELECT @VAR_NOME_1 + ' ' + @VAR_NOME_2

GO

--	ISNULL
DECLARE @VAR_NOME_1 VARCHAR(50) = 'Luiz', @VAR_NOME_2 VARCHAR(50) = NULL

SELECT @VAR_NOME_1 + ' ' + ISNULL(@VAR_NOME_2,'')


--	EXEMPLO 3:
SELECT CONCAT('Luiz','Vitor','França','Lima')

SELECT CONCAT('Luiz ','Vitor ','França ','Lima')

/*
SELECT 'Luiz' + 'Vitor' + 'França' + 'Lima'

SELECT 'Luiz ' + 'Vitor ' + 'França ' + 'Lima'
*/

SELECT CONCAT('LuizVitor')

/*
Msg 189, Level 15, State 1, Line 26
The concat function requires 2 to 254 arguments.
*/

--	EXEMPLO 4
DECLARE @VAR_NOME VARCHAR(50) = NULL

SELECT CONCAT('Luiz ', @VAR_NOME, 'Vitor ')

SELECT 'Luiz ' + @VAR_NOME + 'Vitor '

SELECT CONCAT('Luiz ', NULL, 'Vitor ')

SELECT CONCAT('Luiz ', '', 'Vitor ')

GO

DECLARE @VAR_NOME_1 VARCHAR(50) = 'Luiz', @VAR_NOME_2 VARCHAR(50) = NULL

SELECT CONCAT(@VAR_NOME_1, ' ', @VAR_NOME_2)
GO


--	EXEMPLO 5 - CONCATENANDO COLUNAS DE UMA TABELA
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	FirstName VARCHAR(100) NOT NULL,
	LastName VARCHAR(100) NOT NULL,
	PRIMARY KEY(Id_Cliente)
)

INSERT INTO Cliente (FirstName, LastName)
VALUES
	('Luiz','Lima'),
	('Fabricio','Lima'),
	('Rodrigo','Gomes'),
	('Fabiano','Amorim')

SELECT 
	FirstName,
	LastName,
	FirstName + ' ' + LastName AS FullName
FROM Cliente
GO


---------------------------------------------------------------------------------------------------------------
--	CONCAT_WS (SQL >= 2017):
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	CONCAT_WS ( separator, argument1, argument2 [, argumentN]... )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/concat-ws-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT CONCAT_WS(';', 'Luiz', 'Vitor', 'França', 'Lima')

SELECT CONCAT_WS(' ', 'Luiz', 'Vitor', 'França', 'Lima')

SELECT CONCAT_WS(';', 'Luiz', NULL, NULL, 'Lima')

SELECT CONCAT_WS(';', 'Luiz', '', '', 'Lima')


---------------------------------------------------------------------------------------------------------------
--	FORMAT
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	FORMAT( value, format [, culture ] )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/format-transact-sql?view=sql-server-ver15
--	https://www.sqlshack.com/a-comprehensive-guide-to-the-sql-format-function/
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT FORMAT(8572, '00000000')

SELECT FORMAT(12345678,'####-####')

--	OBS: CUIDADO! POSSUI UMA PERFORMANCE RUIM EM COMPARAÇÃO COM OUTRAS FUNÇÕES PARECIDAS!!!

SELECT FORMAT('ABCDEFGH','####-####')

/*
Msg 8116, Level 16, State 1, Line 173
Argument data type varchar is invalid for argument 1 of format function.
*/


---------------------------------------------------------------------------------------------------------------
--	SUBSTRING
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	SUBSTRING ( expression , start , length )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/substring-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT SUBSTRING('Luiz Vitor', 1, 4)

SELECT SUBSTRING('Luiz Vitor', 6, 5)

SELECT SUBSTRING('123456789', 3, 4)

--	EXEMPLO 2:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) NOT NULL
)

INSERT INTO Cliente (Nome, CPF)
VALUES
	('Luiz Lima','145.698.136-17'),
	('Fabricio Lima','014.247.963-97'),
	('Rodrigo Gomes','678.306.049-40'),
	('Fabiano Amorim','304.687.056-03')

SELECT *, SUBSTRING(Nome, 1, 1) AS Inicial_Nome
FROM Cliente


---------------------------------------------------------------------------------------------------------------
--	LEFT / RIGHT
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	LEFT ( character_expression , integer_expression )
--	RIGHT ( character_expression , integer_expression ) 
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/left-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/right-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	LEFT

--	EXEMPLO 1:
SELECT LEFT('ABCDEFGH', 4)

SELECT LEFT('Luiz Vitor', 4)

SELECT LEFT('Luiz Vitor' + REPLICATE(' ', 20), 20)

--	'Luiz Vitor          '

-- RIGHT

--	EXEMPLO 2:
SELECT RIGHT('ABCDEFGH', 4)

SELECT RIGHT('Luiz Vitor', 5)

SELECT RIGHT(REPLICATE('0', 10) + '1548', 10)

--	EXEMPLO 3 - LAYOUT ARQUIVO TXT:
SELECT 
	RIGHT(REPLICATE('0', 10) + '1548', 10) +			-- 10 pos
	LEFT('LUIZ VITOR' + REPLICATE(' ', 20), 20) +		-- 20 pos
	RIGHT(REPLICATE('0', 10) + '1548', 10)				-- 10 pos

--	0000001548LUIZ VITOR          0000001548


---------------------------------------------------------------------------------------------------------------
--	LEN / DATALENGTH
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	LEN ( string_expression )
--	DATALENGTH ( expression )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/len-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/datalength-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	LEN

--	EXEMPLO 1:
DECLARE @Nome VARCHAR(100)

SET @Nome = 'Luiz'			-- TAMANHO: 4

SELECT LEN(@Nome)

SET @Nome = 'Luiz Vitor'	-- TAMANHO: 10

SELECT LEN(@Nome)
GO

--	EXEMPLO 2 - INTEIROS:
DECLARE @var_BIT BIT, @var_TINYINT TINYINT, @var_SMALLINT SMALLINT, @var_INT INT, @var_BIGINT BIGINT

SELECT
	@var_BIT = 1,
	@var_TINYINT = 1,
	@var_SMALLINT = 1,
	@var_INT = 1,
	@var_BIGINT = 1

--	Tamanho em BYTES
SELECT  
	DATALENGTH(@var_BIT) AS Tam_BIT,
	DATALENGTH(@var_TINYINT) AS Tam_TINYINT,
	DATALENGTH(@var_SMALLINT) AS Tam_SMALLINT,
	DATALENGTH(@var_INT) AS Tam_INT,
	DATALENGTH(@var_BIGINT) AS Tam_BIGINT
GO

--	EXEMPLO 3 - STRINGS:
DECLARE @var_CHAR CHAR(50), @var_VARCHAR VARCHAR(50), @var_NCHAR NCHAR(50), @var_NVARCHAR NVARCHAR(50)

SELECT
	@var_CHAR = 'Luiz Vitor',
	@var_VARCHAR = 'Luiz Vitor',
	@var_NCHAR = 'Luiz Vitor',
	@var_NVARCHAR = 'Luiz Vitor'

SELECT 
	@var_CHAR AS var_CHAR,
	LEN(@var_CHAR) AS Tam_Var, 
	DATALENGTH(@var_CHAR) AS Tam_CHAR,
	DATALENGTH(@var_VARCHAR) AS Tam_VARCHAR,
	DATALENGTH(@var_NCHAR) AS Tam_NCHAR,
	DATALENGTH(@var_NVARCHAR) AS Tam_NVARCHAR
GO


--	EXEMPLO 4 - ESPAÇO EM BRANCO:
--	OBS: A FUNÇÃO "LEN" NÃO CONTA ESPAÇOS A DIREITA
DECLARE @Nome VARCHAR(50)

SET @Nome = 'Luiz Vitor'

SELECT LEN(@Nome) AS Tam_Len, DATALENGTH(@Nome) AS Tam_DataLength

SET @Nome = 'Luiz Vitor     '

SELECT LEN(@Nome) AS Tam_Len, DATALENGTH(@Nome) AS Tam_DataLength
GO

--	SEMELHANTE AO ZERO A ESQUERDA
SELECT 00000123


---------------------------------------------------------------------------------------------------------------
--	CHARINDEX / PATINDEX
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] )
--	PATINDEX ( '%pattern%' , expression )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/charindex-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/patindex-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-como-utilizar-expressoes-regulares-regexp-no-seu-banco-de-dados/
---------------------------------------------------------------------------------------------------------------
--	CHARINDEX

--	EXEMPLO 1:

SELECT CHARINDEX('Lima', 'Luiz Vitor França Lima')

--	STRING "VASCO" APARECENDO MAIS DE UMA VEZ!
SELECT CHARINDEX('VASCO', 'OI VASCO! É O VASCO MELHOR TIME DO MUNDO!!!')

SELECT CHARINDEX('FLAMENGO', 'OI VASCO! É O VASCO MELHOR TIME DO MUNDO!!!')

SELECT CHARINDEX('Vitor', 'Luiz Vitor França Lima', 1)

SELECT CHARINDEX('Vitor', 'Luiz Vitor França Lima', 10)

--	EXEMPLO 2:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) NOT NULL
)

INSERT INTO Cliente (Nome, CPF)
VALUES
	('Luiz Lima','145.698.136-17'),
	('Fabricio Lima','014.247.963-97'),
	('Rodrigo Gomes','678.306.049-40'),
	('Fabiano Amorim','304.687.056-03')

SELECT *, CHARINDEX('Lima', Nome)
FROM Cliente


--	PATINDEX

--	EXEMPLO 3:

SELECT PATINDEX('%[0-9]%', 'Luiz Vitor 2021 França Lima')

SELECT PATINDEX('%[0-9]%', 'Luiz Vitor França Lima')

SELECT PATINDEX('%[A-Z]%', '1 2 3 4 5 6 7 8 ')

SELECT PATINDEX('%[A-Z]%', '1 2 3 4 5 6 7 A 8 ')

SELECT PATINDEX('%[X,Y,Z]%', 'Fabricio Lima')

SELECT PATINDEX('%[X,Y,Z]%', 'Luiz Lima')

SELECT PATINDEX('%[7,8,9]%', 'Luiz 123 Lima')

SELECT PATINDEX('%[2,5,8]%', 'Luiz 153 Lima')


---------------------------------------------------------------------------------------------------------------
--	REPLACE / REPLICATE
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	REPLACE ( string_expression , string_pattern , string_replacement )
--	REPLICATE ( string_expression , integer_expression )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/replace-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/replicate-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	REPLACE

--	EXEMPLO 1:

SELECT REPLACE('123456789', '678', 'LUIZ')

SELECT REPLACE('67812345678', '678', 'LUIZ')

SELECT REPLACE('ABCDEFGH', 'CDE', '-123-')

SELECT REPLACE('123.456.789-74', '.', '')

SELECT REPLACE(REPLACE('123.456.789-74', '.', ''), '-', '')

--	EXEMPLO 2:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nome VARCHAR(100) NOT NULL,
	CPF VARCHAR(14) NOT NULL
)

INSERT INTO Cliente (Nome, CPF)
VALUES
	('Luiz Lima','145.698.136-17'),
	('Fabricio Lima','014.247.963-97'),
	('Rodrigo Gomes','678.306.049-40'),
	('Fabiano Amorim','304.687.056-03')

SELECT *, REPLACE(REPLACE(CPF, '-', ''), '.', '') AS CPF_Formatado
FROM Cliente

--	'145.698.136-17'
--	'14569813617'

--	REPLICATE

--	EXEMPLO 3:
SELECT REPLICATE('0', 5)

SELECT REPLICATE('1', 10)

SELECT RIGHT(REPLICATE('0', 10) + '1548', 10)

SELECT RIGHT(REPLICATE('0', 10) + '258649', 10)

SELECT RIGHT(REPLICATE(' ', 10) + 'LUIZ', 10)

-- '      LUIZ'

SELECT LEFT('LUIZ' + REPLICATE(' ', 10), 10)

-- 'LUIZ      '


---------------------------------------------------------------------------------------------------------------
--	UPPER / LOWER
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	UPPER ( character_expression )
--	LOWER ( character_expression )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/upper-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/lower-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	LETRAS MAIUSCULAS
--	ATALHO: CTRL + SHIFT + U
SELECT UPPER('luiz vitor AAA')

--	letras minúsculas
--	ATALHO: CTRL + SHIFT + L
SELECT LOWER('LUIZ VITOR aaa')


---------------------------------------------------------------------------------------------------------------
--	LTRIM / RTRIM / TRIM
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	LTRIM ( character_expression )
--	RTRIM ( character_expression )
--	TRIM ( string )		-> OBS: SQL >= 2017
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/ltrim-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/rtrim-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/trim-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT LTRIM('   Luiz   ')
SELECT RTRIM('   Luiz   ')

--	COPIAR O RESULTADO ENTRE AS ASPAS ABAIXO:
''
''


--	EXEMPLO 2:
SELECT RTRIM(LTRIM('   Luiz   '))
SELECT TRIM('   Luiz   ')

--	COPIAR O RESULTADO ENTRE AS ASPAS ABAIXO:
''
''


---------------------------------------------------------------------------------------------------------------
--	STRING_SPLIT (SQL >= 2016)
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	STRING_SPLIT ( string , separator )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/string-split-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT *
FROM STRING_SPLIT('1,2,3,4,5,6,7,8,9,10', ',')

--	EXEMPLO 2:
SELECT *
FROM STRING_SPLIT('A.B.C.D.E.F.G.H.I.J', '.')


---------------------------------------------------------------------------------------------------------------
--	STRING_AGG (SQL >= 2016)
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	STRING_AGG ( expression, separator )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/string-agg-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
--	STRING_SPLIT
DROP TABLE IF EXISTS #TEMP_STRING_AGG

SELECT value AS nome
INTO #TEMP_STRING_AGG
FROM STRING_SPLIT('A.B.C.D.E.F.G.H.I.J', '.')

SELECT * FROM #TEMP_STRING_AGG
GO

--	STRING_AGG
SELECT STRING_AGG(nome, '.') AS Resultado
FROM #TEMP_STRING_AGG

--	RESULTADO: "A.B.C.D.E.F.G.H.I.J"
GO


---------------------------------------------------------------------------------------------------------------
--	STUFF
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	STUFF ( character_expression , start , length , replaceWith_expression )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/stuff-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	Resultado: xabcz
SELECT STUFF('xyz', 2, 1, 'abc')

--	Resultado: xabcz
SELECT STUFF('x123z', 2, 3, 'abc')

--	Resultado: Luiz Vitor França Lima
SELECT STUFF('Luiz Lima', 5, 1, ' Vitor França ')


---------------------------------------------------------------------------------------------------------------
--	REVERSE
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	REVERSE ( string_expression )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/reverse-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	654321
SELECT REVERSE('123456')

--	EDCBA
SELECT REVERSE('ABCDE')

--	rotiV ziuL
SELECT REVERSE('Luiz Vitor')