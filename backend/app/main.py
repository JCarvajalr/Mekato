from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine
from app import models

# Crear tablas en la base de datos
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Mekato Restaurant API",
    description="API para sistema de reservas del restaurante Mekato",
    version="1.0.0"
)

# Configurar CORS para Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Importar rutas
from app.routes import usuarios, reservas

app.include_router(usuarios.router)
app.include_router(reservas.router)

@app.get("/")
def read_root():
    return {"message": "Bienvenido a la API de Mekato Restaurant"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}