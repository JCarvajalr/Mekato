// models/user_model.dart
class User {
  final String nombres;
  final String apellidos;
  final String telefono;
  final String email;
  final String password;

  User({
    required this.nombres,
    required this.apellidos,
    required this.telefono,
    required this.email,
    this.password = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombres,
      'apellidos': apellidos,
      'email': email,
      'telefono': telefono,
      'contraseña': password,
    };
  }

  User copyWith({
    String? name,
    String? lastName,
    String? phone,
    String? email,
  }) {
    return User(
      nombres: name ?? nombres,
      apellidos: lastName ?? apellidos,
      email: email ?? this.email,
      telefono: phone ?? telefono,
    );
  }
}