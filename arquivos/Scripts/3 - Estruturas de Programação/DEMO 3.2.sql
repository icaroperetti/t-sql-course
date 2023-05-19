---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	3 - Estruturas de Programação
--	DEMO 3.2:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	Procedures
---------------------------------------------------------------------------------------------------------------
/*
- Procedimento armazenado que executa comandos que foram definidos previamente.
- Pode receber parâmetros de entrada e retornar parâmetros de saída.
- Pode fazer alterações no banco de dados. 

- Vantagens:
	-> Encapsulamento de dados (ajuda na organização do código também).
	-> Ponto único de alteração.
	-> Maior controle de segurança.
	-> Tratamento de Erros.
	-> Melhoria de Performance (OBS: cuidado com Parameter Sniffing).
*/

--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/create-procedure-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1
DROP PROCEDURE IF EXISTS [dbo].[stpRetornaDobro]
GO

CREATE PROCEDURE [dbo].[stpRetornaDobro] (
	@Vl_Entrada INT NULL = 0
)
AS
BEGIN
	SELECT @Vl_Entrada * 2 AS Resultado
END
GO

--	EXECUTA A PROCEDURE
EXEC [dbo].[stpRetornaDobro] 10

EXEC [dbo].[stpRetornaDobro] 50

EXEC [dbo].[stpRetornaDobro] @Vl_Entrada = 7500

EXEC [dbo].[stpRetornaDobro]


--	EXEMPLO 2 - SEM PARAMETROS
DROP PROCEDURE IF EXISTS [dbo].[stpHelloWorld]
GO

CREATE PROCEDURE [dbo].[stpHelloWorld] 
AS
BEGIN
	SELECT 'Olá, estou executando minha primeira Stored Procedure!' AS Resultado
END
GO

--	EXECUTA A PROCEDURE
EXEC [dbo].[stpHelloWorld]

EXECUTE [dbo].[stpHelloWorld]


--	EXEMPLO 3.1 - PARAMETROS OUTPUT
DROP PROCEDURE IF EXISTS [dbo].[stpRetornaDobro]
GO

CREATE PROCEDURE [dbo].[stpRetornaDobro] (
	@Vl_Entrada INT NULL = 0 OUTPUT
)
AS
BEGIN
	SET @Vl_Entrada = @Vl_Entrada * 2

	SELECT @Vl_Entrada AS Vl_Entrada_Procedure
END
GO

-- SEM OUTPUT
DECLARE @VALOR INT = 10

--	EXECUTA A PROCEDURE
EXEC [dbo].[stpRetornaDobro] @VALOR

SELECT @VALOR AS Retorno
GO

-- COM OUTPUT
DECLARE @VALOR INT = 10

--	EXECUTA A PROCEDURE
EXEC [dbo].[stpRetornaDobro] @VALOR OUTPUT

SELECT @VALOR AS Retorno
GO

--	EXEMPLO 3.2 - PARAMETROS OUTPUT
DECLARE @VALOR INT = 50

--	EXECUTA A PROCEDURE
EXEC [dbo].[stpRetornaDobro] @VALOR OUTPUT

SELECT @VALOR AS Retorno
GO


--	EXEMPLO 4 - MELHORIA EM SEGURANÇA
--	1) SQL Injection - Referência
--	https://www.dirceuresende.com/blog/sql-server-como-evitar-sql-injection-pare-de-utilizar-query-dinamica-como-execquery-agora/

--	2) NÃO PRECISA LIBERAR O ACESSO DIRETAMENTE NAS TABELAS, BASTA LIBERAR O ACESSO NA PROCEDURE!
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES
	('Fabrício Lima', '19800106', 1),
	('Luiz Lima', '19890922', 1),
	('Fabiano Amorim', '19620927', 1),
	('Dirceu Resende', '19740516', 1),
	('Rodrigo Ribeiro', '19500108', 1)

SELECT * FROM [dbo].[Cliente]

--	ABRIR OUTRA QUERY E EXECUTAR O SELECT ABAIXO COM O USUARIO "teste":
USE Treinamento_TSQL

SELECT * FROM [dbo].[Cliente]

/*
Msg 229, Level 14, State 5, Line 3
The SELECT permission was denied on the object 'Cliente', database 'Treinamento_TSQL', schema 'dbo'.
*/

GO
DROP PROCEDURE IF EXISTS [dbo].[stpRetornaClientes]
GO

CREATE PROCEDURE [dbo].[stpRetornaClientes]
AS
BEGIN
	SELECT * 
	FROM [dbo].[Cliente]
	ORDER BY Nm_Cliente
END
GO

--	TENTAR EXECUTAR COM O USUARIO "teste"
EXEC [dbo].[stpRetornaClientes]

/*
Msg 229, Level 14, State 5, Procedure dbo.stpRetornaClientes, Line 1 [Batch Start Line 4]
The EXECUTE permission was denied on the object 'stpRetornaClientes', database 'Treinamento_TSQL', schema 'dbo'.
*/

--	LIBERAR A PERMISSAO NA PROCEDURE PARA O USUARIO "teste"
GRANT EXECUTE ON [stpRetornaClientes] TO [teste]

--	EXECUTAR A PROCEDURE COM O USUARIO "teste" E TENTAR FAZER O SELECT NA TABELA "Cliente" TAMBEM.

--	REMOVER O ACESSO DO USUARIO "teste"
REVOKE EXECUTE ON [stpRetornaClientes] TO [teste]


--	EXEMPLO 5 - ALTERANDO DATA DE NASCIMENTO + TRATAMENTO DE ERROS
DROP TABLE IF EXISTS [dbo].[Cliente]
GO

CREATE TABLE [dbo].[Cliente] (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATE NOT NULL,
	Fl_Sexo TINYINT NOT NULL
)

INSERT INTO [dbo].[Cliente] (Nm_Cliente, Dt_Nascimento, Fl_Sexo)
VALUES
	('Fabrício Lima', '19800106', 1),
	('Luiz Lima', '19890922', 1),
	('Fabiano Amorim', '19620927', 1),
	('Dirceu Resende', '19740516', 1),
	('Rodrigo Ribeiro', '19500108', 1)

SELECT * FROM [dbo].[Cliente]

GO
DROP PROCEDURE IF EXISTS [dbo].[stpAlteraDataNascimento]
GO

CREATE PROCEDURE [dbo].[stpAlteraDataNascimento] (
	@Id_Cliente INT,
	@Dt_Nascimento DATE
)
AS
BEGIN
	--	TRATAMENTO DE ERRO 1 - VERIFICA SE INFORMOU O ID DO CLIENTE E A NOVA DATA DE NASCIMENTO
	IF ( (@Id_Cliente IS NOT NULL) AND (@Dt_Nascimento IS NOT NULL) )
	BEGIN
		--	TRATAMENTO DE ERRO 2 - VERIFICA SE O ID DO CLIENTE INFORMADO É VÁLIDO
		IF EXISTS (SELECT TOP 1 Id_Cliente FROM [dbo].[Cliente] WHERE Id_Cliente = @Id_Cliente)
		BEGIN
			UPDATE [dbo].[Cliente] 
			SET Dt_Nascimento = @Dt_Nascimento
			WHERE Id_Cliente = @Id_Cliente
			
			PRINT 'A Data de Nascimento foi alterada com sucesso!'
		END
		ELSE
		BEGIN
			PRINT 'O ID do Cliente informado não existe!'
		END
	END
	ELSE
	BEGIN
		PRINT 'Favor informar o ID do Cliente e a nova Data de Nascimento!'
	END
END
GO

--	EXECUTANDO SEM INFORMAR OS PARÂMETROS
EXEC [dbo].[stpAlteraDataNascimento]

/*
Msg 201, Level 16, State 4, Procedure dbo.stpAlteraDataNascimento, Line 0 [Batch Start Line 216]
Procedure or function 'stpAlteraDataNascimento' expects parameter '@Id_Cliente', which was not supplied.
*/

EXEC [dbo].[stpAlteraDataNascimento] 1

/*
Msg 201, Level 16, State 4, Procedure dbo.stpAlteraDataNascimento, Line 0 [Batch Start Line 218]
Procedure or function 'stpAlteraDataNascimento' expects parameter '@Dt_Nascimento', which was not supplied.
*/

--	EXECUTANDO CORRETAMENTE
SELECT * FROM [dbo].[Cliente]

EXEC [dbo].[stpAlteraDataNascimento] 1, '1975-01-06'

--	CONFERIR O NOVO VALOR DA DATA DE NASCIMENTO
SELECT * FROM [dbo].[Cliente]

/*
A Data de Nascimento foi alterada com sucesso!
*/

--	TESTANDO OS TRATAMENTOS DE ERRO
EXEC [dbo].[stpAlteraDataNascimento] NULL, NULL

EXEC [dbo].[stpAlteraDataNascimento] NULL, '1975-01-06'

EXEC [dbo].[stpAlteraDataNascimento] 1, NULL

/*
Favor informar o ID do Cliente e a nova Data de Nascimento!
Favor informar o ID do Cliente e a nova Data de Nascimento!
Favor informar o ID do Cliente e a nova Data de Nascimento!
*/

EXEC [dbo].[stpAlteraDataNascimento] 1000, '1975-01-06'

/*
O ID do Cliente informado não existe!
*/

--	EXEMPLO 6 - ALTERANDO UMA PROCEDURE
GO
DROP PROCEDURE IF EXISTS [dbo].[stpRetornaClientes]
GO

CREATE PROCEDURE [dbo].[stpRetornaClientes]
AS
BEGIN
	SELECT * 
	FROM [dbo].[Cliente]
	ORDER BY Nm_Cliente
END
GO

--	CONFERIR OS CLIENTE
EXEC [dbo].[stpRetornaClientes]

--	ALTERANDO A PROCEDURE - RETORNAR APENAS O NOME DO CLIENTE E DATA DE NASCIMENTO
--	OBS: MOSTRAR COMO FILTRAR E ABRIR PELO "OBJECT EXPLORER" TAMBEM
GO
ALTER PROCEDURE [dbo].[stpRetornaClientes]
AS
BEGIN
	SELECT Nm_Cliente, Dt_Nascimento 
	FROM [dbo].[Cliente]
	ORDER BY Nm_Cliente
END
GO

--	CONFERIR OS CLIENTE
EXEC [dbo].[stpRetornaClientes]


--	RETORNA A DEFINIÇÃO DA PROCEDURE
sp_helptext 'stpRetornaClientes'



--	EXEMPLO 7 - PARAMETROS DEFAULT
GO
DROP PROCEDURE IF EXISTS [dbo].[stpParametroDefault]
GO

CREATE PROCEDURE [dbo].[stpParametroDefault] (
	@Val1 INT = 100,
	@val2 VARCHAR(100) = 'Teste Parâmetro Default'
)
AS
BEGIN
	SELECT @Val1 AS Val1, @val2 AS val2
END
GO

--	TESTE - PARAMETROS
EXEC [dbo].[stpParametroDefault]

EXEC [dbo].[stpParametroDefault] 500, 'Estou informando o parâmetro'

EXEC [dbo].[stpParametroDefault] 'Estou informando o parâmetro', 500

EXEC [dbo].[stpParametroDefault] @Val1 = 500, @val2 = 'Estou informando o parâmetro'

EXEC [dbo].[stpParametroDefault] @val2 = 'Estou informando o parâmetro', @Val1 = 500

EXEC [dbo].[stpParametroDefault] 500

EXEC [dbo].[stpParametroDefault] 'Estou informando o parâmetro'

EXEC [dbo].[stpParametroDefault] @val2 = 'Estou informando o parâmetro'


--	EXEMPLO 8 - USANDO O RETURN
GO
DROP PROCEDURE IF EXISTS [dbo].[stpTesteReturn]
GO

CREATE PROCEDURE [dbo].[stpTesteReturn]
AS
BEGIN
	SELECT '1 - ANTES DO RETURN'

	RETURN

	SELECT '2 - DEPOIS DO RETURN'
END
GO

--	EXEMPLO 9 - CHAMANDO OUTRAS PROCEDURES
GO
DROP PROCEDURE IF EXISTS [dbo].[stpProc_3]
GO

CREATE PROCEDURE [dbo].[stpProc_3]
AS
BEGIN
	SELECT 'Olá! Eu sou a PROC 3!'
END
GO

GO
DROP PROCEDURE IF EXISTS [dbo].[stpProc_2]
GO

CREATE PROCEDURE [dbo].[stpProc_2]
AS
BEGIN
	SELECT 'Olá! Eu sou a PROC 2!'

	EXEC [dbo].[stpProc_3]
END
GO

GO
DROP PROCEDURE IF EXISTS [dbo].[stpProc_1]
GO

CREATE PROCEDURE [dbo].[stpProc_1]
AS
BEGIN
	SELECT 'Olá! Eu sou a PROC 1!'

	EXEC [dbo].[stpProc_2]

	SELECT 4
END
GO

EXEC [dbo].[stpProc_1]

EXEC [dbo].[stpProc_2]

EXEC [dbo].[stpProc_3]


--	MELHORIA EM PERFORMANCE:

--	Parameter Sniffing - Referências:
--	https://blogfabiano.com/2009/02/20/parameters-and-stored-procedures/
--	https://www.brentozar.com/archive/2013/06/the-elephant-and-the-mouse-or-parameter-sniffing-in-sql-server/

--	Outros Posts - Referências:
--	https://luizlima.net/dicas-t-sql-qual-impacto-de-utilizar-o-prefixo-sp_-no-nome-de-uma-procedure/
--	https://luizlima.net/casos-do-dia-a-dia-procedures-x-rollback/


--	EXEMPLO 10 - WITH RECOMPILE - CUIDADO!!! UTILIZA MAIS CPU!!!
--	OBS: COMENTAR SOBRE A REUTILIZAÇÃO DOS PLANOS PELA PROCEDURE!
GO
DROP PROCEDURE IF EXISTS [dbo].[stpProcWithoutRecompile]
GO

CREATE PROCEDURE [dbo].[stpProcWithoutRecompile] (
	@Id_Cliente INT	
)
AS
BEGIN
	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Id_Cliente = @Id_Cliente
	ORDER BY Nm_Cliente
END
GO

GO
DROP PROCEDURE IF EXISTS [dbo].[stpProcWithRecompile]
GO

CREATE PROCEDURE [dbo].[stpProcWithRecompile] (
	@Id_Cliente INT	
) 
WITH RECOMPILE
AS
BEGIN
	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Id_Cliente = @Id_Cliente
	ORDER BY Nm_Cliente
END
GO

EXEC [dbo].[stpProcWithoutRecompile] 1

EXEC [dbo].[stpProcWithRecompile] 1


---------------------------------------------------------------------------------------------------------------
--	Fuctions
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/create-function-transact-sql?view=sql-server-ver15
--	https://www.sqlservertutorial.net/sql-server-user-defined-functions/sql-server-table-valued-functions/
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

SELECT * FROM [dbo].[Cliente]
GO

--	EXEMPLO 1 - SCALAR FUNCTION
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

--	OBS 1: EXECUTA A FUNCTION PARA CADA LINHA DA TABELA!
--	OBS 2: COMENTAR SOBRE OS POSSÍVEIS PROBLEMAS DE PERFORMANCE DAS FUNCTIONS!

SELECT *, [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) AS Vl_Salario_Novo
FROM [dbo].[Cliente]

--	CALCULANDO DIRETO NA QUERY SEM UTILIZAR A FUNCTION
SELECT *, Vl_Salario * 1.1 AS Vl_Salario_Novo
FROM [dbo].[Cliente]

--	UTILIZANDO UMA EXPRESSAO NA CHAMADA DOS PARAMETROS
SELECT *, [dbo].[fncCalculaAumentoSalario](Vl_Salario * 2, 1.1) AS Vl_Salario_Novo
FROM [dbo].[Cliente]


SELECT *, [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) AS NovoSalario
FROM [dbo].[Cliente]
WHERE NovoSalario > 30000.00

/*
Msg 207, Level 16, State 1, Line 422
Invalid column name 'NovoSalario'.
*/

--	PERGUNTA: VAI EXECUTAR A FUNCTION UMA OU DUAS VEZES (NO SELECT E NO WHERE) A CADA LINHA???
SELECT *, [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) AS NovoSalario
FROM [dbo].[Cliente]
WHERE [dbo].[fncCalculaAumentoSalario](Vl_Salario, 1.1) > 30000.00
ORDER BY NovoSalario DESC

SELECT [dbo].[fncCalculaAumentoSalario](10000, 1.1)


--	EXEMPLO 2 - SCALAR FUNCTION - RETORNANDO SELECT - NÃO PODE!!!
DROP FUNCTION IF EXISTS [dbo].[fncCalculaAumentoSalario]
GO
CREATE FUNCTION [dbo].[fncCalculaAumentoSalario] (
	@Vl_Salario NUMERIC(9,2),
	@Fator_Aumento NUMERIC(9,2)
)
RETURNS NUMERIC(9,2)
AS
BEGIN
	SELECT 1

	RETURN @Vl_Salario * @Fator_Aumento * 2
END
GO


--	EXEMPLO 3 - TABLE FUNCTION
DROP FUNCTION IF EXISTS [dbo].[fncTabelaClientesRicos]
GO
CREATE FUNCTION [dbo].[fncTabelaClientesRicos] (
	@Vl_Salario NUMERIC(9,2)
)
RETURNS TABLE
AS
RETURN 
	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Vl_Salario >= @Vl_Salario
GO

SELECT * FROM [dbo].[Cliente]

SELECT * FROM [dbo].[fncTabelaClientesRicos](20000.00)

SELECT * FROM [dbo].[fncTabelaClientesRicos](50000.00)

SELECT * FROM [dbo].[fncTabelaClientesRicos](20000.00)
WHERE Nm_Cliente LIKE 'F%'

SELECT [dbo].[fncTabelaClientesRicos](20000.00)

/*
Msg 4121, Level 16, State 1, Line 493
Cannot find either column "dbo" or the user-defined function or aggregate "dbo.fncTabelaClientesRicos", 
or the name is ambiguous.
*/


--	EXEMPLO 4.1 - TABLE FUNCTION - COM MAIS DE UM SELECT
DROP FUNCTION IF EXISTS [dbo].[fncTabelaClientesRicos_2]
GO
CREATE FUNCTION [dbo].[fncTabelaClientesRicos_2] (
	@Vl_Salario NUMERIC(9,2)
)
RETURNS TABLE
AS
RETURN
	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Vl_Salario >= @Vl_Salario

	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Vl_Salario >= @Vl_Salario
GO

--	EXEMPLO 4.1 - TABLE FUNCTION - COM MAIS DE UM SELECT - USANDO O "UNION ALL"
DROP FUNCTION IF EXISTS [dbo].[fncTabelaClientesRicos_2]
GO
CREATE FUNCTION [dbo].[fncTabelaClientesRicos_2] (
	@Vl_Salario NUMERIC(9,2)
)
RETURNS TABLE
AS
RETURN
	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Vl_Salario >= @Vl_Salario

	UNION ALL

	SELECT * 
	FROM [dbo].[Cliente]
	WHERE Vl_Salario >= @Vl_Salario
GO

SELECT * FROM [dbo].[fncTabelaClientesRicos_2](20000.00)


---------------------------------------------------------------------------------------------------------------
--	Views
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/create-view-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS [dbo].[Cliente]
Go

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

DROP VIEW IF EXISTS [dbo].[vwClientesRicos]
GO

CREATE VIEW [dbo].[vwClientesRicos]
AS
SELECT * 
FROM [Cliente]
WHERE Vl_Salario >= 30000.00
GO

--	EXEMPLO 1 - VIEW 
SELECT * 
FROM [dbo].[vwClientesRicos]

SELECT * 
FROM [dbo].[vwClientesRicos]
WHERE Nm_Cliente LIKE 'F%'

GO

--	EXEMPLO 2 - HABILITAR O PLANO E MOSTRAR AS TABELAS ENVOLVIDAS
SELECT * 
FROM [Cliente]
WHERE Vl_Salario >= 30000.00

SELECT * 
FROM [dbo].[vwClientesRicos]


--	EXEMPLO 3 - VIEW x ALTERACAO EM TABELAS
--	ROTINA EXISTENTE NA APLICAÇÃO PARA RETORNAR ALGUNS CLIENTES USANDO A VIEW

DROP TABLE IF EXISTS #TEMP_CLIENTE
GO

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL
)

INSERT INTO #TEMP_CLIENTE
SELECT * FROM [dbo].[vwClientesRicos]

--	RETORNA NA TELA DA APLICACAO
SELECT * FROM #TEMP_CLIENTE


--	INCLUI UMA NOVA COLUNA NA TABELA
ALTER TABLE [dbo].[Cliente]
ADD Dt_Nascimento DATE NULL

SELECT * FROM [dbo].[Cliente]

SELECT * FROM [dbo].[vwClientesRicos]

EXEC sp_refreshview 'vwClientesRicos'

SELECT * FROM [dbo].[vwClientesRicos]


-- EXECUTAR NOVAMENTE O PROCEDIMENTO DA TELA DA APLICAÇÃO
DROP TABLE IF EXISTS #TEMP_CLIENTE

CREATE TABLE #TEMP_CLIENTE (
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC (9,2) NOT NULL
)

INSERT INTO #TEMP_CLIENTE
SELECT * FROM [dbo].[vwClientesRicos]

--	RETORNA NA TELA DA APLICACAO
SELECT * FROM #TEMP_CLIENTE

/*
Msg 213, Level 16, State 1, Line 520
Column name or number of supplied values does not match table definition.
*/

--	REMOVENDO A COLUNA
ALTER TABLE [dbo].[Cliente]
DROP COLUMN Dt_Nascimento

--	 EXECUTAR NOVAMENTE A VIEW
SELECT * FROM [dbo].[vwClientesRicos]

/*
Msg 4502, Level 16, State 1, Line 521
View or function 'dbo.vwClientesRicos' has more column names specified than columns defined.
*/

EXEC sp_refreshview 'vwClientesRicos'

--	 EXECUTAR NOVAMENTE A VIEW
SELECT * FROM [dbo].[vwClientesRicos]