from pydantic import BaseModel, EmailStr, validator, Field
from typing import Optional
from datetime import datetime, date, time
from enum import Enum

class EstadoReserva(str, Enum):
    pendiente = "pendiente"
    confirmada = "confirmada"
    cancelada = "cancelada"
    completada = "completada"

# Esquemas para Usuario
class UsuarioBase(BaseModel):
    nombre: str = Field(..., description="Nombre del usuario", example="Juan", max_length=100)
    apellidos: str = Field(..., description="Apellidos del usuario", example="Pérez García", max_length=100)
    email: EmailStr = Field(..., description="Email del usuario", example="juan@example.com")
    telefono: Optional[str] = Field(None, description="Teléfono del usuario", example="+573001234567", max_length=20)

class UsuarioCreate(UsuarioBase):
    contraseña: str = Field(..., description="Contraseña del usuario (mínimo 6 caracteres)", example="password123", min_length=6)

    @validator('contraseña')
    def password_strength(cls, v):
        if len(v) < 6:
            raise ValueError('La contraseña debe tener al menos 6 caracteres')
        return v

class UsuarioUpdate(BaseModel):
    nombre: Optional[str] = Field(None, description="Nombre del usuario", example="Juan Carlos", max_length=100)
    apellidos: Optional[str] = Field(None, description="Apellidos del usuario", example="Pérez Rodríguez", max_length=100)
    email: Optional[EmailStr] = Field(None, description="Email del usuario", example="juan.carlos@example.com")
    telefono: Optional[str] = Field(None, description="Teléfono del usuario", example="+573001111111", max_length=20)

class UsuarioResponse(UsuarioBase):
    id_usuario: int = Field(..., description="ID único del usuario", example=1)
    fecha_registro: datetime = Field(..., description="Fecha de registro del usuario", example="2024-01-15T10:30:00")
    activo: bool = Field(..., description="Estado de activación del usuario", example=True)
    
    class Config:
        from_attributes = True

class UsuarioLogin(BaseModel):
    email: EmailStr = Field(..., description="Email del usuario", example="juan@example.com")
    contraseña: str = Field(..., description="Contraseña del usuario", example="password123")

# Esquemas para Reserva
class ReservaBase(BaseModel):
    fecha_reserva: date = Field(..., description="Fecha de la reserva (YYYY-MM-DD)", example="2024-12-25")
    hora_reserva: time = Field(..., description="Hora de la reserva (HH:MM)", example="19:30")
    num_personas: int = Field(..., description="Número de personas (1-20)", example=4, ge=1, le=20)
    comentarios: Optional[str] = Field(None, description="Comentarios adicionales para la reserva", example="Mesa cerca de la ventana")

    @validator('num_personas')
    def validate_num_personas(cls, v):
        if v <= 0 or v > 20:
            raise ValueError('El número de personas debe estar entre 1 y 20')
        return v

class ReservaCreate(ReservaBase):
    pass

class ReservaUpdate(BaseModel):
    fecha_reserva: Optional[date] = Field(None, description="Fecha de la reserva (YYYY-MM-DD)", example="2024-12-26")
    hora_reserva: Optional[time] = Field(None, description="Hora de la reserva (HH:MM)", example="20:00")
    num_personas: Optional[int] = Field(None, description="Número de personas (1-20)", example=6, ge=1, le=20)
    comentarios: Optional[str] = Field(None, description="Comentarios adicionales para la reserva", example="Actualizado: necesitamos más espacio")
    estado_reserva: Optional[EstadoReserva] = Field(None, description="Estado de la reserva", example="confirmada")

    @validator('num_personas')
    def validate_num_personas(cls, v):
        if v is not None and (v <= 0 or v > 20):
            raise ValueError('El número de personas debe estar entre 1 y 20')
        return v

class ReservaResponse(ReservaBase):
    id_reserva: int = Field(..., description="ID único de la reserva", example=1)
    id_usuario: int = Field(..., description="ID del usuario que creó la reserva", example=1)
    estado_reserva: EstadoReserva = Field(..., description="Estado actual de la reserva", example="pendiente")
    fecha_creacion: datetime = Field(..., description="Fecha de creación de la reserva", example="2024-01-15T10:35:00")
    fecha_modificacion: datetime = Field(..., description="Fecha de última modificación", example="2024-01-15T10:35:00")
    
    class Config:
        from_attributes = True

class ReservaWithUser(ReservaResponse):
    usuario: UsuarioResponse

# Esquema para Token JWT
class Token(BaseModel):
    access_token: str = Field(..., description="Token JWT para autenticación", example="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...")
    token_type: str = Field(..., description="Tipo de token", example="bearer")
    usuario: UsuarioResponse

# Respuestas de la API
class APIResponse(BaseModel):
    success: bool = Field(..., description="Indica si la operación fue exitosa", example=True)
    message: str = Field(..., description="Mensaje descriptivo del resultado", example="Operación completada exitosamente")
    data: Optional[dict] = Field(None, description="Datos adicionales de la respuesta")

# Esquema para respuesta de disponibilidad
class DisponibilidadResponse(BaseModel):
    fecha: date = Field(..., description="Fecha consultada", example="2024-12-25")
    horarios_ocupados: list[str] = Field(..., description="Lista de horarios ocupados", example=["19:30", "20:00"])
    horarios_disponibles: list[str] = Field(..., description="Lista de horarios disponibles", example=["12:00", "12:30", "13:00"])

# Esquema para error
class ErrorResponse(BaseModel):
    success: bool = Field(..., description="Indica que la operación falló", example=False)
    message: str = Field(..., description="Mensaje de error", example="Error en la operación")
    error: Optional[str] = Field(None, description="Detalles del error")