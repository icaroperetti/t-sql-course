---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	1 - Introdução – Conceitos Básicos
--	DEMO 1.1:
---------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------
--	SQL Server – Versões x Edições
---------------------------------------------------------------------------------------------------------------

--	1) Falar sobre as diferentes Versões do SQL Server
--	2) Comentar sobre a diferença entre as Edições do link abaixo:
--	https://docs.microsoft.com/en-us/sql/sql-server/editions-and-components-of-sql-server-version-15?view=sql-server-ver15

--	3) Como validar a Versão x Edição do meu SQL Server? 

SELECT @@VERSION

/*
Microsoft SQL Server 2019 (RTM-CU10) (KB5001090) - 15.0.4123.1 (X64)   
Mar 22 2021 18:10:24   Copyright (C) 2019 Microsoft Corporation  
Developer Edition (64-bit) on Windows 10 Home 10.0 <X64> (Build 19042: ) 
*/

--	4) Comentar sobre UPGRADE e DOWNGRADE de versão / edição do SQL Server

--	5) Comentar sobre as versões GRATUITAS: Developer e Express


---------------------------------------------------------------------------------------------------------------
--	Service Pack x Cumulative Update
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar os sites abaixo:
--	1.1) Mostrar que a partir do SQL Server 2017 não tem mais Service Packs.
--	1.2) Mostrar como baixar um KB específico.

--	https://buildnumbers.wordpress.com/sqlserver/

--	https://sqlserverbuilds.blogspot.com/

--	https://www.catalog.update.microsoft.com/Home.aspx


---------------------------------------------------------------------------------------------------------------
--	Como instalar o SQL Server Developer?
---------------------------------------------------------------------------------------------------------------

--	Link com o PASSO a PASSO para fazer a Instalação do SQL Server 2019 Developer Edition:
--	https://computingforgeeks.com/install-sql-server-developer-edition-on-windows-server/



---------------------------------------------------------------------------------------------------------------
--	O que é uma instância SQL Server?
---------------------------------------------------------------------------------------------------------------

--	1) Um servidor pode ter mais de uma instância. (mostrar o Configuration Manager com várias instâncias) 
--	2) Apenas uma instância pode ser definida como “default”. (mostrar a Instância Default no Configuration Manager)
--	3) Cada instância é completamente independente em termos de segurança e armazenamento de dados.
--	4) Os recursos do servidor serão compartilhados por suas instâncias. 
--	   Por exemplo: CPU, memória e disco (I/O). (mostrar o Task Maganer, "Max Server Memory" e "Affinity Mask")


---------------------------------------------------------------------------------------------------------------
--	SSMS (SQL Server Management Studio)
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar rapidamente o SSMS e principais funcionalidades


---------------------------------------------------------------------------------------------------------------
--	Como conectar no SQL Server
---------------------------------------------------------------------------------------------------------------

--	1) Mostrar como conectar com "Windows Authentication"
--	2) Mostrar como conectar com "SQL Server Authentication"
--	3) Mostrar os Erros de Conexão mais comuns:
--		-> Digitar uma senha errada (usuário "teste").
--		-> Alterar a Database Default do usuário "teste".
--		-> Desabilitar o Serviço do SQL Server 2019 no Configuration Manager.