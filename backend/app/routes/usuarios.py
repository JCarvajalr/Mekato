from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import Optional

from app.database import get_db
from app.models import Usuario
from app.schemas import UsuarioCreate, UsuarioResponse, UsuarioLogin, UsuarioUpdate, APIResponse, ErrorResponse
from app import auth

router = APIRouter(prefix="/api/usuarios", tags=["Usuarios 👤"])

@router.post(
    "/registro",
    response_model=APIResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Registrar nuevo usuario",
    description="""
    Crea una nueva cuenta de usuario en el sistema.
    
    ### Validaciones:
    - Email debe ser único
    - Contraseña mínimo 6 caracteres
    - Todos los campos obligatorios deben ser proporcionados
    """,
    responses={
        201: {"description": "Usuario creado exitosamente"},
        400: {"model": ErrorResponse, "description": "Email ya registrado"},
        422: {"model": ErrorResponse, "description": "Error de validación en los datos"}
    }
)
def registrar_usuario(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    # Verificar si el email ya existe
    db_usuario = db.query(Usuario).filter(Usuario.email == usuario.email).first()
    if db_usuario:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="El email ya está registrado"
        )
    
    # Crear nuevo usuario
    hashed_password = auth.get_password_hash(usuario.contraseña)
    db_usuario = Usuario(
        nombre=usuario.nombre,
        apellidos=usuario.apellidos,
        email=usuario.email,
        telefono=usuario.telefono,
        contraseña_hash=hashed_password
    )
    
    db.add(db_usuario)
    db.commit()
    db.refresh(db_usuario)
    
    return APIResponse(
        success=True,
        message="Usuario registrado exitosamente",
        data={"usuario": UsuarioResponse.from_orm(db_usuario)}
    )

@router.post(
    "/login",
    response_model=APIResponse,
    summary="Iniciar sesión",
    description="""
    Autentica un usuario y genera un token JWT para acceder a endpoints protegidos.
    
    El token debe incluirse en el header de las solicitudes protegidas:
    `Authorization: Bearer <token>`
    """,
    responses={
        200: {"description": "Login exitoso, token generado"},
        401: {"model": ErrorResponse, "description": "Credenciales incorrectas"}
    }
)
def login_usuario(usuario: UsuarioLogin, db: Session = Depends(get_db)):
    # Verificar credenciales
    db_usuario = auth.authenticate_user(db, usuario.email, usuario.contraseña)
    if not db_usuario:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Credenciales incorrectas",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Crear token de acceso
    access_token_expires = timedelta(minutes=auth.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = auth.create_access_token(
        data={"sub": db_usuario.email}, expires_delta=access_token_expires
    )
    
    return APIResponse(
        success=True,
        message="Login exitoso",
        data={
            "access_token": access_token,
            "token_type": "bearer",
            "usuario": UsuarioResponse.from_orm(db_usuario)
        }
    )

@router.get(
    "/perfil",
    response_model=APIResponse,
    summary="Obtener perfil del usuario",
    description="Obtiene la información del perfil del usuario autenticado.",
    responses={
        200: {"description": "Perfil obtenido exitosamente"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"}
    }
)
def obtener_perfil_usuario(current_user: Usuario = Depends(auth.get_current_active_user)):
    return APIResponse(
        success=True,
        message="Perfil obtenido exitosamente",
        data={"usuario": UsuarioResponse.from_orm(current_user)}
    )

@router.put(
    "/perfil",
    response_model=APIResponse,
    summary="Actualizar perfil del usuario",
    description="""
    Actualiza la información del perfil del usuario.
    
    ### Características:
    - Solo actualiza los campos enviados (parcial update)
    - No requiere reautenticación después de la actualización
    - No se puede cambiar la contraseña en este endpoint
    """,
    responses={
        200: {"description": "Perfil actualizado exitosamente"},
        400: {"model": ErrorResponse, "description": "Email ya registrado por otro usuario"},
        401: {"model": ErrorResponse, "description": "Token inválido o expirado"},
        422: {"model": ErrorResponse, "description": "Error de validación en los datos"}
    }
)
def actualizar_perfil_usuario(
    usuario_update: UsuarioUpdate,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user)
):
    # Verificar si el email ya existe (excluyendo el usuario actual)
    if usuario_update.email and usuario_update.email != current_user.email:
        db_usuario = db.query(Usuario).filter(Usuario.email == usuario_update.email).first()
        if db_usuario:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="El email ya está registrado"
            )
    
    # Actualizar solo los campos que se enviaron en la solicitud
    update_data = usuario_update.dict(exclude_unset=True)
    
    for field, value in update_data.items():
        if value is not None:  # Solo actualizar si el valor no es None
            setattr(current_user, field, value)
    
    db.commit()
    db.refresh(current_user)
    
    return APIResponse(
        success=True,
        message="Perfil actualizado exitosamente",
        data={"usuario": UsuarioResponse.from_orm(current_user)}
    )