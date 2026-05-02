import os
import redis
from fastapi import FastAPI
from sqlalchemy import create_engine, text
from datetime import datetime

app = FastAPI()

# Conexão PostgreSQL — usa o nome do serviço "postgres" como host
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:password@postgres:5432/appdb")
engine = create_engine(DATABASE_URL)

# Conexão Redis — usa o nome do serviço "redis" como host
redis_client = redis.Redis(host="redis", port=6379, decode_responses=True)

@app.get("/")
def root():
    return {"status": "ok", "message": "Stack completa rodando!"}

@app.get("/db")
def test_db():
    with engine.connect() as conn:
        result = conn.execute(text("SELECT version()"))
        version = result.fetchone()[0]
    return {"postgres": version}

@app.get("/cache")
def test_cache():
    hits = redis_client.incr("page_hits")
    return {"page_hits": hits}
