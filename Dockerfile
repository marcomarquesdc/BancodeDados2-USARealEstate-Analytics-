# Imagem base focada em Data Science (Pandas, Matplotlib, Seaborn já vêm instalados)
FROM jupyter/scipy-notebook:latest

# Troca para root para instalar pacotes do sistema
USER root

# Instala drivers do sistema (para o psycopg2 funcionar sem erros)
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client libpq-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Instala as bibliotecas de conexão com banco
RUN pip install --no-cache-dir sqlalchemy psycopg2-binary ipython-sql

# Configura permissões para que o usuário do Jupyter possa escrever nas pastas montadas
RUN chown -R jovyan:users /home/jovyan/work

# Volta para o usuário padrão do Jupyter
USER jovyan
WORKDIR /home/jovyan/work

# O comando padrão já é iniciar o Jupyter Lab, não precisa mudar
