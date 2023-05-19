---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	4 - Estrutura de uma Query
--	DEMO 4.2:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	JOINS – UNINDO TABELAS
---------------------------------------------------------------------------------------------------------------
--	CRIA DUAS TABELAS TEMPORARIAS
DROP TABLE IF EXISTS #TABELA_A
GO

CREATE TABLE #TABELA_A (
	ID INT NULL
)

INSERT INTO #TABELA_A (ID) VALUES (1),(2),(3),(4) 

SELECT * FROM #TABELA_A
GO

DROP TABLE IF EXISTS #TABELA_B
GO

CREATE TABLE #TABELA_B (
	ID INT NULL
)

INSERT INTO #TABELA_B (ID) VALUES (3),(4),(5),(6),(NULL)

SELECT * FROM #TABELA_B
GO


---------------------------------------------------------------------------------------------------------------
--	CROSS JOIN (PRODUTO CARTESIANO)
---------------------------------------------------------------------------------------------------------------	
SELECT * FROM #TABELA_A 
SELECT * FROM #TABELA_B 
GO

SELECT *
FROM #TABELA_A AS A
CROSS JOIN #TABELA_B AS B
ORDER BY A.ID, B.ID


---------------------------------------------------------------------------------------------------------------
--	INNER JOIN
---------------------------------------------------------------------------------------------------------------	
SELECT * FROM #TABELA_A 
SELECT * FROM #TABELA_B 
GO

--	EXEMPLO 1:
--	INNER JOIN
SELECT * 
FROM #TABELA_A A
INNER JOIN #TABELA_B B ON A.ID = B.ID
ORDER BY A.ID, B.ID

--	JOIN
SELECT * 
FROM #TABELA_A A
JOIN #TABELA_B B ON A.ID = B.ID
ORDER BY A.ID, B.ID

--	JOIN - ISO/ANSI SQL-89
SELECT * 
FROM #TABELA_A A, #TABELA_B B  
WHERE A.ID = B.ID
ORDER BY A.ID, B.ID


--	EXEMPLO 2 - JOIN COM A PRÓPRIA TABELA:
SELECT * 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
ORDER BY A1.ID, A2.ID


--	EXEMPLO 3 - JOIN COM A PRÓPRIA TABELA - FUNCIONARIO
DROP TABLE IF EXISTS [dbo].[Funcionario]
GO

CREATE TABLE [dbo].[Funcionario] (
	Id_Funcionario INT IDENTITY(1,1) NOT NULL,
	Nm_Funcionario VARCHAR(100) NOT NULL,
	Id_Gerente INT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

--	INSERE ALGUNS REGISTROS
INSERT INTO [dbo].[Funcionario] (Nm_Funcionario, Id_Gerente, Vl_Salario)
VALUES
	('Fabrício Lima', NULL, 150000.00),
	('Luiz Lima', 1, 100000.00),
	('Fabiano Amorim', 2, 50000.00),
	('Dirceu Resende', 3, 1000.00),
	('Rodrigo Ribeiro', 4, 100.00)
	
SELECT * FROM [dbo].[Funcionario]

--	FAZENDO UM JOIN COM A PRÓPRIA TABELA
SELECT * 
FROM [dbo].[Funcionario] F
JOIN [dbo].[Funcionario] G ON F.Id_Gerente = G.Id_Funcionario

SELECT * 
FROM [dbo].[Funcionario] F
LEFT JOIN [dbo].[Funcionario] G ON F.Id_Gerente = G.Id_Funcionario


--	EXEMPLO 4 - JOIN COM COLUNAS NULL
--	SEM TRATAMENTO P/ NULL
SELECT *
FROM #TABELA_B B1
JOIN #TABELA_B B2 ON B1.ID = B2.ID

--	COM TRATAMENTO P/ NULL
--	1 - PERFORMANCE - PROBLEMA FILTRO COM "OR"
SELECT *
FROM #TABELA_B B1
JOIN #TABELA_B B2 ON (B1.ID = B2.ID OR (B1.ID IS NULL AND B2.ID IS NULL))

--	2 - PERFORMANCE - PROBLEMA FILTRO COM "FUNÇÃO"
SELECT *
FROM #TABELA_B B1
JOIN #TABELA_B B2 ON ISNULL(B1.ID,'') = ISNULL(B2.ID,'')
GO


--	EXEMPLO 5 - JOIN COM DADOS DUPLICADOS
DROP TABLE IF EXISTS #TABELA_DUPLICADOS
GO

CREATE TABLE #TABELA_DUPLICADOS (
	ID INT NULL
)

INSERT INTO #TABELA_DUPLICADOS (ID) VALUES (1),(1),(2),(2) 
GO

SELECT * FROM #TABELA_A
SELECT * FROM #TABELA_DUPLICADOS

--	O SELECT ABAIXO VAI DUPLICAR ALGUM DADO?
SELECT *
FROM #TABELA_A A
JOIN #TABELA_DUPLICADOS B ON A.ID = B.ID

--	E AGORA, VAI FAZER ALGUMA DIFERENÇA?
SELECT DISTINCT *
FROM #TABELA_A A
JOIN #TABELA_DUPLICADOS B ON A.ID = B.ID


--	EXEMPLO 6 - JOIN COM SUBQUERY
SELECT * 
FROM #TABELA_A A
JOIN (
		SELECT * 
		FROM #TABELA_B
	) B ON A.ID = B.ID
ORDER BY A.ID, B.ID


--	EXEMPLO 7 - VARIOS JOINS - FAZER EM PARTES
--	OBS: MOSTRAR O PLANO DE EXECUÇÃO
SELECT * 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A2.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A3.ID = A4.ID
INNER JOIN #TABELA_A A5 ON A4.ID = A5.ID
ORDER BY A1.ID


SELECT A5.ID, A4.ID, A3.ID, A2.ID, A1.ID, (A2.ID + A1.ID) * 4 AS Expressao
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A2.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A3.ID = A4.ID
INNER JOIN #TABELA_A A5 ON A4.ID = A5.ID
ORDER BY A1.ID


--	EXEMPLO 7.1 - VARIOS JOINS - RELACAO SOMENTE COM A TABELA A
SELECT * 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A1.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A1.ID = A4.ID
INNER JOIN #TABELA_A A5 ON A1.ID = A5.ID
ORDER BY A1.ID


--	EXEMPLO 8 - JOIN + LEFT JOIN
--	LEFT JOIN - B
SELECT * 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A1.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A1.ID = A4.ID
LEFT JOIN #TABELA_B A5 ON A1.ID = A5.ID
ORDER BY A1.ID

--	INNER JOIN - B
SELECT * 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A1.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A1.ID = A4.ID
INNER JOIN #TABELA_B A5 ON A1.ID = A5.ID
ORDER BY A1.ID


--	EXEMPLO 9 - ERRO: AMBIGUOUS COLUMN
SELECT ID 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A1.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A1.ID = A4.ID
LEFT JOIN #TABELA_B A5 ON A1.ID = A5.ID
ORDER BY A1.ID

/*
Msg 209, Level 16, State 1, Line 214
Ambiguous column name 'ID'.
*/

SELECT A1.ID 
FROM #TABELA_A A1
INNER JOIN #TABELA_A A2 ON A1.ID = A2.ID
INNER JOIN #TABELA_A A3 ON A1.ID = A3.ID
INNER JOIN #TABELA_A A4 ON A1.ID = A4.ID
LEFT JOIN #TABELA_B A5 ON A1.ID = A5.ID
ORDER BY A1.ID


--	EXEMPLO 10 - JOIN SEM UTILIZAR ALIAS - BAD PRACTICE
DROP TABLE IF EXISTS #TEMP_JOIN_ALIAS_1

CREATE TABLE #TEMP_JOIN_ALIAS_1 (
	ID INT NULL,
	NOME VARCHAR(100) NULL
)

INSERT INTO #TEMP_JOIN_ALIAS_1 VALUES(1, 'Luiz')
GO

DROP TABLE IF EXISTS #TEMP_JOIN_ALIAS_2

CREATE TABLE #TEMP_JOIN_ALIAS_2 (
	ID INT NULL,
	NOME VARCHAR(100) NULL
)
GO

INSERT INTO #TEMP_JOIN_ALIAS_2 VALUES(1, 'Vitor')
GO

SELECT * FROM #TEMP_JOIN_ALIAS_1
SELECT * FROM #TEMP_JOIN_ALIAS_2


--	TESTE 1:
SELECT A1.ID, NOME
FROM #TABELA_A A
INNER JOIN #TEMP_JOIN_ALIAS_1 A1 ON A1.ID = A.ID


--	TESTE 2:
SELECT A1.ID, NOME
FROM #TABELA_A A
INNER JOIN #TEMP_JOIN_ALIAS_1 A1 ON A1.ID = A.ID
INNER JOIN #TEMP_JOIN_ALIAS_2 A2 ON A1.ID = A2.ID

/*
Msg 209, Level 16, State 1, Line 269
Ambiguous column name 'NOME'.
*/


---------------------------------------------------------------------------------------------------------------
--	LEFT JOIN
---------------------------------------------------------------------------------------------------------------	
SELECT * FROM #TABELA_A 
SELECT * FROM #TABELA_B 
GO

--	EXEMPLO 1:
SELECT *
FROM #TABELA_A A
LEFT JOIN #TABELA_B B ON A.ID = B.ID

SELECT *
FROM #TABELA_B B
LEFT JOIN #TABELA_A A ON A.ID = B.ID


--	EXEMPLO 2:
--	A -> B
SELECT *
FROM #TABELA_A A
LEFT JOIN #TABELA_B B ON A.ID = B.ID
WHERE B.ID IS NULL

SELECT * FROM #TABELA_A
EXCEPT
SELECT * FROM #TABELA_B

--	B -> A
SELECT *
FROM #TABELA_B B
LEFT JOIN #TABELA_A A ON A.ID = B.ID
WHERE A.ID IS NULL

SELECT * FROM #TABELA_B
EXCEPT
SELECT * FROM #TABELA_A


---------------------------------------------------------------------------------------------------------------
--	RIGHT JOIN
---------------------------------------------------------------------------------------------------------------	
--	EXEMPLO 1: COMPARANDO OS JOINS - LEFT x RIGHT
SELECT *
FROM #TABELA_A A
LEFT JOIN #TABELA_B B ON A.ID = B.ID

SELECT *
FROM #TABELA_A A
RIGHT JOIN #TABELA_B B ON A.ID = B.ID


---------------------------------------------------------------------------------------------------------------
--	FULL JOIN
---------------------------------------------------------------------------------------------------------------	
SELECT * 
FROM #TABELA_A AS A
FULL OUTER JOIN #TABELA_B AS B ON A.ID = B.ID

SELECT * 
FROM #TABELA_B AS B
FULL OUTER JOIN #TABELA_A AS A ON A.ID = B.ID