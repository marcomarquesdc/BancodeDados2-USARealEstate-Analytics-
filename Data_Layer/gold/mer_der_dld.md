# Documentação do Modelo de Dados  
## Data Warehouse – Camada Gold (Imobiliária)

Este documento descreve o **modelo dimensional da Camada Gold** do Data Warehouse da Imobiliária.  
A Camada Gold representa o nível mais refinado dos dados, sendo projetada especificamente para **análises analíticas, relatórios gerenciais e consumo por ferramentas de Business Intelligence (BI)**.

---

## 1. Objetivo da Camada Gold

A Camada Gold tem como principais objetivos:

- Consolidar dados já tratados e integrados das camadas anteriores.
- Fornecer uma visão analítica orientada ao negócio.
- Otimizar consultas analíticas (OLAP).
- Facilitar a criação de dashboards, indicadores e relatórios estratégicos.

Neste contexto, o foco do modelo é a **análise de vendas e características de imóveis**, permitindo cruzamentos por localização, imobiliária e perfil do imóvel.

---

## 2. Visão Geral da Arquitetura

O modelo foi desenvolvido utilizando a arquitetura **Star Schema (Esquema Estrela)**, amplamente adotada em Data Warehouses por sua simplicidade e eficiência analítica.

### Características do Star Schema

- **Tabela Fato central**, contendo métricas quantitativas do negócio.
- **Tabelas Dimensão desnormalizadas**, fornecendo contexto descritivo.
- Relacionamentos simples (1:N) entre dimensões e fato.
- Consultas com poucos JOINs e alta performance.

### Fato de Negócio

- **Fato analisado:** Vendas / características econômicas de imóveis.

---

## 3. Diagrama Conceitual do Modelo

O modelo é composto por uma tabela fato (`fat_ven`) conectada a três dimensões:

- `dim_loc` — Dimensão Localização
- `dim_imb` — Dimensão Imobiliária
- `dim_car` — Dimensão Característica do Imóvel

> O diagrama segue o padrão visual do **BR Modelo**, com identificação clara de chaves primárias (PK), chaves estrangeiras (FK) e uso de chaves substitutas (SRK).

---

## 4. Detalhamento dos Componentes do Modelo

## 4.1. Tabela Fato — `fat_ven` (Fato Vendas)

A tabela `fat_ven` é o **núcleo do modelo dimensional**.  
Ela armazena os valores numéricos que representam o desempenho e as características quantitativas dos imóveis.

### Função
- Centralizar as métricas de negócio.
- Relacionar os contextos de localização, imobiliária e características do imóvel.

### Granularidade
- **Um registro por imóvel/venda**, associado a uma única combinação de localização, imobiliária e perfil do imóvel.

### Estrutura

| Tipo | Coluna | Descrição |
|-----|--------|-----------|
| FK | `srk_loc` | Referência à dimensão de localização (`dim_loc`). |
| FK | `srk_imb` | Referência à dimensão de imobiliária (`dim_imb`). |
| FK | `srk_car` | Referência à dimensão de característica (`dim_car`). |
| Métrica | `val_prc` | Valor absoluto do preço do imóvel. |
| Métrica | `val_prc_m2` | Preço por metro quadrado (métrica derivada). |
| Métrica | `num_are_con` | Área construída do imóvel (m²). |
| Métrica | `num_are_ter` | Área total do terreno (m²). |

---

## 4.2. Tabelas Dimensão

As tabelas dimensão fornecem o **contexto descritivo** que permite analisar as métricas sob diferentes perspectivas.

---

### 4.2.1. `dim_loc` — Dimensão Localização

Define **onde o imóvel está localizado**.

### Granularidade
- Uma combinação única de:
  - Cidade
  - Estado
  - Rua
  - CEP

Imóveis com exatamente o mesmo endereço compartilham a mesma chave substituta (`srk_loc`).

### Estrutura

| Coluna | Descrição |
|------|-----------|
| `srk_loc` (PK) | Chave substituta da localização. |
| `nom_cid` | Nome da cidade. |
| `sgl_est` | Sigla do estado (UF). |
| `nom_rua` | Nome da rua ou logradouro. |
| `cod_cep` | Código postal (CEP). |

---

### 4.2.2. `dim_imb` — Dimensão Imobiliária

Define **quem está vendendo ou anunciando o imóvel**.

### Granularidade
- Uma imobiliária/corretora única.

### Estrutura

| Coluna | Descrição |
|------|-----------|
| `srk_imb` (PK) | Chave substituta da imobiliária. |
| `nom_imb` | Nome da imobiliária. |

---

### 4.2.3. `dim_car` — Dimensão Característica do Imóvel

Define **o que é o imóvel**, considerando seu perfil físico.

### Granularidade
- Um perfil único baseado na combinação de:
  - Número de quartos
  - Número de banheiros

### Estrutura

| Coluna | Descrição |
|------|-----------|
| `srk_car` (PK) | Chave substituta do perfil do imóvel. |
| `num_qrt` | Quantidade de quartos. |
| `num_bnh` | Quantidade de banheiros. |
| `des_seg` | Segmento do imóvel (ex.: Compacto, Familiar, Alto Padrão). |

---

## 5. Decisões de Design e Padrões Adotados

### 5.1. Uso de Surrogate Keys (SRK)

Todas as dimensões utilizam **chaves substitutas artificiais** (`SERIAL`) como chave primária.

#### Justificativas:
- Independência em relação às chaves naturais dos sistemas de origem.
- Melhor desempenho em JOINs.
- Facilidade para evolução do modelo.
- Suporte futuro a **Slowly Changing Dimensions (SCD)**.

---

### 5.2. Convenção de Nomenclatura

Foi adotado um padrão consistente para facilitar leitura, manutenção e entendimento do modelo:

| Prefixo | Significado |
|------|------------|
| `fat_` | Tabela fato |
| `dim_` | Tabela dimensão |
| `srk_` | Surrogate Key |
| `nom_` | Atributos descritivos (texto) |
| `val_` | Valores monetários |
| `num_` | Valores numéricos e quantitativos |
| `cod_` | Códigos |
| `sgl_` | Siglas |

---

## 6. Exemplos de Análises Possíveis

Com este modelo dimensional, é possível responder perguntas de negócio como:

1. Qual o **preço médio por metro quadrado** por cidade?
2. Qual imobiliária possui o **maior volume financeiro de vendas**?
3. Como o preço médio varia entre imóveis de **diferentes perfis de quartos e banheiros**?
4. Qual o segmento de imóvel mais valorizado em cada estado?
5. Qual a distribuição de preços por área construída?

---

## 7. Considerações Finais

O modelo da Camada Gold foi projetado para ser:

- Simples de entender.
- Altamente performático.
- Alinhado às boas práticas de Data Warehousing.
- Adequado para análises estratégicas e operacionais.

Sua estrutura em Star Schema garante escalabilidade, clareza e eficiência no suporte à tomada de decisão.
