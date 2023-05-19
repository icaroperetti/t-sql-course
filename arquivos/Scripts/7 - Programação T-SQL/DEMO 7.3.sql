---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	7 - Programação T-SQL
--	DEMO 7.3:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	Tratamento de Erros – TRY...CATCH
---------------------------------------------------------------------------------------------------------------				
--	Referência:
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/try-catch-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-qual-a-diferenca-entre-error-e-error_number/
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1 - TRY ... CATCH:
BEGIN TRY
	SELECT 15 / 2
	
	SELECT 'OI! ESTOU DENTRO DO BLOCO "TRY"!'
END TRY
BEGIN CATCH
	SELECT 'OI! ESTOU DENTRO DO BLOCO "CATCH"!'
END CATCH
GO


--	EXEMPLO 2 - GERANDO UM ERRO NO TRY:
BEGIN TRY
	SELECT 15 / 0
	
	SELECT 'OI! ESTOU DENTRO DO BLOCO "TRY"!'
END TRY
BEGIN CATCH
	SELECT 'OI! ESTOU DENTRO DO BLOCO "CATCH"!'
END CATCH
GO


--	EXEMPLO 3 - GERANDO UM ERRO SEM USAR O TRY ... CATCH:
SELECT 15 / 0
	
SELECT 'OI! ESTOU DEPOIS DA DIVISÃO POR ZERO!'
GO


--	EXEMPLO 4 - ERROR FUNCTIONS: ERROR_NUMBER E ERROR_MESSAGE
BEGIN TRY
	SELECT 15 / 0
	
	SELECT 'OI! ESTOU DENTRO DO BLOCO "TRY"!'
END TRY
BEGIN CATCH
	SELECT 
		ERROR_NUMBER() AS [Error_Number], 
		ERROR_MESSAGE() AS [Error_Message],
		ERROR_SEVERITY() AS [Error_Severity],
		ERROR_STATE() AS [Error_State],
		ERROR_LINE() AS [Error_Line],
		ERROR_PROCEDURE() AS [Error_Procedure]
END CATCH
GO


--	EXEMPLO 5 - TRATAMENTO DE ERROS:
BEGIN TRY
	--	ERRO 1 - Divisão por zero
	SELECT 15 / 0

	--	ERRO 2 - ARITHMETIC OVERFLOW
	--DECLARE @Valor TINYINT = 1000000
	
	--	ERRO 3 - ARITHMETIC OVERFLOW
	--DECLARE @Cliente TABLE (Nome VARCHAR(6)) 
	
	--INSERT INTO @Cliente(Nome) 
	--VALUES ('Luiz Vitor')

	--SELECT 'OI! ESTOU DENTRO DO BLOCO "TRY"!'
END TRY
BEGIN CATCH
	-- TRATAMENTO DO ERRO!
	SELECT 
		CASE ERROR_NUMBER()

			WHEN 8134	--	Divide by zero error encountered.
				THEN 'O ERRO FOI UMA DIVISÃO POR ZERO! FAVOR VERIFICAR O VALOR DO DENOMINADOR DA DIVISÃO!'

			WHEN 220	--	Arithmetic overflow error for data type tinyint
				THEN 'O ERRO FOI UM ARITHMETIC OVERFLOW! FAVOR VERIFICAR OS VALORES QUE FORAM UTILIZADOS!'

			WHEN 2628	--	String or binary data would be truncated in table
				THEN 'O ERRO FOI UMA STRING TRUNCADA! FAVOR VERIFICAR OS VALORES QUE FORAM UTILIZADOS!'

			ELSE
				'ERRO AINDA NÃO TRATADO! FAVOR INFORMAR AO SUPORTE DE TI!'
		END

	--	ERROR FUNCTIONS
	SELECT 
		ERROR_NUMBER() AS [Error_Number], 
		ERROR_MESSAGE() AS [Error_Message],
		ERROR_SEVERITY() AS [Error_Severity],
		ERROR_STATE() AS [Error_State],
		ERROR_LINE() AS [Error_Line],
		ERROR_PROCEDURE() AS [Error_Procedure]
END CATCH
GO


--	EXEMPLO 6 - USANDO O THROW:
--	Referência:	
--	https://pedrogalvaojunior.wordpress.com/2014/07/22/aplicando-tratamento-de-erros-no-microsoft-sql-server-2012-e-2014-utilizando-o-comando-throw/
--	https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/throw-transact-sql?view=sql-server-ver15

BEGIN TRY
	SELECT 15 / 0
	
	SELECT 'OI! ESTOU DENTRO DO BLOCO "TRY"!'
END TRY
BEGIN CATCH	
	THROW
END CATCH
GO

/*
Msg 8134, Level 16, State 1, Line 117
Divide by zero error encountered.
*/
GO


--	EXEMPLO 7 - @@ERROR:
--	Referência:	

--	7.1) SEM ERRO
SELECT 1 

SELECT @@ERROR
GO

--	7.2) COM ERRO
SELECT 1 / 0

SELECT @@ERROR
GO

--	7.3) DEVE USAR O @@ERROR SEMPRE APÓS O COMANDO!
SELECT 1 / 0

SELECT 1

SELECT @@ERROR
GO


---------------------------------------------------------------------------------------------------------------
--	Dynamic SQL
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/system-stored-procedures/sp-executesql-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 - sp_executesql:
EXEC sp_executesql N'SELECT * FROM Cliente'
GO


--	EXEMPLO 2 - EXEC:
EXEC (N'SELECT * FROM Cliente')

--	QUERY AD-HOC -> CADA UMA DAS TRÊS QUERIES ABAIXO VAI GERAR UM PLANO DIFERENTE!
EXEC (N'SELECT * FROM Cliente WHERE Nm_Cliente = ''Fabrício Lima''')

EXEC (N'SELECT * FROM Cliente WHERE Nm_Cliente = ''Luiz Lima''')

EXEC (N'SELECT * FROM Cliente WHERE Nm_Cliente = ''Fabiano Amorim''')
GO

SELECT * FROM Cliente WHERE Nm_Cliente = 'Fabrício Lima'


--	EXEMPLO 3 - sp_executesql COM PARAMETRO:

--	QUERY PARAMETRIZADA -> VAI REUTILIZAR O PLANO!
EXEC sp_executesql 
	@stmt = N'SELECT * FROM Cliente WHERE Nm_Cliente = @Nm_Cliente',
	@params = N'@Nm_Cliente AS VARCHAR(100)',
	@Nm_Cliente = 'Fabrício Lima'

EXEC sp_executesql 
	@stmt = N'SELECT * FROM Cliente WHERE Nm_Cliente = @Nm_Cliente',
	@params = N'@Nm_Cliente AS VARCHAR(100)',
	@Nm_Cliente = 'Luiz Lima'

EXEC sp_executesql 
	@stmt = N'SELECT * FROM Cliente WHERE Nm_Cliente = @Nm_Cliente',
	@params = N'@Nm_Cliente AS VARCHAR(100)',
	@Nm_Cliente = 'Fabiano Amorim'
GO


--	EXEMPLO 4 - Tarefas Administrativas
--	OBS 1:	COPIAR O RESULTADO DO SELECT ABAIXO EM OUTRA QUERY E EXECUTAR!
--	OBS 2:	ATALHOS:
--			CTRL + T -> RESULTADO NO FORMATO DE TEXTO
--			CTRL + D -> RESULTADO NO FORMATO DE GRID

SELECT	
	'BACKUP DATABASE ' + [name] + ' TO DISK = ''C:\SQLServer\Backup\' 
	+ [name] + '.bak'' WITH COMPRESSION, CHECKSUM, INIT' AS Ds_Comando
FROM sys.databases
WHERE [name] NOT IN ('tempdb')
ORDER BY [name]
GO


--	EXEMPLO 5 - EXECUTANDO UM COMANDO EM VARIOS BANCOS DE DADOS:
--	OBS: A PROCEDURE "sp_msforeachdb" NÃO É DOCUMENTADA PELA MICROSOFT!
--	Referência:
--	https://www.dirceuresende.com/blog/executando-um-comando-em-todos-os-databases-da-instancia-no-sql-server/

--	RETORNA O NOME DO BANCO DE DADOS
SELECT DB_NAME()

EXEC sp_msforeachdb 'USE [?]; SELECT DB_NAME()'


--	RETORNA O TAMANHO DO BANCO DE DADOS
EXEC sp_spaceused

EXEC sp_msforeachdb 'USE [?]; EXEC sp_spaceused'
GO


--	EXEMPLO 6 - SQL INJECTION x SEGURANÇA:
--	Referência:
--	https://www.dirceuresende.com/blog/sql-server-como-evitar-sql-injection-pare-de-utilizar-query-dinamica-como-execquery-agora/

GO
DROP PROCEDURE IF EXISTS stpSQL_Injection_NotSafe
GO
CREATE PROCEDURE stpSQL_Injection_NotSafe
	@Nm_Cliente VARCHAR(100)
AS
BEGIN
	DECLARE @Ds_Comando NVARCHAR(500) = ''

	SELECT @Ds_Comando += 'SELECT * FROM Cliente WHERE Nm_Cliente = ''' +  @Nm_Cliente + ''''

	EXEC (@Ds_Comando)
END
GO


--	6.1) EXECUTANDO A PROCEDURE
EXEC stpSQL_Injection_NotSafe @Nm_Cliente = 'Luiz Lima'
GO


--	6.2) FAZENDO UM SQL INJECTION SIMPLES
--	ENCONTRANDO UMA BRECHA
EXEC stpSQL_Injection_NotSafe @Nm_Cliente = '''; SELECT 1 --'

--	DESCOBRINDO O NOME DOS BANCOS DE DADOS!
EXEC stpSQL_Injection_NotSafe @Nm_Cliente = '''; SELECT * FROM sys.databases --'

--	DESCOBRINDO O NOME DOS USUÁRIOS!
EXEC stpSQL_Injection_NotSafe @Nm_Cliente = '''; SELECT * FROM sys.syslogins --'

--	CUIDADO: DESCOBRINDO ESSAS BRECHAS, O HACKER PODE FAZER O QUE QUISER COM O SEU BANCO DE DADOS!!!
GO


--	6.3) EVITANDO O SQL INJECTION - USE PARÂMETROS AO INVÉS DE CONCATENAR TEXTO!!!
GO
DROP PROCEDURE IF EXISTS stpSQL_Injection_Safe
GO
CREATE PROCEDURE stpSQL_Injection_Safe
	@Nm_Cliente VARCHAR(100)
AS
BEGIN
	EXEC sp_executesql
		@stmt = N'SELECT * FROM Cliente WHERE Nm_Cliente = @nome',
		@params = N'@nome AS VARCHAR(100)',
		@nome = @Nm_Cliente
END
GO

--	EXECUTANDO A PROCEDURE
EXEC stpSQL_Injection_Safe @Nm_Cliente = 'Luiz Lima'
GO

--	FAZENDO UM SQL INJECTION SIMPLES
EXEC stpSQL_Injection_Safe @Nm_Cliente = ''';SELECT 1 --'

EXEC stpSQL_Injection_Safe @Nm_Cliente = ''';SELECT * FROM sys.databases --'