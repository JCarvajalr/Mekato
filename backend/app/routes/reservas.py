from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, date

from app.database import get_db
from app.models import Reserva, Usuario, EstadoReserva
from app.schemas import ReservaCreate, ReservaResponse, ReservaUpdate, APIResponse, EstadoReserva as EstadoReservaSchema
from app import auth

router = APIRouter(prefix="/api/reservas", tags=["reservas"])

@router.post("/", response_model=APIResponse)
def crear_reserva(
    reserva: ReservaCreate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    # Validar fecha (no permitir reservas en fechas pasadas)
    if reserva.fecha_reserva < date.today():
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No se pueden hacer reservas en fechas pasadas"
        )
    
    # Verificar disponibilidad
    reserva_existente = db.query(Reserva).filter(
        Reserva.fecha_reserva == reserva.fecha_reserva,
        Reserva.hora_reserva == reserva.hora_reserva,
        Reserva.estado_reserva.in_([EstadoReserva.pendiente, EstadoReserva.confirmada])
    ).first()
    
    if reserva_existente:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Ya existe una reserva para esa fecha y hora"
        )
    
    # Crear nueva reserva
    db_reserva = Reserva(
        id_usuario=current_user.id_usuario,
        fecha_reserva=reserva.fecha_reserva,
        hora_reserva=reserva.hora_reserva,
        num_personas=reserva.num_personas,
        comentarios=reserva.comentarios,
        estado_reserva=EstadoReserva.pendiente
    )
    
    db.add(db_reserva)
    db.commit()
    db.refresh(db_reserva)
    
    return APIResponse(
        success=True,
        message="Reserva creada exitosamente",
        data={"reserva": ReservaResponse.from_orm(db_reserva)}
    )

@router.get("/", response_model=APIResponse)
def obtener_reservas_usuario(
    skip: int = 0,
    limit: int = 100,
    estado: Optional[EstadoReservaSchema] = None,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    query = db.query(Reserva).filter(Reserva.id_usuario == current_user.id_usuario)
    
    if estado:
        query = query.filter(Reserva.estado_reserva == estado)
    
    reservas = query.order_by(Reserva.fecha_reserva.desc(), Reserva.hora_reserva.desc()).offset(skip).limit(limit).all()
    
    return APIResponse(
        success=True,
        message="Reservas obtenidas exitosamente",
        data={"reservas": [ReservaResponse.from_orm(reserva) for reserva in reservas]}
    )

@router.get("/{reserva_id}", response_model=APIResponse)
def obtener_reserva(
    reserva_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    reserva = db.query(Reserva).filter(
        Reserva.id_reserva == reserva_id,
        Reserva.id_usuario == current_user.id_usuario
    ).first()
    
    if reserva is None:
        raise HTTPException(status_code=404, detail="Reserva no encontrada")
    
    return APIResponse(
        success=True,
        message="Reserva obtenida exitosamente",
        data={"reserva": ReservaResponse.from_orm(reserva)}
    )

@router.put("/{reserva_id}", response_model=APIResponse)
def actualizar_reserva(
    reserva_id: int,
    reserva_update: ReservaUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    db_reserva = db.query(Reserva).filter(
        Reserva.id_reserva == reserva_id,
        Reserva.id_usuario == current_user.id_usuario
    ).first()
    
    if db_reserva is None:
        raise HTTPException(status_code=404, detail="Reserva no encontrada")
    
    # No permitir modificar reservas canceladas o completadas
    if db_reserva.estado_reserva in [EstadoReserva.cancelada, EstadoReserva.completada]:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No se puede modificar una reserva cancelada o completada"
        )
    
    # Actualizar solo los campos que se enviaron
    update_data = reserva_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        if value is not None:  # Solo actualizar si el valor no es None
            setattr(db_reserva, field, value)
    
    db.commit()
    db.refresh(db_reserva)
    
    return APIResponse(
        success=True,
        message="Reserva actualizada exitosamente",
        data={"reserva": ReservaResponse.from_orm(db_reserva)}
    )

@router.delete("/{reserva_id}", response_model=APIResponse)
def eliminar_reserva(
    reserva_id: int,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    reserva = db.query(Reserva).filter(
        Reserva.id_reserva == reserva_id,
        Reserva.id_usuario == current_user.id_usuario
    ).first()
    
    if reserva is None:
        raise HTTPException(status_code=404, detail="Reserva no encontrada")
    
    # ELIMINAR la reserva completamente de la base de datos
    db.delete(reserva)
    db.commit()
    
    return APIResponse(
        success=True,
        message="Reserva eliminada exitosamente",
        data={}
    )
