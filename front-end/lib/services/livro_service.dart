import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/livro.dart';

class LivroService {
  static Future<List<Livro>> getAllLivros({String? titulo}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.livroEndpoint}');
    final finalUri = titulo != null && titulo.isNotEmpty
        ? uri.replace(queryParameters: {'titulo': titulo})
        : uri;

    final response = await http.get(finalUri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Livro.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar livros');
    }
  }

  static Future<Livro?> getLivroById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.livroEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) {
        return null;
      }
      return Livro.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Falha ao carregar livro');
    }
  }

  static Future<Livro> createLivro(Livro livro) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.livroEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livro.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Livro.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar livro');
    }
  }

  static Future<Livro> updateLivro(int id, Livro livro) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.livroEndpoint}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livro.toUpdateJson()),
    );

    if (response.statusCode == 200) {
      return Livro.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar livro');
    }
  }

  static Future<bool> deleteLivro(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.livroEndpoint}/$id'),
    );

    return response.statusCode == 200;
  }
}

