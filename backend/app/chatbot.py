import os
from chatterbot import ChatBot
from chatterbot.trainers import ListTrainer

# Inicializar ruta de base de datos para el chatbot (archivo sqlite junto al paquete app)
base_dir = os.path.dirname(__file__)
db_path = os.path.join(base_dir, "..", "chatbot.sqlite3")
db_path = os.path.abspath(db_path)
# Asegurarse que la ruta use slashes adecuados en Windows
db_uri = f"sqlite:///{db_path.replace('\\', '/') }"

# Crear instancia del ChatBot
bot = ChatBot(
    "MekatoBot",
    storage_adapter="chatterbot.storage.SQLStorageAdapter",
    database_uri=db_uri,
    read_only=True,  # no modificamos el almacenamiento en tiempo de petición
)

# Entrenamiento mínimo (solo frases simples). Solo entrenar si no existe la BD del bot.
def _train_minimal():
    try:
        trainer = ListTrainer(bot)
        training_data = [
            ["hola", "¡Hola! Soy el asistente de Mekato. Puedo mostrarte tus reservas si me pides 'mis reservas'"],
            ["buenos dias", "¡Buenos días! ¿En qué puedo ayudarte? Puedes pedirme 'mis reservas' o saludar."],
            ["gracias", "De nada. Si necesitas ver tus reservas di: 'mostrar reservas' o 'mis reservas'."],
            ["adiós", "¡Hasta luego!"],
            ["qué puedes hacer", "Puedo listar tus reservas. Pregunta por 'reservas' o 'mis reservas'."],
        ]

        for convo in training_data:
            trainer.train(convo)
    except Exception:
        # Si falla el entrenamiento no queremos romper la app; el bot seguirá respondiendo con reglas básicas
        pass

# Solo entrenar si no existe la base de datos del bot
try:
    if not os.path.exists(db_path):
        _train_minimal()
except Exception:
    # protección general para entornos donde chatterbot pueda fallar en import/creación
    pass


def get_bot():
    """Retorna la instancia global del bot."""
    return bot
