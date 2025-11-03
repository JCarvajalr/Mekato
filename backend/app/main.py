from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.openapi.utils import get_openapi
from app.database import engine
from app import models

# Crear tablas en la base de datos
models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Mekato API",
    description="""
    API para Sistema de Reservas - Mekato
    
    -----------------------------------------
    Características:
    - Gestión de usuarios y autenticación JWT
    - Sistema completo de reservas
    - Documentación interactiva con Swagger
    
    -----------------------------------------
    Autenticación:
    La mayoría de los endpoints requieren autenticación JWT.
    Para obtener un token, use el endpoint `/api/usuarios/login`.
    
    Incluya el token en los headers como:
    ```
    Authorization: Bearer <your_token>
    ```
    -----------------------------------------
    Endpoints principales:
    - **Auth**: Registro, login y gestión de perfil
    - **Reservas**: Crear, listar, actualizar y eliminar reservas
    
    -----------------------------------------
    Códigos de estado:
    - 200: Éxito
    - 400: Solicitud incorrecta
    - 401: No autorizado (token inválido/missing)
    - 404: Recurso no encontrado
    - 422: Error de validación
    """,
    version="1.0.0",
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/licenses/MIT",
    }
)

def custom_openapi():
    if app.openapi_schema:
        return app.openapi_schema
    
    openapi_schema = get_openapi(
        title=app.title,
        version=app.version,
        description=app.description,
        routes=app.routes,
    )
    
    # Agregar seguridad JWT globalmente
    openapi_schema["components"]["securitySchemes"] = {
        "Bearer Auth": {
            "type": "http",
            "scheme": "bearer",
            "bearerFormat": "JWT",
            "description": "Ingrese el token JWT en el formato: Bearer <token>"
        }
    }
    
    # Agregar seguridad global a todos los endpoints que necesitan auth
    for path, methods in openapi_schema["paths"].items():
        for method, details in methods.items():
            # Excluir endpoints públicos de la seguridad
            if any(public_path in path for public_path in [
                "/health", 
                "/", 
                "/api/usuarios/registro", 
                "/api/usuarios/login",
                "/api/reservas/disponibilidad"
            ]):
                continue
            
            # Agregar seguridad a endpoints protegidos
            if "security" not in details:
                details["security"] = [{"Bearer Auth": []}]
    
    app.openapi_schema = openapi_schema
    return app.openapi_schema

app.openapi = custom_openapi

# Configurar CORS para Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Importar rutas
from app.routes import usuarios, reservas, chatbot

app.include_router(usuarios.router)
app.include_router(reservas.router)
app.include_router(chatbot.router)

@app.get(
    "/",
    summary="Raíz de la API",
    description="Endpoint principal que muestra un mensaje de bienvenida",
    response_description="Mensaje de bienvenida"
)
def read_root():
    return {"message": "Bienvenido a la API de Mekato Restaurant"}

@app.get(
    "/health",
    summary="Health Check",
    description="Verifica el estado del servidor y la conectividad",
    response_description="Estado del servidor"
)
def health_check():
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}