<center>

# Dicionário de Dados - Real Estate (Versão Segmentada)

</center>

---

<center>

# O que é?

</center>

> Este documento serve como a documentação oficial para os datasets imobiliários do projeto. Ele descreve a estrutura dos arquivos de dados segmentados (`imoveis_padrao.csv` e `imoveis_luxo.csv`), explicando cada elemento, seus tipos e regras de negócio aplicadas. A estrutura de colunas é idêntica para ambos os segmentos.

<div style="margin: 0 auto; width: fit-content;">

| Datasets (Origem) | Tabela Unificada (Destino) |
|:--- |:--- |
| `imoveis_padrao.csv` (Mercado < 1M) | [Schema Imóvel](#schema-imovel) |
| `imoveis_luxo.csv` (Mercado >= 1M) | [Schema Imóvel](#schema-imovel) |

</div>

---

# Schema Imovel

| | |
| :--- | :--- |
| **Descrição** | Estrutura de dados padrão utilizada para armazenar informações de propriedades imobiliárias, tanto do segmento Padrão quanto do segmento de Luxo. |
| **Segmentação** | **Padrão:** Imóveis com preço < 1.000.000.<br>**Luxo:** Imóveis com preço >= 1.000.000. |
| **Observações** | Colunas como `street` e `brokered_by` são numéricas (anonimizadas). A coluna `prev_sold_date` pode conter valores nulos para imóveis novos ou sem histórico registrado. |

| Nome | Definição Lógica | Tipo (CSV) | Tipo (Banco) | Restrições / Regras |
| :--- | :--- | :--- | :--- | :--- |
| `brokered_by` | Identificador numérico da agência/corretora. | Float/Int | DECIMAL | Pode ser Nulo. |
| `status` | Estado atual do imóvel ('for_sale', 'sold'). | String | VARCHAR(20) | Obrigatório. Filtramos apenas 'for_sale' no ETL. |
| `price` | Valor de venda do imóvel. | Float | DECIMAL(12,2) | **Padrão:** < 1M<br>**Luxo:** >= 1M |
| `bed` | Número de quartos. | Float/Int | SMALLINT | Nulos convertidos para 0 no ETL. Máx: 20. |
| `bath` | Número de banheiros. | Float/Int | SMALLINT | Nulos convertidos para 0 no ETL. Máx: 20. |
| `acre_lot` | Tamanho do terreno em acres. | Float | DECIMAL(10,2) | Nulos convertidos para 0.0 (Apartamentos). Máx: 10k. |
| `street` | Identificador numérico da rua/endereço. | Float/Int | DECIMAL | Pode ser Nulo. |
| `city` | Nome da cidade (Formatado em Title Case). | String | VARCHAR(100) | Obrigatório. |
| `state` | Nome do estado ou província. | String | VARCHAR(100) | Obrigatório. |
| `zip_code` | Código postal (CEP). | String | VARCHAR(10) | Mantido como string para preservar zeros à esquerda. |
| `house_size` | Área construída do imóvel (sqft). | Float | DECIMAL(10,2) | Entre 100 e 30.000 sqft. |
| `prev_sold_date` | Data da última venda registrada. | String | DATE | Geralmente removida no processo Silver se irrelevante. |

---

<center>

# Histórico de Versão

</center>

<div style="margin: 0 auto; width: fit-content;">

| Data | Versão | Descrição | Autor |
| :---: | :---: | :--- | :--- |
| 11/01/2026 | `1.0` | Criação inicial do dicionário. | [Diassis](https://github.com/Diaxiz) |

</div>