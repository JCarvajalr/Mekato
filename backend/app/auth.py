from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
import os
from dotenv import load_dotenv
from app.database import get_db
from app.models import Usuario

load_dotenv()

# Configuración desde variables de entorno
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))

if not SECRET_KEY:
    raise Exception("SECRET_KEY no está configurada en el archivo .env")

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()
# Permite no fallar si no hay header Authorization (auto_error=False)
security_optional = HTTPBearer(auto_error=False)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def authenticate_user(db: Session, email: str, password: str):
    user = db.query(Usuario).filter(Usuario.email == email, Usuario.activo == True).first()
    if not user:
        return False
    if not verify_password(password, user.contraseña_hash):
        return False
    return user

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db)
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No se pudieron validar las credenciales",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    user = db.query(Usuario).filter(Usuario.email == email, Usuario.activo == True).first()
    if user is None:
        raise credentials_exception
    return user

async def get_current_active_user(current_user: Usuario = Depends(get_current_user)):
    return current_user


async def get_current_user_optional(
    credentials: HTTPAuthorizationCredentials = Depends(security_optional),
    db: Session = Depends(get_db),
):
    """Intenta obtener el usuario desde el Authorization header.
    Si no hay header o el token no es válido, devuelve None en lugar de lanzar 401.
    """
    if not credentials:
        return None

    try:
        payload = jwt.decode(credentials.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        if email is None:
            return None
    except JWTError:
        return None

    user = db.query(Usuario).filter(Usuario.email == email, Usuario.activo == True).first()
    return user