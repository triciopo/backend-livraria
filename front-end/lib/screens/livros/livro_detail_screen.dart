import 'package:flutter/material.dart';
import '../../models/livro.dart';

class LivroDetailScreen extends StatelessWidget {
  final Livro livro;

  const LivroDetailScreen({super.key, required this.livro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.book, color: Colors.white),
                  ),
                  title: Text(
                    livro.titulo,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(),
                _buildDetailRow('ID', livro.id?.toString() ?? 'N/A'),
                _buildDetailRow('Título', livro.titulo),
                _buildDetailRow('Ano de Publicação', livro.anoPublicacao.toString()),
                _buildDetailRow('Preço', 'R\$ ${livro.preco.toStringAsFixed(2)}'),
                _buildDetailRow('Estoque', livro.estoque.toString()),
                _buildDetailRow(
                  'Autor',
                  livro.autor?.nome ?? 'Não informado',
                ),
                _buildDetailRow(
                  'Categoria',
                  livro.categoria?.nome ?? 'Não informado',
                ),
                _buildDetailRow(
                  'Descrição',
                  livro.descricao.isNotEmpty ? livro.descricao : 'Sem descrição',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

