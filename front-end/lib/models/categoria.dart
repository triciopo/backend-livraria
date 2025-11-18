class Categoria {
  final int? id;
  final String nome;
  final String descricao;

  Categoria({
    this.id,
    required this.nome,
    required this.descricao,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] as int?,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  Categoria copyWith({
    int? id,
    String? nome,
    String? descricao,
  }) {
    return Categoria(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
    );
  }
}

