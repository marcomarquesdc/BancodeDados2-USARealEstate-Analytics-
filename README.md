# USA Real Estate Analytics (Grupo 23)
### Análise de Dados do Mercado Imobiliário dos Estados Unidos

Este projeto tem como objetivo realizar uma **análise exploratória completa (EDA)** e estruturada do mercado imobiliário dos Estados Unidos, utilizando um dataset público do Kaggle.  
O trabalho segue uma **arquitetura de dados profissional (Medallion Architecture)**, separando claramente as etapas de ingestão, tratamento e análise dos dados.

---

## Objetivo do Projeto

- Realizar uma **EDA completa** a partir de dados brutos (CSV)
- Identificar problemas de qualidade de dados e documentá-los
- Aplicar processos de **ETL** para limpeza, padronização e enriquecimento
- Armazenar os dados em um **banco de dados relacional**
- Criar análises analíticas e métricas de negócio
- Organizar todo o projeto de forma **reprodutível e profissional**

Este repositório foi estruturado com foco em **boas práticas de Engenharia e Análise de Dados**, simulando um ambiente real de projetos de dados.

---

## Dataset

- **Fonte:** Kaggle  
- **Nome:** USA Real Estate Dataset  
- **Link:** https://www.kaggle.com/datasets/ahmedshahriarsakib/usa-real-estate-dataset  

O dataset contém informações sobre imóveis residenciais nos Estados Unidos, incluindo características como preço, localização, tipo de imóvel e atributos estruturais.

---

## Arquitetura de Dados

O projeto utiliza a **Arquitetura Medallion**, dividida em três camadas principais:

### RAW — Dados Brutos
- Dados armazenados **exatamente como fornecidos pela fonte**
- Nenhum tratamento ou correção
- Foco em exploração inicial e identificação de problemas

### SILVER — Dados Tratados
- Limpeza, padronização e validação dos dados
- Correção de tipos, valores nulos e inconsistências
- Dados confiáveis para análises

### GOLD — Dados Analíticos
- Dados agregados e enriquecidos
- Estrutura voltada para análises de negócio
- Criação de métricas, KPIs e insights

---
## Participantes
|Nome|Matrícula|User|
|----|---------|----|
|Marco Marques|211062197|@marcomarquesdc|
|Bruno Henryque|222024158|@Bgrangeiro|
|Diassis Bezerra|221007985|@Diaxiz|
|André Lopes|211031593||
|Lívia Rodrigues|180105051||

---
## Pipeline de dados
CSV (Kaggle) <br>
   ↓ <br>
RAW (Exploração inicial) <br>
   ↓ <br>
ETL (Raw → Silver) <br>
   ↓ <br>
SILVER (Dados tratados) <br>
   ↓ <br>
ETL (Silver → Gold) <br>
   ↓ <br>
GOLD (Análises e métricas) <br>

---

## Tecnologias Utilizadas

- **Python**
  - Pandas
  - NumPy
  - Matplotlib
  - Seaborn
- **SQL**
  - PostgreSQL
- **Jupyter Notebook**
- **Docker & Docker Compose**
- **Git & GitHub**

---
## Análises Realizadas

Ao longo do projeto, são realizadas análises como:

- Distribuição de preços dos imóveis
- Análise de imóveis por estado e cidade
- Relação entre preço, área construída e número de quartos
- Identificação de regiões mais valorizadas
- Comparações entre tipos de imóveis
- Análises estatísticas descritivas e exploratórias

---

## Como Executar o Projeto

1. Clone o repositório:
```bash
git clone https://github.com/seu-usuario/usa-real-estate-analytics.git
````

## Estrutura do Repositório

```bash
usa-real-estate-analytics/
│
├── Data_Layer/
│   ├── raw/
│   │   ├── dados_brutos.csv
│   │   ├── analytics.ipynb
│   │   └── dicionario_de_dados.pdf
│   │
│   ├── silver/
│   │   ├── ddl.sql
│   │   ├── analytics.ipynb
│   │   └── mer_der_ddl.pdf
│   │
│   └── gold/
│       ├── ddl.sql
│       ├── consultas.sql
│       ├── analytics.ipynb
│       ├── mer_der_ddl.pdf
│       └── mnemonico.pdf
│
├── Transformer/
│   ├── etl_raw_to_silver.ipynb
│   └── etl_silver_to_gold.ipynb
│
├── docker-compose.yml
├── Dockerfile
└── README.md
```
