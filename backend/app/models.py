from sqlalchemy import Column, Integer, String, DateTime, Text, ForeignKey, Boolean, Enum, Date, Time
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from app.database import Base

class EstadoReserva(enum.Enum):
    pendiente = "pendiente"
    confirmada = "confirmada"
    cancelada = "cancelada"
    completada = "completada"

class Usuario(Base):
    __tablename__ = "usuarios"
    
    id_usuario = Column(Integer, primary_key=True, index=True)
    nombre = Column(String(100), nullable=False)
    apellidos = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, index=True, nullable=False)
    telefono = Column(String(20))
    contraseña_hash = Column(String(255), nullable=False)
    fecha_registro = Column(DateTime(timezone=True), server_default=func.now())
    fecha_ultima_modificacion = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    activo = Column(Boolean, default=True)
    
    # Relación con reservas
    reservas = relationship("Reserva", back_populates="usuario")

class Reserva(Base):
    __tablename__ = "reservas"
    
    id_reserva = Column(Integer, primary_key=True, index=True)
    id_usuario = Column(Integer, ForeignKey("usuarios.id_usuario"), nullable=False)
    fecha_reserva = Column(Date, nullable=False)
    hora_reserva = Column(Time, nullable=False)
    num_personas = Column(Integer, nullable=False)
    comentarios = Column(Text)
    estado_reserva = Column(Enum(EstadoReserva), default=EstadoReserva.pendiente)
    fecha_creacion = Column(DateTime(timezone=True), server_default=func.now())
    fecha_modificacion = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    # Relación con usuario
    usuario = relationship("Usuario", back_populates="reservas")