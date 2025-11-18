import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/categoria.dart';

class CategoriaService {
  static Future<List<Categoria>> getAllCategorias({String? nome}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}');
    final finalUri = nome != null && nome.isNotEmpty
        ? uri.replace(queryParameters: {'nome': nome})
        : uri;

    final response = await http.get(finalUri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Categoria.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar categorias');
    }
  }

  static Future<Categoria?> getCategoriaById(int id) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) {
        return null;
      }
      return Categoria.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Falha ao carregar categoria');
    }
  }

  static Future<Categoria> createCategoria(Categoria categoria) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar categoria');
    }
  }

  static Future<Categoria> updateCategoria(int id, Categoria categoria) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': categoria.nome,
        'descricao': categoria.descricao,
      }),
    );

    if (response.statusCode == 200) {
      return Categoria.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar categoria');
    }
  }

  static Future<bool> deleteCategoria(int id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}/$id'),
    );

    return response.statusCode == 200;
  }

  static Future<bool> atualizarPrecoCategoria(int categoriaId, double percentual) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.categoriaEndpoint}/atualizarpreco')
          .replace(queryParameters: {
        'categoriaId': categoriaId.toString(),
        'percentual': percentual.toString(),
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Falha ao atualizar preços da categoria');
    }
  }
}

