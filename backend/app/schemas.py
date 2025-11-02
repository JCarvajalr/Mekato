from pydantic import BaseModel, EmailStr, validator
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
    nombre: str
    apellidos: str
    email: EmailStr
    telefono: Optional[str] = None

class UsuarioCreate(UsuarioBase):
    contraseña: str

    @validator('contraseña')
    def password_strength(cls, v):
        if len(v) < 6:
            raise ValueError('La contraseña debe tener al menos 6 caracteres')
        return v

# NUEVO: Esquema para actualizar usuario sin contraseña
class UsuarioUpdate(BaseModel):
    nombre: Optional[str] = None
    apellidos: Optional[str] = None
    email: Optional[EmailStr] = None
    telefono: Optional[str] = None

class UsuarioResponse(UsuarioBase):
    id_usuario: int
    fecha_registro: datetime
    activo: bool
    
    class Config:
        from_attributes = True

class UsuarioLogin(BaseModel):
    email: EmailStr
    contraseña: str

# Esquemas para Reserva
class ReservaBase(BaseModel):
    fecha_reserva: date
    hora_reserva: time
    num_personas: int
    comentarios: Optional[str] = None

    @validator('num_personas')
    def validate_num_personas(cls, v):
        if v <= 0 or v > 20:
            raise ValueError('El número de personas debe estar entre 1 y 20')
        return v

class ReservaCreate(ReservaBase):
    pass

class ReservaUpdate(BaseModel):
    fecha_reserva: Optional[date] = None
    hora_reserva: Optional[time] = None
    num_personas: Optional[int] = None
    comentarios: Optional[str] = None
    estado_reserva: Optional[EstadoReserva] = None

    @validator('num_personas')
    def validate_num_personas(cls, v):
        if v is not None and (v <= 0 or v > 20):
            raise ValueError('El número de personas debe estar entre 1 y 20')
        return v

class ReservaResponse(ReservaBase):
    id_reserva: int
    id_usuario: int
    estado_reserva: EstadoReserva
    fecha_creacion: datetime
    fecha_modificacion: datetime
    
    class Config:
        from_attributes = True

class ReservaWithUser(ReservaResponse):
    usuario: UsuarioResponse

# Esquema para Token JWT
class Token(BaseModel):
    access_token: str
    token_type: str
    usuario: UsuarioResponse

# Respuestas de la API
class APIResponse(BaseModel):
    success: bool
    message: str
    data: Optional[dict] = None