class AccountModel {
  String name;       // Nombre completo
  String phone;
  String? email;
  String? imagePath; // Puede ser URL o ruta local

  AccountModel({
    required this.name,
    required this.phone,
    this.email,
    this.imagePath,
  });

  /// Permite clonar el modelo cambiando campos puntuales.
  AccountModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? imagePath,
  }) {
    return AccountModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  /// Crea un modelo desde el JSON del backend.
  factory AccountModel.fromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] ?? '';
    final lastName = json['last_name'] ?? '';
    return AccountModel(
      name: '$firstName $lastName'.trim(),
      phone: json['phone'] ?? '',
      email: json['email'],
      imagePath: json['image_url'], // opcional, si el backend lo devuelve
    );
  }

  /// Convierte el modelo a JSON para enviar al backend.
  Map<String, dynamic> toJson() {
    final parts = name.split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return {
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'image_url': imagePath, // opcional
    };
  }
}
