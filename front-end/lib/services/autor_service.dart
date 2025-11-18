import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/autor.dart';

class AutorService {
  static Future<List<Autor>> getAllAutores({String? nome}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.autorEndpoint}');
    final finalUri = nome != null && nome.isNotEmpty
        ? uri.replace(queryParameters: {'nome': nome})
        : uri;

    final response = await http.get(finalUri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Autor.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar autores');
    }
  }

  static Future<Autor?> getAutorById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.autorEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) {
        return null;
      }
      return Autor.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Falha ao carregar autor');
    }
  }

  static Future<Autor> createAutor(Autor autor) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.autorEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(autor.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Autor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar autor');
    }
  }

  static Future<Autor> updateAutor(int id, Autor autor) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.autorEndpoint}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': autor.nome,
        'nacionalidade': autor.nacionalidade,
        'dataNascimento': autor.dataNascimento?.toIso8601String().split('T')[0],
      }),
    );

    if (response.statusCode == 200) {
      return Autor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar autor');
    }
  }

  static Future<bool> deleteAutor(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.autorEndpoint}/$id'),
    );

    return response.statusCode == 200;
  }
}

