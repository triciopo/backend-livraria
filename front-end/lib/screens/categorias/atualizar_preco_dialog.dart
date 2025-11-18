import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../services/categoria_service.dart';

class AtualizarPrecoDialog extends StatefulWidget {
  final Categoria categoria;

  const AtualizarPrecoDialog({super.key, required this.categoria});

  @override
  State<AtualizarPrecoDialog> createState() => _AtualizarPrecoDialogState();
}

class _AtualizarPrecoDialogState extends State<AtualizarPrecoDialog> {
  final TextEditingController _percentualController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _percentualController.dispose();
    super.dispose();
  }

  Future<void> _atualizarPreco() async {
    final percentual = double.tryParse(_percentualController.text);
    if (percentual == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira um percentual válido'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await CategoriaService.atualizarPrecoCategoria(
        widget.categoria.id!,
        percentual,
      );
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Preços atualizados com sucesso! ${percentual > 0 ? "Aumento" : "Redução"} de ${percentual.abs()}%',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar preços: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.percent, color: Colors.blue),
          SizedBox(width: 8),
          Text('Atualizar Preços'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categoria: ${widget.categoria.nome}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Digite o percentual de aumento ou redução:',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _percentualController,
            decoration: const InputDecoration(
              labelText: 'Percentual (%)',
              hintText: 'Ex: 10 para aumentar 10%, -5 para reduzir 5%',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.percent),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            enabled: !_isLoading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton.icon(
          onPressed: _isLoading ? null : _atualizarPreco,
          icon: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.update),
          label: Text(_isLoading ? 'Atualizando...' : 'Atualizar'),
        ),
      ],
    );
  }
}

