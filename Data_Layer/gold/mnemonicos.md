# 1. Resumo da Arquitetura do Pipeline de Dados

## 1.1. Pilar 1: Camada Bronze (Source/Origem)
* **Conceito chave:** Arquivos brutos (CSV) contendo os dados originais de anúncios imobiliários, segmentados por categoria.
* **Artefato Principal:** `imoveis_padrao.csv` e `imoveis_luxo.csv`.

## 1.2. Pilar 2: Camada Prata (Staging/Preparação)
* **Conceito chave:** Limpeza de dados, remoção de outliers, unificação dos arquivos (Padrão + Luxo) e tratamento de nulos.
* **Artefato Principal:** Script `etl_raw_to_silver.ipynb` e tabela `public.imoveis_silver`.

## 1.3. Pilar 3: Camada Gold (Data Warehouse)
* **Conceito chave:** Modelo dimensional (Esquema Estrela) otimizado para BI, com tabelas de dimensão normalizadas e tabelas fato com métricas.
* **Artefato Principal:** Script `etl_silver_to_gold.ipynb` e tabela fato `gold.fat_ven`.

---

# 2. Mnemónicos

## 2.1. Padrões Gerais (Prefixos e Sufixos)
| Mnemónico | Significado |
| :--- | :--- |
| **dim_** | Tabelas de Dimensão |
| **fat_** | Tabelas de Fato |
| **srk_** | Surrogate Key (Chave Artificial Sequencial) |
| **nom_** | Nome descritivo |
| **cod_** | Código identificador (não sequencial) |
| **sgl_** | Sigla (ex: UF) |
| **num_** | Número ou Quantidade (Contagem) |
| **val_** | Valor monetário (Financeiro) |
| **des_** | Descrição ou Classificação |

## 2.2. Siglas Base (Componentes)
| Mnemónico | Significado |
| :--- | :--- |
| **are** | Área (Acres ou SqFt) |
| **bnh** | Banheiros |
| **car** | Característica |
| **cep** | Código Postal (CEP) |
| **cid** | Cidade |
| **con** | Construída (referente à área) |
| **est** | Estado (UF) |
| **imb** | Imobiliária |
| **loc** | Localização |
| **prc** | Preço |
| **qrt** | Quartos |
| **rua** | Rua / Logradouro |
| **seg** | Segmento (ex: Luxo, Padrão) |
| **ter** | Terreno |
| **ven** | Venda |

## 2.3. Glossário Detalhado por Tabela

### 2.3.1 Dimensão Localização (`gold.dim_loc`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_loc** | Surrogate Key da Localização |
| **nom_cid** | Nome da Cidade |
| **sgl_est** | Sigla do Estado (UF) |
| **nom_rua** | Nome da Rua / Logradouro |
| **cod_cep** | Código Postal (CEP) |

### 2.3.2 Dimensão Imobiliária (`gold.dim_imb`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_imb** | Surrogate Key da Imobiliária |
| **nom_imb** | Nome da Imobiliária (Corretora) |

### 2.3.3 Dimensão Característica (`gold.dim_car`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_car** | Surrogate Key da Característica |
| **num_qrt** | Número de Quartos |
| **num_bnh** | Número de Banheiros |
| **des_seg** | Descrição do Segmento (Calculado: Studio, Familiar, Alto Padrão) |

### 2.3.4 Fato Vendas (`gold.fat_ven`)
| Mnemónico | Significado |
| :--- | :--- |
| **srk_loc** | FK para Dimensão Localização |
| **srk_imb** | FK para Dimensão Imobiliária |
| **srk_car** | FK para Dimensão Característica |
| **val_prc** | Valor do Preço de Venda (Absoluto) |
| **val_prc_m2** | Valor do Preço por Unidade de Área (Calculado) |
| **num_are_con** | Número da Área Construída (SqFt - Pés Quadrados) |
| **num_are_ter** | Número da Área do Terreno (Acres) |