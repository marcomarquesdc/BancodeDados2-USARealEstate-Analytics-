# Modelo Conceitual de Dados (MER) Camada Silver

**BancoDeDados2: USA Real Estate Analytics**

## 1. Introdução

Este documento apresenta o **Modelo Conceitual de Dados (MER)** da **Camada Silver** do projeto _USA Real Estate Analytics_, desenvolvido no contexto da disciplina **Banco de Dados II**.

A Camada Silver segue os princípios da **Arquitetura Medallion**, adotando uma **estrutura desnormalizada**, na qual os dados provenientes da camada RAW são tratados, padronizados e consolidados em uma **tabela única**, pronta para consumo analítico.

Essa abordagem tem como objetivo facilitar a análise exploratória e o processamento posterior na Camada Gold, reduzindo a complexidade estrutural e garantindo maior confiabilidade e consistência dos dados.

---

## 2. Objetivo e Escopo

O objetivo deste **Modelo Entidade-Relacionamento (MER)** é descrever a **entidade central e única** que representa os dados tratados do mercado imobiliário dos Estados Unidos na Camada Silver.

A entidade modelada consolida informações relacionadas a:

- Características dos imóveis (preço, área, número de quartos e banheiros);
- Informações da imobiliária responsável;
- Dados de localização geográfica (rua anonimizada, cidade, estado e código postal).

A decisão arquitetural de concentrar todos os dados tratados em uma única entidade (`IMOVEL_SILVER`) visa atender aos seguintes propósitos:

- **Simplificação de Consultas:** Reduzir a necessidade de operações de _JOIN_, facilitando o uso por analistas de dados;
- **Performance:** Otimizar o tempo de resposta para consultas analíticas, com dados previamente unificados;
- **Visão Analítica:** Disponibilizar um registro completo por imóvel, permitindo análises diretas e comparativas entre atributos físicos, financeiros e geográficos.

Essa modelagem está alinhada às boas práticas de projetos analíticos, onde a Camada Silver atua como base confiável para geração de métricas, relatórios e análises avançadas na Camada Gold.

## 3. Entidade Principal da Camada Silver

A entidade **IMOVEL_SILVER** constitui o núcleo da Camada Silver do projeto _USA Real Estate Analytics_.  
Ela consolida, em uma única estrutura desnormalizada, todos os dados tratados e padronizados oriundos da camada RAW, permitindo rastreabilidade da origem dos dados e facilidade de uso analítico.

A tabela a seguir descreve todos os atributos da entidade, seus tipos conceituais, origem para fins de rastreabilidade e suas respectivas descrições conceituais.

| Atributo            | Tipo de Dado (Conceitual) | Rastreabilidade                     | Descrição Conceitual                                                                                         |
| ------------------- | ------------------------- | ----------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **imobiliaria**     | Texto                     | Origem: Dataset Kaggle (Broker)     | Nome da imobiliária ou corretora responsável pelo anúncio do imóvel.                                         |
| **preco**           | Numérico                  | Origem: Dataset Kaggle (Price)      | Valor de venda do imóvel, representado em moeda corrente.                                                    |
| **quartos**         | Inteiro                   | Origem: Dataset Kaggle (Bed)        | Quantidade de quartos disponíveis no imóvel.                                                                 |
| **banheiros**       | Inteiro                   | Origem: Dataset Kaggle (Bath)       | Quantidade de banheiros disponíveis no imóvel.                                                               |
| **area_terreno**    | Numérico Real             | Origem: Dataset Kaggle (Acre Lot)   | Área total do terreno onde o imóvel está localizado. Valor zero indica imóveis sem lote (ex.: apartamentos). |
| **rua**             | Texto                     | Origem: Dataset Kaggle (Street)     | Endereço do imóvel, armazenado de forma anonimizada para preservar privacidade.                              |
| **cidade**          | Texto                     | Origem: Dataset Kaggle (City)       | Nome da cidade onde o imóvel está localizado.                                                                |
| **estado**          | Texto                     | Origem: Dataset Kaggle (State)      | Nome do estado norte-americano onde o imóvel se encontra.                                                    |
| **cep**             | Texto                     | Origem: Dataset Kaggle (Zip Code)   | Código postal (ZIP Code) associado à localização do imóvel.                                                  |
| **area_construida** | Numérico Real             | Origem: Dataset Kaggle (House Size) | Área construída do imóvel, utilizada para análises comparativas de tamanho e valor.                          |

Essa entidade fornece uma **visão analítica completa** de cada imóvel, permitindo análises diretas sobre preços, características físicas e localização geográfica, sem a necessidade de junções adicionais entre tabelas.

# Diagrama Entidade-Relacionamento (DER) Camada Silver

**BancoDeDados2: USA Real Estate Analytics**

## 1. Introdução

O Diagrama Entidade-Relacionamento (DER) da **Camada Silver** evidencia a simplificação do modelo conceitual para uma **estrutura desnormalizada**, composta por uma **única entidade central**.

Nesta camada, não há definição de relacionamentos, cardinalidades ou entidades auxiliares, uma vez que todo o contexto necessário para análises analíticas do mercado imobiliário já se encontra materializado na tabela `IMOVEL_SILVER`. Essa abordagem está alinhada com o objetivo da Camada Silver dentro da Arquitetura Medallion, que prioriza dados tratados, padronizados e prontos para consumo.

---

## 2. Estrutura do Diagrama

O DER da Camada Silver apresenta exclusivamente a entidade **IMOVEL_SILVER** e seus respectivos atributos descritivos.

Optou-se por manter a representação lógica reduzida, uma vez que não existem vínculos entre entidades a serem representados. Todos os atributos físicos, financeiros e geográficos do imóvel estão consolidados em uma única estrutura, garantindo simplicidade, desempenho e facilidade de análise para as camadas posteriores (Gold).

A representação visual do diagrama será apresentada na seção subsequente, evidenciando apenas a entidade principal e seus atributos.

![der](Data_Layer/silver/assets/merder.png)

# Diagrama Lógico de Dados (DLD) — Camada Silver

**BancoDeDados2 — USA Real Estate Analytics**

## 1. Introdução

Este documento descreve o **Diagrama Lógico de Dados (DLD)** da **Camada Silver** do projeto _USA Real Estate Analytics_.  
Nesta camada, adota-se uma **arquitetura de tabela única e desnormalizada**, cujo objetivo é disponibilizar dados tratados, padronizados e prontos para consumo analítico.

O foco da Camada Silver está na **definição clara das colunas**, seus tipos de dados, restrições de domínio e rastreabilidade da informação, garantindo qualidade, consistência e suporte às cargas analíticas da Camada Gold.

---

## 2. Tabela `imoveis_silver`

A tabela `imoveis_silver` armazena os dados consolidados do mercado imobiliário dos Estados Unidos após o processo de ETL da Camada RAW para a Camada Silver.

Cada registro representa um **imóvel individual**, combinando informações financeiras, estruturais e geográficas em uma única linha, eliminando a necessidade de junções adicionais para análises exploratórias.

Nesta camada, **restrições físicas de chave estrangeira não são aplicadas**, uma vez que a modelagem é desnormalizada. Entretanto, os atributos são mantidos para fins de **rastreabilidade**, padronização e como **chaves de negócio** para enriquecimentos futuros na Camada Gold.

---

## 3. Estrutura Lógica da Tabela

| Nome                | Definição Lógica                             | Tipo SQL         | Restrições de Domínio | Lineage (Origem Camada RAW) |
| ------------------- | -------------------------------------------- | ---------------- | --------------------- | --------------------------- |
| **imobiliaria**     | Nome da imobiliária responsável pelo anúncio | VARCHAR(255)     | NOT NULL              | broker                      |
| **preco**           | Valor de venda do imóvel                     | NUMERIC(15,2)    | NOT NULL              | price                       |
| **quartos**         | Quantidade de quartos do imóvel              | INTEGER          | NOT NULL              | bed                         |
| **banheiros**       | Quantidade de banheiros do imóvel            | INTEGER          | NOT NULL              | bath                        |
| **area_terreno**    | Área total do terreno do imóvel              | DOUBLE PRECISION | NOT NULL              | acre_lot                    |
| **rua**             | Endereço do imóvel (anonimizado)             | VARCHAR(255)     | NOT NULL              | street                      |
| **cidade**          | Cidade onde o imóvel está localizado         | VARCHAR(100)     | NOT NULL              | city                        |
| **estado**          | Estado onde o imóvel está localizado         | VARCHAR(50)      | NOT NULL              | state                       |
| **cep**             | Código postal do imóvel                      | VARCHAR(20)      | NOT NULL              | zip_code                    |
| **area_construida** | Área construída do imóvel                    | DOUBLE PRECISION | NOT NULL              | house_size                  |

---

## 4. Considerações de Modelagem

- A tabela `imoveis_silver` segue o princípio de **desnormalização controlada**, característico da Camada Silver.
- Todas as colunas possuem restrição `NOT NULL`, assegurando a qualidade e completude dos dados tratados.
- Os tipos de dados foram definidos considerando:
  - **Precisão financeira** (`NUMERIC`) para valores monetários;
  - **Flexibilidade dimensional** (`DOUBLE PRECISION`) para áreas;
  - **Integridade semântica** para atributos textuais.
- A rastreabilidade (`lineage`) permite identificar claramente a origem de cada atributo na Camada RAW, facilitando auditorias e evoluções do pipeline de dados.

Essa estrutura lógica serve como base confiável para agregações, métricas e análises avançadas na **Camada Gold**.
