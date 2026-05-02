# Imagem base — slim é menor que a padrão (~50MB vs ~1GB)
FROM python:3.12-slim

# Diretório de trabalho dentro do container
WORKDIR /app

# Copia PRIMEIRO o requirements — aproveita o cache do Docker
# Se o código mudar mas o requirements não, o pip não roda de novo
COPY requirements.txt .

# Instala as dependências
RUN pip install --no-cache-dir -r requirements.txt

# Agora copia o resto do código
COPY app/ ./app/

# Porta que a aplicação vai usar
EXPOSE 8000

# Comando que roda quando o container sobe
#CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
CMD ["gunicorn", "app.main:app", \
     "--workers", "2", \
     "--worker-class", "uvicorn.workers.UvicornWorker", \
     "--bind", "0.0.0.0:8000", \
     "--access-logfile", "-", \
     "--error-logfile", "-"]
