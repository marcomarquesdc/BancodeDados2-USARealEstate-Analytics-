-- =============================================================================
-- DDL CAMADA GOLD (DATA WAREHOUSE) - IMOBILIÁRIA
-- Modelo: Star Schema (Fato e Dimensões)
-- Padrão: SRK (Surrogate Key) SERIAL para chaves primárias
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS gold;

-- Limpeza (Ordem reversa de dependência)
DROP TABLE IF EXISTS gold.fat_ven;
DROP TABLE IF EXISTS gold.dim_loc;
DROP TABLE IF EXISTS gold.dim_imb;
DROP TABLE IF EXISTS gold.dim_car;

-------------------------------------
-- 1. DIMENSÕES
-------------------------------------

-- 1.1. Dimensão Localização (DIM_LOC)
-- Granularidade: Combinação única de Endereço
CREATE TABLE gold.dim_loc (
    srk_loc     SERIAL PRIMARY KEY,
    nom_cid     VARCHAR(100) NOT NULL,
    sgl_est     VARCHAR(50) NOT NULL,
    nom_rua     VARCHAR(255) NOT NULL,
    cod_cep     VARCHAR(20) NOT NULL,
    -- Constraint para evitar duplicidade lógica
    UNIQUE (nom_cid, sgl_est, nom_rua, cod_cep)
);

-- 1.2. Dimensão Imobiliária (DIM_IMB)
-- Granularidade: Corretora
CREATE TABLE gold.dim_imb (
    srk_imb     SERIAL PRIMARY KEY,
    nom_imb     VARCHAR(255) NOT NULL,
    UNIQUE (nom_imb)
);

-- 1.3. Dimensão Característica (DIM_CAR)
-- Granularidade: Perfil do Imóvel (Quartos + Banheiros + Segmento)
CREATE TABLE gold.dim_car (
    srk_car     SERIAL PRIMARY KEY,
    num_qrt     INTEGER NOT NULL,
    num_bnh     INTEGER NOT NULL,
    des_seg     VARCHAR(50), -- Segmento (ex: 'Compacto', 'Luxo')
    UNIQUE (num_qrt, num_bnh)
);

-------------------------------------
-- 2. TABELA DE FATO
-------------------------------------

-- Tabela de Fato: Vendas (FAT_VEN)
CREATE TABLE gold.fat_ven (
    -- Chaves Estrangeiras (Surrogate Keys)
    srk_loc     INTEGER NOT NULL REFERENCES gold.dim_loc(srk_loc),
    srk_imb     INTEGER NOT NULL REFERENCES gold.dim_imb(srk_imb),
    srk_car     INTEGER NOT NULL REFERENCES gold.dim_car(srk_car),

    -- Métricas
    val_prc         NUMERIC(15, 2),     -- Preço Absoluto
    val_prc_m2      NUMERIC(15, 2),     -- Preço por m² (Calculado)
    num_are_con     DOUBLE PRECISION,   -- Área Construída
    num_are_ter     DOUBLE PRECISION    -- Área Terreno
);

-- Índices para performance
CREATE INDEX idx_fat_loc ON gold.fat_ven(srk_loc);
CREATE INDEX idx_fat_imb ON gold.fat_ven(srk_imb);
CREATE INDEX idx_fat_car ON gold.fat_ven(srk_car);