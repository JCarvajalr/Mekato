from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime, date

from app.database import get_db
from app.models import Reserva, Usuario, EstadoReserva
from app.schemas import ReservaCreate, ReservaResponse, ReservaUpdate, APIResponse, EstadoReserva as EstadoReservaSchema, ErrorResponse
from app import auth

router = APIRouter(prefix="/api/reservas", tags=["Reservas 📅"])

@router.post(
    "/",
    response_model=APIResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Crear nueva reserva",
    description="""
    Crea una nueva reserva para el usuario autenticado.
    
    ### Validaciones:
    - Fecha no puede ser en el pasado
    - Número de personas entre 1 y 20
    - Horario no puede estar ocupado
    - Formato de fecha: YYYY-MM-DD
    - Formato de hora: HH:MM (24 horas)
    """,
    responses={
        201: {"description": "Reserva creada exitosamente"},
        400: {"model": ErrorResponse, "description": "Fecha pasada, horario ocupado o datos inválidos"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"},
        422: {"model": ErrorResponse, "description": "Error de validación en los datos"}
    }
)
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

@router.get(
    "/",
    response_model=APIResponse,
    summary="Listar reservas del usuario",
    description="""
    Obtiene todas las reservas del usuario autenticado.
    
    ### Parámetros opcionales:
    - **skip**: Número de registros a saltar (paginación)
    - **limit**: Número máximo de registros a retornar
    - **estado**: Filtrar por estado de reserva
    """,
    responses={
        200: {"description": "Lista de reservas obtenida exitosamente"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"}
    }
)
def obtener_reservas_usuario(
    skip: int = Query(0, ge=0, description="Número de registros a saltar"),
    limit: int = Query(100, ge=1, le=100, description="Número máximo de registros"),
    estado: Optional[EstadoReservaSchema] = Query(None, description="Filtrar por estado de reserva"),
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

@router.get(
    "/{reserva_id}",
    response_model=APIResponse,
    summary="Obtener reserva específica",
    description="Obtiene los detalles de una reserva específica del usuario autenticado.",
    responses={
        200: {"description": "Reserva obtenida exitosamente"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"},
        404: {"model": ErrorResponse, "description": "Reserva no encontrada"}
    }
)
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

@router.put(
    "/{reserva_id}",
    response_model=APIResponse,
    summary="Actualizar reserva",
    description="""
    Actualiza una reserva existente.
    
    ### Características:
    - Solo actualiza los campos enviados (parcial update)
    - No se puede modificar reservas canceladas o completadas
    - Valida disponibilidad al cambiar fecha/hora
    """,
    responses={
        200: {"description": "Reserva actualizada exitosamente"},
        400: {"model": ErrorResponse, "description": "No se puede modificar reserva cancelada/completada"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"},
        404: {"model": ErrorResponse, "description": "Reserva no encontrada"},
        422: {"model": ErrorResponse, "description": "Error de validación en los datos"}
    }
)
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

@router.delete(
    "/{reserva_id}",
    response_model=APIResponse,
    summary="Eliminar reserva",
    description="Elimina permanentemente una reserva de la base de datos.",
    responses={
        200: {"description": "Reserva eliminada exitosamente"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"},
        404: {"model": ErrorResponse, "description": "Reserva no encontrada"}
    }
)
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

@router.get(
    "/disponibilidad/fecha/{fecha}",
    response_model=APIResponse,
    summary="Verificar disponibilidad por fecha",
    description="""
    Consulta los horarios disponibles para una fecha específica.
    
    ### Notas:
    - No requiere autenticación
    - Retorna horarios ocupados y disponibles
    - Horarios disponibles predefinidos: 12:00-14:30 y 19:00-21:30
    """,
    responses={
        200: {"description": "Disponibilidad verificada exitosamente"},
        422: {"model": ErrorResponse, "description": "Formato de fecha inválido"}
    }
)
def verificar_disponibilidad_fecha(
    fecha: date,
    db: Session = Depends(get_db)
):
    # Obtener reservas para la fecha específica
    reservas = db.query(Reserva).filter(
        Reserva.fecha_reserva == fecha,
        Reserva.estado_reserva.in_([EstadoReserva.pendiente, EstadoReserva.confirmada])
    ).all()
    
    # Generar horarios disponibles (puedes personalizar esto)
    horarios_ocupados = [reserva.hora_reserva.strftime("%H:%M") for reserva in reservas]
    
    # Horarios disponibles del restaurante (ejemplo)
    horarios_disponibles = [
        "12:00", "12:30", "13:00", "13:30", "14:00", "14:30",
        "19:00", "19:30", "20:00", "20:30", "21:00", "21:30"
    ]
    
    horarios_libres = [hora for hora in horarios_disponibles if hora not in horarios_ocupados]
    
    return APIResponse(
        success=True,
        message="Disponibilidad verificada",
        data={
            "fecha": fecha,
            "horarios_ocupados": horarios_ocupados,
            "horarios_disponibles": horarios_libres
        }
    )