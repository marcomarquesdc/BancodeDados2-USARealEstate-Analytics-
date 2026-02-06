-- =============================================================================
-- DASHBOARD ANALÍTICO: ESTRATÉGIA E OPORTUNIDADES 
-- Schema: "DW"
-- =============================================================================

-- 1. Market Share e Faturamento Total por Estado 
-- Objetivo: Gera a base para gráfico de pizza/treemap. Visão macro de onde vem a receita.
SELECT 
    l.sgl_est,
    SUM(f.val_prc) AS faturamento_total,
    COUNT(*) AS qtd_vendas
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.sgl_est
ORDER BY faturamento_total DESC;

-- 2. Cidades "Locomotivas": Top 1 de cada Estado 
-- Objetivo: Identificar qual cidade carrega o faturamento do estado nas costas.
SELECT 
    sgl_est, 
    nom_cid, 
    total_vendas
FROM (
    SELECT 
        l.sgl_est, 
        l.nom_cid, 
        SUM(f.val_prc) as total_vendas,
        RANK() OVER (PARTITION BY l.sgl_est ORDER BY SUM(f.val_prc) DESC) as rnk
    FROM "DW".fat_ven f
    JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
    GROUP BY l.sgl_est, l.nom_cid
) t WHERE rnk = 1;

-- 3. Ranking de Preço Médio m² por Cidade 
-- Objetivo: Comparativo de valorização para identificar áreas nobres.
SELECT 
    l.nom_cid, 
    l.sgl_est,
    AVG(f.val_prc_m2) AS media_m2_cidade
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.nom_cid, l.sgl_est
ORDER BY media_m2_cidade DESC 
LIMIT 20;

-- 4. Índice de Adensamento: Construção vs Terreno 
-- Objetivo: Entender se o valor vem da construção ou da terra (localização).
SELECT 
    l.nom_cid,
    AVG(f.val_prc_m2) AS preco_m2_construido,
    AVG(f.val_prc / NULLIF(f.num_are_ter_m2, 0)) AS preco_m2_terreno
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
GROUP BY l.nom_cid
ORDER BY preco_m2_construido DESC;

-- 5. Mix de Segmentos por Estado 
-- Objetivo: Entender o perfil de produto (Ex: SP tem mais Alto Padrão ou Econômico?).
SELECT 
    l.sgl_est,
    c.des_seg,
    COUNT(*) AS total_vendas
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
JOIN "DW".dim_car c ON f.srk_car = c.srk_car
GROUP BY l.sgl_est, c.des_seg;

-- 6. Perfil Típico: Tamanho e Quartos por Cidade 
-- Objetivo: Definir a "cara" do imóvel médio naquela região.
SELECT 
    l.nom_cid,
    AVG(c.num_qrt) AS media_quartos,
    AVG(f.num_are_con_m2) AS area_media_m2
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
JOIN "DW".dim_car c ON f.srk_car = c.srk_car
GROUP BY l.nom_cid;

-- 7. Desvio de Preço: Cidade vs. Média Estadual 
-- Objetivo: Encontrar outliers (quem está barato ou caro em relação ao estado).
WITH MediaEst AS (
    SELECT 
        l.sgl_est, 
        AVG(f.val_prc) as avg_est
    FROM "DW".fat_ven f 
    JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc 
    GROUP BY l.sgl_est
)
SELECT 
    l.nom_cid, 
    l.sgl_est, 
    AVG(f.val_prc) as media_cid, 
    m.avg_est,
    (AVG(f.val_prc) / m.avg_est) - 1 as percentual_desvio
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
JOIN MediaEst m ON l.sgl_est = m.sgl_est
GROUP BY l.nom_cid, l.sgl_est, m.avg_est;

-- 8. Volume de Oportunidades: Imóveis Descontados 
-- Objetivo: Cidades com maior estoque de imóveis 30% abaixo da média global.
SELECT 
    l.nom_cid,
    COUNT(*) AS qtd_imoveis_abaixo_media
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
WHERE f.val_prc < (SELECT AVG(val_prc) * 0.7 FROM "DW".fat_ven)
GROUP BY l.nom_cid
ORDER BY qtd_imoveis_abaixo_media DESC;

-- 9. Predominância de Dormitórios por Cidade 
-- Objetivo: Entender a saturação de tipologias (Solteiros vs Famílias).
SELECT 
    l.nom_cid,
    l.sgl_est,
    c.num_qrt,
    COUNT(*) AS total_imoveis
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
JOIN "DW".dim_car c ON f.srk_car = c.srk_car
GROUP BY l.nom_cid, l.sgl_est, c.num_qrt;

-- 10. Ticket Médio por Quantidade de Quartos e Estado 
-- Objetivo: Analisar o custo de "adicionar um quarto" em cada estado.
SELECT 
    l.sgl_est,
    c.num_qrt,
    ROUND(AVG(f.val_prc), 2) AS preco_medio
FROM "DW".fat_ven f
JOIN "DW".dim_loc l ON f.srk_loc = l.srk_loc
JOIN "DW".dim_car c ON f.srk_car = c.srk_car
GROUP BY l.sgl_est, c.num_qrt
ORDER BY l.sgl_est, c.num_qrt;