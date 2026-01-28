-- =============================================================================
-- DDL CAMADA GOLD (DATA WAREHOUSE) - IMOBILIÁRIA
-- Schema: "DW" (Maiúsculo)
-- =============================================================================

CREATE SCHEMA IF NOT EXISTS "DW";

-- Limpeza
DROP TABLE IF EXISTS "DW".fat_ven CASCADE;
DROP TABLE IF EXISTS "DW".dim_loc CASCADE;
DROP TABLE IF EXISTS "DW".dim_imb CASCADE;
DROP TABLE IF EXISTS "DW".dim_car CASCADE;

-------------------------------------
-- 1. DIMENSÕES
-------------------------------------

-- 1.1. Dimensão Localização
CREATE TABLE "DW".dim_loc (
    srk_loc     SERIAL PRIMARY KEY,
    nom_cid     VARCHAR(100),
    sgl_est     VARCHAR(50),
    nom_rua     VARCHAR(255),
    cod_cep     VARCHAR(20),
    UNIQUE (nom_cid, sgl_est, nom_rua, cod_cep)
);

-- 1.2. Dimensão Imobiliária
CREATE TABLE "DW".dim_imb (
    srk_imb     SERIAL PRIMARY KEY,
    nom_imb     VARCHAR(255),
    UNIQUE (nom_imb)
);

-- 1.3. Dimensão Característica
CREATE TABLE "DW".dim_car (
    srk_car     SERIAL PRIMARY KEY,
    num_qrt     INTEGER,
    num_bnh     INTEGER,
    des_seg     VARCHAR(50), 
    UNIQUE (num_qrt, num_bnh)
);

-------------------------------------
-- 2. TABELA DE FATO
-------------------------------------

-- Tabela de Fato: Vendas (FAT_VEN)
CREATE TABLE "DW".fat_ven (
    srk_loc     INTEGER REFERENCES "DW".dim_loc(srk_loc),
    srk_imb     INTEGER REFERENCES "DW".dim_imb(srk_imb),
    srk_car     INTEGER REFERENCES "DW".dim_car(srk_car),

    val_prc         NUMERIC(15, 2),     -- Preço Absoluto
    val_prc_m2      NUMERIC(15, 2),     -- Preço por m² (Calculado)
    num_are_con_m2  DOUBLE PRECISION,   -- Área Construída (m²)
    num_are_ter_m2  DOUBLE PRECISION    -- Área Terreno (m²)
);