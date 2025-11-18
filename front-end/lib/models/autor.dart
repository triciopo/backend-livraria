class Autor {
  final int? id;
  final String nome;
  final String nacionalidade;
  final DateTime? dataNascimento;

  Autor({
    this.id,
    required this.nome,
    required this.nacionalidade,
    this.dataNascimento,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      nacionalidade: json['nacionalidade'] as String,
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'nacionalidade': nacionalidade,
      if (dataNascimento != null)
        'dataNascimento': dataNascimento!.toIso8601String().split('T')[0],
    };
  }

  Autor copyWith({
    int? id,
    String? nome,
    String? nacionalidade,
    DateTime? dataNascimento,
  }) {
    return Autor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      nacionalidade: nacionalidade ?? this.nacionalidade,
      dataNascimento: dataNascimento ?? this.dataNascimento,
    );
  }
}

