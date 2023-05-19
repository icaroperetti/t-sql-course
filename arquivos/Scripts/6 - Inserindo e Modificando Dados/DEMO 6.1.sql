---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRAN�A LIMA
--	BLOG: https://luizlima.net/

--	6 - Inserindo e Modificando Dados
--	DEMO 6.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	CONTROLE DE TRANSA��O
---------------------------------------------------------------------------------------------------------------
--	Refer�ncias:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/transactions-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/begin-transaction-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/set-transaction-isolation-level-transact-sql?view=sql-server-ver15

--	COMMIT:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/commit-transaction-transact-sql?view=sql-server-ver15

--	ROLLBACK:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/rollback-transaction-transact-sql?view=sql-server-ver15

--	OUTROS:
--	https://www.sqlshack.com/how-to-rollback-using-explicit-sql-server-transactions/
--	https://diegonogare.net/2013/01/transaction-isolation-level-voc-est-usando-certo/
--	https://www.tiagoneves.net/blog/isolation-level-no-sql-server/
---------------------------------------------------------------------------------------------------------------

/*
--	Transa��o:

-> � uma "unit of work" (unidade de trabalho) que pode incluir v�rias consultas ou modifica��es no banco de dados.

Possui quatro propriedades (ACID):
	Atomicidade:	Unidade de trabalho at�mica -> "ou faz tudo, ou n�o faz nada".
	Consist�ncia:	Uma transa��o deve utilizar sempre dados consistentes. 
					Se o dado estiver sendo alterado, ir� esperar a 
					outra transa��o finalizar para depois utilizar o dado.
	Isolamento:		Uma transa��o n�o pode interferir em outra enquanto est� em atividade. 
					Aqui podemos ter o n�vel de isolamento que utiliza o "Row Versioning" para evitar locks.
	Durabilidade:	Garante que os dados ser�o persistidos no banco de dados.
*/

DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL
)

--	INSERINDO V�RIOS REGISTROS NA TABELA
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES 	
	('Fabr�cio Lima', '19800106'),
	('Luiz Lima', '19890922'),
	('Fabiano Amorim', '19620927'),
	('Dirceu Resende', '19740516'),
	('Rodrigo Ribeiro', '19500108')
	
SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 1 - UPDATE COM TRANSA��O EXPL�CITA:

--	1.1) ABRIR UMA NOVA QUERY E EXECUTAR O UPDATE ABAIXO
BEGIN TRAN
	--	"UPDATE SEM WHERE"
	UPDATE [dbo].[Cliente]
	SET Dt_Nascimento = '19800101'
	--WHERE Nm_Cliente = 'Luiz Lima'

	SELECT * FROM [dbo].[Cliente]
	
	-- ROLLBACK


--	1.2) ABRIR UMA NOVA QUERY E EXECUTAR O SELECT ABAIXO:
SELECT * FROM [dbo].[Cliente]

--	1.3) ABRIR UMA NOVA QUERY E EXECUTAR O SELECT ABAIXO:
SELECT * FROM [dbo].[Cliente] WITH(NOLOCK)

SELECT * FROM [dbo].[Cliente] (NOLOCK)

--	1.4) EXECUTAR A PROCEDURE "SP_WHOISACTIVE" PARA VERIFICAR O LOCK!
EXEC sp_whoisactive

--	1.5) EXECUTAR O ROLLBACK NA QUERY DO ITEM (1.1) E DEPOIS EXECUTAR O UPDATE ABAIXO
BEGIN TRAN
	--	"UPDATE COM WHERE"
	UPDATE [dbo].[Cliente]
	SET Dt_Nascimento = '19800101'
	WHERE Nm_Cliente = 'Luiz Lima'

COMMIT

SELECT * FROM [dbo].[Cliente]
GO


--	EXEMPLO 2 - UPDATE COM TRANSA��O IMPL�CITA:
--	OBS: EXPLICAR A DIFEREN�A PARA O CASO ANTERIOR!

UPDATE [dbo].[Cliente]
SET Dt_Nascimento = '19890922'
WHERE Nm_Cliente = 'Luiz Lima'

ROLLBACK

/*
Msg 3903, Level 16, State 1, Line 110
The ROLLBACK TRANSACTION request has no corresponding BEGIN TRANSACTION.
*/

SELECT * FROM [dbo].[Cliente]
GO


---------------------------------------------------------------------------------------------------------------
--	INSERT 
---------------------------------------------------------------------------------------------------------------				
--	Refer�ncia
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/insert-transact-sql
---------------------------------------------------------------------------------------------------------------				

---------------------------------------------------------------------------------------------------------------
--	INSERT VALUES
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL
)

--	EXEMPLO 1: INSERINDO UM REGISTRO APENAS
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES 	('Fabr�cio Lima', '19800106')


--	EXEMPLO 2: INSERINDO MAIS DE UM REGISTRO
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES
	('Luiz Lima', '19890922'),
	('Fabiano Amorim', '19620927')
	
	
--	EXEMPLO 3: INSERINDO COLUNAS DIFERENTE DA ORDEM DA DEFINI��O DA TABELA (ALT + F1)
INSERT INTO [dbo].[Cliente] (Dt_Nascimento, Nm_Cliente)
VALUES ('19740516', 'Dirceu Resende')

--	VALIDA OS DADOS INSERIDOS NA TABELA CLIENTE:
SELECT * FROM [dbo].[Cliente]

--	EXEMPLO 4: INSERINDO SEM ESPECIFICAR O NOME DAS COLUNAS
INSERT INTO [dbo].[Cliente]
VALUES ('Rodrigo Ribeiro', '19500108')


--	VALIDA OS DADOS INSERIDOS NA TABELA CLIENTE:
SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 5: CUIDADO COM COLUNAS "NULL" E "NOT NULL"
--	OBS 1: "ALT + F1" E MOSTRAR QUE A COLUNA "DT_NASCIMENTO" N�O ACEITA VALORES "NULL"!
--	OBS 2: EXECUTAR O INSERT MAIS DE UMA VEZ PARA COMENTAR O COMPORTAMENTO DO IDENTITY!
INSERT INTO [dbo].[Cliente]
VALUES ('Gustavo Larocca', NULL)

/*
Msg 515, Level 16, State 2, Line 51
Cannot insert the value NULL into column 'Dt_Nascimento', 
table 'Treinamento_TSQL.dbo.Cliente'; column does not allow nulls. INSERT fails.
*/

--	VALIDA OS DADOS INSERIDOS NA TABELA CLIENTE:
SELECT * FROM [dbo].[Cliente]


--	ALTERA A COLUNA "DT_NASCIMENTO" PARA ACEITAR VALORES "NULL"
ALTER TABLE [dbo].[Cliente]
ALTER COLUMN Dt_Nascimento DATE NULL


--	TENTAR INSERIR NOVAMENTE UM VALOR "NULL" NA TABELA
--	OBS: "ALT + F1" E MOSTRAR QUE A COLUNA "DT_NASCIMENTO" ACEITA VALORES "NULL"!
INSERT INTO [dbo].[Cliente]
VALUES ('Gustavo Larocca', NULL)

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 6: INSERT COM QUANTIDADE DE COLUNAS INCORRETA
INSERT INTO [dbo].[Cliente]
VALUES ('Raiane Flores')

SELECT * FROM [dbo].[Cliente]

/*
Msg 213, Level 16, State 1, Line 80
Column name or number of supplied values does not match table definition.
*/


--	N�O ESPECIFICANDO UM VALOR PARA A COLUNA "DT_NASCIMENTO" (NULL).
INSERT INTO [dbo].[Cliente](Nm_Cliente)
VALUES ('Raiane Flores')

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 7: INSERT COM TIPOS DE DADOS INCORRETOS
INSERT INTO [dbo].[Cliente] (Dt_Nascimento, Nm_Cliente)
VALUES ('Eduardo Roedel', '19800125')

/*
Msg 241, Level 16, State 1, Line 98
Conversion failed when converting date and/or time from character string.
*/

SELECT * FROM [dbo].[Cliente]


--	EXEMPLO 8: INSERT COM ERRO EM UMA LINHA APENAS -> NENHUMA LINHA SER� INSERIDA!
--	OBS: ESSE INSERT FUNCIONA COMO UMA TRANSA��O �NICA, OU FAZ TUDO OU N�O FAZ NADA!
INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento)
VALUES 
	('Eduardo Roedel', '19800125'),
	('19800125', 'Eduardo Roedel 1'),
	('19800125', 'Eduardo Roedel 2'),
	('19800125', 'Eduardo Roedel 3')

/*
Msg 241, Level 16, State 1, Line 111
Conversion failed when converting date and/or time from character string.
*/
GO

SELECT * FROM [dbo].[Cliente]


---------------------------------------------------------------------------------------------------------------
--	INSERT SELECT
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)

--	EXEMPLO 1 - ESPECIFICANDO AS COLUNAS:
INSERT INTO #TEMP_CLIENTE (Nm_Cliente, Dt_Nascimento)
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE


--	EXEMPLO 2 - N�O ESPECIFICANDO AS COLUNAS:
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE


--	EXEMPLO 3 - TENTANDO INSERIR EM UMA COLUNA IDENTITY
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE
SELECT *
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE

/*
Msg 8101, Level 16, State 1, Line 161
An explicit value for the identity column in table '#TEMP_CLIENTE' 
can only be specified when a column list is used and IDENTITY_INSERT is ON.
*/


--	EXEMPLO 4 - IGNORANDO O "ALIAS" DO SELECT
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE (Nm_Cliente, Dt_Nascimento)
SELECT Nm_Cliente AS [Nome Cliente], Dt_Nascimento AS [Data de Nascimento]
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE
GO


--	EXEMPLO 5 - UTILIZANDO UMA SYSTEM FUNCTION x FUNCTION

--	CRIA UMA TABELA TEMPOR�RIA
DROP TABLE IF EXISTS #TEMP_FUNCTION
GO

CREATE TABLE #TEMP_FUNCTION (
	ID INT IDENTITY(1,1) NOT NULL,
	VALOR INT NOT NULL
)

SET NOCOUNT ON
GO

--	POPULA A TABELA TEMPOR�RIA - EXECUTAR 2 OU 3 VEZES! 
INSERT INTO #TEMP_FUNCTION (VALOR)
VALUES (1)
GO 10000

GO
SET NOCOUNT OFF
GO

SELECT COUNT(*) FROM #TEMP_FUNCTION

SELECT TOP 10 * FROM #TEMP_FUNCTION


--	5.1) EXECUTA COM O GETDATE()
--	OBS: O "GETDATE()" VAI SER EXECUTADO APENAS UMA VEZ PARA A QUERY INTEIRA!
SELECT ID, VALOR, GETDATE()
FROM #TEMP_FUNCTION


--	5.2) USANDO FUNCTION
GO
DROP FUNCTION IF EXISTS fncDataAtual
GO
CREATE FUNCTION dbo.fncDataAtual()
RETURNS DATETIME
AS
BEGIN
	DECLARE @DATA_ATUAL DATETIME

	SET @DATA_ATUAL = GETDATE()
	RETURN @DATA_ATUAL
END
GO

--	A FUNCTION � EXECUTADA PARA CADA LINHA, POR ISSO O VALOR MUDA!
SELECT ID, VALOR, dbo.fncDataAtual()
FROM #TEMP_FUNCTION


---------------------------------------------------------------------------------------------------------------
--	INSERT EXEC
---------------------------------------------------------------------------------------------------------------

--	CRIA A PROCEDURE QUE RETORNA OS CLIENTES
DROP PROCEDURE IF EXISTS [dbo].[stpRetornaClientes]
GO

CREATE PROCEDURE [dbo].[stpRetornaClientes]
AS
BEGIN
	SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento
	FROM [dbo].[Cliente]
END
GO

EXEC [dbo].[stpRetornaClientes]
GO


--	CRIA A TABELA TEMPORARIA
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)


--	EXEMPLO 1 - PROCEDURE:
INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
EXEC [dbo].[stpRetornaClientes]

SELECT * FROM #TEMP_CLIENTE
GO


--	EXEMPLO 2 - C�DIGO SQL DIN�MICO:
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
EXEC sp_executesql N'SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento FROM [dbo].[Cliente]'

SELECT * FROM #TEMP_CLIENTE


--	EXEMPLO 3 - CUIDADO: PROCEDURE COM MAIS DE UM RESULTADO:

--	TESTE 3.1) SELECTS COMPAT�VEIS

DROP PROCEDURE IF EXISTS [dbo].[stpRetornaClientes_2_Results]
GO

CREATE PROCEDURE [dbo].[stpRetornaClientes_2_Results]
AS
BEGIN
	SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento
	FROM [dbo].[Cliente]

	SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento
	FROM [dbo].[Cliente]
END
GO

EXEC [dbo].[stpRetornaClientes_2_Results]
GO

--	EXECUTA A PROCEDURE PARA POPULAR A TABELA
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
EXEC [dbo].[stpRetornaClientes_2_Results]

SELECT * FROM #TEMP_CLIENTE
GO


--	TESTE 3.2) SELECTS INCOMPAT�VEIS

DROP PROCEDURE IF EXISTS [dbo].[stpRetornaClientes_2_Results]
GO

CREATE PROCEDURE [dbo].[stpRetornaClientes_2_Results]
AS
BEGIN
	SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento
	FROM [dbo].[Cliente]

	SELECT Nm_Cliente, Dt_Nascimento, Id_Cliente
	FROM [dbo].[Cliente]
END
GO

EXEC [dbo].[stpRetornaClientes_2_Results]
GO

--	EXECUTA A PROCEDURE PARA POPULAR A TABELA
TRUNCATE TABLE #TEMP_CLIENTE

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
EXEC [dbo].[stpRetornaClientes_2_Results]

/*
Msg 206, Level 16, State 2, Procedure dbo.stpRetornaClientes_2_Results, Line 8 [Batch Start Line 410]
Operand type clash: int is incompatible with date
*/

SELECT * FROM #TEMP_CLIENTE
GO


---------------------------------------------------------------------------------------------------------------
--	SELECT INTO
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

SELECT Nm_Cliente, Dt_Nascimento
INTO #TEMP_CLIENTE
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE


--	EXEMPLO 2 - COLUNA SEM "ALIAS":

--	OBS: VERIFICAR O NOME DAS COLUNAS NO RESULTADO!
SELECT UPPER(Nm_Cliente), Dt_Nascimento
FROM [dbo].[Cliente]
GO

DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

SELECT UPPER(Nm_Cliente), Dt_Nascimento
INTO #TEMP_CLIENTE
FROM [dbo].[Cliente]

/*
Msg 1038, Level 15, State 5, Line 450
An object or column name is missing or empty. For SELECT INTO statements, verify each column has a name.
For other statements, look for empty alias names. Aliases defined as "" or [] are not allowed. 
Change the alias to a valid name.
*/

SELECT * FROM #TEMP_CLIENTE


--	ESPECIFICANDO O NOME DA COLUNA
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

SELECT UPPER(Nm_Cliente) AS Nm_Cliente, Dt_Nascimento
INTO #TEMP_CLIENTE
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE


--	EXEMPLO 3 - SELECT INTO COM IDENTITY:
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

SELECT 
	IDENTITY(INT, 1,1) AS Id_Cliente,
	Nm_Cliente, 
	Dt_Nascimento
INTO #TEMP_CLIENTE
FROM [dbo].[Cliente]

SELECT * FROM #TEMP_CLIENTE


---------------------------------------------------------------------------------------------------------------
--	INSERT - OUTPUT
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)

--	EXEMPLO 1 - RETORNA AS LINHAS QUE FORAM INSERIDAS:
INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
OUTPUT inserted.*		
SELECT *
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%Lima%'

SELECT * FROM #TEMP_CLIENTE
GO

--	EXEMPLO 2 - ARMAZENA AS LINHAS QUE FORAM INSERIDAS:
TRUNCATE TABLE #TEMP_CLIENTE

DROP TABLE IF EXISTS #TEMP_INSERTED
GO

CREATE TABLE #TEMP_INSERTED (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)
GO

INSERT INTO #TEMP_CLIENTE (Id_Cliente, Nm_Cliente, Dt_Nascimento)
OUTPUT inserted.*
INTO #TEMP_INSERTED
SELECT Id_Cliente, Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]
WHERE Nm_Cliente LIKE '%Lima%'

SELECT * FROM #TEMP_CLIENTE

SELECT * FROM #TEMP_INSERTED


---------------------------------------------------------------------------------------------------------------
--	BULK INSERT
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/bulk-insert-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)

--	EXEMPLO 1 - ESPECIFICANDO AS COLUNAS:
BULK INSERT #TEMP_CLIENTE
FROM 'C:\SQLServer\Clientes-UTF8.txt'
WITH 
(
	CODEPAGE		= '1252',
	DATAFILETYPE    = 'CHAR',
	FIRSTROW		= 2,		-- UTILIZADO PARA IGNORAR A LINHA DO CABE�ALHO
	FIELDTERMINATOR = ',',		-- SEPARADOR DAS COLUNAS
	ROWTERMINATOR   = '\n'		-- SEPARADOR DAS LINHAS
);

SELECT * FROM #TEMP_CLIENTE
GO


-- EXEMPLO 2
DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NULL
)

--	EXEMPLO 1 - ESPECIFICANDO AS COLUNAS:
BULK INSERT #TEMP_CLIENTE
FROM 'C:\SQLServer\Clientes-ANSI.txt'
WITH 
(
	CODEPAGE		= '1252',
	DATAFILETYPE    = 'CHAR',
	FIRSTROW		= 2,		-- UTILIZADO PARA IGNORAR A LINHA DO CABE�ALHO
	FIELDTERMINATOR = ',',		-- SEPARADOR DAS COLUNAS
	ROWTERMINATOR   = '\n'		-- SEPARADOR DAS LINHAS
);

SELECT * FROM #TEMP_CLIENTE


---------------------------------------------------------------------------------------------------------------
--	B�NUS 1 - TESTE DE PERFORMANCE: TRANSA��O IMPL�CITA x TRANSA��O EXPL�CITA
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://www.sqlshack.com/how-to-rollback-using-explicit-sql-server-transactions/
---------------------------------------------------------------------------------------------------------------

--	OBS: PERGUNTAR QUAL A DIFEREN�A ENTRE AS DUAS FORMAS!

SET NOCOUNT ON

--	1) TRANSA��O IMPL�CITA -> TEMPO: 6 SEGUNDOS!
DROP TABLE IF EXISTS Demo
GO

CREATE TABLE Demo (
	Descricao VARCHAR(20)
)

DECLARE @i INT
SET @i = 1

--	 CADA ITERACAO EXECUTA UMA NOVA TRANSACAO!!!
WHILE (@i <= 50000)
BEGIN
    INSERT INTO Demo VALUES ('Performance test')
    SET @i=@i+1
END

--	CONFERE A QUANTIDADE DE LINHAS INSERIDAS NA TABELA
SELECT COUNT(*) FROM Demo
GO


--	2) TRANSA��O EXPL�CITA -> TEMPO: 0 SEGUNDOS!
DROP TABLE IF EXISTS Demo
GO

CREATE TABLE Demo (
	Descricao VARCHAR(20)
)

DECLARE @i INT
SET @i = 1

BEGIN TRAN	-- ABRINDO UMA �NICA TRANSA��O EXPL�CITA
	WHILE (@i <= 50000)
	BEGIN
		INSERT INTO Demo VALUES ('Performance test')
		SET @i=@i+1
	END
COMMIT TRAN

--	CONFERE A QUANTIDADE DE LINHAS INSERIDAS NA TABELA
SELECT COUNT(*) FROM Demo
GO


---------------------------------------------------------------------------------------------------------------
--	B�NUS 2 - UTILIZANDO MAIS DE UMA TRANSA��O
---------------------------------------------------------------------------------------------------------------

--	@@TRANCOUNT -> Retorna a quantidade de transa��es abertas na sess�o atual.
SELECT @@TRANCOUNT
GO

--	TESTE 1: ROLLBACK

--	TRANSA��O 1:
BEGIN TRAN
	SELECT @@TRANCOUNT

		--	TRANSA��O 2:
		BEGIN TRAN			
			SELECT @@TRANCOUNT

				--	TRANSA��O 3:
				BEGIN TRAN
					SELECT @@TRANCOUNT

				--	QUAL VALOR SER� RETORNADO NO SELECT ABAIXO???
				ROLLBACK
				SELECT @@TRANCOUNT


--	TESTE 2: COMMIT

--	TRANSA��O 1:
BEGIN TRAN
	SELECT @@TRANCOUNT

		--	TRANSA��O 2:
		BEGIN TRAN			
			SELECT @@TRANCOUNT

				--	TRANSA��O 3:
				BEGIN TRAN
					SELECT @@TRANCOUNT

				--	QUAL VALOR SER� RETORNADO NO SELECT ABAIXO???
				COMMIT
				SELECT @@TRANCOUNT


---------------------------------------------------------------------------------------------------------------
--	B�NUS 3 - TRANSA��ES x VARI�VEIS x TABELAS TEMPOR�RIAS
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 1 - VARI�VEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @MySalary INT = 100000;

BEGIN TRAN
	SET @MySalary = @MySalary * 2;
ROLLBACK;

-- RESULTADO
SELECT @MySalary
GO

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 2 - TABELAS VARI�VEIS:
---------------------------------------------------------------------------------------------------------------
DECLARE @People TABLE (Name VARCHAR(50));

BEGIN TRAN
	INSERT INTO @People VALUES ('Bill Gates');
	INSERT INTO @People VALUES ('Melinda Gates');
	INSERT INTO @People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM @People;
GO

---------------------------------------------------------------------------------------------------------------
--	DESAFIO 3 - TABELAS TEMPOR�RIAS LOCAIS:
---------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #People

CREATE TABLE #People (
	Name VARCHAR(50)
);

BEGIN TRAN
	INSERT INTO #People VALUES ('Bill Gates');
	INSERT INTO #People VALUES ('Melinda Gates');
	INSERT INTO #People VALUES ('Satya Nadella');

ROLLBACK

-- RESULTADO
SELECT * FROM #People;

DROP TABLE IF EXISTS #People
GO