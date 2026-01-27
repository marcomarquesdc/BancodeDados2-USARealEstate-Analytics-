-- CONSULTAS DE ANÁLISE (IMOBILIÁRIA GOLD)
-- Padrão: CTEs + Joins + Agregações

-- 1. Top 10 Cidades com o Metro Quadrado Mais Caro
-- Objetivo: Identificar as áreas mais valorizadas.
WITH CityAvg AS (
    SELECT 
        l.nom_cid,
        l.sgl_est,
        AVG(f.val_prc_m2) as media_m2
    FROM gold.fat_ven f
    JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
    GROUP BY l.nom_cid, l.sgl_est
)
SELECT * FROM CityAvg ORDER BY media_m2 DESC LIMIT 10;

-- 2. Ranking de Faturamento por Imobiliária
-- Objetivo: Quem são os maiores players do mercado?
WITH Faturamento AS (
    SELECT 
        i.nom_imb,
        SUM(f.val_prc) as total_vendido,
        COUNT(*) as qtd_imoveis
    FROM gold.fat_ven f
    JOIN gold.dim_imb i ON f.srk_imb = i.srk_imb
    GROUP BY i.nom_imb
)
SELECT * FROM Faturamento ORDER BY total_vendido DESC LIMIT 10;

-- 3. Comparativo: Alto Padrão vs Padrão Familiar (Segmento)
-- Objetivo: Analisar a diferença de preço médio entre os segmentos criados no ETL.
SELECT 
    c.des_seg AS segmento,
    COUNT(*) AS volume_vendas,
    ROUND(AVG(f.val_prc), 2) AS preco_medio,
    ROUND(AVG(f.num_are_con), 2) AS tamanho_medio_m2
FROM gold.fat_ven f
JOIN gold.dim_car c ON f.srk_car = c.srk_car
GROUP BY c.des_seg
ORDER BY preco_medio DESC;

-- 4. Oportunidades: Imóveis abaixo do preço médio da cidade
-- Uso de Window Function na CTE
WITH MediaCidade AS (
    SELECT 
        l.srk_loc, 
        AVG(f.val_prc) OVER (PARTITION BY l.nom_cid) as media_cidade_ref
    FROM gold.fat_ven f
    JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
),
Oportunidades AS (
    SELECT 
        l.nom_cid,
        f.val_prc,
        mc.media_cidade_ref,
        (mc.media_cidade_ref - f.val_prc) as desconto_relativo
    FROM gold.fat_ven f
    JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
    JOIN MediaCidade mc ON f.srk_loc = mc.srk_loc
    WHERE f.val_prc < (mc.media_cidade_ref * 0.7) -- 30% abaixo da média
)
SELECT DISTINCT * FROM Oportunidades LIMIT 20;

-- 5. Cidades com maior oferta de Mansões (> 5 quartos)
WITH Mansoes AS (
    SELECT f.srk_loc
    FROM gold.fat_ven f
    JOIN gold.dim_car c ON f.srk_car = c.srk_car
    WHERE c.num_qrt >= 5
)
SELECT 
    l.nom_cid,
    l.sgl_est,
    COUNT(*) as qtd_mansoes
FROM Mansoes m
JOIN gold.dim_loc l ON m.srk_loc = l.srk_loc
GROUP BY l.nom_cid, l.sgl_est
ORDER BY qtd_mansoes DESC LIMIT 10;

-- 6. Ticket Médio por Estado
SELECT 
    l.sgl_est,
    AVG(f.val_prc) as ticket_medio,
    SUM(f.val_prc) as volume_total
FROM gold.fat_ven f
JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.sgl_est
ORDER BY ticket_medio DESC;

-- 7. Eficiência de Área: Preço vs Tamanho do Terreno
-- Onde o terreno vale mais?
WITH TerrenoStats AS (
    SELECT 
        l.nom_cid,
        AVG(f.val_prc / NULLIF(f.num_are_ter, 0)) as preco_por_acre
    FROM gold.fat_ven f
    JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
    WHERE f.num_are_ter > 0
    GROUP BY l.nom_cid
)
SELECT * FROM TerrenoStats ORDER BY preco_por_acre DESC LIMIT 10;

-- 8. Tipologia Mais Comum (Moda de Quartos/Banheiros)
SELECT 
    c.num_qrt,
    c.num_bnh,
    COUNT(*) as frequencia
FROM gold.fat_ven f
JOIN gold.dim_car c ON f.srk_car = c.srk_car
GROUP BY c.num_qrt, c.num_bnh
ORDER BY frequencia DESC LIMIT 5;

-- 9. Top 3 Cidades por Estado (Window Function Rank)
WITH RankingCidade AS (
    SELECT 
        l.sgl_est,
        l.nom_cid,
        SUM(f.val_prc) as total_vendas,
        RANK() OVER (PARTITION BY l.sgl_est ORDER BY SUM(f.val_prc) DESC) as rank_est
    FROM gold.fat_ven f
    JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
    GROUP BY l.sgl_est, l.nom_cid
)
SELECT * FROM RankingCidade WHERE rank_est <= 3;

-- 10. Relatório Executivo Completo (Denormalizado)
SELECT 
    l.sgl_est AS Estado,
    l.nom_cid AS Cidade,
    i.nom_imb AS Corretora,
    c.des_seg AS Segmento,
    SUM(f.val_prc) AS Total_Vendido,
    AVG(f.val_prc_m2) AS Preco_M2_Medio
FROM gold.fat_ven f
JOIN gold.dim_loc l ON f.srk_loc = l.srk_loc
JOIN gold.dim_imb i ON f.srk_imb = i.srk_imb
JOIN gold.dim_car c ON f.srk_car = c.srk_car
GROUP BY l.sgl_est, l.nom_cid, i.nom_imb, c.des_seg
ORDER BY Total_Vendido DESC
LIMIT 50;