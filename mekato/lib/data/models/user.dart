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
    required this.password,
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
}