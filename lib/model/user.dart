class User {
  final String? idUsuario;
  final String nomeUsuario;
  final String emailUsuario;
  final String? senhaUsuario;

  User({
    this.idUsuario,
    required this.nomeUsuario,
    required this.emailUsuario,
    this.senhaUsuario,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUsuario: json['idUsuario'],
      nomeUsuario: json['nomeUsuario'],
      emailUsuario: json['emailUsuario'],
    );
  }

  Map<String, dynamic> toJsonCadastro() {
    return {
      'nomeUsuario': nomeUsuario,
      'emailUsuario': emailUsuario,
      'senhaUsuario': senhaUsuario,
    };
  }
}
