--------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	4 - Estrutura de uma Query
--	DEMO 4.4:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

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

SELECT * FROM [dbo].[Cliente]

---------------------------------------------------------------------------------------------------------------
--	SUBQUERY
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/performance/subqueries?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DECLARE @Vl_Total NUMERIC(9,2)

SELECT @Vl_Total = (
	SELECT SUM(Vl_Venda)
	FROM Vendas
)

SELECT @Vl_Total AS Vl_Total
GO


--	EXEMPLO 1.1 - RETORNANDO MAIS DE UM RESULTADO:
DECLARE @Vl_Total NUMERIC(9,2)

SELECT @Vl_Total = (
	SELECT Vl_Venda
	FROM Vendas
)

SELECT @Vl_Total AS Vl_Total
GO

/*
Msg 512, Level 16, State 1, Line 30
Subquery returned more than 1 value. This is not permitted when the 
subquery follows =, !=, <, <= , >, >= or when the subquery is used as an expression.
*/


--	EXEMPLO 2:
SELECT A.*
FROM (
	SELECT *
	FROM Cliente
) AS A

-- SEM ALIAS
SELECT *
FROM (
	SELECT *
	FROM Cliente
) 

/*
Msg 102, Level 15, State 1, Line 80
Incorrect syntax near ')'.

*/
GO


--	EXEMPLO 3:
SELECT 
	Id_Cliente,
	Nm_Cliente,
	Dt_Nascimento,

	--	SUBQUERY
	(
		SELECT SUM(Vl_Venda)
		FROM Vendas V
		WHERE V.Id_Cliente = C.Id_Cliente
	) AS Vl_Total
FROM Cliente C


--	EXEMPLO 3.1 - QUAL A DIFERENÇA COM O COMANDO ANTERIOR???
SELECT 
	Id_Cliente,
	Nm_Cliente,
	Dt_Nascimento,

	--	SUBQUERY
	(
		SELECT SUM(Vl_Venda)
		FROM Vendas V
	) AS Vl_Total
FROM Cliente C


--	EXEMPLO 4 - SUBQUERY x IN:
SELECT 
	Id_Cliente,
	Nm_Cliente,
	Dt_Nascimento	
FROM Cliente C
WHERE
	Id_Cliente IN (
		--	SUBQUERY
		SELECT DISTINCT V.Id_Cliente
		FROM Vendas V		
	)

	
---------------------------------------------------------------------------------------------------------------
--	EXISTS:
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/exists-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

select * from Cliente

--	EXEMPLO 1 - IF EXISTS:
DECLARE @Nm_Cliente VARCHAR(100) = 'Luiz Lima'
--DECLARE @Nm_Cliente VARCHAR(100) = 'Luiz Vitor'

IF EXISTS (SELECT TOP 1 Id_Cliente FROM Cliente WHERE Nm_Cliente = @Nm_Cliente)
BEGIN
	SELECT 'EXISTE UM USUÁRIO COM O NOME: "' + @Nm_Cliente + '"!' 
END
ELSE
BEGIN
	SELECT 'NÃO EXISTE UM USUÁRIO COM O NOME: "' + @Nm_Cliente + '"!' 
END
GO

--	EXEMPLO 1.1:
--	VAI RETORNAR ALGUMA COISA OU DAR ERRO???
IF EXISTS(SELECT 1)
BEGIN
	SELECT 111111
END

GO

IF EXISTS(1)
BEGIN
	SELECT 111111
END

GO

--	EXEMPLO 2 - WHERE EXISTS:
--	RETORNAR APENAS OS CLIENTES QUE POSSUEM ALGUMAS VENDAS!
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	EXISTS (SELECT TOP 1 Id_Venda FROM Vendas V WHERE C.Id_Cliente = V.Id_Cliente)

--	RETORNAR APENAS OS CLIENTES QUE NÃO POSSUEM ALGUMAS VENDAS!
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	NOT EXISTS (SELECT TOP 1 Id_Venda FROM Vendas V WHERE C.Id_Cliente = V.Id_Cliente)
GO


--	EXEMPLO 3 - NOT IN x NOT EXISTS:
DROP TABLE IF EXISTS #TEMP_VENDAS
GO

CREATE TABLE #TEMP_VENDAS (
	Id_Venda INT IDENTITY(1,1) NOT NULL,	
	Id_Cliente INT NULL,	
	Dt_Venda DATE NOT NULL,
	Vl_Venda NUMERIC(9,2) NOT NULL
)

INSERT INTO #TEMP_VENDAS (Id_Cliente, Dt_Venda, Vl_Venda)
VALUES
	(1, '20210506', 100.00),
	(1, '20210610', 250.00),
	(2, '20210701', 500.00),
	(2, '20210715', 300.00),
	(NULL, '20210720', 1000.00)

SELECT * FROM #TEMP_VENDAS

--	IN x EXISTS - TUDO OK ATE AQUI.
--	TESTE 1:
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	EXISTS (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS V WHERE C.Id_Cliente = V.Id_Cliente)

SELECT * 
FROM [dbo].[Cliente] C
WHERE
	Id_Cliente IN (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS)


--	NOT IN x NOT EXISTS - COLUNA "Id_Cliente" ACEITA VALORES "NULL".
--	TESTE 1:
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	NOT EXISTS (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS V WHERE C.Id_Cliente = V.Id_Cliente)

SELECT * 
FROM [dbo].[Cliente] C
WHERE
	Id_Cliente NOT IN (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS)


--	TESTE 1.1:
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	NOT EXISTS (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS V WHERE C.Id_Cliente = V.Id_Cliente)

SELECT * 
FROM [dbo].[Cliente] C
WHERE
	Id_Cliente NOT IN (SELECT DISTINCT ISNULL(Id_Cliente,0) FROM #TEMP_VENDAS)

--	TESTE 1.2:
SELECT * 
FROM [dbo].[Cliente] C
WHERE
	NOT EXISTS (SELECT DISTINCT Id_Cliente FROM #TEMP_VENDAS V WHERE C.Id_Cliente = V.Id_Cliente)

SELECT * 
FROM [dbo].[Cliente] C
WHERE
	Id_Cliente NOT IN (SELECT DISTINCT V.Id_Cliente FROM #TEMP_VENDAS V WHERE V.Id_Cliente IS NOT NULL)


---------------------------------------------------------------------------------------------------------------
--	CTE (COMMON TABLE EXPRESSION)
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/queries/with-common-table-expression-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-como-criar-consultas-recursivas-com-a-cte-common-table-expressions/
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
;WITH CTE_LUIZ AS (
	SELECT * FROM Cliente
)

SELECT * 
FROM CTE_LUIZ
GO


--	EXEMPLO 2 - COMANDOS INTERMEDIÁRIOS:
;WITH CTE_LUIZ AS (
	SELECT * FROM Cliente
)

SELECT 1

SELECT * 
FROM CTE_LUIZ
GO

/*
Msg 422, Level 16, State 4, Line 179
Common table expression defined but not used.
*/


--	EXEMPLO 3 - CUIDADO COM O COMANDO ANTERIOR
--	ERRADO
SELECT 1

WITH CTE_LUIZ AS (
	SELECT * FROM Cliente
)

SELECT * 
FROM CTE_LUIZ
GO

/*
Msg 319, Level 15, State 1, Line 258
Incorrect syntax near the keyword 'with'. If this statement is a common table expression, 
an xmlnamespaces clause or a change tracking context clause, 
the previous statement must be terminated with a semicolon.
*/

-- CORRETO: USAR O ";" (PONTO E VIRGULA)
SELECT 1

;WITH CTE_LUIZ AS (
	SELECT * FROM Cliente
)

SELECT * 
FROM CTE_LUIZ
GO


--	EXEMPLO 4 - UTILIZANDO VARIAS CTEs

;WITH CTE_CLIENTE AS (		-- CTE 1
	SELECT * FROM Cliente
),
CTE_VENDAS AS (				-- CTE 2
	SELECT V.* 
	FROM Vendas V
	JOIN CTE_CLIENTE C ON C.Id_Cliente = V.Id_Cliente
),
CTE_VENDAS_TOP10 AS (		-- CTE 3
	SELECT TOP 10 * 
	FROM CTE_VENDAS
	ORDER BY Vl_Venda DESC	
)

SELECT * 
FROM CTE_VENDAS_TOP10;
GO


--	EXEMPLO 5 - CTE RECURSIVA
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

--	CTE RECURSIVA
;WITH CTE_RECURSIVA AS (
	-- NIVEL ANCORA
	SELECT F.*
	FROM Funcionario F
	WHERE Id_Gerente IS NULL

	UNION ALL

	-- DEMAIS NIVEIS
	SELECT F.*
	FROM Funcionario F
	JOIN CTE_RECURSIVA CTE ON F.Id_Gerente = CTE.Id_Funcionario
)
SELECT * FROM CTE_RECURSIVA


--	CTE RECURSIVA - USANDO SOMENTE O "UNION"
;WITH CTE_RECURSIVA AS (
	-- NIVEL ANCORA
	SELECT F.*
	FROM Funcionario F
	WHERE Id_Gerente IS NULL

	UNION 

	-- DEMAIS NIVEIS
	SELECT F.*
	FROM Funcionario F
	JOIN CTE_RECURSIVA CTE ON F.Id_Gerente = CTE.Id_Funcionario
)
SELECT * FROM CTE_RECURSIVA

/*
Msg 252, Level 16, State 1, Line 352
Recursive common table expression 'CTE_RECURSIVA' does not contain a top-level UNION ALL operator.
*/


---------------------------------------------------------------------------------------------------------------
--	CROSS APPLY / OUTER APPLY
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/queries/from-transact-sql?view=sql-server-ver15#using-apply
--	https://www.youtube.com/watch?v=M9a5Rr9ef_Y
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - APLLY x INLINE TABLE-VALUED FUNCTION (TVF): 
DROP FUNCTION IF EXISTS [dbo].[fncRetornaVendasCliente]
GO
CREATE FUNCTION [dbo].[fncRetornaVendasCliente] (
	@Id_Cliente INT
)
RETURNS TABLE
AS
RETURN
	SELECT * 
	FROM Vendas
	WHERE Id_Cliente = @Id_Cliente
GO

SELECT *
FROM [dbo].[fncRetornaVendasCliente](1)

SELECT *
FROM [dbo].[fncRetornaVendasCliente](2)


--	"INLINE TVF" x INNER JOIN
SELECT *
FROM [dbo].[Cliente] C
INNER JOIN [dbo].[fncRetornaVendasCliente](C.Id_Cliente) V

/*
Msg 102, Level 15, State 1, Line 399
Incorrect syntax near 'V'.
*/
GO


--	OBS: A TABELA CLIENTE POSSUI 5 CLIENTES
SELECT * FROM [dbo].[Cliente] C

--	"INLINE TVF" x CROSS APPLY - RETORNA APENAS OS CLIENTE COM VENDAS (SEMELHANTE AO INNER JOIN)
SELECT *
FROM [dbo].[Cliente] C
CROSS APPLY [dbo].[fncRetornaVendasCliente](Id_Cliente) V
--WHERE V.Vl_Venda > 500
ORDER BY C.Id_Cliente, V.Id_Venda


--	"INLINE TVF" x OUTER APPLY - RETORNA TODOS OS CLIENTES, COM OU SEM VENDAS (SEMELHANTE AO LEFT JOIN)
SELECT *
FROM [dbo].[Cliente] C
OUTER APPLY [dbo].[fncRetornaVendasCliente](Id_Cliente) V
--WHERE V.Vl_Venda > 500
ORDER BY C.Id_Cliente, V.Id_Venda


--	EXEMPLO 2 - APLLY x SUBQUERY: 
--	SUBQUERY
SELECT *
FROM [dbo].[Cliente] C
JOIN (
	SELECT * 
	FROM Vendas V
	WHERE V.Id_Cliente = C.Id_Cliente
) V
ORDER BY C.Id_Cliente, V.Id_Venda
GO
/*
Msg 156, Level 15, State 1, Line 433
Incorrect syntax near the keyword 'ORDER'.
*/

--	SUBQUERY x CROSS APPLY
SELECT *
FROM [dbo].[Cliente] C
CROSS APPLY (
	SELECT * 
	FROM Vendas V
	WHERE V.Id_Cliente = C.Id_Cliente
) V
ORDER BY C.Id_Cliente, V.Id_Venda


--	SUBQUERY x OUTER APPLY
SELECT *
FROM [dbo].[Cliente] C
OUTER APPLY (
	SELECT * 
	FROM Vendas V
	WHERE V.Id_Cliente = C.Id_Cliente
) V
ORDER BY C.Id_Cliente, V.Id_Venda


---------------------------------------------------------------------------------------------------------------
--	OPERADOR LIKE
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/like-transact-sql?view=sql-server-ver15
--	https://luizlima.net/dicas-t-sql-pesquisar-texto-qual-a-diferenca-entre-like-_texto-e-_texto/
--	https://www.fabriciolima.net/blog/2017/02/06/video-melhorando-a-performance-de-uma-consulta-com-like-string-alterando-a-collation/
---------------------------------------------------------------------------------------------------------------
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

SELECT * FROM [dbo].[Cliente]

--	CRIA UM ÍNDICE PARA AJUDAR NO DESEMPENHO
DROP INDEX IF EXISTS [Cliente].[SK01_Cliente]

CREATE NONCLUSTERED INDEX SK01_Cliente
ON [Cliente] (Nm_Cliente, Dt_Nascimento)


--	EXEMPLO 1:
--	HABILITAR O PLANO DE EXECUÇÃO

--	INICIO - 'TEXTO%' - "INDEX SEEK"
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE 'Luiz%'

--	QUALQUER LUGAR - '%TEXTO%' - "INDEX SCAN"
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%Luiz%'

--	FIM - '%TEXTO' - "INDEX SCAN"
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%Lima'

--	TAMANHO FIXO
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE 'Luiz Lima'

SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'


--	EXEMPLO 2 - "_" UNDERSCORE WILDCARD (CURINGA):
SELECT * FROM [dbo].[Cliente]

SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '_a%'

SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%m_'


--	EXEMPLO 2.1 - "_" UNDERSCORE CARACTERE:
DROP TABLE IF EXISTS #TEMP_LIKE_UNDERSCORE
GO

CREATE TABLE #TEMP_LIKE_UNDERSCORE (
	Nm_Cliente VARCHAR(100) NOT NULL
)

INSERT INTO #TEMP_LIKE_UNDERSCORE (Nm_Cliente)
VALUES
	('Fabrício Lima'),
	('Luiz_Lima'),
	('Fabiano_Amorim'),
	('Dirceu Resende')

SELECT * FROM #TEMP_LIKE_UNDERSCORE

SELECT Nm_Cliente
FROM #TEMP_LIKE_UNDERSCORE
WHERE Nm_Cliente LIKE '%_%'

SELECT Nm_Cliente
FROM #TEMP_LIKE_UNDERSCORE
WHERE Nm_Cliente LIKE '%[_]%'


--	EXEMPLO 3 - LISTA DE CARACTERES:
SELECT * FROM [dbo].[Cliente]

SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '[D,R]%'

SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%[M,E]'

SELECT *
FROM Cliente
WHERE Nm_Cliente LIKE '[A-F]%'
ORDER BY Nm_Cliente
 
SELECT *
FROM Cliente
WHERE Nm_Cliente LIKE '[^A-F]%'
ORDER BY Nm_Cliente


--	EXEMPLO 4 - NOT LIKE
SELECT *
FROM Cliente
WHERE Nm_Cliente NOT LIKE '%Lima%'
ORDER BY Nm_Cliente
GO


---------------------------------------------------------------------------------------------------------------
--	PIVOT / UNPIVOT
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-ver15
--	https://www.devmedia.com.br/pivot-no-sql-server-invertendo-linhas-e-colunas-em-um-exemplo-real/28318
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - PIVOT:
--	SUBQUERY DO PIVOT
SELECT YEAR(Dt_Venda) AS Ano, Vl_Venda
FROM Vendas
ORDER BY Ano

--	PIVOT
DROP TABLE IF EXISTS #TEMP_PIVOT
GO

SELECT *
INTO #TEMP_PIVOT
FROM (
	SELECT YEAR(Dt_Venda) AS Ano, Vl_Venda
	FROM Vendas
) AS T
PIVOT (SUM(Vl_Venda) FOR Ano IN ([2018], [2019], [2020], [2021])) AS Vl_Total

--	CONFERE O RESULTADO:
SELECT * FROM #TEMP_PIVOT


--	EXEMPLO 2 - UNPIVOT:
--	SUBQUERY DO UNPIVOT
SELECT [2018], [2019], [2020], [2021] FROM #TEMP_PIVOT

--	UNPIVOT
SELECT Ano, Vl_Total 
FROM (
	SELECT [2018], [2019], [2020], [2021] FROM #TEMP_PIVOT
) AS T
UNPIVOT (Vl_Total FOR Ano IN ([2018], [2019], [2020], [2021])) AS Vl_Total


--	EXEMPLO 3 - UNPIVOT - SEM ESPECIFICAR ALGUMAS COLUNAS (2018 E 2019):
--	SUBQUERY DO UNPIVOT
SELECT [2018], [2019], [2020], [2021] FROM #TEMP_PIVOT

--	UNPIVOT
SELECT Ano, Vl_Total 
FROM (
	SELECT [2018], [2019], [2020], [2021] FROM #TEMP_PIVOT
) AS T
UNPIVOT (Vl_Total FOR Ano IN ([2020], [2021])) AS Vl_Total


--	SOLUÇÃO: QUANDO TIVER MUITAS COLUNAS, UTILIZAR UM PIVOT COM CÓDIGO DINÂMICO!
--	https://www.devmedia.com.br/pivot-no-sql-server-invertendo-linhas-e-colunas-em-um-exemplo-real/28318


---------------------------------------------------------------------------------------------------------------
--	LINKED SERVER
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/linked-servers/linked-servers-database-engine?view=sql-server-ver15
--	https://www.linkedin.com/pulse/open-query-vs-linked-server-leon-gordon/
--	https://imasters.com.br/data/linked-server-pra-que-serve-e-quando-utilizar
--	https://www.sqlshack.com/querying-remote-data-sources-in-sql-server/
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
--	EXECUTAR NA INSTÂNCIA "[HPSPECTRE\SQL2019]"
SELECT * 
FROM [HPSPECTRE\SQL2017].[Traces].[dbo].[Cliente]

/*
Msg 7202, Level 11, State 2, Line 181
Could not find server 'HPSPECTRE\SQL2017' in sys.servers. 
Verify that the correct server name was specified. 
If necessary, execute the stored procedure sp_addlinkedserver to add the server to sys.servers.
*/


--	1) VALIDAR SE A INSTANCIA "HPSPECTRE\SQL2017" ESTÁ ATIVA.
--	2) CRIAR UM LINKED SERVER PARA A INSTANCIA "HPSPECTRE\SQL2017".
--		UTILIZAR O USUARIO "LS_User" (Senha: LS_User)

SELECT * 
FROM [HPSPECTRE\SQL2017].[Traces].[dbo].[Cliente]

SELECT * 
FROM [HPSPECTRE\SQL2017].[Traces].[dbo].[Cliente]
WHERE Nm_Cliente = 'Luiz Lima'



---------------------------------------------------------------------------------------------------------------
--	OPENQUERY
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/openquery-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
--	EXECUTAR NA INSTÂNCIA "[HPSPECTRE\SQL2019]"
SELECT *
FROM OPENQUERY ([HPSPECTRE\SQL2017], 'SELECT * FROM .[Traces].[dbo].[Cliente]')  

SELECT *
FROM OPENQUERY ([HPSPECTRE\SQL2017], 'SELECT * FROM .[Traces].[dbo].[Cliente] WHERE Nm_Cliente = 'Luiz Lima'')  

/*
Msg 102, Level 15, State 1, Line 498
Incorrect syntax near 'Luiz'.
*/

SELECT *
FROM OPENQUERY ([HPSPECTRE\SQL2017], 'SELECT * FROM .[Traces].[dbo].[Cliente] WHERE Nm_Cliente = ''Luiz Lima''')  