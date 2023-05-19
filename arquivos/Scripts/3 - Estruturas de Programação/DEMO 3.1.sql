---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	3 - Estruturas de Programação
--	DEMO 3.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	BATCHES / GO
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/odbc/reference/develop-app/batches-of-sql-statements?view=sql-server-ver15
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/sql-server-utilities-statements-go?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
SELECT 1

SELECT 2

SELECT 3

GO

--	EXEMPLO 2:
SELECT 1

GO

SELECT 2

GO

SELECT 3

GO

--	EXEMPLO 3:
SELECT 'ANTES DA DIVISÃO POR ZERO'

SELECT 2 / 0

SELECT 'DEPOIS DA DIVISÃO POR ZERO'

GO

--	EXEMPLO 4:
SELECT 'ANTES DA DIVISÃO POR ZERO'

SELEC 2 / 0

SELECT 'DEPOIS DA DIVISÃO POR ZERO'

GO

--	EXEMPLO 5:
SELECT 'ANTES DA DIVISÃO POR ZERO'

GO

SELEC 2 / 0

GO

SELECT 'DEPOIS DA DIVISÃO POR ZERO'

GO

--	EXEMPLO 6 - VARIAVEIS x GO:
DECLARE @VALOR INT = 10

SELECT @VALOR

GO
--DECLARE @VALOR INT = 10

SELECT @VALOR
GO

--	EXEMPLO 7 - LOOP:
SELECT 1
GO 2

--	EXEMPLO 8 - LOOP:
SELECT 1

SELECT 2
GO 2

--	EXEMPLO 10 - ALTERARANDO O DELIMITADOR "GO":
--	MENU -> OPTIONS -> QUERY EXECUTION -> BATCH SEPARATOR


---------------------------------------------------------------------------------------------------------------
--	WAITFOR
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/waitfor-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	DELAY (espera por um determinado período)
WAITFOR DELAY '00:00:05'	-- 5 Segundos

--	TIME (espera por um determinado horário)
WAITFOR TIME '16:20'		-- Executa depois das 16:20 horas

SELECT GETDATE()


---------------------------------------------------------------------------------------------------------------
--	PRINT
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/print-transact-sql?view=sql-server-ver15
--	https://www.sqlshack.com/sql-server-print-and-sql-server-raiserror-statements/
---------------------------------------------------------------------------------------------------------------
--	1) Mensagem <> Resultado
--	Mensagem
PRINT 'Mensagem definida pelo Luiz Vitor!'

-- Resultado
SELECT 'Mensagem definida pelo Luiz Vitor!'

GO

--	2) Usando variável
DECLARE @Msg VARCHAR(100) = 'Mensagem definida pelo Luiz Vitor usando uma variável!'

PRINT @Msg


---------------------------------------------------------------------------------------------------------------
--	RAISERROR
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver15
--	https://www.sqlshack.com/sql-server-print-and-sql-server-raiserror-statements/
---------------------------------------------------------------------------------------------------------------
--	 EXEMPLO 1:
RAISERROR ('Usando o RAISERROR para gerar um ERRO!', -- Message text.  
            16, -- Severity.  
            1 -- State.  
            );
GO

--	 EXEMPLO 2 - USANDO VARIAVEL NA MENSAGEM:
DECLARE @Msg VARCHAR(100) = 'Mensagem definida pelo Luiz Vitor usando uma variável no RAISERROR!'

RAISERROR (@Msg, -- Message text.  
            16, -- Severity.  
            1 -- State.  
            );  

SELECT 'ESSE SELECT É EXECUTADO DEPOIS DO RAISERROR!'
GO

--	 EXEMPLO 3:
RAISERROR ('Usando o RAISERROR para gerar um ERRO!', -- Message text.  
            16, -- Severity.  
            1 -- State.  
            );  

-- SELECT @@ERROR

IF (@@ERROR = 0)
BEGIN
	SELECT 'ESSE SELECT É EXECUTADO DEPOIS DO RAISERROR - SEM ERRO!'
END
ELSE
BEGIN
	SELECT 'ESSE SELECT É EXECUTADO DEPOIS DO RAISERROR - COM ERRO!'
END
GO

---------------------------------------------------------------------------------------------------------------
--	@@ERROR
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/error-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DECLARE @VAR_ERROS INT = 0

SELECT 1 

SET @VAR_ERROS = @@ERROR

SELECT @VAR_ERROS
GO


--	EXEMPLO 2:
DECLARE @VAR_ERROS INT = 0

SELECT 1/0

SET @VAR_ERROS = @@ERROR

SELECT @VAR_ERROS
GO


--	EXEMPLO 3:
DECLARE @VAR_ERROS INT = 0

DROP TABLE IF EXISTS #TEMP_ERRO

CREATE TABLE #TEMP_ERRO (
	NOME VARCHAR(3)
)

INSERT INTO #TEMP_ERRO (NOME)
VALUES ('Vitor')

SET @VAR_ERROS = @@ERROR

SELECT @VAR_ERROS

DROP TABLE IF EXISTS #TEMP_ERRO
GO


--	EXEMPLO 4:
DECLARE @VAR_ERROS INT = 0

SELECT 1/0

SELECT 1

SET @VAR_ERROS = @@ERROR

SELECT @VAR_ERROS
GO


--	EXEMPLO 5:

SELECT 1/0

IF(@@ERROR <> 0)
	PRINT 'A DIVISÃO DEU ERRO!'
ELSE
	PRINT 'A DIVISÃO FOI EXECUTADA COM SUCESSO!'
GO


--	EXEMPLO 6:

SELECT 1/0

PRINT 'A DIVISÃO DEU ERRO!'

IF(@@ERROR <> 0)
	PRINT 'ERRO! A ROTINA NÃO FOI EXECUTADA COM SUCESSO!'
ELSE
	PRINT 'DEU TUDO CERTO! A ROTINA FOI EXECUTADA COM SUCESSO!'
GO


---------------------------------------------------------------------------------------------------------------
--	CONTROLE DE FLUXO
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	GOTO
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/goto-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DECLARE @TESTE_GOTO INT = 1

IF (@TESTE_GOTO = 1)
BEGIN
	GOTO TESTE_1
END
ELSE IF (@TESTE_GOTO = 2)
BEGIN
	GOTO TESTE_2
END

SELECT 'EU VOU SER EXECUTADO???'

--	GOTO - Labels
TESTE_1:
	SELECT 'TESTE 1 GOTO';

TESTE_2:
	SELECT 'TESTE 2 GOTO';

GO

--	EXEMPLO 2.1 - USANDO O RETURN:
DECLARE @TESTE_GOTO INT = 1

IF (@TESTE_GOTO = 1)
BEGIN
	GOTO TESTE_1
END
ELSE IF (@TESTE_GOTO = 2)
BEGIN
	GOTO TESTE_2
END

SELECT 'EU VOU SER EXECUTADO???';

--	GOTO - Labels
TESTE_1:
	SELECT 'TESTE 1 GOTO';
	RETURN

TESTE_2:
	SELECT 'TESTE 2 GOTO';
	RETURN

TESTE_3:
	SELECT 'TESTE 2 GOTO';
	RETURN
GO


--	EXEMPLO 2.2 - USANDO O RETURN:
SELECT 1
RETURN
SELECT 1.1
GO

SELECT 2
RETURN
SELECT 2.1
GO


--	EXEMPLO 3:
DECLARE @TESTE_GOTO INT = 3

IF (@TESTE_GOTO = 1)
BEGIN
	GOTO TESTE_1
END
ELSE IF (@TESTE_GOTO = 2)
BEGIN
	GOTO TESTE_2
END

SELECT 'EU VOU SER EXECUTADO???';
-- RETURN

--	GOTO - Labels
TESTE_1:
	SELECT 'TESTE 1 GOTO';
	RETURN

TESTE_2:
	SELECT 'TESTE 2 GOTO';
	RETURN
GO


--	EXEMPLO 4 - ROTINA DE BAIXA DE FATURAS - COM TRATAMENTO DE ERROS:

--	ROTINA DE BAIXA DE FATURAS:
--	PASSO 1 - PROCESSA ARQUIVOS
DECLARE @ID_PASSO CHAR = '1'
PRINT 'PASSO 1 - PROCESSA ARQUIVOS';

-- SELECT 1/0

--	VERIFICA SE DEU ERRO
IF (@@ERROR <> 0)
BEGIN
	GOTO DEU_ERRO
END

--	PASSO 2 - CALCULA TOTAL DE PAGAMENTOS
SELECT @ID_PASSO = '2'
PRINT 'PASSO 2 - CALCULA TOTAL DE PAGAMENTOS';

-- SELECT 1/0

--	VERIFICA SE DEU ERRO
IF (@@ERROR <> 0)
BEGIN
	GOTO DEU_ERRO
END

--	PASSO 3 - REALIZA BAIXA DAS FATURAS
SELECT @ID_PASSO = '3'
PRINT 'PASSO 3 - REALIZA BAIXA DAS FATURAS';

--SELECT 1/0
 
--	VERIFICA SE DEU ERRO
IF (@@ERROR <> 0)
BEGIN
	GOTO DEU_ERRO
END

PRINT 'A ROTINA DE BAIXA DE FATURAS FOI EXECUTADA COM SUCESSO!';
RETURN

--	PASSO 4 - AVISA QUE DEU ERRO
DEU_ERRO:
	PRINT 'DEU UM ERRO NA ROTINA DE BAIXA DA FATURA NO PASSO ' + @ID_PASSO + '! FAVOR VERIFICAR COM URGÊNCIA!';
	RETURN
GO


---------------------------------------------------------------------------------------------------------------
--	IF / ELSE
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/if-else-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DECLARE @Valor INT = 10

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END
GO

DECLARE @Valor INT = 11

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END
GO

--	EXEMPLO 2 - SEM O BEGIN ... END:
DECLARE @Valor INT = 10

IF(@Valor = 10)
	SELECT 'O VALOR É IGUAL A 10'
GO

--	EXEMPLO 3:
--	Referência: https://luizlima.net/dicas-t-sql-if-else-begin-end/

DECLARE @Valor INT = 15

IF(@Valor = 10)
	SELECT 'O VALOR É IGUAL A 10'
	SELECT 'EU VOU SER EXECUTADO???'
GO

--	EXEMPLO 4:
DECLARE @Valor INT = 15

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END
ELSE
BEGIN
	SELECT 'O VALOR É DIFERENTE DE 10'
END
GO

--	EXEMPLO 5 - SEM O BEGIN ... END:
DECLARE @Valor INT = 15

IF(@Valor = 10)
	SELECT 'O VALOR É IGUAL A 10'
ELSE
	SELECT 'O VALOR É DIFERENTE DE 10'

GO

--	EXEMPLO 6.1:
DECLARE @Valor INT = 20

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END
ELSE IF(@Valor = 15)
BEGIN
	SELECT 'O VALOR É IGUAL A 15'
END
ELSE
BEGIN
	SELECT 'O VALOR NÃO É 10 NEM 15'
END
GO

--	EXEMPLO 6.2:
DECLARE @Valor INT = 20
--DECLARE @Valor INT = 10

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END

IF(@Valor = 15)
BEGIN
	SELECT 'O VALOR É IGUAL A 15'
END

IF( @Valor NOT IN(10,15) )
BEGIN
	SELECT 'O VALOR NÃO É 10 NEM 15'
END
GO

--	EXEMPLO 7 - IF's ANINHADOS:
DECLARE @Valor INT = 20

IF(@Valor <> 10)
BEGIN
	IF(@Valor <> 15)
	BEGIN
		SELECT 'O VALOR NÃO É 10 NEM 15'		
	END
END
GO

--	EXEMPLO 8.1 - IF x NULL:
SET ANSI_NULLS ON

DECLARE @Valor INT = NULL

IF(@Valor = 10)
BEGIN
	SELECT 'O VALOR É IGUAL A 10'
END
GO

SET ANSI_NULLS ON

DECLARE @Valor INT = NULL

IF(@Valor IS NULL)
BEGIN
	SELECT 'O VALOR É NULO'
END
GO

SET ANSI_NULLS ON

DECLARE @Valor INT = 1

IF(@Valor IS NOT NULL)
BEGIN
	SELECT 'O VALOR NAO É NULO'
END
GO


--	EXEMPLO 8.2 - IF x NULL x ANSI_NULLS (ON - PADRÃO SQL SERVER):
SET ANSI_NULLS ON

DECLARE @Valor INT = NULL

IF(@Valor = NULL)
BEGIN
	SELECT 'O VALOR É IGUAL A NULL'
END
GO

--	EXEMPLO 8.2 - IF x NULL x ANSI_NULLS (OFF):
--	CUIDADO!!! ESSA ALTERAÇÃO PODE AFETAR O RESULTADO DAS QUERIES TAMBÉM!!	
SET ANSI_NULLS OFF

DECLARE @Valor INT = NULL

IF(@Valor = NULL)
BEGIN
	SELECT 'O VALOR É IGUAL A NULL'
END
GO

--	VOLTA AO VALOR PADRÃO DO SQL SERVER
SET ANSI_NULLS ON

--	OBS: MOSTRAR O "DBCC USEROPTIONS"


--	EXEMPLO 9 - IF x IN:
DECLARE @Valor INT = 10

IF(@Valor IN(10, 20))
BEGIN
	SELECT 'O VALOR É IGUAL A 10 OU 20'
END
GO

--	EXEMPLO 10 - IF EXISTS:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	Dt_Cadastro DATETIME NOT NULL CONSTRAINT DF_DtCadastro DEFAULT(GETDATE())
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Fabrício Lima', '19800106', 1)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES('Luiz Lima', '19890922', 1)

SELECT * FROM [dbo].[Cliente]

GO

-- TRUNCATE TABLE [dbo].[Cliente]

IF EXISTS (SELECT TOP 1 * FROM [dbo].[Cliente])
BEGIN
	SELECT 'A TABELA CLIENTE NÃO ESTÁ VAZIA'
END
GO

--	EXEMPLO 11:
IF (1)
	SELECT 1
GO

--	EXEMPLO 12:
DECLARE @VALOR INT = 1

IF (@VALOR)
	SELECT 1
GO

--	EXEMPLO 13:
IF (1 = 1)
	SELECT 1
GO


---------------------------------------------------------------------------------------------------------------
--	IFF
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/logical-functions-iif-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DECLARE @VALOR INT = 5
SELECT IIF(@VALOR < 10, 'O VALOR É MENOR DO QUE 10!', 'O VALOR É MAIOR DO QUE 10!') AS Result; 
GO

--	EXEMPLO 2:
DECLARE @VALOR INT = 15
SELECT IIF(@VALOR < 10, 'O VALOR É MENOR DO QUE 10!', 'O VALOR É MAIOR DO QUE 10!') AS Result; 
GO

--	EXEMPLO 3:
DECLARE @VALOR INT = 5
SELECT IIF(@VALOR < 10, 'O VALOR É MENOR DO QUE 10!', 100) AS Result; 
GO

/*
Msg 245, Level 16, State 1, Line 450
Conversion failed when converting the varchar value 'O VALOR É MENOR DO QUE 10!' to data type int.
*/

---------------------------------------------------------------------------------------------------------------
--	CHOOSE
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/functions/logical-functions-choose-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT 
	CHOOSE (0, 'Manager', 'Director', 'Developer', 'Tester') AS Result_0, 
	CHOOSE (1, 'Manager', 'Director', 'Developer', 'Tester') AS Result_1, 
	CHOOSE (2, 'Manager', 'Director', 'Developer', 'Tester') AS Result_2,
	CHOOSE (3, 'Manager', 'Director', 'Developer', 'Tester') AS Result_3,
	CHOOSE (5, 'Manager', 'Director', 'Developer', 'Tester') AS Result_5

--	EXEMPLO 2:
SELECT CHOOSE (3, 'Manager', 'Director', 'Developer', 'Tester', 100) AS Result; 

/*
Msg 245, Level 16, State 1, Line 468
Conversion failed when converting the varchar value 'Developer' to data type int.
*/

---------------------------------------------------------------------------------------------------------------
--	CASE
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DECLARE @TESTE_CASE INT = 10

SELECT
	CASE 
		WHEN @TESTE_CASE = 8
			THEN 'O VALOR É 8'
		WHEN @TESTE_CASE = 9
			THEN 'O VALOR É 9'
		WHEN @TESTE_CASE = 10
			THEN 'O VALOR É 10'
		ELSE
			'O VALOR É DIFERENTE DE 10'
	END AS Teste_Case
GO

--	EXEMPLO 2:
DECLARE @TESTE_CASE INT = 9

SELECT
	CASE @TESTE_CASE
		WHEN 9
			THEN 'O VALOR É 9'
		WHEN 10
			THEN 'O VALOR É 10'
		ELSE
			'O VALOR É DIFERENTE DE 9 E 10'
	END AS Teste_Case
GO

--	EXEMPLO 3:
DECLARE @TESTE_CASE INT = 9

SELECT
	CASE @TESTE_CASE
		WHEN 9
			THEN 'O VALOR É 9'
		WHEN 10
			THEN 10
		ELSE
			'O VALOR É DIFERENTE DE 9 E 10'
	END AS Teste_Case
GO

/*
Msg 245, Level 16, State 1, Line 472
Conversion failed when converting the varchar value 'O VALOR É 9' to data type int.
*/

--	EXEMPLO 4 - CUIDADO -> SEM ELSE:
DECLARE @TESTE_CASE INT = 15

SELECT
	CASE 
		WHEN @TESTE_CASE = 10
			THEN 'O VALOR É 10'
		--WHEN @TESTE_CASE = 15
		--	THEN 'O VALOR É 15'
	END AS Teste_Case
GO

--	EXEMPLO 5 - USANDO EXPRESSÃO:
DECLARE @TESTE_CASE INT = 5

SELECT
	CASE 
		WHEN (@TESTE_CASE > 0 AND @TESTE_CASE <= 10)
			THEN 'O VALOR ESTÁ NO INTERVALO ENTRE 0 E 10'
		
		WHEN (@TESTE_CASE >= 11 AND @TESTE_CASE <= 20)
			THEN 'O VALOR ESTÁ NO INTERVALO ENTRE 11 E 20'
		
		ELSE
			'O VALOR É MAIOR QUE 20'
	END AS Teste_Case
GO


--	EXEMPLO 6 - USANDO UMA TABELA - DESCRIÇÃO DA SITUAÇÃO:

/*
Fl_Situacao:
	0  -> Novo
	1  -> Aprovado
	2  -> Pendente
	3  -> Cancelado	
*/

DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Situacao TINYINT NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(Id_Cliente)
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Situacao)
VALUES
	('Fabrício Lima', '19800106', 0),
	('Luiz Lima', '19890922', 1),
	('Fabiano Amorim', '19620927', 2),
	('Dirceu Resende', '19740516', 3),
	('Rodrigo Ribeiro', '19500108', 99)

SELECT * FROM [dbo].[Cliente]

--	USANDO O CASE COM A COLUNA "Fl_Situacao"
SELECT
	Id_Cliente,
	Nm_Cliente,
	Dt_Nascimento,
	Fl_Situacao,
	CASE Fl_Situacao
		WHEN 0
			THEN 'Novo'
		WHEN 1
			THEN 'Aprovado'
		WHEN 2
			THEN 'Pendente'
		WHEN 3
			THEN 'Cancelado'
		ELSE
			'Outros'
	END AS Fl_Situacao_Desc
FROM [dbo].[Cliente]
GO


---------------------------------------------------------------------------------------------------------------
--	LOOP - WHILE
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/while-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
DECLARE @LOOP INT = 1

WHILE(@LOOP <= 10)
BEGIN
	PRINT @LOOP

	SET @LOOP = @LOOP + 1
END
GO

--	EXEMPLO 2 - CONTINUE:
DECLARE @LOOP INT = 1

WHILE(@LOOP <= 10)
BEGIN
	IF ((@LOOP % 2) = 1)
	BEGIN
		SET @LOOP = @LOOP + 1
		CONTINUE
	END

	PRINT @LOOP

	SET @LOOP = @LOOP + 1
END
GO

--	EXEMPLO 3 - BREAK:
DECLARE @LOOP INT = 1

WHILE(@LOOP <= 10)
BEGIN
	IF (@LOOP = 5)
	BEGIN
		BREAK
	END

	PRINT @LOOP

	SET @LOOP = @LOOP + 1
END
GO

--	EXEMPLO 4 - CUIDADO -> LOOP INFINITO:
DECLARE @LOOP INT = 1

WHILE(@LOOP > 0)
BEGIN
	PRINT @LOOP
	SET @LOOP = @LOOP + 1	
END
GO


---------------------------------------------------------------------------------------------------------------
--	LOOP - CURSOR
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/declare-cursor-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL,
	CONSTRAINT PK_Cliente PRIMARY KEY(Id_Cliente)
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES
	('Fabrício Lima', '19800106', 1),
	('Luiz Lima', '19890922', 1),
	('Fabiano Amorim', '19620927', 1),
	('Dirceu Resende', '19740516', 1),
	('Rodrigo Ribeiro', '19500108', 1)

SELECT * FROM [dbo].[Cliente]

-- DECLARA AS VARIAVEIS, DECLARA E POPULA O CURSOR
DECLARE @Nm_Cliente VARCHAR(100), @Dt_Nascimento DATE

DECLARE Cursor_Clientes CURSOR FAST_FORWARD FOR  
SELECT Nm_Cliente, Dt_Nascimento
FROM [dbo].[Cliente]

OPEN Cursor_Clientes;  
FETCH NEXT FROM Cursor_Clientes INTO @Nm_Cliente, @Dt_Nascimento;  

WHILE @@FETCH_STATUS = 0  
   BEGIN  
      SELECT @Nm_Cliente AS Nm_Cliente, @Dt_Nascimento AS Dt_Nascimento

      FETCH NEXT FROM Cursor_Clientes INTO @Nm_Cliente, @Dt_Nascimento;  
   END

CLOSE Cursor_Clientes;  
DEALLOCATE Cursor_Clientes;

GO


--	EXEMPLO 2: MESMO EXEMPLO DO CURSOR, MAS AGORA USANDO O WHILE!

--	GUARDA OS IDs (PRIMARY KEY) EM UMA TABELA TEMPORÁRIA
DROP TABLE IF EXISTS #TEMP_CLIENTE

SELECT Id_Cliente
INTO #TEMP_CLIENTE
FROM [dbo].[Cliente]

-- SELECT * FROM #TEMP_CLIENTE

--	WHILE
DECLARE @Id_Cliente INT

WHILE EXISTS(SELECT TOP 1 Id_Cliente FROM #TEMP_CLIENTE)
BEGIN
	--	SELECIONA UM ID_CLIENTE
	SELECT TOP 1 @Id_Cliente = Id_Cliente
	FROM #TEMP_CLIENTE
	ORDER BY Id_Cliente

	--	EXIBE O RESULTADO
	SELECT Nm_Cliente, Dt_Nascimento
	FROM [dbo].[Cliente]
	WHERE Id_Cliente = @Id_Cliente
	
	--	EXCLUI O ID_CLIENTE
	DELETE #TEMP_CLIENTE
	WHERE Id_Cliente = @Id_Cliente
END
GO

DROP TABLE IF EXISTS #TEMP_CLIENTE