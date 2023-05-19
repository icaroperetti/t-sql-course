---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	8 - WINDOW FUNCTION
--	DEMO 8.1:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	WINDOW FUNCTIONS
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://www.red-gate.com/simple-talk/sql/learn-sql-server/window-functions-in-sql-server/
--	https://www.red-gate.com/simple-talk/sql/t-sql-programming/introduction-to-t-sql-window-functions/
--	https://www.brentozar.com/sql-syntax-examples/window-function-examples-sql-server/
--	https://portosql.wordpress.com/2018/10/14/funcoes-de-janela-window-functions/

--	(VIDEO - Marcelo Adade) -> MUITO BOM!!! 
--	https://www.dbbits.com.br/sql-server/window-functions-parte-1/
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	WINDOW FUNCTIONS - RANKING:
---------------------------------------------------------------------------------------------------------------				

SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,

	-- WINDOW FUNCTIONS - RANKING:
	ROW_NUMBER() OVER(ORDER BY Vl_Venda) AS [rownum],
	RANK() OVER(ORDER BY Vl_Venda) AS [rank],
	DENSE_RANK() OVER(ORDER BY Vl_Venda) AS [dense_rank],
	NTILE(5) OVER(ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Vl_Venda
--ORDER BY Id_Venda


---------------------------------------------------------------------------------------------------------------
--	ROW_NUMBER():
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1 - ORDENANDO AS MENORES VENDAS NO GERAL:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	ROW_NUMBER() OVER(ORDER BY Vl_Venda) AS [rownum]
FROM Vendas
ORDER BY Vl_Venda


--	EXEMPLO 2 - ORDENANDO AS MENORES VENDAS POR CLIENTE:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	ROW_NUMBER() OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [rownum]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda


--	EXEMPLO 3 - ORDENANDO AS MENORES VENDAS POR CLIENTE EM CADA LOJA:
--	OBS: PODEMOS TER MAIS DE UMA WINDOW FUNCTION NA MESMA QUERY!
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	ROW_NUMBER() OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [rownum],
	ROW_NUMBER() OVER(ORDER BY Vl_Venda) AS [rownum_valor_venda_geral]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


---------------------------------------------------------------------------------------------------------------
--	RANK() E DENSE_RANK():
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1 - ORDENANDO AS MENORES VENDAS NO GERAL:

--	RANK()

-- RANK PELA MENOR VENDA
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	RANK() OVER(ORDER BY Vl_Venda) AS [rank]
FROM Vendas
ORDER BY Vl_Venda

-- RANK PELA MAIOR VENDA
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	RANK() OVER(ORDER BY Vl_Venda DESC) AS [rank]
FROM Vendas
ORDER BY Vl_Venda DESC


--	DENSE_RANK()
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	DENSE_RANK() OVER(ORDER BY Vl_Venda) AS [dense_rank]
FROM Vendas
ORDER BY Vl_Venda


--	EXEMPLO 2 - ORDENANDO AS MENORES VENDAS POR CLIENTE:

--	RANK()
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	RANK() OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [rank]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda

--	DENSE_RANK()
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	DENSE_RANK() OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [dense_rank]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda


--	EXEMPLO 3 - ORDENANDO AS MENORES VENDAS POR CLIENTE EM CADA LOJA:
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	RANK() OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [rank]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda

--	DENSE_RANK()
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	DENSE_RANK() OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [dense_rank]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


---------------------------------------------------------------------------------------------------------------
--	NTILE() - DIVIDE EM GRUPOS:
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1:

--	2 GRUPOS (20 VENDAS CADA)
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(2) OVER(ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Vl_Venda

--	5 GRUPOS (8 VENDAS CADA)
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(5) OVER(ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Vl_Venda

--	10 GRUPOS (4 VENDAS CADA)
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(10) OVER(ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Vl_Venda

--	20 GRUPOS (2 VENDAS CADA)
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(20) OVER(ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Vl_Venda


--	EXEMPLO 2 - AGRUPA O CLIENTE E DEPOIS DIVIDE POR GRUPOS:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(2) OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda

SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	NTILE(4) OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [ntile]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda
GO


---------------------------------------------------------------------------------------------------------------
--	WINDOW FUNCTIONS - AGGREGATE
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,

	-- WINDOW FUNCTIONS - AGGREGATE:
	SUM(Vl_Venda)   OVER(PARTITION BY Id_Cliente ORDER BY Id_Venda) AS [sum],
	COUNT(Vl_Venda) OVER(PARTITION BY Id_Cliente ORDER BY Id_Venda) AS [count],
	AVG(Vl_Venda)   OVER(PARTITION BY Id_Cliente ORDER BY Id_Venda) AS [avg]
FROM Vendas
ORDER BY Id_Cliente, Id_Venda


--	EXEMPLO 2 - VALOR ACUMULADO POR CLIENTE:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	SUM(Vl_Venda) OVER(PARTITION BY Id_Cliente ORDER BY Id_Venda) AS [soma_acumulada],
	
	SUM(Vl_Venda) OVER(
						PARTITION BY Id_Cliente 
						ORDER BY Id_Venda
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
					) AS [soma_acumulada_2],
	
	SUM(Vl_Venda) OVER(
						PARTITION BY Id_Cliente 
						ORDER BY Id_Venda
						ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
					  ) AS [soma_total]
FROM Vendas
ORDER BY Id_Cliente, Id_Venda


--	EXEMPLO 3 - VALOR ACUMULADO GERAL:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	SUM(Vl_Venda) OVER(ORDER BY Id_Venda) AS [soma_acumulada],
	SUM(Vl_Venda) OVER(
						ORDER BY Id_Venda
						ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
					  ) AS [soma_total]
FROM Vendas
ORDER BY Id_Venda
GO


---------------------------------------------------------------------------------------------------------------
--	WINDOW FUNCTIONS - OFFSET:
---------------------------------------------------------------------------------------------------------------				

SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,

	-- WINDOW FUNCTIONS - OFFSET:
	LAG(Vl_Venda)  OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [lag],			-- ANTERIOR
	
	LEAD(Vl_Venda) OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [lead],			-- POSTERIOR
	
	FIRST_VALUE(Vl_Venda) OVER(															-- PRIMEIRO
								PARTITION BY Id_Cliente 
								ORDER BY Vl_Venda
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							  ) AS [first_value],
	
	LAST_VALUE(Vl_Venda) OVER(															-- ÚLTIMO
								PARTITION BY Id_Cliente 
								ORDER BY Vl_Venda
								ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
							  ) AS [last_value]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda


---------------------------------------------------------------------------------------------------------------
--	LAG(): RETORNA O VALOR DO "REGISTRO ANTERIOR"
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1 - ORDENANDO AS MENORES VENDAS POR CLIENTE:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	LAG(Vl_Venda) OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [lag]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda


--	EXEMPLO 2 - ORDENANDO AS MENORES VENDAS POR CLIENTE EM CADA LOJA:
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LAG(Vl_Venda) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lag]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


--	EXEMPLO 3 - BUSCA A SEGUNDA VENDA ANTERIOR
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LAG(Vl_Venda, 2) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lag]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


--	EXEMPLO 4 - BUSCA A TERCEIRA VENDA ANTERIOR
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LAG(Vl_Venda, 3) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lag]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


--	EXEMPLO 5 - INFORMANDO O TERCEIRO PARAMETRO PARA SUBSTITUIR OS VALORES "NULL"
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LAG(Vl_Venda, 3, 0.00) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lag]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


---------------------------------------------------------------------------------------------------------------
--	LEAD(): RETORNA O VALOR DO "REGISTRO POSTERIOR"
---------------------------------------------------------------------------------------------------------------				
--	EXEMPLO 1 - ORDENANDO AS MENORES VENDAS POR CLIENTE:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,
	LEAD(Vl_Venda) OVER(PARTITION BY Id_Cliente ORDER BY Vl_Venda) AS [lead]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda


--	EXEMPLO 2 - ORDENANDO AS MENORES VENDAS POR CLIENTE EM CADA LOJA:
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LEAD(Vl_Venda) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lead]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


--	EXEMPLO 3 - BUSCA A SEGUNDA VENDA POSTERIOR
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LEAD(Vl_Venda, 2) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lead]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda


--	EXEMPLO 4 - BUSCA A TERCEIRA VENDA POSTERIOR
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LEAD(Vl_Venda, 3) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lead]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda
GO


--	EXEMPLO 5 - INFORMANDO O TERCEIRO PARAMETRO PARA SUBSTITUIR OS VALORES "NULL"
SELECT 
	Id_Venda, Id_Cliente, Id_Loja, Vl_Venda,
	LEAD(Vl_Venda, 3, 0.00) OVER(PARTITION BY Id_Cliente, Id_Loja ORDER BY Vl_Venda) AS [lead]
FROM Vendas
ORDER BY Id_Cliente, Id_Loja, Vl_Venda
GO


---------------------------------------------------------------------------------------------------------------
--	FIRST_VALUE(): RETORNA O PRIMEIRO VALOR DA "JANELA"
--	LAST_VALUE() : RETORNA O ÚLTIMO VALOR DA "JANELA"
---------------------------------------------------------------------------------------------------------------	
--	EXEMPLO - BUSCA O VALOR DA MENOR E MAIOR VENDA DO CLIENTE:
SELECT 
	Id_Venda, Id_Cliente, Vl_Venda,

	FIRST_VALUE(Vl_Venda) OVER(
								PARTITION BY Id_Cliente 
								ORDER BY Vl_Venda
								ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
							  ) AS [first_value],

	LAST_VALUE(Vl_Venda) OVER(
								PARTITION BY Id_Cliente 
								ORDER BY Vl_Venda
								ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
							  ) AS [last_value]
FROM Vendas
ORDER BY Id_Cliente, Vl_Venda 
GO