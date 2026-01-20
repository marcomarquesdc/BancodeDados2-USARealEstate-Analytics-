import pandas as pd
import numpy as np
import os
import time

# caminho da raw pra buscar os dados brutos
base_path = r"C:\TrabalhoBancosVerao\Data Layer\raw"
input_file = os.path.join(base_path, "dados_brutos.csv")

# Caminhos de Saída
output_padrao = os.path.join(base_path, "imoveis_padrao.csv") # < 1 Milhão
output_luxo   = os.path.join(base_path, "imoveis_luxo.csv")   # >= 1 Milhão

print(f"Arquivo carregado: {input_file}")
start_time = time.time()

# ==============================================================================
# 1. CARREGAMENTO E PREPARAÇÃO
# ==============================================================================
try:
    # Lendo como string para preservar ZIP codes e formatação original
    df = pd.read_csv(input_file, dtype=str)
    print(f"O arquivo foi carregado, tamanho: {len(df)}")
except FileNotFoundError:
    print(f"Nao foi possivel localizar o arquivo em: {input_file}")
    exit(1)

# converter 'price' pra numero
# Criar uma coluna temporária '_price_float' para não estragar a original
print("Conversao de precos realizada com sucesso")
df['_price_float'] = pd.to_numeric(df['price'], errors='coerce')

# Remover linhas onde o preço é inválido/nulo (pq não dá para saber se é luxo ou padrão)
df_valid = df.dropna(subset=['_price_float'])
ignored = len(df) - len(df_valid)
if ignored > 0:
    print(f" {ignored} registros ignorados (Preço inválido ou vazio).")

# ==============================================================================
# Dividindo 

print("Dividindo o dataset...")

# Filtro: Casas < 1.000.000
df_padrao = df_valid[df_valid['_price_float'] < 1000000].copy()

# Filtro: Casas >= 1.000.000
df_luxo = df_valid[df_valid['_price_float'] >= 1000000].copy()

# Remove a coluna temporária de ajuda
df_padrao = df_padrao.drop(columns=['_price_float'])
df_luxo = df_luxo.drop(columns=['_price_float'])

# ==============================================================================
# Salvando

print(f"Arquivos salvo em {base_path}")

df_padrao.to_csv(output_padrao, index=False)
print(f"   -> imoveis_padrao.csv: {len(df_padrao)} registros (Mercado Padrão)")

df_luxo.to_csv(output_luxo, index=False)
print(f"   -> imoveis_luxo.csv:   {len(df_luxo)} registros (Mercado de Luxo)")

print(f"\nConcluido")