class Task {
  final int? idTarefa;
  final String nomeTarefa;
  final String descricao;
  final String? status;
  final String? dtCriacao;

  Task({
    this.idTarefa,
    required this.nomeTarefa,
    required this.descricao,
    this.status,
    this.dtCriacao,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      idTarefa: json['idTarefa'],
      nomeTarefa: json['nomeTarefa'] ?? '',
      descricao: json['descricao'] ?? '',
      status: json['status'],
      dtCriacao: json['dtCriacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTarefa': idTarefa,
      'nomeTarefa': nomeTarefa,
      'descricao': descricao,
      'status': status,
      'dtCriacao': dtCriacao,
    };
  }
}
