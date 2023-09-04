CREATE DATABASE exerciciotransacao
GO
USE exerciciotransacao
GO
CREATE TABLE produto(
codigo		INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
valor		DECIMAL(7,2)	NOT NULL
PRIMARY KEY(codigo))
GO
CREATE TABLE entrada(
codigo_transacao		INT				NOT NULL,
codigo_produto			INT				NOT NULL,
quantidade				INT				NOT NULL,
valor_total				DECIMAL(7,2)	NOT NULL
PRIMARY KEY(codigo_transacao))
GO
CREATE TABLE saida(
codigo_transacao		INT				NOT NULL,
codigo_produto			INT				NOT NULL,
quantidade				INT				NOT NULL,
valor_total				DECIMAL(7,2)	NOT NULL
PRIMARY KEY(codigo_transacao))

/*
Exercício:
Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido, receba o codigo_transacao,
codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de cada transação de cada produto.
*/

CREATE PROCEDURE sp_inserir_transacao(
    @TipoTransacao VARCHAR(1),
    @CodigoTransacao INT,
    @CodigoProduto INT,
	@NomeProduto VARCHAR(100),
    @Quantidade INT,
	@ValorProduto DECIMAL(7, 2),
	@saida VARCHAR(100) OUTPUT)
AS
DECLARE @ValorTotal DECIMAL(7, 2),
		@Tabela VARCHAR(10),
		@Query VARCHAR(200)
BEGIN
    IF (@TipoTransacao != 'e' AND @TipoTransacao != 's')
    BEGIN
        RAISERROR('Tipo de transação inválido. Use ''e'' para ENTRADA ou ''s'' para SAIDA.', 16, 1)
        RETURN
    END
    SELECT @ValorProduto = valor FROM produto WHERE codigo = @CodigoProduto;
    SET @ValorTotal = @ValorProduto * @Quantidade;
    IF (@TipoTransacao = 'e')
    BEGIN
		SET @tabela = 'entrada'
		SET @Query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@CodigoTransacao AS VARCHAR(10))+','+CAST(@CodigoProduto AS VARCHAR(10))+','+CAST(@Quantidade AS VARCHAR(10))
		+','+CAST(@ValorTotal AS VARCHAR(10))+')'
		INSERT INTO produto VALUES (@CodigoProduto, @NomeProduto, @ValorProduto)
		EXEC (@Query)
		SET @saida = 'Produto deu entrada com sucesso'
    END
    ELSE IF (@TipoTransacao = 's')
    BEGIN
		SET @tabela = 'saida'
		SET @Query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@CodigoTransacao AS VARCHAR(10))+','+CAST(@CodigoProduto AS VARCHAR(10))+','+CAST(@Quantidade AS VARCHAR(10))
		+','+CAST(@ValorTotal AS VARCHAR(10))+')'
		INSERT INTO produto VALUES (@CodigoProduto, @NomeProduto, @ValorProduto)
		EXEC (@Query)
		SET @saida = 'Produto deu saída com sucesso'
    END
END

DECLARE @out1 VARCHAR(100)
EXEC sp_inserir_transacao 'e', 1001, 1001, 'camiseta', 10, 40.0, @out1 OUTPUT
PRINT @out1

DECLARE @out2 VARCHAR(100)
EXEC sp_inserir_transacao 's', 1001, 1001, 'camiseta', 10, 40.0, @out2 OUTPUT
PRINT @out2

DECLARE @out3 VARCHAR(100)
EXEC sp_inserir_transacao 'e', 1002, 1002, 'tenis', 30, 80.0, @out3 OUTPUT
PRINT @out3

DECLARE @out4 VARCHAR(100)
EXEC sp_inserir_transacao 's', 1002, 1002, 'tenis', 30, 80.0, @out4 OUTPUT
PRINT @out4



SELECT * FROM produto
SELECT * FROM entrada
SELECT * FROM saida

DELETE produto
DELETE entrada
DELETE saida

DROP PROCEDURE sp_inserir_transacao






