from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import Any, Dict

from app.database import get_db
from app import auth
from app.chatbot import get_bot
from app.models import Reserva, Usuario
from app.schemas import APIResponse, ReservaResponse

router = APIRouter(prefix="/api/chatbot", tags=["Chatbot 🤖"])


def _serialize_schema(obj: Any) -> Dict:
    # Soporta Pydantic v1 (.dict) y v2 (.model_dump)
    if hasattr(obj, "model_dump"):
        return obj.model_dump()
    if hasattr(obj, "dict"):
        return obj.dict()
    return obj


@router.post("/", response_model=APIResponse, status_code=status.HTTP_200_OK)
def chat(
    payload: dict,
    db: Session = Depends(get_db),
    current_user: Usuario = Depends(auth.get_current_active_user),
):
    """Endpoint para interactuar con el chatbot.

    Body esperado: { "message": "texto" }
    - Si el mensaje solicita "reservas" (palabras clave), el bot devolverá la lista de reservas del usuario.
    - En mensajes generales, se delega a ChatterBot para respuestas simples.
    """
    message = payload.get("message") if isinstance(payload, dict) else None
    if not message or not isinstance(message, str):
        raise HTTPException(status_code=400, detail="Se requiere el campo 'message' en el body")

    texto = message.strip().lower()

    # Palabras clave para listar reservas
    if any(k in texto for k in ["reserva", "reservas", "mis reservas", "mostrar reservas", "ver reservas"]):
        # Obtener reservas del usuario
        reservas = (
            db.query(Reserva)
            .filter(Reserva.id_usuario == current_user.id_usuario)
            .order_by(Reserva.fecha_reserva.desc(), Reserva.hora_reserva.desc())
            .all()
        )

        reservas_serializadas = [
            _serialize_schema(ReservaResponse.from_orm(r)) for r in reservas
        ]

        reply = f"Tienes {len(reservas_serializadas)} reserva(s)."
        if len(reservas_serializadas) == 0:
            reply = "No tienes reservas registradas."

        return APIResponse(success=True, message=reply, data={"reply": reply, "reservas": reservas_serializadas})

    # Respuestas generales: usar ChatterBot
    try:
        bot = get_bot()
        respuesta = bot.get_response(message)
        reply_text = str(respuesta)
    except Exception:
        # Fallback simple
        reply_text = "Lo siento, no entendí eso. Puedes pedirme 'mis reservas' para ver tus reservas."

    return APIResponse(success=True, message=reply_text, data={"reply": reply_text})
