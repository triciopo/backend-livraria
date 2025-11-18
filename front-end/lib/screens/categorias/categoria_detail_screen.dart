import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../services/categoria_service.dart';
import 'atualizar_preco_dialog.dart';

class CategoriaDetailScreen extends StatefulWidget {
  final Categoria categoria;

  const CategoriaDetailScreen({super.key, required this.categoria});

  @override
  State<CategoriaDetailScreen> createState() => _CategoriaDetailScreenState();
}

class _CategoriaDetailScreenState extends State<CategoriaDetailScreen> {
  void _showAtualizarPrecoDialog() {
    showDialog(
      context: context,
      builder: (context) => AtualizarPrecoDialog(categoria: widget.categoria),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Categoria'),
        actions: [
          IconButton(
            icon: const Icon(Icons.percent),
            onPressed: _showAtualizarPrecoDialog,
            tooltip: 'Atualizar preços',
          ),
        ],
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
                    backgroundColor: Colors.green,
                    child: Text(
                      widget.categoria.nome[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    widget.categoria.nome,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(),
                _buildDetailRow('ID', widget.categoria.id?.toString() ?? 'N/A'),
                _buildDetailRow('Nome', widget.categoria.nome),
                _buildDetailRow(
                  'Descrição',
                  widget.categoria.descricao.isNotEmpty
                      ? widget.categoria.descricao
                      : 'Sem descrição',
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
            width: 120,
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

