class AccountModel {
  String name;
  String phone;
  String? email;
  String? imagePath; // path local de la imagen (o null)

  AccountModel({
    required this.name,
    required this.phone,
    this.email,
    this.imagePath,
  });

  AccountModel copyWith({String? name, String? phone, String? email, String? imagePath}) {
    return AccountModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
