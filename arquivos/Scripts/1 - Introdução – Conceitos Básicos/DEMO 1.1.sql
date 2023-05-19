---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRAN�A LIMA
--	BLOG: https://luizlima.net/

--	1 - Introdu��o � Conceitos B�sicos
--	DEMO 1.1:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	SQL Server � Vers�es x Edi��es
---------------------------------------------------------------------------------------------------------------

--	1) Falar sobre as diferentes Vers�es do SQL Server
--	2) Comentar sobre a diferen�a entre as Edi��es do link abaixo:
--	https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-version-15?view=sql-server-ver15

--	3) Como validar a Vers�o x Edi��o do meu SQL Server? 

SELECT @@VERSION

/*
Microsoft SQL Server 2019 (RTM-CU10) (KB5001090) - 15.0.4123.1 (X64)   
Mar 22 2021 18:10:24   Copyright (C) 2019 Microsoft Corporation  
Developer Edition (64-bit) on Windows 10 Home 10.0 <X64> (Build 19042: ) 
*/

--	4) Comentar sobre UPGRADE e DOWNGRADE de vers�o / edi��o do SQL Server

--	5) Comentar sobre as vers�es GRATUITAS: Developer e Express


---------------------------------------------------------------------------------------------------------------
--	Service Pack x Cumulative Update
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar os sites abaixo:
--	1.1) Mostrar que a partir do SQL Server 2017 n�o tem mais Service Packs.
--	1.2) Mostrar como baixar um KB espec�fico.

--	https://buildnumbers.wordpress.com/sqlserver/

--	https://sqlserverbuilds.blogspot.com/

--	https://www.catalog.update.microsoft.com/Home.aspx


---------------------------------------------------------------------------------------------------------------
--	Como instalar o SQL Server Developer?
---------------------------------------------------------------------------------------------------------------

--	Link com o PASSO a PASSO para fazer a Instala��o do SQL Server 2019 Developer Edition:
--	https://computingforgeeks.com/install-sql-server-developer-edition-on-windows-server/



---------------------------------------------------------------------------------------------------------------
--	O que � uma inst�ncia SQL Server?
---------------------------------------------------------------------------------------------------------------

--	1) Um servidor pode ter mais de uma inst�ncia. (mostrar o Configuration Manager com v�rias inst�ncias) 
--	2) Apenas uma inst�ncia pode ser definida como �default�. (mostrar a Inst�ncia Default no Configuration Manager)
--	3) Cada inst�ncia � completamente independente em termos de seguran�a e armazenamento de dados.
--	4) Os recursos do servidor ser�o compartilhados por suas inst�ncias. 
--	   Por exemplo: CPU, mem�ria e disco (I/O). (mostrar o Task Maganer, "Max Server Memory" e "Affinity Mask")


---------------------------------------------------------------------------------------------------------------
--	SSMS (SQL Server Management Studio)
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar rapidamente o SSMS e principais funcionalidades


---------------------------------------------------------------------------------------------------------------
--	Como conectar no SQL Server
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar como conectar com "Windows Authentication"
--	2) Mostrar como conectar com "SQL Server Authentication"
--	3) Mostrar os Erros de Conex�o mais comuns:
--		-> Digitar uma senha errada (usu�rio "teste").
--		-> Alterar a Database Default do usu�rio "teste".
--		-> Desabilitar o Servi�o do SQL Server 2019 no Configuration Manager.