---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRAN�A LIMA
--	BLOG: https://luizlima.net/

--	7 - Programa��o T-SQL
--	DEMO 7.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	COMENT�RIOS 
---------------------------------------------------------------------------------------------------------------				
--	Refer�ncias:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/comment-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/slash-star-comment-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	1) COMENT�RIO PARA UMA LINHA - USAR O "--"

--	2) COMENT�RIO PARA UM BLOCO DE LINHAS - USAR O "/* TEXTO */"

/*
ESSE
AQUI 
�
UM
COMENT�RIO 
EM 
BLOCO
*/

/*
SELECT 1

SELECT * FROM Cliente
*/

SELECT * FROM Cliente
GO


---------------------------------------------------------------------------------------------------------------
--	NOCOUNT 
---------------------------------------------------------------------------------------------------------------				
--	Refer�ncia:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/set-nocount-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXECUTAR O SELECT ABAIXO E CONFERIR A ABA "MESSAGES"
SELECT * FROM Cliente

/*
(6 rows affected)
*/

--	VERIFICA SE A OP��O "nocount" EST� HABILITADA
DBCC USEROPTIONS

--	HABILITAR
SET NOCOUNT ON

--	VALIDAR NOVAMENTE A OP��O "nocount"
DBCC USEROPTIONS

--	EXECUTAR NOVAMENTE O SELECT E CONFERIR A ABA "MESSAGES"
SELECT * FROM Cliente

/*
Commands completed successfully.
*/

--	DESABILITAR
SET NOCOUNT OFF
GO


---------------------------------------------------------------------------------------------------------------
--	ANSI_NULLS 
---------------------------------------------------------------------------------------------------------------				
--	Refer�ncia:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/set-ansi-nulls-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #TEMP_ANSI_NULLS

CREATE TABLE #TEMP_ANSI_NULLS (
	ID INT IDENTITY (1,1) NOT NULL,
	Nome VARCHAR(100) NULL
)

INSERT INTO #TEMP_ANSI_NULLS
VALUES ('Luiz'),('Vitor'),(NULL),(NULL)

SELECT * FROM #TEMP_ANSI_NULLS


--	VERIFICA SE A OP��O "ansi_nulls" EST� HABILITADA
DBCC USEROPTIONS

--	EXEMPLO 1 - ANSI_NULLS ON:

SET ANSI_NULLS ON

--	NULL =
SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome = NULL

SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome IS NULL

--	NULL <>
SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome <> NULL

SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome IS NOT NULL

SELECT *
FROM #TEMP_ANSI_NULLS AS T1
JOIN #TEMP_ANSI_NULLS AS T2 ON T1.Nome = T2.Nome


--	EXEMPLO 2 - ANSI_NULLS OFF:

SET ANSI_NULLS OFF

--	VERIFICA SE A OP��O "ansi_nulls" EST� HABILITADA
DBCC USEROPTIONS

--	NULL =
SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome = NULL

SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome IS NULL

--	NULL <>
SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome <> NULL

SELECT * 
FROM #TEMP_ANSI_NULLS
WHERE Nome IS NOT NULL

SELECT *
FROM #TEMP_ANSI_NULLS AS T1
JOIN #TEMP_ANSI_NULLS AS T2 ON T1.Nome = T2.Nome

--	VOLTA O VALOR DEFAULT
SET ANSI_NULLS ON


---------------------------------------------------------------------------------------------------------------
--	QUOTED_IDENTIFIER 
---------------------------------------------------------------------------------------------------------------				
--	Refer�ncias
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/set-quoted-identifier-transact-sql?view=sql-server-ver15
--	https://luizlima.net/dicas-t-sql-pra-que-serve-a-opcao-set-quoted-identifier-on/
---------------------------------------------------------------------------------------------------------------

DBCC USEROPTIONS

--	QUOTED_IDENTIFIER ON -> 
--	Quando est� habilitada, as strings devem utilizar apenas �aspas simples�.

SET QUOTED_IDENTIFIER ON
 
SELECT 'texto' AS "Aspas_Simples"

SELECT "texto" AS "Aspas_Duplas"

/*
Msg 207, Level 16, State 1, Line 154
Invalid column name 'texto'.
*/

GO

--	QUOTED_IDENTIFIER OFF -> 
--	Quando est� desabilitada, as strings podem utilizar �aspas duplas�.

SET QUOTED_IDENTIFIER OFF

SELECT 'texto' AS "Aspas_Simples"

SELECT "texto" AS "Aspas_Duplas"