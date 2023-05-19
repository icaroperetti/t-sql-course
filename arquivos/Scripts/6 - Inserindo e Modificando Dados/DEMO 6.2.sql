---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	6 - Inserindo e Modificando Dados
--	DEMO 6.2:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	UPDATE 
---------------------------------------------------------------------------------------------------------------				
--	Referência
--	https://docs.microsoft.com/pt-br/sql/t-sql/queries/update-transact-sql?view=sql-server-ver15
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

	
--	EXEMPLO 1 – UPDATE COM UMA TABELA APENAS:
SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE [dbo].[Cliente]
	SET 
		Nm_Cliente = 'Luiz Vitor França Lima',
		Vl_Salario = 3000.00
	WHERE Id_Cliente = 2

	SELECT * FROM [dbo].[Cliente]

ROLLBACK
GO


--	EXEMPLO 2 – INCREMENTANDO O VALOR DE UMA COLUNA

--	2.1) Vl_Salario = Vl_Salario * 1.1
SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE [dbo].[Cliente]
	SET Vl_Salario = Vl_Salario * 1.1	-- AUMENTO DE 10% DO SALÁRIO

	SELECT * FROM [dbo].[Cliente]

ROLLBACK
GO

--	2.2) Vl_Salario *= 1.1
SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE [dbo].[Cliente]
	SET Vl_Salario *=  1.1	-- AUMENTO DE 10% DO SALÁRIO

	SELECT * FROM [dbo].[Cliente]

ROLLBACK
GO

--	2.3) Vl_Salario += 500
SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE [dbo].[Cliente]
	SET Vl_Salario += 500	-- AUMENTO DE 500 REAIS

	SELECT * FROM [dbo].[Cliente]

ROLLBACK
GO


--	EXEMPLO 3 – UPDATE COM MAIS DE UMA TABELA (JOIN):
DROP TABLE IF EXISTS #TEMP_ATUALIZAR_CLIENTES
GO

CREATE TABLE #TEMP_ATUALIZAR_CLIENTES (
	Id_Cliente INT  NOT NULL,
	Ds_Observacao VARCHAR(200) NULL
)

--	INSERE O ID DOS CLIENTES QUE SERÃO ALTERADOS
INSERT INTO #TEMP_ATUALIZAR_CLIENTES (Id_Cliente, Ds_Observacao)
VALUES 	
	(1, 'Promovido em ' + CONVERT(VARCHAR(10), GETDATE(), 103) +  ' por superar as metas!'),
	(2, 'Promovido em ' + CONVERT(VARCHAR(10), GETDATE(), 103) +  ' por superar as metas!')
	
--	3.1) UTILIZANDO O JOIN PARA FILTRAR
SELECT * FROM #TEMP_ATUALIZAR_CLIENTES

SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE C
	SET C.Vl_Salario *=  1.1
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

	SELECT * FROM [dbo].[Cliente]

ROLLBACK


--	3.2) UTILIZANDO O JOIN PARA FILTRAR E USAR AS INFORMAÇÕES DA OUTRA TABELA

--	INCLUI UMA COLUNA "Ds_Observacao" NA TABELA CLIENTE
ALTER TABLE [dbo].[Cliente]
ADD Ds_Observacao VARCHAR(200) NULL

SELECT * FROM #TEMP_ATUALIZAR_CLIENTES

SELECT * FROM [dbo].[Cliente]

BEGIN TRAN
	UPDATE C
	SET 
		C.Vl_Salario *=  1.1,
		C.Ds_Observacao =  T.Ds_Observacao
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

	SELECT * FROM [dbo].[Cliente]

ROLLBACK


---------------------------------------------------------------------------------------------------------------
--	UPDATE - OUTPUT
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - RETORNA AS LINHAS QUE FORAM ATUALIZADAS:
SELECT * FROM #TEMP_ATUALIZAR_CLIENTES

BEGIN TRAN
	UPDATE C
	SET 
		C.Vl_Salario *=  1.1,
		C.Ds_Observacao =  T.Ds_Observacao
	OUTPUT
		deleted.Id_Cliente,
		deleted.Vl_Salario AS Vl_Salario_Antigo,
		inserted.Vl_Salario AS Vl_Salario_Novo,
		deleted.Ds_Observacao AS Ds_Observacao_Antigo,
		inserted.Ds_Observacao AS Ds_Observacao_Novo
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

ROLLBACK
GO


--	EXEMPLO 2 - ARMAZENA AS LINHAS QUE FORAM ATUALIZADAS:
DROP TABLE IF EXISTS #AUDIT_UPDATE
GO

CREATE TABLE #AUDIT_UPDATE (
	Id_Cliente INT NOT NULL,
	Vl_Salario_Antigo NUMERIC (9,2) NOT NULL,
	Vl_Salario_Novo NUMERIC (9,2) NOT NULL,
	Ds_Observacao_Antigo VARCHAR(200) NULL,
	Ds_Observacao_Novo VARCHAR(200) NULL
)

BEGIN TRAN
	UPDATE C
	SET 
		C.Vl_Salario *=  1.1,
		C.Ds_Observacao =  T.Ds_Observacao
	OUTPUT
		deleted.Id_Cliente,
		deleted.Vl_Salario AS Vl_Salario_Antigo,
		inserted.Vl_Salario AS Vl_Salario_Novo,
		deleted.Ds_Observacao AS Ds_Observacao_Antigo,
		inserted.Ds_Observacao AS Ds_Observacao_Novo
	INTO #AUDIT_UPDATE
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

	SELECT * FROM #AUDIT_UPDATE

ROLLBACK


--	EXCLUI A COLUNA "Ds_Observacao"
ALTER TABLE [dbo].[Cliente]
DROP COLUMN Ds_Observacao


---------------------------------------------------------------------------------------------------------------
--	DELETE 
---------------------------------------------------------------------------------------------------------------				
--	Referência
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/delete-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------				

DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Vl_Salario)
SELECT * 
FROM [dbo].[Cliente]


--	EXEMPLO 1 - DELETE USANDO O FROM:
SELECT * FROM #TEMP_CLIENTE

BEGIN TRAN
	DELETE FROM #TEMP_CLIENTE
	WHERE Nm_Cliente NOT LIKE '%Lima%'

	SELECT * FROM #TEMP_CLIENTE

ROLLBACK
GO


--	EXEMPLO 2 - DELETE SEM O FROM:
SELECT * FROM #TEMP_CLIENTE

BEGIN TRAN
	DELETE #TEMP_CLIENTE
	WHERE Nm_Cliente NOT LIKE '%Lima%'

	SELECT * FROM #TEMP_CLIENTE

ROLLBACK
GO


--	EXEMPLO 3 - DELETE COM JOIN:
SELECT * FROM #TEMP_ATUALIZAR_CLIENTES
SELECT * FROM #TEMP_CLIENTE

BEGIN TRAN
	DELETE C
	FROM #TEMP_CLIENTE AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS A ON C.Id_Cliente = A.Id_Cliente
	
	SELECT * FROM #TEMP_CLIENTE

ROLLBACK
GO


--	EXEMPLO 4 - DELETE COM TOP:
--	TOP
BEGIN TRAN
	SELECT * FROM #TEMP_CLIENTE

	DELETE TOP (2) 
	FROM #TEMP_CLIENTE

	SELECT * FROM #TEMP_CLIENTE

ROLLBACK
GO

--	TOP PERCENT
BEGIN TRAN
	SELECT * FROM #TEMP_CLIENTE

	DELETE TOP (50) PERCENT
	FROM #TEMP_CLIENTE

	SELECT * FROM #TEMP_CLIENTE

ROLLBACK
GO


--	EXEMPLO 5 - EXPURGO:

--	SELECIONA TODOS OS IDs QUE SERÃO EXCLUÍDOS!
DROP TABLE IF EXISTS #TEMP_EXPURGO
GO

SELECT Id_Cliente
INTO #TEMP_EXPURGO
FROM #TEMP_CLIENTE

SELECT * FROM #TEMP_EXPURGO

--	OBJETIVO: FAZER UM EXPURGO (EXCLUSÃO) DOS DADOS DA TABELA "#TEMP_CLIENTE".
BEGIN TRAN
	SELECT * FROM #TEMP_CLIENTE
	
	WHILE EXISTS(SELECT TOP 1 Id_Cliente FROM #TEMP_EXPURGO)
	BEGIN
		--	SEPARA AS LINHAS QUE SERÃO EXCLUÍDAS NESSA ITERAÇÃO
		DROP TABLE IF EXISTS #TEMP_LOOP

		SELECT TOP 1 Id_Cliente
		INTO #TEMP_LOOP 
		FROM #TEMP_EXPURGO

		--	EXCLUI OS REGISTROS DA TABELA PRINCIPAL
		DELETE C	
		FROM #TEMP_CLIENTE AS C
		JOIN #TEMP_LOOP AS L ON C.Id_Cliente = L.Id_Cliente

		--	EXCLUI OS REGISTROS QUE JÁ FORAM EXCLUÍDOS
		DELETE E
		FROM #TEMP_EXPURGO AS E
		JOIN #TEMP_LOOP AS L ON E.Id_Cliente = L.Id_Cliente
	
		-- UTILIZAR PARA GERAR UM INTERVALO ENTRE AS EXECUÇÕES, QUANDO GERAR MUITOS LOCKS
		-- WAITFOR DELAY '00:00:00.100'
	END
	
	SELECT * FROM #TEMP_CLIENTE
ROLLBACK
GO


---------------------------------------------------------------------------------------------------------------
--	DELETE - OUTPUT
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - RETORNA AS LINHAS QUE FORAM EXCLUÍDAS:
SELECT * FROM #TEMP_ATUALIZAR_CLIENTES

BEGIN TRAN
	SELECT * FROM [dbo].[Cliente]

	DELETE FROM C
	OUTPUT
		deleted.*
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

	SELECT * FROM [dbo].[Cliente]
ROLLBACK
GO


--	EXEMPLO 2 - ARMAZENA AS LINHAS QUE FORAM EXCLUÍDAS:
DROP TABLE IF EXISTS #AUDIT_DELETE
GO

CREATE TABLE #AUDIT_DELETE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL
)

BEGIN TRAN
	DELETE FROM C
	OUTPUT
		deleted.*
	INTO #AUDIT_DELETE
	FROM [dbo].[Cliente] AS C
	JOIN #TEMP_ATUALIZAR_CLIENTES AS T ON C.Id_Cliente = T.Id_Cliente

	SELECT * FROM #AUDIT_DELETE

ROLLBACK


---------------------------------------------------------------------------------------------------------------
--	TRUNCATE TABLE
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/truncate-table-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/relational-databases/partitions/create-partitioned-tables-and-indexes?view=sql-server-ver15
--	https://www.mssqltips.com/sqlservertip/1080/deleting-data-in-sql-server-with-truncate-vs-delete-commands/
--	https://blog.sqlauthority.com/2017/04/16/difference-truncate-delete-sql-server-interview-question-week-118/
--	https://blog.sqlauthority.com/2010/03/04/sql-server-rollback-truncate-command-in-transaction/

--	TRUNCATE TABLE -> DDL (DATA DEFINITION LANGUAGE)
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/statements?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------				

DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Vl_Salario)
SELECT * 
FROM [dbo].[Cliente]


--	EXEMPLO 1 - TRUNCATE TABLE:
BEGIN TRAN
	SELECT * FROM #TEMP_CLIENTE

	TRUNCATE TABLE #TEMP_CLIENTE

	SELECT * FROM #TEMP_CLIENTE
ROLLBACK

SELECT * FROM #TEMP_CLIENTE
GO


--	EXEMPLO 2 - TRUNCATE TABLE x WHERE:
TRUNCATE TABLE #TEMP_CLIENTE
WHERE Nm_Cliente LIKE '%Lima%'
GO

/*
Msg 156, Level 15, State 1, Line 405
Incorrect syntax near the keyword 'WHERE'.
*/


--	EXEMPLO 3 - TRUNCATE TABLE x IDENTITY:
DROP TABLE IF EXISTS #TEMP_IDENTITY
GO

CREATE TABLE #TEMP_IDENTITY (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL,
)

INSERT INTO #TEMP_IDENTITY (Nm_Cliente, Vl_Salario)
VALUES 
	('Fabrício Lima', 30000.00),
	('Luiz Lima', 1000.00)

SELECT * FROM #TEMP_IDENTITY

--	3.1) TRUNCATE
TRUNCATE TABLE #TEMP_IDENTITY

SELECT * FROM #TEMP_IDENTITY

INSERT INTO #TEMP_IDENTITY (Nm_Cliente, Vl_Salario)
VALUES 
	('Fabrício Lima', 30000.00),
	('Luiz Lima', 1000.00)

SELECT * FROM #TEMP_IDENTITY


--	3.2) DELETE
--	OBS: VALIDAR O INCREMENTO DO IDENTITY NA COLUNA "Id_Cliente"
SELECT * FROM #TEMP_IDENTITY

DELETE FROM #TEMP_IDENTITY

SELECT * FROM #TEMP_IDENTITY

INSERT INTO #TEMP_IDENTITY (Nm_Cliente, Vl_Salario)
VALUES 
	('Fabrício Lima', 30000.00),
	('Luiz Lima', 1000.00)

SELECT * FROM #TEMP_IDENTITY


--	EXEMPLO 4 - TRUNCATE TABLE x FOREIGN KEY:

--	CRIA AS TABELAS E A FOREIGN KEY:
DROP TABLE IF EXISTS [dbo].[Produto]
DROP TABLE IF EXISTS [dbo].[Tipo_Produto]
GO

CREATE TABLE [dbo].[Tipo_Produto] (
	Id_Tipo_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Tipo_Produto VARCHAR(100) NOT NULL,
	CONSTRAINT [PK_Tipo_Produto] PRIMARY KEY (Id_Tipo_Produto)
)

INSERT INTO [dbo].[Tipo_Produto]
VALUES('Celular'),('Video Game')

SELECT * FROM [dbo].[Tipo_Produto]

CREATE TABLE [dbo].[Produto] (
	Id_Produto INT IDENTITY(1,1) NOT NULL,
	Nm_Produto VARCHAR(100) NOT NULL,
	Id_Tipo_Produto INT NOT NULL,	
	CONSTRAINT [PK_Produto] PRIMARY KEY (Id_Produto)
)

--	ADICIONA A FOREIGN KEY
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

--	ADICIONA ALGUNS PRODUTOS
INSERT INTO [dbo].[Produto]
VALUES
	('Samsung Galaxy', 1),('Iphone', 1),
	('Playstation', 2),('Xbox', 2)

-- OBS: "ALT + F1" PARA MOSTRAR A FOREIGN KEY NAS DUAS TABELAS!
SELECT * FROM [dbo].[Produto]


--	4.1) TENTA FAZER O TRUNCATE NA TABELA QUE É REFERENCIADA PELO FOREIGN KEY
TRUNCATE TABLE [Tipo_Produto]

/*
Msg 4712, Level 16, State 1, Line 498
Cannot truncate table 'Tipo_Produto' because it is being referenced by a FOREIGN KEY constraint.
*/

--	TAMBÉM NÃO CONSEGUE FAZER O DELETE DE UM REGISTRO QUE É REFERENCIADO EM OUTRA TABELA!
DELETE FROM Tipo_Produto
WHERE Id_Tipo_Produto = 1

/*
Msg 547, Level 16, State 0, Line 515
The DELETE statement conflicted with the REFERENCE constraint "FK_Tipo_Produto". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Produto", column 'Id_Tipo_Produto'.
The statement has been terminated.
*/

SELECT * FROM [dbo].[Tipo_Produto]
SELECT * FROM [dbo].[Produto]


--	4.2) REMOVE A CONSTRAINT PARA CONSEGUIR FAZER O TRUNCATE

--	REMOVE A CONSTRAINT
ALTER TABLE [dbo].[Produto]
DROP CONSTRAINT FK_Tipo_Produto

--	FAZ O TRUNCATE NA TABELA
TRUNCATE TABLE [Tipo_Produto]

SELECT * FROM [dbo].[Tipo_Produto]
SELECT * FROM [dbo].[Produto]


--	TENTA ADICIONAR A FOREIGN KEY NOVAMENTE
ALTER TABLE [dbo].[Produto]
ADD CONSTRAINT [FK_Tipo_Produto]
FOREIGN KEY ([Id_Tipo_Produto])
REFERENCES [Tipo_Produto] ([Id_Tipo_Produto])

/*
Msg 547, Level 16, State 0, Line 557
The ALTER TABLE statement conflicted with the FOREIGN KEY constraint "FK_Tipo_Produto". 
The conflict occurred in database "Treinamento_TSQL", table "dbo.Tipo_Produto", column 'Id_Tipo_Produto'.
*/

SELECT * FROM [dbo].[Tipo_Produto]
SELECT * FROM [dbo].[Produto]


---------------------------------------------------------------------------------------------------------------
--	MERGE
---------------------------------------------------------------------------------------------------------------	
--	COMANDO UM POUCO MAIS AVANÇADO!

--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/merge-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-como-utilizar-o-comando-merge-para-inserir-atualizar-e-apagar-dados-com-apenas-1-comando/
---------------------------------------------------------------------------------------------------------------	