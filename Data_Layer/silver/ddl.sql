-- Garante que começamos do zero (Idempotência)
DROP TABLE IF EXISTS imoveis_silver;

-- Cria a tabela com nomes em PORTUGUÊS e restrição NOT NULL (Zero Nulos)
CREATE TABLE imoveis_silver (
    imobiliaria VARCHAR(255) NOT NULL DEFAULT 'Não Informado',
    preco NUMERIC(15, 2) NOT NULL,      -- antigo price
    quartos INTEGER NOT NULL,           -- antigo bed
    banheiros INTEGER NOT NULL,         -- antigo bath
    area_terreno DOUBLE PRECISION NOT NULL DEFAULT 0, -- antigo acre_lot
    rua VARCHAR(255) NOT NULL DEFAULT 'Não Informado', -- antigo street
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    cep VARCHAR(20) NOT NULL DEFAULT '00000',
    area_construida DOUBLE PRECISION NOT NULL -- antigo house_size
);