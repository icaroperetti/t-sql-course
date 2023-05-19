--------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	4 - Estrutura de uma Query
--	DEMO 4.3:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	UNION
---------------------------------------------------------------------------------------------------------------
--	TABELA 1:
DROP TABLE IF EXISTS #TEMP_UNION_1
GO

CREATE TABLE #TEMP_UNION_1 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_UNION_1 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(1, 100.00, '20210106'),
	(2, 100.00, '20210206'),
	(3, 100.00, '20210306'),
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506')

SELECT * FROM #TEMP_UNION_1

--	TABELA 2:
DROP TABLE IF EXISTS #TEMP_UNION_2
GO

CREATE TABLE #TEMP_UNION_2 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_UNION_2 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506'),
	(6, 200.00, '20210606'),
	(7, 200.00, '20210606')

SELECT * FROM #TEMP_UNION_2


--	EXEMPLO 1 - UNION (DISTINCT):
--	MOSTRAR O DISTINCT NO PLANO DE EXECUÇÃO
SELECT * FROM #TEMP_UNION_1
UNION
SELECT * FROM #TEMP_UNION_2
GO

--	REGISTROS DUPLICADOS
SELECT * FROM #TEMP_UNION_1
UNION
SELECT * FROM #TEMP_UNION_1
GO


--	EXEMPLO 2 - UNION ALL:
SELECT * FROM #TEMP_UNION_1
UNION ALL
SELECT * FROM #TEMP_UNION_2
GO

SELECT * FROM #TEMP_UNION_1
UNION ALL
SELECT * FROM #TEMP_UNION_1
GO


--	EXEMPLO 3 - UNION - COM QTDE DE COLUNAS DIFERENTES:
SELECT Id_Cliente, Vl_Venda, Dt_Venda FROM #TEMP_UNION_1
UNION 
SELECT Id_Cliente, Vl_Venda FROM #TEMP_UNION_2
GO

/*
Msg 205, Level 16, State 1, Line 78
All queries combined using a UNION, INTERSECT or EXCEPT operator 
must have an equal number of expressions in their target lists.
*/


--	EXEMPLO 4 - UNION - COM TIPOS DIFERENTES:
--	4.1) TIPOS INCOMPATIVEIS:
SELECT Id_Cliente, Vl_Venda, Dt_Venda FROM #TEMP_UNION_1
UNION 
SELECT Dt_Venda, Vl_Venda, Id_Cliente FROM #TEMP_UNION_2
GO

/*
Msg 206, Level 16, State 2, Line 91
Operand type clash: int is incompatible with date
Msg 206, Level 16, State 2, Line 91
Operand type clash: int is incompatible with date
*/

--	4.2) TIPOS COMPATIVEIS:
SELECT Id_Cliente, Vl_Venda, Dt_Venda FROM #TEMP_UNION_1
UNION 
SELECT CAST(Id_Cliente AS BIGINT), Vl_Venda, Dt_Venda FROM #TEMP_UNION_2
GO


--	EXEMPLO 5 - UNION x ORDER BY:
SELECT * FROM #TEMP_UNION_1 ORDER BY Id_Cliente DESC
UNION ALL
SELECT * FROM #TEMP_UNION_2
GO

/*
Msg 156, Level 15, State 1, Line 106
Incorrect syntax near the keyword 'UNION'.
*/

--	ORDER BY ASC
SELECT * FROM #TEMP_UNION_1 
UNION
SELECT * FROM #TEMP_UNION_2
ORDER BY Id_Cliente
GO

--	ORDER BY DESC
SELECT * FROM #TEMP_UNION_1 
UNION
SELECT * FROM #TEMP_UNION_2
ORDER BY Id_Cliente DESC
GO


--	EXEMPLO 6 - UNION COM VARIOS SELECTS:
SELECT * FROM #TEMP_UNION_1 
UNION ALL
SELECT * FROM #TEMP_UNION_1 
UNION ALL
SELECT * FROM #TEMP_UNION_2 
UNION ALL
SELECT * FROM #TEMP_UNION_2 


--	EXEMPLO 7 - UNION x ALIAS:
--	7.1 - ALIAS NA SEGUNDA QUERY:
SELECT Id_Cliente, Vl_Venda, Dt_Venda 
FROM #TEMP_UNION_1 
UNION
SELECT Id_Cliente AS ID, Vl_Venda AS Valor, Dt_Venda AS Data
FROM #TEMP_UNION_2 

--	7.2 - ALIAS NA PRIMEIRA QUERY:
SELECT Id_Cliente AS ID, Vl_Venda AS Valor, Dt_Venda AS Data
FROM #TEMP_UNION_1 
UNION
SELECT Id_Cliente, Vl_Venda, Dt_Venda
FROM #TEMP_UNION_2 
GO

DROP TABLE IF EXISTS #TEMP_UNION_1
DROP TABLE IF EXISTS #TEMP_UNION_2


---------------------------------------------------------------------------------------------------------------
--	INTERSECT
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMP_INTERSECT_1
GO

CREATE TABLE #TEMP_INTERSECT_1 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_INTERSECT_1 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(1, 100.00, '20210106'),
	(2, 100.00, '20210206'),
	(3, 100.00, '20210306'),
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506')

SELECT * FROM #TEMP_INTERSECT_1

--	TABELA 2:
DROP TABLE IF EXISTS #TEMP_INTERSECT_2
GO

CREATE TABLE #TEMP_INTERSECT_2 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_INTERSECT_2 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506'),
	(6, 200.00, '20210606'),
	(7, 200.00, '20210606')

SELECT * FROM #TEMP_INTERSECT_2


--	EXEMPLO 1 - INTERSECT:
SELECT * FROM #TEMP_INTERSECT_1
INTERSECT
SELECT * FROM #TEMP_INTERSECT_2

SELECT * FROM #TEMP_INTERSECT_2
INTERSECT
SELECT * FROM #TEMP_INTERSECT_1


--	EXEMPLO 2 - ORDER BY:
SELECT * FROM #TEMP_INTERSECT_1 
INTERSECT
SELECT * FROM #TEMP_INTERSECT_2
ORDER BY Dt_Venda DESC


--	EXEMPLO 3 - INTERSECT x NULL x JOIN:
--	TABELA 1 - CRIA AS TABELAS COM NULL:
DROP TABLE IF EXISTS #TEMP_INTERSECT_1_NULL
GO

CREATE TABLE #TEMP_INTERSECT_1_NULL (
	Id_Cliente INT NULL,
	Vl_Venda NUMERIC(9,2) NULL,
	Dt_Venda DATE NULL
)

INSERT INTO #TEMP_INTERSECT_1_NULL (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(1, 100.00, '20210106'),
	(2, 100.00, '20210206'),
	(3, 100.00, '20210306'),
	(4, NULL, '20210406'),
	(NULL, NULL, '20210506')

SELECT * FROM #TEMP_INTERSECT_1_NULL
GO

--	TABELA 2 - CRIA AS TABELAS COM NULL:
DROP TABLE IF EXISTS #TEMP_INTERSECT_2_NULL
GO

CREATE TABLE #TEMP_INTERSECT_2_NULL (
	Id_Cliente INT NULL,
	Vl_Venda NUMERIC(9,2) NULL,
	Dt_Venda DATE NULL
)

INSERT INTO #TEMP_INTERSECT_2_NULL (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(4, NULL, '20210406'),
	(NULL, NULL, '20210506'),
	(6, NULL, '20210606'),
	(7, 200.00, NULL)

SELECT * FROM #TEMP_INTERSECT_2_NULL
GO

--	EXEMPLO 3.1 - INTERSECT x NULL:
SELECT * FROM #TEMP_INTERSECT_1_NULL 
INTERSECT
SELECT * FROM #TEMP_INTERSECT_2_NULL
GO

SELECT * FROM #TEMP_INTERSECT_2_NULL
INTERSECT
SELECT * FROM #TEMP_INTERSECT_1_NULL 


--	EXEMPLO 3.2 - JOIN x NULL:
--	JOIN SEM TRATAR NULL
SELECT T1.* 
FROM #TEMP_INTERSECT_1_NULL T1
JOIN #TEMP_INTERSECT_2_NULL T2 ON
	T1.Id_Cliente = T2.Id_Cliente AND
	T1.Vl_Venda = T2.Vl_Venda AND
	T1.Dt_Venda = T2.Dt_Venda

--	JOIN TRATANDO NULL
SELECT T1.*
FROM #TEMP_INTERSECT_1_NULL T1
JOIN #TEMP_INTERSECT_2_NULL T2 ON
	(T1.Id_Cliente = T2.Id_Cliente OR (T1.Id_Cliente IS NULL AND T2.Id_Cliente IS NULL)) AND
	(T1.Vl_Venda = T2.Vl_Venda OR (T1.Vl_Venda IS NULL AND T2.Vl_Venda IS NULL)) AND
	(T1.Dt_Venda = T2.Dt_Venda OR (T1.Dt_Venda IS NULL AND T2.Dt_Venda IS NULL))
ORDER BY T1.Id_Cliente

--	APENAS PARA COMPARAR A DIFERENÇA DA ESCRITA DO CODIGO
SELECT * FROM #TEMP_INTERSECT_1_NULL 
INTERSECT
SELECT * FROM #TEMP_INTERSECT_2_NULL
ORDER BY Id_Cliente


DROP TABLE IF EXISTS #TEMP_INTERSECT_1
DROP TABLE IF EXISTS #TEMP_INTERSECT_2
DROP TABLE IF EXISTS #TEMP_INTERSECT_1_NULL
DROP TABLE IF EXISTS #TEMP_INTERSECT_2_NULL


---------------------------------------------------------------------------------------------------------------
--	EXCEPT
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMP_EXCEPT_1
GO

CREATE TABLE #TEMP_EXCEPT_1 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_EXCEPT_1 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(1, 100.00, '20210106'),
	(2, 100.00, '20210206'),
	(3, 100.00, '20210306'),
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506')

SELECT * FROM #TEMP_EXCEPT_1

--	TABELA 2:
DROP TABLE IF EXISTS #TEMP_EXCEPT_2
GO

CREATE TABLE #TEMP_EXCEPT_2 (
	Id_Cliente INT NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL,
	Dt_Venda DATE NOT NULL
)

INSERT INTO #TEMP_EXCEPT_2 (Id_Cliente, Vl_Venda, Dt_Venda)
VALUES
	(4, 200.00, '20210406'),
	(5, 200.00, '20210506'),
	(6, 200.00, '20210606'),
	(7, 200.00, '20210606')

SELECT * FROM #TEMP_EXCEPT_2


--	EXEMPLO 1 - EXCEPT:
SELECT * FROM #TEMP_EXCEPT_1
EXCEPT
SELECT * FROM #TEMP_EXCEPT_2

SELECT * FROM #TEMP_EXCEPT_2
EXCEPT
SELECT * FROM #TEMP_EXCEPT_1


DROP TABLE IF EXISTS #TEMP_EXCEPT_1
DROP TABLE IF EXISTS #TEMP_EXCEPT_2


---------------------------------------------------------------------------------------------------------------
--	DISTINCT
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT * FROM Vendas

SELECT Id_Loja, Vl_Venda 
FROM Vendas

SELECT DISTINCT Vl_Venda 
FROM Vendas

SELECT DISTINCT Id_Loja, Vl_Venda 
FROM Vendas

--	EXEMPLO 2 - DISTINCT x TOP:
SELECT DISTINCT TOP 5 Id_Loja, Vl_Venda 
FROM Vendas
WHERE Id_Cliente = 1


--	EXEMPLO 3 - DISTINCT x ORDER BY:
SELECT TOP 5 Id_Loja, Vl_Venda 
FROM Vendas
ORDER BY Id_Cliente

SELECT DISTINCT TOP 5 Id_Loja, Vl_Venda 
FROM Vendas
ORDER BY Id_Cliente

/*
Msg 145, Level 15, State 1, Line 52
ORDER BY items must appear in the select list if SELECT DISTINCT is specified.
*/

SELECT DISTINCT TOP 5 Id_Loja, Vl_Venda 
FROM Vendas
ORDER BY Id_Loja DESC, Vl_Venda DESC


---------------------------------------------------------------------------------------------------------------
--	TOP, WITH TIES, OFFSET-FETCH
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - TOP x WITH TIES (EMPATE):
SELECT *
FROM Vendas
ORDER BY Vl_Venda DESC

SELECT TOP 10 *
FROM Vendas

SELECT TOP 10 *
FROM Vendas
ORDER BY Vl_Venda DESC

--	WITH TIES
SELECT TOP 10 WITH TIES *
FROM Vendas
ORDER BY Vl_Venda DESC


--	EXEMPLO 2 - TOP:
SELECT *
FROM Vendas
ORDER BY Vl_Venda

SELECT TOP (5) *
FROM Vendas
ORDER BY Vl_Venda

--	WITH TIES
SELECT TOP 5 WITH TIES *
FROM Vendas
ORDER BY Vl_Venda


--	EXEMPLO 3 - TOP x PERCENT:
SELECT *
FROM Vendas
ORDER BY Vl_Venda DESC

--	10%
SELECT TOP (10) PERCENT *
FROM Vendas
ORDER BY Vl_Venda DESC

--	50%
SELECT TOP 50 PERCENT *
FROM Vendas
ORDER BY Vl_Venda DESC


--	EXEMPLO 4 - TOP x OFFSET-FETCH (PAGINACAO):
SELECT *
FROM Vendas
ORDER BY Id_Venda

--	RETORNA AS LINHAS 1 A 10
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

--	RETORNA AS LINHAS 11 A 20
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY

--	RETORNA AS LINHAS 21 A 30
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY

--	RETORNA AS LINHAS 31 A 40
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 30 ROWS FETCH NEXT 10 ROWS ONLY

--	RETORNA AS LINHAS 21 A 40
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY

--	SEM ORDER BY
SELECT *
FROM Vendas
--ORDER BY Id_Venda
OFFSET 20 ROWS FETCH NEXT 20 ROWS ONLY

/*
Msg 102, Level 15, State 1, Line 118
Incorrect syntax near '20'.
Msg 153, Level 15, State 2, Line 118
Invalid usage of the option NEXT in the FETCH statement.
*/
GO


--	EXEMPLO 5 - TOP x OFFSET-FETCH - COM VARIAVEIS:
DECLARE @Qtd_Registros INT = 10, @Num_Pagina INT

--	DEFINIR AQUI O NÚMERO DA PÁGINA
SET @Num_Pagina = 1

--	RESULTADO "PAGINADO"
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET (@Qtd_Registros * (@Num_Pagina - 1)) ROWS FETCH NEXT @Qtd_Registros ROWS ONLY


--	EXERCICIOS - TOP x OFFSET-FETCH - QUAIS LINHAS SERÃO RETORNADAS NOS CASOS ABAIXO???

--	EXERCÍCIOS 1:
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY

--	EXERCÍCIOS 2:
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 25 ROWS FETCH NEXT 3 ROWS ONLY

--	EXERCÍCIOS 3:
SELECT *
FROM Vendas
ORDER BY Id_Venda
OFFSET 5 ROWS FETCH NEXT 20 ROWS ONLY