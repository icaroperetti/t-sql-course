---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	5 - Funções do SQL Server
--	DEMO 5.2:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Date Functions:
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/date-and-time-data-types-and-functions-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	GETDATE()
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/getdate-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT GETDATE()		-- 2021-06-26 23:10:42.930

SELECT GETDATE() + 1	-- 2021-06-27 23:10:42.930

SELECT GETDATE() + 3	-- 2021-06-29 23:10:42.930

SELECT GETDATE() - 1	-- 2021-06-25 23:10:42.930

SELECT GETDATE() - 3	-- 2021-06-23 23:10:42.930


---------------------------------------------------------------------------------------------------------------
--	YEAR / MONTH / DAY - Retorna um número INTEIRO!
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	YEAR  ( date )
--	MONTH ( date )
--	DAY   ( date )
---------------------------------------------------------------------------------------------------------------
--	Referências:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/year-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/month-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/day-transact-sql?view=sql-server-ver15

--	https://www.tiagoneves.net/blog/voce-sabe-a-diferenca-entre-uma-consulta-sargable-e-non-sargable/
---------------------------------------------------------------------------------------------------------------
DECLARE @Data DATETIME = '2021-06-26'

--	EXEMPLO 2 - YEAR:
SELECT YEAR(@Data)	-- 2021

--	EXEMPLO 3 - MONTH:
SELECT MONTH(@Data)	-- 6

SELECT RIGHT('00' + CAST(MONTH(@Data) AS VARCHAR), 2)	-- "06"

SELECT FORMAT(MONTH(@Data), '00')						-- "06"

--	EXEMPLO 4 - DAY:
SELECT DAY(@Data)	-- 26
GO


--	EXEMPLO 5 - USANDO VARIÁVEL
DECLARE @VAR_DATA_ATUAL DATETIME = GETDATE()

SELECT
	@VAR_DATA_ATUAL AS Data_Atual,
	YEAR(@VAR_DATA_ATUAL) AS Ano, 
	MONTH(@VAR_DATA_ATUAL) AS Mês, 
	DAY(@VAR_DATA_ATUAL) AS Dia

GO


---------------------------------------------------------------------------------------------------------------
--	DATEPART
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: DATEPART ( datepart , date )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
DECLARE @VAR_DATA_ATUAL DATETIME = GETDATE()

SELECT
	@VAR_DATA_ATUAL AS Data_Atual,
	
	--	DATA
	DATEPART(YEAR, @VAR_DATA_ATUAL) AS Ano, 
	DATEPART(MONTH, @VAR_DATA_ATUAL) AS Mês, 
	DATEPART(DAY, @VAR_DATA_ATUAL) AS Dia,
	DATEPART(DAYOFYEAR, @VAR_DATA_ATUAL) AS DiaDoAno,
	
	--	SEMANA
	DATEPART(WEEK, @VAR_DATA_ATUAL) AS SemanaDoAno,
	DATEPART(WEEKDAY, @VAR_DATA_ATUAL) AS DiaDaSemana,
	
	--	HORÁRIO
	DATEPART(HOUR, @VAR_DATA_ATUAL) AS Hora,
	DATEPART(MINUTE, @VAR_DATA_ATUAL) AS Minuto,
	DATEPART(SECOND, @VAR_DATA_ATUAL) AS Segundo,
	DATEPART(MILLISECOND, @VAR_DATA_ATUAL) AS Milissegundo

GO


--	EXEMPLO 2: ABREVIAÇÃO
DECLARE @VAR_DATA_ATUAL DATETIME = GETDATE()

SELECT
	@VAR_DATA_ATUAL AS Data_Atual,
	
	--	DATA
	DATEPART(yy, @VAR_DATA_ATUAL) AS Ano, 
	DATEPART(mm, @VAR_DATA_ATUAL) AS Mês, 
	DATEPART(dd, @VAR_DATA_ATUAL) AS Dia,
	DATEPART(hh, @VAR_DATA_ATUAL) AS Hora,
	DATEPART(mi, @VAR_DATA_ATUAL) AS Minuto,
	DATEPART(ss, @VAR_DATA_ATUAL) AS Segundo
GO


--	EXEMPLO 3: DIA DA SEMANA
DECLARE @VAR_DATA_ATUAL DATETIME = GETDATE()

SELECT
	DATEPART(WEEKDAY, @VAR_DATA_ATUAL) AS DiaDaSemana,
	
	--	USANDO O CASE
	CASE DATEPART(WEEKDAY, @VAR_DATA_ATUAL)		
		WHEN 2
			THEN 'Segunda-Feira'
		WHEN 3
			THEN 'Terça-Feira'
		WHEN 4
			THEN 'Quarta-Feira'
		WHEN 5
			THEN 'Quinta-Feira'
		WHEN 6
			THEN 'Sexta-Feira'
		WHEN 7
			THEN 'Sábado'
		ELSE
			'Domingo'
	END AS NomeDiaSemana


---------------------------------------------------------------------------------------------------------------
--	DATENAME
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: DATENAME ( datepart , date )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/datename-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
SET LANGUAGE 'English'

--	MÊS
SELECT DATENAME(MONTH, GETDATE())  AS NmMes

--	DIA DA SEMANA
SELECT DATENAME(WEEKDAY, GETDATE())  AS NmDiaSemana

GO

--	EXEMPLO 2:
SET LANGUAGE 'Portuguese'

--	DAY
SELECT DATENAME(DAY, GETDATE()) AS NmDia

--	MÊS
SELECT DATENAME(MONTH, GETDATE()) AS NmMes

--	DIA DA SEMANA
SELECT DATENAME(WEEKDAY, GETDATE()) AS NmDiaSemana

GO
SET LANGUAGE 'English'
GO


---------------------------------------------------------------------------------------------------------------
--	DATEADD
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: DATEADD (datepart , number , date ) 
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/dateadd-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:

SELECT DATEADD(DAY, 1, GETDATE())

SELECT DATEADD(DAY, -1, GETDATE())

SELECT DATEADD(MONTH, -1, GETDATE())

SELECT DATEADD(DAY, -30, '20210830')
SELECT DATEADD(MONTH, -1, '20210830')

SELECT DATEADD(MONTH, -1, '20210731')

GO

--	EXEMPLO 2 - ABREVIAÇÕES:

SELECT DATEADD(DD, 1, GETDATE())

SELECT DATEADD(MM, -1, GETDATE())

SELECT DATEADD(YY, -1, GETDATE())
GO

--	EXEMPLO 3:
DECLARE @VAR_DATA_ATUAL DATETIME = GETDATE()

SELECT 
	@VAR_DATA_ATUAL AS DtAtual,
	DATEADD(MONTH, -6, @VAR_DATA_ATUAL) AS DtUltimoSemestre

GO


--	EXEMPLO 4:
DROP TABLE IF EXISTS Cliente
GO

CREATE TABLE Cliente (
	Id_Cliente INT IDENTITY(1,1) NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Dt_Nascimento DATETIME NOT NULL,
	PRIMARY KEY(Id_Cliente)
)

INSERT INTO Cliente (Nm_Cliente, Dt_Nascimento)
VALUES
	('Luiz Vitor', '19890914'),
	('Fabricio Lima', '19800504'),
	('Rodrigo Gomes', '19701029'),
	('Fabiano Amorim', '19600126')

CREATE NONCLUSTERED INDEX SK01_Dt_Nascimento
ON Cliente(Dt_Nascimento)
INCLUDE(Nm_Cliente)

SELECT * FROM Cliente

--	RETORNA APENAS CLIENTES COM MENOS DE 50 ANOS
--	HABILITAR PLANO DE EXECUCAO
SELECT GETDATE(), DATEADD(YEAR,-50,GETDATE())

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente
WHERE Dt_Nascimento >= DATEADD(YEAR,-50,GETDATE())

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente
WHERE YEAR(Dt_Nascimento) >= 1971
GO

--	USANDO VARIAVEL
DECLARE @Dt_Filtro DATETIME = DATEADD(YEAR,-50,GETDATE())

SELECT Nm_Cliente, Dt_Nascimento
FROM Cliente
WHERE Dt_Nascimento >= @Dt_Filtro

GO


---------------------------------------------------------------------------------------------------------------
--	DATEDIFF E DATEDIFF_BIG
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: DATEDIFF ( datepart , startdate , enddate )
--			 DATEDIFF_BIG ( datepart , startdate , enddate )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/datediff-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/datediff-big-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	DATEDIFF

--	EXEMPLO 1:
SELECT DATEDIFF(MONTH, '20210101', '20210601')

SELECT DATEDIFF(MONTH, '20190101', '20210201')

SELECT DATEDIFF(DAY, '20210101', '20210125')

SELECT DATEDIFF(DAY, '20210125', '20210101')

--	EXEMPLO 2:
SELECT DATEDIFF(SECOND, '19500601', '20210101')

/*
Msg 535, Level 16, State 0, Line 264
The datediff function resulted in an overflow. 
The number of dateparts separating two date/time instances is too large. 
Try to use datediff with a less precise datepart.
*/


--	DATEDIFF_BIG

--	EXEMPLO 3 -- 2227564800:
SELECT DATEDIFF_BIG(SECOND, '19500601', '20210101')


---------------------------------------------------------------------------------------------------------------
--	EOMONTH E ISDATE
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: EOMONTH ( start_date [, month_to_add ] )
--			 ISDATE ( expression )
---------------------------------------------------------------------------------------------------------------
--	Referência:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/eomonth-transact-sql?view=sql-server-ver15
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/isdate-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EOMONTH

--	EXEMPLO 1:
SELECT EOMONTH (GETDATE())

--	EXEMPLO 2:
SELECT EOMONTH ('20210216')


--	ISDATE

--	EXEMPLO 3:
--	AAAA-MM-DD
SELECT ISDATE ('20210216')

--	AAAA-DD-MM - INVALIDO
SELECT ISDATE ('20211602')

SELECT ISDATE ('2021-07-12 19:16:23.830')

SELECT ISDATE ('2021-07-12 19:16')

SELECT ISDATE ('20210216A')

SELECT ISDATE ('123')


--	A LINGUAGEM NAO INFLUENCIA O ISDATE!

--	EXEMPLO 1:
SET LANGUAGE 'Portuguese'
DBCC USEROPTIONS

--	EXEMPLO 2:
SET LANGUAGE 'English'
DBCC USEROPTIONS

GO

--	EXEMPLO 4:
DECLARE @VAR_TESTE VARCHAR(9) = '20210216'

--	VALIDA SE É UMA DATA VÁLIDA
IF ( (ISDATE(@VAR_TESTE)) = 1 )
BEGIN
	SELECT 'A DATA INFORMADA "' + @VAR_TESTE + '" É VÁLIDA!!!'
END
ELSE
BEGIN
	SELECT 'A DATA INFORMADA "' + @VAR_TESTE + '" NÃO É VÁLIDA!!!'
END

SET @VAR_TESTE = '20210216A'

IF ( (ISDATE(@VAR_TESTE)) = 1 )
BEGIN
	SELECT 'A DATA INFORMADA "' + @VAR_TESTE + '" É VÁLIDA!!!'
END
ELSE
BEGIN
	SELECT 'A DATA INFORMADA "' + @VAR_TESTE + '" NÃO É VÁLIDA!!!'
END

GO