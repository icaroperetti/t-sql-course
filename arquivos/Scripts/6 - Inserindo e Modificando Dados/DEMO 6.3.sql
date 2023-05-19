---------------------------------------------------------------------------------------------------------------
--	CRIADO POR: LUIZ VITOR FRANÇA LIMA
--	BLOG: https://luizlima.net/

--	6 - Inserindo e Modificando Dados
--	DEMO 6.3:
---------------------------------------------------------------------------------------------------------------

USE Treinamento_TSQL
GO

---------------------------------------------------------------------------------------------------------------
--	TRIGGERS 
---------------------------------------------------------------------------------------------------------------				
--	Referência
--	https://docs.microsoft.com/pt-br/sql/t-sql/statements/merge-transact-sql?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/sql-server-trigger-para-prevenir-e-impedir-alteracoes-em-tabelas/
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


DROP TABLE IF EXISTS Cliente_Audit

CREATE TABLE Cliente_Audit (
	Id_Audit INT IDENTITY(1,1) NOT NULL,
	Tp_Alteracao CHAR(1) NOT NULL,
	Id_Cliente INT NOT NULL,
	Nm_Cliente VARCHAR(100) NOT NULL,
	Vl_Salario NUMERIC(9,2) NULL
)

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO

--	1) DML TRIGGER x INSERT

--	1.1) TRIGGER x AFTER INSERT
DROP TRIGGER IF EXISTS TrgCliente_Insert
GO
CREATE TRIGGER TrgCliente_Insert
ON Cliente AFTER INSERT
AS
BEGIN 
	INSERT INTO Cliente_Audit (Tp_Alteracao, Id_Cliente, Nm_Cliente, Vl_Salario)
	SELECT 'I', Id_Cliente, Nm_Cliente, Vl_Salario
	FROM inserted
END
GO

--	INSERE UM NOVO CLIENTE
INSERT INTO Cliente (Nm_Cliente, Vl_Salario)
VALUES ('Gustavo Larocca', 5000.00)

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	1.2) TRIGGER x INSTEAD OF INSERT
GO
ALTER TRIGGER TrgCliente_Insert
ON Cliente INSTEAD OF INSERT
AS
BEGIN 
	SELECT 'Não é permitido inserir um novo cliente!'
END
GO

--	INSERE UM NOVO CLIENTE
INSERT INTO Cliente (Nm_Cliente, Vl_Salario)
VALUES ('Raiane Flores', 5000.00)

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit


-- 1.3) HABILITAR / DESABILITAR

--	DESABILITA A TRIGGER
--	OBS: MOSTRAR NO OBJECT_EXPLORER
GO
DISABLE TRIGGER TrgCliente_Insert ON [dbo].Cliente
GO

--	INSERE UM NOVO CLIENTE
INSERT INTO Cliente (Nm_Cliente, Vl_Salario)
VALUES ('Raiane Flores', 5000.00)

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit

--	HABILITA A TRIGGER
GO
ENABLE TRIGGER TrgCliente_Insert ON [dbo].Cliente
GO

--	INSERE UM NOVO CLIENTE
INSERT INTO Cliente (Nm_Cliente, Vl_Salario)
VALUES ('Raiane Flores', 5000.00)


--	2) DML TRIGGER x UPDATE
DROP TRIGGER IF EXISTS TrgCliente_Update
GO
CREATE TRIGGER TrgCliente_Update
ON Cliente AFTER UPDATE
AS
BEGIN 
	INSERT INTO Cliente_Audit (Tp_Alteracao, Id_Cliente, Nm_Cliente, Vl_Salario)
	SELECT 'U', Id_Cliente, Nm_Cliente, Vl_Salario
	FROM inserted	-- Valor Novo  - DEPOIS do UPDATE
	--FROM deleted		-- Valor Antigo - ANTES do UPDATE
END
GO

--	ATUALIZA UM CLIENTE
SELECT * FROM Cliente
SELECT * FROM Cliente_Audit

UPDATE Cliente 
SET Nm_Cliente = 'Gustavo Larocca Gatooo', Vl_Salario = 15000.00
WHERE Nm_Cliente = 'Gustavo Larocca'

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	2.2) TRIGGER x INSTEAD OF UPDATE
GO
ALTER TRIGGER TrgCliente_Update
ON Cliente INSTEAD OF UPDATE
AS
BEGIN 
	SELECT 'Não é permitido atualizar um cliente!'
END
GO

--	ATUALIZA UM CLIENTE
UPDATE Cliente 
SET Nm_Cliente = 'Gustavo Larocca Gatooo', Vl_Salario = 5000.00
WHERE Nm_Cliente = 'Gustavo Larocca Gatooo'

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	3) DML TRIGGER x DELETE
DROP TRIGGER IF EXISTS TrgCliente_Delete
GO
CREATE TRIGGER TrgCliente_Delete
ON Cliente AFTER DELETE
AS
BEGIN 
	INSERT INTO Cliente_Audit (Tp_Alteracao, Id_Cliente, Nm_Cliente, Vl_Salario)
	SELECT 'D', Id_Cliente, Nm_Cliente, Vl_Salario
	FROM deleted
END
GO

--	DELETA UM CLIENTE
SELECT * FROM Cliente
SELECT * FROM Cliente_Audit

DELETE FROM Cliente 
WHERE Nm_Cliente = 'Gustavo Larocca Gatooo'

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	3.2) TRIGGER x INSTEAD OF DELETE
GO
ALTER TRIGGER TrgCliente_Delete
ON Cliente INSTEAD OF DELETE
AS
BEGIN 
	SELECT 'Não é permitido deletar um cliente!'
END
GO

--	DELETA UM CLIENTE
SELECT * FROM Cliente
SELECT * FROM Cliente_Audit

DELETE FROM Cliente 
WHERE Nm_Cliente = 'Raiane Flores'

SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	3.3) Listar as TRIGGERs do Banco de dados
SELECT OBJECT_NAME(parent_id) AS Nm_Tabela, *
FROM sys.triggers


--	3.4) TRIGGER x ROLLBACK 
DROP TRIGGER IF EXISTS TrgCliente_Delete
GO
CREATE TRIGGER TrgCliente_Delete
ON Cliente AFTER DELETE
AS
BEGIN 
	INSERT INTO Cliente_Audit (Tp_Alteracao, Id_Cliente, Nm_Cliente, Vl_Salario)
	SELECT 'D', Id_Cliente, Nm_Cliente, Vl_Salario
	FROM deleted
END
GO

--	DELETA UM CLIENTE
SELECT * FROM Cliente
SELECT * FROM Cliente_Audit

BEGIN TRAN
	DELETE FROM Cliente 
	WHERE Nm_Cliente = 'Raiane Flores'

	SELECT * FROM Cliente
	SELECT * FROM Cliente_Audit

ROLLBACK

--	VALIDA SE FEZ O ROLLBACK
SELECT * FROM Cliente
SELECT * FROM Cliente_Audit
GO


--	3.5) TENTA EXECUTAR DIRETAMENTE UMA TRIGGER
EXEC TrgCliente_Delete

/*
Msg 2812, Level 16, State 62, Line 253
Could not find stored procedure 'TrgCliente_Delete'.
*/
GO


--	EXCLUI AS TRIGGERS
DROP TRIGGER TrgCliente_Insert
DROP TRIGGER TrgCliente_Update
DROP TRIGGER TrgCliente_Delete


--	OBS FINAL: COMENTAR SOBRE TRIGGER x PERFORMANCE!!!


---------------------------------------------------------------------------------------------------------------
--	TRIGGER DDL (DATA DEFINITION LANGUAGE)
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/triggers/ddl-triggers?view=sql-server-ver15
--	https://www.fabriciolima.net/blog/2010/04/11/como-criar-um-controle-de-versao-de-procedures-views-e-functions-no-sql-server/
--	https://www.sqlshack.com/database-level-ddl-trigger-over-the-table/
--	https://www.sqlshack.com/database-level-ddl-triggers-for-views-procedures-and-functions/


---------------------------------------------------------------------------------------------------------------
--	TRIGGER LOGON
---------------------------------------------------------------------------------------------------------------				
--	Referências:
--	https://docs.microsoft.com/pt-br/sql/relational-databases/triggers/logon-triggers?view=sql-server-ver15
--	https://www.dirceuresende.com/blog/como-implementar-auditoria-e-controle-de-logins-no-sql-server-trigger-logon/
---------------------------------------------------------------------------------------------------------------			


---------------------------------------------------------------------------------------------------------------
--	TASK IMPORT / EXPORT 
---------------------------------------------------------------------------------------------------------------				
--	Referência
--	https://docs.microsoft.com/pt-br/sql/integration-services/import-export-data/start-the-sql-server-import-and-export-wizard?view=sql-server-ver15#sql-server-management-studio-ssms
---------------------------------------------------------------------------------------------------------------			

--	EXEMPLO 1 - EXPORT DATA:

--	EXPORTAR OS DADOS DA TABELA "Cliente":

/*
DATA SOURCE: SQL Server Native Client 11.0

INSTÂNCIA: HPSPECTRE\SQL2019

DESTINATION SOURCE: FLAT FILE DESTINATION

-- CRIAR UM NOVO ARQUIVO VAZIO
Caminho Destino: "C:\SQLServer\Clientes.txt"

DATABASE: Treinamento_TSQL

TABELA: Cliente
*/

SELECT * FROM Cliente


--	EXEMPLO 2 - IMPORT DATA:

--	EXECUTAR O SCRIPT ABAIXO PARA DROPAR A TABELA ANTES DA IMPORTAÇÃO!
DROP TABLE IF EXISTS Clientes_Import

/*
DATA SOURCE: FLAT FILE DESTINATION

Caminho Arquivo: "C:\SQLServer\Clientes.txt"

DESTINATION SOURCE: SQL Server Native Client 11.0

INSTÂNCIA: HPSPECTRE\SQL2019

DATABASE: Treinamento_TSQL

TABELA: Clientes_Import
*/

--	FAZER O SELECT ABAIXO PARA CONFERIR O RESULTADO DA IMPORTAÇÃO
SELECT * FROM Clientes_Import