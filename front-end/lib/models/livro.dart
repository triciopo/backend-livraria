import 'autor.dart';
import 'categoria.dart';

class Livro {
  final int? id;
  final String titulo;
  final int anoPublicacao;
  final double preco;
  final int estoque;
  final String descricao;
  final Autor? autor;
  final Categoria? categoria;

  Livro({
    this.id,
    required this.titulo,
    required this.anoPublicacao,
    required this.preco,
    required this.estoque,
    required this.descricao,
    this.autor,
    this.categoria,
  });

  factory Livro.fromJson(Map<String, dynamic> json) {
    return Livro(
      id: json['id'] as int?,
      titulo: json['titulo'] as String,
      anoPublicacao: json['anoPublicacao'] as int,
      preco: (json['preco'] as num).toDouble(),
      estoque: json['estoque'] as int,
      descricao: json['descricao'] as String? ?? '',
      autor: json['autor'] != null
          ? Autor.fromJson(json['autor'] as Map<String, dynamic>)
          : null,
      categoria: json['categoria'] != null
          ? Categoria.fromJson(json['categoria'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'anoPublicacao': anoPublicacao,
      'preco': preco,
      'estoque': estoque,
      'descricao': descricao,
      if (autor != null) 'autor': autor!.toJson(),
      if (categoria != null) 'categoria': categoria!.toJson(),
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'titulo': titulo,
      'anoPublicacao': anoPublicacao,
      'preco': preco,
      'estoque': estoque,
      'descricao': descricao,
      'autorId': autor?.id ?? 0,
      'categoriaId': categoria?.id ?? 0,
    };
  }

  Livro copyWith({
    int? id,
    String? titulo,
    int? anoPublicacao,
    double? preco,
    int? estoque,
    String? descricao,
    Autor? autor,
    Categoria? categoria,
  }) {
    return Livro(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      anoPublicacao: anoPublicacao ?? this.anoPublicacao,
      preco: preco ?? this.preco,
      estoque: estoque ?? this.estoque,
      descricao: descricao ?? this.descricao,
      autor: autor ?? this.autor,
      categoria: categoria ?? this.categoria,
    );
  }
}

