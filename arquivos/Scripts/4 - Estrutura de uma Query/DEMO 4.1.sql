---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	4 - Estrutura de uma Query
--	DEMO 4.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	SELECT
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO - ESTRUTURA DE UMA QUERY:

SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, COUNT(*) AS Qt_Vendas, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano


DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES
	('Fabrício Lima', '19800106'),
	('Luiz Lima', '19890922'),
	('Fabiano Amorim', '19620927'),
	('Dirceu Resende', '19740516'),
	('Rodrigo Ribeiro', '19500108')

--	EXEMPLO 1:
SELECT * 
FROM [dbo].[Cliente]


--	EXEMPLO 2 - ARRASTAR AS COLUNAS DO OBJECT EXPLORER:
SELECT [Id_Cliente], [Nm_Cliente], [Dt_Nascimento]
FROM [dbo].[Cliente]


--	EXEMPLO 3 - ORDEM DIFERENTE DAS COLUNAS (MOSTRAR A ORDEM DAS COLUNAS NA DEFINIÇÃO COM O ALT+F1):
SELECT [Nm_Cliente], [Dt_Nascimento], [Id_Cliente]
FROM [dbo].[Cliente]


--	EXEMPLO 4.1 - UTILIZANDO O "ALIAS":
SELECT 
	[Id_Cliente]	AS [ID Cliente], 
	[Nm_Cliente]	AS [Nome Cliente], 
	[Dt_Nascimento] AS [Data de Nascimento]
FROM [dbo].[Cliente]

--	SEM O "AS" NA DATA DE NASCIMENTO
SELECT 
	[Id_Cliente]	AS [ID Cliente], 
	[Nm_Cliente]	AS "Nome Cliente", 
	[Dt_Nascimento] [Data de Nascimento]	
FROM [dbo].[Cliente]

--	ESQUECENDO DA "VIRGULA" ENTRE AS COLUNAS
SELECT Id_Cliente Nm_Cliente 
FROM [dbo].[Cliente]


--	ALIAS = EXPRESSION
SELECT 
	[Id_Cliente]	AS [ID Cliente], 
	[Nm_Cliente]	AS [Nome Cliente], 
	[Data de Nascimento] = [Dt_Nascimento] 	
FROM [dbo].[Cliente]


--	EXEMPLO 4.2 - UTILIZANDO O "ALIAS" EM OUTRA COLUNA:
--	USANDO O CONVERT
SELECT 
	[Id_Cliente]								AS [ID Cliente], 
	[Nm_Cliente]								AS [Nome Cliente], 
	CONVERT(VARCHAR(10),[Dt_Nascimento],103)	AS [Data de Nascimento]
FROM [dbo].[Cliente]

SELECT 
	[Id_Cliente]								AS [ID Cliente], 
	[Nm_Cliente]								AS [Nome Cliente], 
	CONVERT(VARCHAR(10),[Dt_Nascimento],103)	AS [Data de Nascimento],
	[Data de Nascimento] AS [Data2]
FROM [dbo].[Cliente]

/*
Msg 207, Level 16, State 1, Line 78
Invalid column name 'Data de Nascimento'.
*/

SELECT 
	[Id_Cliente]								AS [ID Cliente], 
	[Nm_Cliente]								AS [Nome Cliente], 
	CONVERT(VARCHAR(10),[Dt_Nascimento],103)	AS [Data de Nascimento],
	CONVERT(VARCHAR(10),[Dt_Nascimento],103)	AS [Data2]
FROM [dbo].[Cliente]


--	EXEMPLO 5 - CUIDADO COM TABELAS GRANDES E A PERFORMANCE!!!
--	COMANDO PARA VALIDAR O TAMANHO E A QUANTIDADE DE REGISTROS DE UMA TABELA.
EXEC sp_spaceused 'Cliente' 

SELECT TOP 10 * 
FROM [dbo].[Cliente]
GO


--	EXEMPLO 6 - DELIMITADORES
SELECT * FROM Cliente
SELECT * FROM [Cliente]
SELECT * FROM "Cliente"

SELECT * FROM dbo.Cliente
SELECT * FROM [dbo].[Cliente]
SELECT * FROM "dbo"."Cliente"


---------------------------------------------------------------------------------------------------------------
--	MULTIPART NAMES -> "four-part name“:

--	SINTAXE:
--	SELECT [colunas] 
--	FROM [ServerName].[DatabaseName].[SchemaName].[ObjectName]

--	Referências:
--	https://docs.microsoft.com/en-us/sql/t-sql/language-elements/transact-sql-syntax-conventions-transact-sql?view=sql-server-ver15#multipart-names
--	https://www.mssqltips.com/sqlservertip/1095/sql-server-four-part-naming/
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

USE Treinamento_TSQL
GO

--	four-part object name -> other instance (Linked Server)
SELECT * 
FROM [HPSPECTRE\SQL2019].[Treinamento_TSQL].[dbo].[Cliente]

--	three-part object name -> other database
SELECT * 
FROM [Traces].[dbo].[Cliente]

SELECT * 
FROM [Treinamento_TSQL].[dbo].[Cliente]

SELECT * 
FROM [Traces]..[Cliente]

--	two-part object name -> schema-qualified
SELECT * 
FROM [dbo].[Cliente]

--	one-part object name -> object only
SELECT * 
FROM [Cliente]
GO


--	EXEMPLO 2: CUIDADO - SELECT SEM SCHEMA!
--	Referência:
--	https://luizlima.net/casos-do-dia-a-dia-default-schema-e-default-database/

DROP TABLE IF EXISTS [dbo].[TesteSchema]
GO

CREATE TABLE [dbo].[TesteSchema] (
	ID INT IDENTITY(1,1) NOT NULL,
	Descricao VARCHAR(100) NOT NULL
)

INSERT INTO [dbo].[TesteSchema]
VALUES('TABELA DO SCHEMA "DBO"!')
GO

DROP TABLE IF EXISTS [RH].[TesteSchema]
GO

CREATE TABLE [RH].[TesteSchema] (
	ID INT IDENTITY(1,1) NOT NULL,
	Descricao VARCHAR(100) NOT NULL
)

INSERT INTO [RH].[TesteSchema]
VALUES('TABELA DO SCHEMA "RH"!')
GO

SELECT * FROM [dbo].[TesteSchema]
SELECT * FROM [RH].[TesteSchema]

--	QUAL TABELA IRÁ UTILIZAR???
--	FILTRAR O NOME DA TABELA NO OBJECT EXPLORER
SELECT * FROM [TesteSchema]
GO


---------------------------------------------------------------------------------------------------------------
--	Executando uma Query – Passo a Passo – RESUMO:
---------------------------------------------------------------------------------------------------------------
--	1)    FROM		-> Consulta as linhas da tabela “Orders”.
--	2)    WHERE		-> Filtra apenas as linhas onde a coluna “custid” é igual a 71.
--	3)    GROUP BY	-> Agrupa o resultado anterior por “empid” e “ano da venda”.
--	4)    HAVING	-> Filtra somente os grupos (“empid” e “ano da venda”) que possuem mais de uma venda (COUNT(*) > 1).
--	5)    SELECT	-> Retorna o “empid”, “ano da venda” e a quantidade de vendas (COUNT(*)).
--	6)    ORDER BY	-> Retorna o resultado final ordenado por “empid” e “ano da venda”.
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO:
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano

--	1) FROM	-> Consulta as linhas da tabela “Orders”.
--	(40 rows affected)
SELECT * 
FROM Vendas


--	2) WHERE -> Filtra apenas as linhas onde a coluna “custid” é igual a 71.
--	(20 rows affected)
SELECT * 
FROM Vendas
WHERE Id_Cliente = 1


--	3) GROUP BY -> Agrupa o resultado anterior por “empid” e “ano da venda”.
--	
--	3.1
--	(20 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano
FROM Vendas
WHERE Id_Cliente = 1

--	3.2
--	(8 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)


--	4) HAVING -> Filtra somente os grupos (“empid” e “ano da venda”) que possuem mais de uma venda (COUNT(*) > 1).
-- (6 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1


--	5) SELECT -> Retorna o “empid”, “ano da venda” e a quantidade de vendas (COUNT(*)).
-- (6 rows affected)
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1


--	6) ORDER BY -> Retorna o resultado final ordenado por “empid” e “ano da venda”.
--	(6 rows affected)

--	AN0 - CRESCENTE
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano

--	AN0 - DECRESCENTE
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, SUM(Vl_Venda) AS Vl_Total, COUNT(*) AS Qt_Vendas 
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano DESC

--	Incluindo a média
SELECT 
	Id_Loja, 
	YEAR(Dt_Venda)							AS Nr_Ano, 	
	SUM(Vl_Venda)							AS Vl_Total, 
	COUNT(*)								AS Qt_Vendas, 
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2))		AS Vl_Media
FROM Vendas
WHERE Id_Cliente = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
HAVING COUNT(*) > 1
ORDER BY Id_Loja, Nr_Ano


---------------------------------------------------------------------------------------------------------------
--	WHERE:
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT  * 
FROM Vendas
WHERE 
	Id_Cliente = 1
	AND YEAR(Dt_Venda) >= 2021
	AND (Id_Loja = 1 OR Id_Loja = 2)


--	EXEMPLO 2 - UTILIZANDO FUNÇÕES NO WHERE:
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
GO

DROP FUNCTION IF EXISTS [dbo].[fncCalculaAumentoSalario]
GO
CREATE FUNCTION [dbo].[fncCalculaAumentoSalario] (
	@Vl_Salario NUMERIC(9,2),
	@Fator_Aumento NUMERIC(9,2)
)
RETURNS NUMERIC(9,2)
AS
BEGIN
	RETURN @Vl_Salario * @Fator_Aumento
END
GO

--	RETORNANDO OS DADOS
SELECT *, [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) AS Vl_Salario_Novo
FROM [dbo].[Cliente]
WHERE [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) > 20000
GO


--	EXEMPLO 3 -	UTILIZANDO UMA EXPRESSÃO NO WHERE
DECLARE @Vl_Salario_Minimo NUMERIC(9,2) = 1000.00

SELECT *
FROM [dbo].[Cliente]
WHERE Vl_Salario > @Vl_Salario_Minimo * 15


--	EXEMPLO 4 -	IN
SELECT *
FROM [dbo].[Cliente]
WHERE Vl_Salario IN (1000.00, 50000.00)


--	EXEMPLO 5 -	BETWEEN
SELECT *
FROM [dbo].[Cliente]
WHERE Vl_Salario BETWEEN 1000.00 AND 50000.00


--	EXEMPLO 6 -	NOT IN
SELECT *
FROM [dbo].[Cliente]
WHERE Vl_Salario NOT IN (1000.00, 50000.00)



---------------------------------------------------------------------------------------------------------------
--	GROUP BY:
---------------------------------------------------------------------------------------------------------------
--	Referências:

--	Funções de Agregação
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/aggregate-functions-transact-sql?view=sql-server-ver15

--	SUM
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/sum-transact-sql?view=sql-server-ver15

--	COUNT
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/count-transact-sql?view=sql-server-ver15

--	AVG
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/avg-transact-sql?view=sql-server-ver15

--	MIN
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/min-transact-sql?view=sql-server-ver15

--	MAX
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/max-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - COUNT / SUM / AVG / MAX / MIN:
SELECT Id_Loja, YEAR(Dt_Venda) AS Nr_Ano, Vl_Venda
FROM Vendas
WHERE Id_Cliente = 1 AND Id_Loja = 1

SELECT 
	-- Elementos do GROUP BY
	Id_Loja, 
	YEAR(Dt_Venda)							AS Nr_Ano, 

	--	Funções de Agregação	
	SUM(Vl_Venda)							AS Vl_Total, 
	COUNT(*)								AS Qt_Vendas, 
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2))		AS Vl_Media,
	MIN(Vl_Venda)							AS Vl_Venda_Min,
	MAX(Vl_Venda)							AS Vl_Venda_Max
FROM Vendas
WHERE Id_Cliente = 1 AND Id_Loja = 1
GROUP BY Id_Loja, YEAR(Dt_Venda)
ORDER BY Nr_Ano


--	EXEMPLO 2 - COLUNA "Id_Loja" NÃO ESTÁ NO GROUP BY:
SELECT 
	-- Elementos do GROUP BY
	Id_Loja, 
	YEAR(Dt_Venda)							AS Nr_Ano, 

	--	Funções de Agregação
	COUNT(*)								AS Qt_Vendas, 
	SUM(Vl_Venda)							AS Vl_Total, 
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2))		AS Vl_Media,
	MIN(Vl_Venda)							AS Vl_Venda_Min,
	MAX(Vl_Venda)							AS Vl_Venda_Max
FROM Vendas
WHERE Id_Cliente = 1 AND Id_Loja = 1
GROUP BY YEAR(Dt_Venda)

/*
Msg 8120, Level 16, State 1, Line 275
Column 'Vendas.Id_Loja' is invalid in the select list because it is not contained 
in either an aggregate function or the GROUP BY clause.
*/


--	EXEMPLO 3 - FUNÇÃO DE AGREGAÇÃO - COUNT x COLUNAS NULL:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Vl_Salario)
VALUES
	('Fabrício Lima', 10000.00),
	('Luiz Lima', NULL),
	('Fabiano Amorim', 50000.00),
	('Dirceu Resende', NULL),
	('Rodrigo Ribeiro', 10000.00)

SELECT * FROM [dbo].[Cliente]
GO

--	(5 rows affected)

--	COLUNAS QUE NÃO POSSUEM VALOR "NULL"
--	COUNT(*)
SELECT COUNT(*)
FROM [dbo].[Cliente]

--	COUNT(Id_Cliente)
SELECT COUNT(Id_Cliente)
FROM [dbo].[Cliente]

--	COUNT(Nm_Cliente)
SELECT COUNT(Nm_Cliente)
FROM [dbo].[Cliente]

--	COUNT(Vl_Salario)	-- POSSUI VALORES "NULL"
SELECT * FROM [dbo].[Cliente]
GO

--	RESULTADO: 5
SELECT COUNT(*)
FROM [dbo].[Cliente]

--	RESULTADO: 3
SELECT COUNT(Vl_Salario)
FROM [dbo].[Cliente]

--	 Messages:
--	 Warning: Null value is eliminated by an aggregate or other SET operation.


--	EXEMPLO 4 - FUNÇÃO DE AGREGAÇÃO - COUNT x COLUNAS NULL:
DROP TABLE IF EXISTS [dbo].[TesteCountNull]
GO

CREATE TABLE [dbo].[TesteCountNull] (
	Nm_Cliente VARCHAR(100)  NULL
)

GO

INSERT INTO [TesteCountNull] (Nm_Cliente)
VALUES (NULL)
GO 10


SELECT *
FROM [TesteCountNull]

SELECT COUNT(*), COUNT(Nm_Cliente)
FROM [TesteCountNull]


--	EXEMPLO 5 - FUNÇÃO DE AGREGAÇÃO - COUNT x DISTINCT:
DROP TABLE IF EXISTS [dbo].[TesteCountDistinct]
GO

CREATE TABLE [dbo].[TesteCountDistinct] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Fl_Tipo TINYINT NULL
)

GO

INSERT INTO [dbo].[TesteCountDistinct] (Nm_Cliente, Fl_Tipo)
VALUES 
	('Luiz Vitor', 1),
	('Fabricio Lima', 1),
	('Rodrigo Gomes', 2),
	('Dirceu Resende', 2),
	('Fabiano Amorim', 3)

SELECT * FROM [dbo].[TesteCountDistinct]

--	USANDO O DISTINCT
SELECT COUNT(*), COUNT(Fl_Tipo), COUNT(DISTINCT Fl_Tipo)
FROM [TesteCountDistinct]

GO

INSERT INTO [dbo].[TesteCountDistinct] (Nm_Cliente, Fl_Tipo)
VALUES 
	('Gustavo Larocca', NULL)
GO

SELECT * FROM [TesteCountDistinct]

--	USANDO O DISTINCT COM COLUNA NULL
SELECT COUNT(*), COUNT(Fl_Tipo), COUNT(DISTINCT Fl_Tipo)
FROM [TesteCountDistinct]

--	(6 rows affected)
--	Warning: Null value is eliminated by an aggregate or other SET operation.


--	EXEMPLO 6 - FUNÇÃO DE AGREGAÇÃO - SUM | AVG | MIN | MAX:
SELECT * FROM Cliente

--	SEM O GROUP BY VAI FUNCIONAR LUIZ???
--	EXPLICAR O RESULTADO DA COLUNA "MEDIA"
SELECT  
	SUM(Vl_Salario) AS Soma, 
	AVG(Vl_Salario) AS Media, 
	MIN(Vl_Salario) AS Minimo, 
	MAX(Vl_Salario) AS Maximo
FROM Cliente

--	(5 rows affected)
--	Warning: Null value is eliminated by an aggregate or other SET operation.


--	BÔNUS - CÁLCULO AVG (AVG() = SUM() / COUNT()):
--	HABILITAR O PLANO DE EXECUÇÃO E MOSTRAR AS INFORMAÇÕES DOS OPERADORES E EXPRESSÕES (F4)
SELECT   
	AVG(Vl_Salario) AS Media
FROM Cliente

/*
[Expr1004] = Scalar Operator(COUNT_BIG([Treinamento_TSQL].[dbo].[Cliente].[Vl_Salario])); 
[Expr1005] = Scalar Operator(SUM([Treinamento_TSQL].[dbo].[Cliente].[Vl_Salario]))

[Expr1003] = Scalar Operator(CASE WHEN [Expr1004]=(0) THEN NULL ELSE [Expr1005] / CONVERT_IMPLICIT(numeric(19,0),[Expr1004],0) END)
*/


---------------------------------------------------------------------------------------------------------------
--	HAVING - FILTRANDO GRUPOS:
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

SELECT *
FROM Vendas
ORDER BY Vl_Venda DESC

--	AGRUPADO POR ANO
SELECT YEAR(Dt_Venda) AS Ano, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
GROUP BY YEAR(Dt_Venda)
ORDER BY Ano DESC

--	FILTRANDO GRUPOS:
SELECT YEAR(Dt_Venda) AS Ano, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
GROUP BY YEAR(Dt_Venda)
HAVING SUM(Vl_Venda) > 3000
ORDER BY Ano DESC

--	FILTRANDO LINHAS:
SELECT YEAR(Dt_Venda) AS Ano, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
WHERE Vl_Venda > 3000
GROUP BY YEAR(Dt_Venda)
ORDER BY Ano DESC

SELECT YEAR(Dt_Venda) AS Ano, SUM(Vl_Venda) AS Vl_Total
FROM Vendas
WHERE Vl_Venda > 500
GROUP BY YEAR(Dt_Venda)
ORDER BY Ano DESC


--	EXEMPLO 2:
SELECT *
FROM Vendas
ORDER BY Vl_Venda DESC

--	AGRUPADO POR ANO
SELECT 
	YEAR(Dt_Venda) AS Ano, 
	SUM(Vl_Venda) AS Vl_Total, 
	COUNT(*) AS Qt_Total, 
	AVG(Vl_Venda) AS Vl_Media,
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2)) AS Vl_Media_Formatada
	
	--	QUAL A DIFERENÇA PARA A COLUNA ACIMA???
	-- AVG(CAST(Vl_Venda AS NUMERIC(9,2)))  AS Vl_Media_Formatada
FROM Vendas
GROUP BY YEAR(Dt_Venda)
ORDER BY Ano DESC


--	EXEMPLO 2.1 - SUM:
SELECT 
	YEAR(Dt_Venda) AS Ano, 
	SUM(Vl_Venda) AS Vl_Total, 
	COUNT(*) AS Qt_Total, 
	AVG(Vl_Venda) AS Vl_Media,
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2)) AS Vl_Media_Formatada
FROM Vendas
GROUP BY YEAR(Dt_Venda)
HAVING SUM(Vl_Venda) > 3000
ORDER BY Ano DESC


--	EXEMPLO 2.2 - COUNT:
SELECT 
	YEAR(Dt_Venda) AS Ano, 
	SUM(Vl_Venda) AS Vl_Total, 
	COUNT(*) AS Qt_Total, 
	AVG(Vl_Venda) AS Vl_Media,
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2)) AS Vl_Media_Formatada
FROM Vendas
GROUP BY YEAR(Dt_Venda)
HAVING COUNT(*) > 10
ORDER BY Ano DESC


--	EXEMPLO 2.3 - AVG:
SELECT 
	YEAR(Dt_Venda) AS Ano, 
	SUM(Vl_Venda) AS Vl_Total, 
	COUNT(*) AS Qt_Total, 
	AVG(Vl_Venda) AS Vl_Media,
	CAST(AVG(Vl_Venda) AS NUMERIC(9,2)) AS Vl_Media_Formatada
FROM Vendas
GROUP BY YEAR(Dt_Venda)
HAVING AVG(Vl_Venda) > 500
ORDER BY Ano DESC


---------------------------------------------------------------------------------------------------------------
--	ORDER BY - ORDENANDO DADOS:
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT TOP 5 *
FROM Vendas
ORDER BY Vl_Venda

SELECT TOP 5 *
FROM Vendas
ORDER BY Vl_Venda ASC

SELECT TOP 5 *
FROM Vendas
ORDER BY Vl_Venda DESC


--	EXEMPLO 2:
SELECT *
FROM Vendas
ORDER BY Id_Loja, Dt_Venda

SELECT *
FROM Vendas
ORDER BY Id_Loja, Dt_Venda DESC

SELECT *
FROM Vendas
ORDER BY Id_Loja DESC, Dt_Venda


--	EXEMPLO 3 - ORDER BY COM CARDINAIS - BAD PRACTICE:
SELECT Id_Cliente, Vl_Salario
FROM Cliente
ORDER BY 2 DESC

--	INCLUINDO A COLUNA "Nm_Cliente" NA SEGUNDA COLUNA
SELECT Id_Cliente, Nm_Cliente, Vl_Salario
FROM Cliente
ORDER BY 2 DESC


--	EXEMPLO 4 - ORDER BY COM ALIAS - EXPRESSAO:
SELECT Id_Venda, Id_Loja, Vl_Venda *  0.1 AS [Valor Taxa] --, [Valor Venda]
FROM Vendas
ORDER BY [Valor Taxa] DESC
--ORDER BY Vl_Venda *  0.1 DESC


--	EXEMPLO 5 - ORDER BY COM FUNÇÃO:
SELECT TOP 5 Id_Venda, Id_Loja, Vl_Venda, YEAR(Dt_Venda) AS Ano, Dt_Venda
FROM Vendas
ORDER BY YEAR(Dt_Venda), Id_Venda

SELECT TOP 5 Id_Venda, Id_Loja, Vl_Venda, YEAR(Dt_Venda) AS Ano, Dt_Venda
FROM Vendas
ORDER BY Ano, Id_Venda

--	RESULTADO DIFERENTE DOS CASOS ACIMA?
-- SELECT * FROM Vendas

SELECT TOP 5 Id_Venda, Id_Loja, Vl_Venda, YEAR(Dt_Venda) AS Ano, Dt_Venda
FROM Vendas
ORDER BY Dt_Venda, Id_Venda


--	EXEMPLO 6 - TABELA "Cliente"
SELECT *
FROM Cliente
ORDER BY Vl_Salario DESC

SELECT *
FROM Cliente
ORDER BY Nm_Cliente

--	ORDER BY COM FUNÇÃO - A FUNÇÃO EXECUTA MAIS DE UMA VEZ OU NÃO???
SELECT *, [dbo].[fncCalculaAumentoSalario] (Vl_Salario, 1.1) AS Vl_Salario_Novo
FROM Cliente
ORDER BY [dbo].[fncCalculaAumentoSalario] (Vl_Salario, 1.1) DESC


--	EXEMPLO 7 - UTILIZANDO UMA COLUNA NO ORDER BY, SENDO QUE ELA NÃO APARECE NO RESULTADO
SELECT *
FROM Cliente

SELECT Nm_Cliente, Vl_Salario
FROM Cliente
ORDER BY Id_Cliente

SELECT Nm_Cliente, Vl_Salario
FROM Cliente
ORDER BY Id_Cliente DESC


--	EXEMPLO 7 - ORDER BY x NULL
SELECT * FROM Cliente

--	NULL VEM PRIMEIRO OU POR ULTIMO???
--	COLLATION: SQL_Latin1_General_CP1_CI_AS
SELECT *
FROM Cliente
ORDER BY Vl_Salario

SELECT *
FROM Cliente
ORDER BY Vl_Salario DESC


---------------------------------------------------------------------------------------------------------------
--	OPTION – INCLUINDO ALGUMAS OPÇÕES:
---------------------------------------------------------------------------------------------------------------
--	MAXDOP: Limita a quantidade de processadores que a query pode utilizar.
--	RECOMPILE: Cria um novo plano de execução para a query a cada execução.
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT Nm_Cliente
FROM Cliente
ORDER BY Nm_Cliente
OPTION (MAXDOP 1, RECOMPILE)