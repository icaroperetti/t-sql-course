---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	1 - Introdução – Conceitos Básicos
--	DEMO 1.2:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Tipos de Dados
---------------------------------------------------------------------------------------------------------------

-- Mostrar o site abaixo (ver as tabelas dos tipos INT e DECIMAL):
-- https://docs.microsoft.com/pt-br/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15

---------------------------------------------------------------------------------------------------------------
--	BIT
--	Um tipo de dados inteiro que pode aceitar os valores: 1, 0 ou NULL.
---------------------------------------------------------------------------------------------------------------
DECLARE @var_BIT BIT

SET @var_BIT = 0
--SET @var_BIT = 1
--SET @var_BIT = NULL
--SET @var_BIT = 2
--SET @var_BIT = 2000
--SET @var_BIT = 'Luiz'

SELECT @var_BIT AS var_BIT

/*
Msg 245, Level 16, State 1, Line 25
Conversion failed when converting the varchar value 'Luiz' to data type bit.
*/

---------------------------------------------------------------------------------------------------------------
--	TINYINT
--	Tipos de dados numéricos exatos que usam dados inteiros.
--	Utiliza 1 byte
--	Valores: 0 a 255
---------------------------------------------------------------------------------------------------------------
DECLARE @var_TINYINT TINYINT

SET @var_TINYINT = 255
--SET @var_TINYINT = 256

SELECT @var_TINYINT AS var_TINYINT

/*
Msg 220, Level 16, State 2, Line 39
Arithmetic overflow error for data type tinyint, value = 256.
*/

---------------------------------------------------------------------------------------------------------------
--	SMALLINT
--	Tipos de dados numéricos exatos que usam dados inteiros.
--	Utiliza 2 bytes
--	Valores: -2^15 (-32.768) a 2^15-1 (32.767)
---------------------------------------------------------------------------------------------------------------
DECLARE @var_SMALLINT SMALLINT

SET @var_SMALLINT = 32767
--SET @var_SMALLINT = 32768

SELECT @var_SMALLINT AS var_SMALLINT
--SELECT @var_SMALLINT = @var_SMALLINT + @var_SMALLINT

/*
Msg 220, Level 16, State 1, Line 57
Arithmetic overflow error for data type smallint, value = 32768.

Msg 8115, Level 16, State 2, Line 59
Arithmetic overflow error converting expression to data type smallint.
*/
 
---------------------------------------------------------------------------------------------------------------
--	INT
--	Tipos de dados numéricos exatos que usam dados inteiros.
--	Utiliza 4 bytes
--	Valores: -2^31 (-2.147.483.648) a 2^31-1 (2.147.483.647)
---------------------------------------------------------------------------------------------------------------
DECLARE @var_INT INT

SET @var_INT = 2147483647
--SET @var_INT = 2147483648

SELECT @var_INT AS var_INT

/*
Msg 8115, Level 16, State 2, Line 75
Arithmetic overflow error converting expression to data type int.
*/

---------------------------------------------------------------------------------------------------------------
--	BIGINT
--	Tipos de dados numéricos exatos que usam dados inteiros.
--	Utiliza 8 bytes
--	Valores: -2^63 (-9.223.372.036.854.775.808) a 2^63-1 (9.223.372.036.854.775.807)
---------------------------------------------------------------------------------------------------------------
DECLARE @var_BIGINT BIGINT

SET @var_BIGINT = 9223372036854775807
--SET @var_BIGINT = 9223372036854775808

SELECT @var_BIGINT AS var_BIGINT

/*
Msg 8115, Level 16, State 2, Line 93
Arithmetic overflow error converting expression to data type bigint.
*/

GO

DECLARE @var_BIT BIT, @var_TINYINT TINYINT, @var_SMALLINT SMALLINT, @var_INT INT, @var_BIGINT BIGINT

SELECT
	@var_BIT = 1,
	@var_TINYINT = 1,
	@var_SMALLINT = 1,
	@var_INT = 1,
	@var_BIGINT = 1

--SELECT 
--	@var_BIT AS var_BIT, 
--	@var_TINYINT AS var_TINYINT,
--	@var_SMALLINT AS var_SMALLINT, 
--	@var_INT AS var_INT,
--	@var_BIGINT AS var_BIGINT

--	Tamanho em BYTES
SELECT  
	DATALENGTH(@var_BIT) AS Tam_BIT,
	DATALENGTH(@var_TINYINT) AS Tam_TINYINT,
	DATALENGTH(@var_SMALLINT) AS Tam_SMALLINT,
	DATALENGTH(@var_INT) AS Tam_INT,
	DATALENGTH(@var_BIGINT) AS Tam_BIGINT

GO

-- TESTE TAMANHO TABELA INTEIROS
DROP TABLE IF EXISTS TESTE_INTEIRO_BIT

CREATE TABLE TESTE_INTEIRO_BIT (
	Fl_Sexo_BIT BIT NOT NULL
)

DROP TABLE IF EXISTS TESTE_INTEIRO_INT

CREATE TABLE TESTE_INTEIRO_INT (
	Fl_Sexo_INT INT NOT NULL
)

DROP TABLE IF EXISTS TESTE_INTEIRO_BIGINT

CREATE TABLE TESTE_INTEIRO_BIGINT (
	Fl_Sexo_BIGINT BIGINT NOT NULL
)

-- POPULA AS TABELAS
SET NOCOUNT ON

INSERT INTO TESTE_INTEIRO_BIT (Fl_Sexo_BIT) 
VALUES(1)
GO 100000

INSERT INTO TESTE_INTEIRO_INT (Fl_Sexo_INT)
VALUES(1)
GO 100000

INSERT INTO TESTE_INTEIRO_BIGINT (Fl_Sexo_BIGINT)
VALUES(1)
GO 100000

SET NOCOUNT OFF

-- VALIDA O TAMANHO DAS TABELAS
EXEC sp_spaceused 'TESTE_INTEIRO_BIT'		-- 1160 KB
EXEC sp_spaceused 'TESTE_INTEIRO_INT'		-- 1416 KB (22% maior que o tipo BIT)
EXEC sp_spaceused 'TESTE_INTEIRO_BIGINT'	-- 1800 KB (55% maior que o tipo BIT)


---------------------------------------------------------------------------------------------------------------
--	NUMERIC / DECIMAL
--	Referência: https://www.fabriciolima.net/blog/2017/01/31/video-economize-espaco-e-ganhe-performance-com-o-tipo-de-dados-numeric/
---------------------------------------------------------------------------------------------------------------
DECLARE @var_NUMERIC numeric(8,2)

SELECT @var_NUMERIC = 173226.62
--SELECT @var_NUMERIC = 1732261.23

SELECT @var_NUMERIC AS var_NUMERIC

/*
Msg 8115, Level 16, State 8, Line 185
Arithmetic overflow error converting numeric to data type numeric.
*/

GO

DECLARE @var_NUMERIC numeric(8,2)
SELECT @var_NUMERIC = 526.1
--SELECT @var_NUMERIC = 526.194
--SELECT @var_NUMERIC = 526.195

SELECT @var_NUMERIC AS var_NUMERIC

GO

--DECLARE @var_NUMERIC numeric(3,5)
DECLARE @var_NUMERIC numeric(8,5)

SELECT @var_NUMERIC = 526.1

SELECT @var_NUMERIC AS var_NUMERIC

/*
Msg 192, Level 15, State 1, Line 109
The scale must be less than or equal to the precision.
*/

--	DECIMAL - Mesma ideia do NUMERIC
DECLARE @var_DECIMAL DECIMAL(8,2)

SELECT @var_DECIMAL = 123314.1199

SELECT @var_DECIMAL AS var_DECIMAL

-- FUNÇÃO: ISNUMERIC
SELECT ISNUMERIC(12.345), ISNUMERIC('Luiz')
GO

--	FLOAT - CUIDADO: Números aproximados!
DROP TABLE IF EXISTS TesteFloatNumeric

CREATE TABLE TesteFloatNumeric (
	NumFloat FLOAT,
	NumNumeric NUMERIC(9,2),
)

INSERT INTO TesteFloatNumeric (NumFloat, NumNumeric)
VALUES(18.91, 18.91), (18.910000000000007, 18.910000000000007)

SELECT * FROM TesteFloatNumeric

SELECT DISTINCT NumFloat FROM TesteFloatNumeric
SELECT DISTINCT NumNumeric FROM TesteFloatNumeric


---------------------------------------------------------------------------------------------------------------
--	DATE / DATETIME
--	Referência: https://luizlima.net/casos-do-dia-a-dia-cuidado-ao-alterar-o-idioma-ou-o-formato-da-data-da-sessao/
---------------------------------------------------------------------------------------------------------------
-- DATE
DECLARE @var_DATE DATE

--SELECT @var_DATE = '20210608'
--SELECT @var_DATE = '2021-06-08'
-- SELECT GETDATE()
SELECT @var_DATE = GETDATE()

SELECT @var_DATE AS var_DATE

-- DATETIME
DECLARE @var_DATETIME DATETIME

SELECT @var_DATETIME = GETDATE()

SELECT @var_DATETIME AS var_DATETIME

-- CUIDADO COM O DATEFORMAT / LANGUAGE!!
GO

--	DBCC USEROPTIONS
--	SET DATEFORMAT dmy
--	SET DATEFORMAT mdy

DECLARE @var_DATE DATE
SELECT @var_DATE = '20/02/2021'

SELECT @var_DATE AS var_DATE

/*
Msg 241, Level 16, State 1, Line 278
Conversion failed when converting date and/or time from character string.
*/

GO

--	DBCC USEROPTIONS
--	SET LANGUAGE us_english
--	SET LANGUAGE portuguese

DECLARE @var_DATE DATE
SELECT @var_DATE = '06/08/2021'

SELECT @var_DATE AS var_DATE


---------------------------------------------------------------------------------------------------------------
-- CHAR / VARCHAR (1 BYTE POR CARACTERE - TABELA ASCII)
-- NCHAR / NVARCHAR (2 BYTES POR CARACTERE - TABELA UNICODE)
---------------------------------------------------------------------------------------------------------------
DECLARE @var_CHAR CHAR(50), @var_VARCHAR VARCHAR(50), @var_NCHAR NCHAR(50), @var_NVARCHAR NVARCHAR(50)

SELECT
	@var_CHAR = 'Luiz Vitor',
	@var_VARCHAR = 'Luiz Vitor',
	@var_NCHAR = 'Luiz Vitor',
	@var_NVARCHAR = 'Luiz Vitor'

SELECT 
	@var_CHAR AS var_CHAR, 
	@var_VARCHAR AS var_VARCHAR,
	@var_NCHAR AS var_NCHAR, 
	@var_NVARCHAR AS var_NVARCHAR

--	COLAR O RESULTADO DAS COLUNAS "var_CHAR" E "var_VARCHAR".
--	''
--	''

--IF(@var_CHAR = @var_VARCHAR)
--	SELECT 'SÃO IGUAIS!'
--ELSE
--	SELECT 'SÃO DIFERENTES!'

SELECT 
	@var_CHAR AS var_CHAR,
	LEN(@var_CHAR) AS Tam_Var, 
	DATALENGTH(@var_CHAR) AS Tam_CHAR,
	DATALENGTH(@var_VARCHAR) AS Tam_VARCHAR,
	DATALENGTH(@var_NCHAR) AS Tam_NCHAR,
	DATALENGTH(@var_NVARCHAR) AS Tam_NVARCHAR


-- TESTE TAMANHO TABELA STRINGS
/*
Fl_Sexo:
	'FEM' -> Feminino
	'MAS' -> Masculino
*/

DROP TABLE IF EXISTS TESTE_STRING_CHAR

CREATE TABLE TESTE_STRING_CHAR (
	Fl_Sexo_CHAR CHAR(3) NOT NULL
)

DROP TABLE IF EXISTS TESTE_STRING_NCHAR

CREATE TABLE TESTE_STRING_NCHAR (
	Fl_Sexo_NCHAR NCHAR(3) NOT NULL
)

-- POPULA AS TABELAS
SET NOCOUNT ON

INSERT INTO TESTE_STRING_CHAR (Fl_Sexo_CHAR) 
VALUES('FEM')
GO 100000

INSERT INTO TESTE_STRING_NCHAR (Fl_Sexo_NCHAR)
VALUES('FEM')
GO 100000


SET NOCOUNT OFF

-- VALIDA O TAMANHO DAS TABELAS
EXEC sp_spaceused 'TESTE_INTEIRO_BIT'		-- 1160 KB (0 - Feminino / 1 - Masculino)
EXEC sp_spaceused 'TESTE_STRING_CHAR'		-- 1288 KB (11% maior que o tipo BIT)
EXEC sp_spaceused 'TESTE_STRING_NCHAR'		-- 1608 KB (38% maior que o tipo BIT)

/*
--	LEITURA COMPLEMENTAR: Dicas T-SQL – CPF: Qual tipo de dados devo utilizar? BIGINT ou CHAR?
--	Referência: https://luizlima.net/dicas-t-sql-cpf-qual-tipo-de-dados-devo-utilizar-bigint-ou-char/
*/


---------------------------------------------------------------------------------------------------------------
-- USER DATA TYPE
---------------------------------------------------------------------------------------------------------------
-- CRIANDO
CREATE TYPE [dbo].[CEP] FROM CHAR(8) NOT NULL

CREATE TYPE [dbo].[CPF] FROM CHAR(11) NOT NULL

-- UTILIZANDO
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	IdCliente INT IDENTITY(1,1) NOT NULL,
	NmCliente VARCHAR(200) NOT NULL,
	CEP CEP NOT NULL,
	CPF CPF NOT NULL
)

INSERT INTO Cliente(NmCliente, CEP, CPF)
VALUES ('Luiz Vitor França Lima','29503158','14682165897')

SELECT * FROM Cliente

---------------------------------------------------------------------------------------------------------------
-- TIPOS DE DADOS - PONTO DE ATENÇÃO - ESCOLHA DOS TIPOS ADEQUADOS:
---------------------------------------------------------------------------------------------------------------
--	Cliente_Big
DROP TABLE IF EXISTS Cliente_Big
GO

CREATE TABLE Cliente_Big (
	IdCliente BIGINT IDENTITY(1,1) NOT NULL,
	NmCliente NVARCHAR(MAX) NOT NULL,
	Endereco NVARCHAR(MAX) NOT NULL,
	CEP NVARCHAR(MAX) NOT NULL,
	Telefone NVARCHAR(MAX) NOT NULL
)

INSERT INTO Cliente_Big (NmCliente, Endereco, CEP, Telefone)
VALUES 
	('Luiz Lima','Rua dos DBA Malucos','29503158','27999886611'),
	('Fabricio Lima','Rua dos DBA Malucos','29503158','27999886611'),
	('Fabiano Amorim','Rua dos DBA Malucos','29503158','27999886611')

SELECT * FROM Cliente_Big

CREATE NONCLUSTERED INDEX IX_NmCliente
ON Cliente_Big(NmCliente)

/*
Msg 1919, Level 16, State 1, Line 427
Column 'NmCliente' in table 'Cliente_Big' is of a 
type that is invalid for use as a key column in an index.
*/

--	Cliente
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	IdCliente INT IDENTITY(1,1) NOT NULL,
	NmCliente VARCHAR(100) NOT NULL,
	Endereco VARCHAR(200) NOT NULL,
	CEP CHAR(8) NOT NULL,
	Telefone VARCHAR(11) NOT NULL
)

INSERT INTO Cliente (NmCliente, Endereco, CEP, Telefone)
VALUES 
	('Luiz Lima','Rua dos DBA Malucos','29503158','27999886611'),
	('Fabricio Lima','Rua dos DBA Malucos','29503158','27999886611'),
	('Fabiano Amorim','Rua dos DBA Malucos','29503158','27999886611')

SELECT * FROM Cliente

--	COMPARAÇÃO DO TAMANHO DE CADA LINHA
SELECT 
	IdCliente,
	DATALENGTH(NmCliente) AS Tam_NmCliente,
	DATALENGTH(Endereco) AS Tam_Endereco,
	DATALENGTH(CEP) AS Tam_CEP,
	DATALENGTH(Telefone) AS Tam_Telefone,
	DATALENGTH(NmCliente) + DATALENGTH(Endereco) + 
	DATALENGTH(Telefone) + DATALENGTH(CEP) AS [Tam_Total_Linha (bytes)]
FROM Cliente_Big

SELECT 
	IdCliente,
	DATALENGTH(NmCliente) AS Tam_NmCliente,
	DATALENGTH(Endereco) AS Tam_Endereco,
	DATALENGTH(CEP) AS Tam_CEP,
	DATALENGTH(Telefone) AS Tam_Telefone,
	DATALENGTH(NmCliente) + DATALENGTH(Endereco) + 
	DATALENGTH(Telefone) + DATALENGTH(CEP) AS [Tam_Total_Linha (bytes)]
FROM Cliente

--	CRIA INDICE POR NOME DO CLIENTE
CREATE NONCLUSTERED INDEX IX_NmCliente
ON Cliente(NmCliente)


---------------------------------------------------------------------------------------------------------------
--	Identificadores
--	Devem conter de 1 a 128 caracteres no máximo.

--	Possuem algumas Regras Gerais:

--		1)	O primeiro caractere deve ser um dos seguintes:
--			- Deve ser uma letra (A até Z).
--			- Sublinhado (_), arroba (@) ou jogo da velha (#).

--		2)	O identificador não deve ser uma palavra reservada do Transact-SQL.

--		3) NÃO são permitidos espaços ou caracteres especiais.

--	OBS: Se o nome do identificador NÃO estiver de acordo com essas regras, ele deverá ser delimitado por aspas duplas “” ou colchetes [].
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL

DROP TABLE IF EXISTS NomeCliente
CREATE TABLE NomeCliente (Id INT)

DROP TABLE IF EXISTS _NomeCliente
CREATE TABLE _NomeCliente (Id INT)

DROP TABLE IF EXISTS [Nome Cliente]
CREATE TABLE [Nome Cliente] (Id INT)

DROP TABLE IF EXISTS [Nome TABLE]
CREATE TABLE [Nome TABLE] (Id INT)

CREATE TABLE 2NomeCliente (Id INT)

/*
Msg 102, Level 15, State 1, Line 252
Incorrect syntax near '2'.
*/

---------------------------------------------------------------------------------------------------------------
--	Literais (constantes)
---------------------------------------------------------------------------------------------------------------
USE Treinamento_TSQL

SELECT 32

SELECT 'Luiz Vitor DBA'

SELECT N'Luiz Vitor DBA'

SELECT CAST('20210606' AS DATE)


---------------------------------------------------------------------------------------------------------------
--	Expressões

--	É uma combinação de símbolos e operadores que retorna um único valor.

--	Os tipos de dados precisam ser COMPATÍVEIS:
--		- Tipo de dados IGUAIS.
--		- O tipo de dados com a MENOR precedência pode ser IMPLICITAMENTE CONVERTIDO para o de MAIOR precedência. 
--		  Ex: Combinar INT e BIGINT.

--	Podemos usar as funções CAST ou CONVERT para converter EXPLICITAMENTE o tipo de dados. 
--	Ex: VARCHAR para INT.

--	A ordenação de execução em uma expressão segue as regras de precedência.
---------------------------------------------------------------------------------------------------------------
USE Treinamento_TSQL

SELECT 32 + 123165465413216541

SELECT 32 + '8'

SELECT 32 + CAST('8' AS INT)

SELECT '32' + '8'

SELECT 32 + 'Luiz'

-- Msg 245, Level 16, State 1, Line 480
--Conversion failed when converting the varchar value 'Luiz' to data type int.


SELECT 'Luiz ' + 'Vitor'

SELECT 'Luiz - ' + getdate()

/*
Msg 241, Level 16, State 1, Line 293
Conversion failed when converting date and/or time from character string.
*/

SELECT 'Luiz - ' + CONVERT(VARCHAR(10),getdate(),120) 

---------------------------------------------------------------------------------------------------------------
--	Utilizando Variáveis

--	Precisa do comando DECLARE para ser declarada antes de ser utilizada.
--	O nome da variável deve iniciar com o caractere “@”.
--	Por fim, deve informar o TIPO da variável.
---------------------------------------------------------------------------------------------------------------

-- DECLARANDO UMA VARIAVEL
DECLARE @var_teste INT
SET @var_teste = 100
SELECT @var_teste

GO

DECLARE @var_teste INT
SELECT @var_teste = 100
SELECT @var_teste

GO

DECLARE @var_teste INT = 100
SELECT @var_teste

GO

DECLARE @var_teste INT
SELECT @var_teste

GO


-- DECLARANDO VARIAS VARIAVEIS
DECLARE @var_teste INT, @var_teste2 INT, @var_teste3 INT
SET @var_teste = 100, @var_teste2 = 200, @var_teste3 = 300
SELECT @var_teste, @var_teste2, @var_teste3

/*
Msg 102, Level 15, State 1, Line 340
Incorrect syntax near ','.
*/

GO

DECLARE @var_teste INT, @var_teste2 INT, @var_teste3 INT
SELECT @var_teste = 100, @var_teste2 = 200, @var_teste3 = 300
SELECT @var_teste AS var_teste, @var_teste2 AS var_teste2, @var_teste3 AS var_teste3

GO

-- CUIDADO COM A ATRIBUIÇÃO UTILIZANDO OUTRAS VARIÁVEIS!
DECLARE @var_teste INT, @var_teste2 INT, @var_teste3 INT
SELECT @var_teste = @var_teste3, @var_teste2 = 200, @var_teste3 = 300
--SELECT @var_teste3 = 300, @var_teste = @var_teste3, @var_teste2 = 200 
SELECT @var_teste AS var_teste, @var_teste2 AS var_teste2, @var_teste3 AS var_teste3

GO

-- DECLARAÇÃO COM TIPOS DE DADOS DISTINTOS
DECLARE @var_teste INT = 100, @var_teste2 INT = 200, @var_teste3 INT = 300, @var_teste4 VARCHAR(20) = 'Luiz Gato'

SELECT @var_teste AS var_teste, @var_teste2 AS var_teste2, @var_teste3 AS var_teste3, @var_teste4 AS var_teste4

GO

-- CUIDADO QUANDO NÃO ATRIBUIR VALORES PARA AS VARIÁVEIS!
DECLARE @var_teste INT, @var_teste2 INT, @var_teste3 INT, @var_teste4 VARCHAR(20)
SELECT @var_teste AS var_teste, @var_teste2 AS var_teste2, @var_teste3 AS var_teste3, @var_teste4 AS var_teste4

SELECT 'POWER TUNING - ' +  @var_teste4

SELECT 'POWER TUNING - ' +  ISNULL(@var_teste4,'')

GO

--	VARIAVEIS x MULTIPLOS VALORES
--	EXEMPLO 1:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

SELECT * FROM [dbo].[Cliente]

GO

DECLARE @Nm_Cliente VARCHAR(100)

SELECT @Nm_Cliente = [Nm_Cliente]
FROM [dbo].[Cliente]

SELECT @Nm_Cliente

GO

--	EXEMPLO 2 - MAIS DE UMA COLUNA:
DECLARE @Nm_Cliente VARCHAR(100)

SET @Nm_Cliente = (SELECT * FROM [dbo].[Cliente])

SELECT @Nm_Cliente

/*
Msg 116, Level 16, State 1, Line 583
Only one expression can be specified in the select list when the subquery is not introduced with EXISTS.
*/

GO

--	EXEMPLO 3 - MAIS DE UM RESULTADO:
DECLARE @Nm_Cliente VARCHAR(100)

SET @Nm_Cliente = (SELECT Nm_Cliente FROM [dbo].[Cliente])

SELECT @Nm_Cliente

/*
Msg 512, Level 16, State 1, Line 599
Subquery returned more than 1 value. This is not permitted when the subquery 
follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
*/

GO

--	EXEMPLO 4:
DECLARE @Nm_Cliente VARCHAR(100)

SET @Nm_Cliente = (SELECT Nm_Cliente FROM [dbo].[Cliente] WHERE Id_Cliente = 1)

SELECT @Nm_Cliente
GO

--	EXEMPLO 5:
DECLARE @Nm_Cliente VARCHAR(100)

SELECT @Nm_Cliente = Nm_Cliente 
FROM [dbo].[Cliente] 
WHERE Id_Cliente = 1

SELECT @Nm_Cliente


---------------------------------------------------------------------------------------------------------------
--	Precedência e Operadores
---------------------------------------------------------------------------------------------------------------

/*
Ordem de Precedência (1 é o nível MAIS ALTO e 8 é o nível MAIS BAIXO):

	1) () (Parênteses)
	2) * (Multiplicação), / (Divisão), % (Módulo)
	3) + (Positivo), – (Negativo), + (Adição), + (Concatenação), – (Subtração)
	4) =, >, <, >=, <=, <>, !=, !>, !< (Operadores de Comparação)
	5) NOT
	6) AND
	7) BETWEEN, IN, LIKE, OR
	8) = (Atribuição)

Observações:
-> Quando uma expressão complexa tiver vários operadores, a precedência de operador determinará a sequência de operações. 
-> A ordem de execução pode afetar o valor resultante significativamente.
-> Quando dois operadores em uma expressão tiverem o mesmo nível de precedência, 
   eles serão avaliados da ESQUERDA para a DIREITA em sua posição na expressão.
-> Se uma expressão tiver parênteses aninhados, a expressão mais aninhada será avaliada primeiro. 
*/

--	EXEMPLO 1 - PARÊNTESES E MULTIPLICAÇÃO:

SELECT 5 * (2 + 3)

SELECT 5 + 2 * 3

SELECT 5 + (5 + (2 * 2)) + 2 * 10

SELECT 5 / 2

SELECT 5 % 2

SELECT 6 % 2

SELECT 17 % 3

DECLARE @VarX1 INT = 0
SELECT 5 / @VarX1

/*
Msg 8134, Level 16, State 1, Line 679
Divide by zero error encountered.
*/

DECLARE @VarX2 INT = 0
SELECT 
	CASE WHEN @VarX2 = 0
		THEN 0
		ELSE 5 / @VarX2
	END
GO

--	OU...
DECLARE @VarX2 INT = 0
SELECT 
	CASE WHEN @VarX2 <> 0
		THEN 5 / @VarX2
		ELSE 0
	END
GO

DECLARE @VarX2 INT = 2
SELECT 
	CASE WHEN @VarX2 = 0
		THEN 0
		ELSE 5 / @VarX2
	END
GO

--	EXEMPLO 2 - OPERADORES NO MESMO NÍVEL:

SELECT 10 * 5 / 2

SELECT 10 / 5 * 2

--	EXEMPLO 3 - OPERADORES DE COMPARAÇÃO:

--	CRIA TABELA EXEMPLO
DROP TABLE IF EXISTS Vendas
GO

CREATE TABLE Vendas (
	IdVenda INT IDENTITY(1,1) NOT NULL,
	Cd_Loja INT NOT NULL,
	DtVenda DATETIME NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL
)

INSERT INTO Vendas (Cd_Loja, DtVenda, Vl_Venda)
VALUES
	(1, GETDATE(), 100.00),
	(1, GETDATE(), 232.17),
	(2, GETDATE(), 597.52),
	(2, GETDATE(), 304.63)

-- SELECT * FROM Vendas

SELECT * 
FROM Vendas
WHERE
	Cd_Loja = 2
	AND Vl_Venda > 500

SELECT * 
FROM Vendas
WHERE
	Cd_Loja = 2
	AND Vl_Venda > 100 + 50 * 2

--	EXEMPLO 4 - CUIDADO COM O "OR":
SELECT * 
FROM Vendas
WHERE
	Cd_Loja = 1
	OR Vl_Venda > 500

SELECT * 
FROM Vendas
WHERE
	Cd_Loja = 1
	OR Vl_Venda > 500
	AND Cd_Loja = 2 
	AND Vl_Venda > 600

-- EXEMPLO 5 - OPERADOR "NOT" - COMPARAR OS PLANOS DE EXECUÇÃO:
SELECT * 
FROM Vendas
WHERE
	NOT (Cd_Loja = 1)

SELECT * 
FROM Vendas
WHERE
	Cd_Loja NOT IN(1)