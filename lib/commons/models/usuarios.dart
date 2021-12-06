class Usuarios {
  String? name;
  String? email;
  String? senha;

  Usuarios({
    this.name,
    this.email,
    this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'senha': senha,
    };
  }
}
