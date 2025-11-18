import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/autor.dart';

class AutorDetailScreen extends StatelessWidget {
  final Autor autor;

  const AutorDetailScreen({super.key, required this.autor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Autor'),
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
                    child: Text(autor.nome[0].toUpperCase()),
                  ),
                  title: Text(
                    autor.nome,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const Divider(),
                _buildDetailRow('ID', autor.id?.toString() ?? 'N/A'),
                _buildDetailRow('Nome', autor.nome),
                _buildDetailRow('Nacionalidade', autor.nacionalidade),
                _buildDetailRow(
                  'Data de Nascimento',
                  autor.dataNascimento != null
                      ? DateFormat('dd/MM/yyyy').format(autor.dataNascimento!)
                      : 'Não informado',
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

