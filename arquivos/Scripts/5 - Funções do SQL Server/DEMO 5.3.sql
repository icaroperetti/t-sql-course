---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRAN�A LIMA
--	BLOG: https://luizlima.net/

--	5 - Fun��es do SQL Server
--	DEMO 5.3:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	Mathematical Functions:
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/mathematical-functions-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO
 
---------------------------------------------------------------------------------------------------------------
--	ABS (absolute)
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	ABS ( numeric_expression ) 
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/abs-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT ABS(100)

SELECT ABS(-150)

SELECT ABS(-23.145)


---------------------------------------------------------------------------------------------------------------
--	PI
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/pi-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1 -> 3,14159265358979:
SELECT PI()	

--	EXEMPLO 2 -> 3,14
SELECT CAST(PI() AS NUMERIC(9,2))


---------------------------------------------------------------------------------------------------------------
--	SIN
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	SIN ( float_expression ) -> Valor em "radianos"
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/sin-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	90�
SELECT SIN(1.5708)

SELECT CAST(SIN(1.5708) AS NUMERIC(9,2))

--	30�
SELECT CAST(SIN(0.523599) AS NUMERIC(9,2))


---------------------------------------------------------------------------------------------------------------
--	COS
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	COS ( float_expression ) -> Valor em "radianos"
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/cos-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	0�
SELECT COS(0)

--	60�
SELECT CAST(COS(1.0472) AS NUMERIC(9,2))

--	90�
SELECT CAST(COS(1.5708) AS NUMERIC(9,2))


---------------------------------------------------------------------------------------------------------------
--	TAN
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	TAN ( float_expression ) -> Valor em "radianos"
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/tan-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:

--	0�
SELECT TAN(0)

--	45�
SELECT TAN(0.7853)

SELECT CAST(TAN(0.7853) AS NUMERIC(9,2))


---------------------------------------------------------------------------------------------------------------
--	FLOOR - PISO
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	FLOOR ( numeric_expression )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/floor-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	CEILING - TETO
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	CEILING ( numeric_expression )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/ceiling-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	EXEMPLO 1:
SELECT FLOOR(1.99), CEILING(1.99) 

SELECT FLOOR(2.5), CEILING(2.5) 
SELECT FLOOR(2.5), CEILING(2.1)

SELECT FLOOR(2), CEILING(2)  

SELECT FLOOR(-2), CEILING(-2)

SELECT FLOOR(123.01), CEILING(123.01) 

SELECT FLOOR(-123.45), CEILING(-123.45)

SELECT FLOOR(14568), CEILING(14568)

SELECT FLOOR(0), CEILING(0)
GO  


---------------------------------------------------------------------------------------------------------------
--	POWER
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	POWER ( float_expression , y )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/power-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT POWER(2, 3)

SELECT POWER(2, 4)

SELECT POWER(3, 3)

SELECT POWER(3, 4)


---------------------------------------------------------------------------------------------------------------
--	SQUARE - QUADRADO
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	SQUARE ( float_expression )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/square-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT SQUARE(2)

SELECT SQUARE(3)

SELECT SQUARE(4)


---------------------------------------------------------------------------------------------------------------
--	SQRT - RAIZ QUADRADA
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	SQRT ( float_expression )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/sqrt-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT SQRT(4)

SELECT SQRT(9)

SELECT SQRT(16)

SELECT SQRT(7)

SELECT SQRT(20)

SELECT SQRT(20.54)


---------------------------------------------------------------------------------------------------------------
--	RAND
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	RAND ( [ seed ] )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/rand-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------

--	OBS: RETORNA UM VALOR ALEAT�RIO ENTRE 0 E 1, PODENDO RECEBER TAMB�M UM VALOR COMO �SEMENTE�.

--	EXEMPLO 1:
--	O VALOR MUDA A CADA EXECU��O - EXECUTAR V�RIAS VEZES
SELECT RAND()

--	0,715436657367485
SELECT RAND(100)
SELECT RAND(100)
SELECT RAND(100)

--	0,714654072574641
SELECT RAND(58)
SELECT RAND(58)
SELECT RAND(58)


--	EXEMPLO 2 - EXECUTAR V�RIAS VEZES:
SELECT RAND(100), RAND(), RAND(), RAND()

--	RETORNA UM NUMERO ENTRE 0 e 10
SELECT CAST(RAND() * 10 AS INT)

--	RETORNA UM NUMERO ENTRE 0 e 100
SELECT CAST(RAND() * 100 AS INT)


--	SORTEIO "VICIADO" -> RETORNA SEMPRE O MESMO VALOR -> 71
SELECT CAST(RAND(60) * 100 AS INT)


---------------------------------------------------------------------------------------------------------------
--	ROUND
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	ROUND ( numeric_expression , length [ ,function ] )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/round-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT 
	123.99945,
	ROUND(123.99945, 2),	-- 124.00000
	ROUND(123.99945, 3),	-- 123.99900
	ROUND(123.99945, 4)		-- 123.99950

--	EXEMPLO 2:
SELECT 
	1.4945,
	ROUND(1.4945, 2),	-- 1.4900
	ROUND(1.4945, 3),	-- 1.4950
	ROUND(1.4945, 4),	-- 1.4945
	ROUND(1.4950, 2)	-- 1.5000


---------------------------------------------------------------------------------------------------------------
--	SIGN
---------------------------------------------------------------------------------------------------------------
--	SINTAXE: 
--	SIGN ( numeric_expression )
---------------------------------------------------------------------------------------------------------------
--	Refer�ncia:
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/sign-transact-sql?view=sql-server-ver15
---------------------------------------------------------------------------------------------------------------
--	EXEMPLO 1:
SELECT 
	SIGN(100),
	SIGN(2.4567),
	SIGN(2.4),
	SIGN(2.45),
	SIGN(0),
	SIGN(-2.4567),
	SIGN(-100),
	SIGN(-2.4),
	SIGN(-2.45)

--	EXEMPLO 2 - EXPRESS�ES:
SELECT 
	SIGN(100 + 540),
	SIGN(200 - 500)