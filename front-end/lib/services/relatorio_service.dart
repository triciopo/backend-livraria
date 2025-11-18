import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class RelatorioService {
  static Future<List<Map<String, dynamic>>> getLivrosPorCategoria(int categoriaId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}${ApiConfig.relatorioEndpoint}/categoria/$categoriaId/livros'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Falha ao carregar relatório');
    }
  }
}

