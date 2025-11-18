import 'package:flutter/material.dart';
import '../../models/categoria.dart';
import '../../services/categoria_service.dart';
import '../../services/relatorio_service.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  List<Categoria> _categorias = [];
  Categoria? _selectedCategoria;
  List<Map<String, dynamic>> _livros = [];
  bool _isLoading = false;
  bool _isLoadingCategorias = true;

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    try {
      final categorias = await CategoriaService.getAllCategorias();
      setState(() {
        _categorias = categorias;
        _isLoadingCategorias = false;
      });
    } catch (e) {
      setState(() => _isLoadingCategorias = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar categorias: $e')),
        );
      }
    }
  }

  Future<void> _loadRelatorio() async {
    if (_selectedCategoria == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma categoria')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final livros = await RelatorioService.getLivrosPorCategoria(
        _selectedCategoria!.id!,
      );
      setState(() {
        _livros = livros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar relatório: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Livros por Categoria',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoadingCategorias
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<Categoria>(
                            value: _selectedCategoria,
                            decoration: const InputDecoration(
                              labelText: 'Selecione uma categoria',
                              border: OutlineInputBorder(),
                            ),
                            items: _categorias.map((categoria) {
                              return DropdownMenuItem(
                                value: categoria,
                                child: Text(categoria.nome),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategoria = value;
                                _livros = [];
                              });
                            },
                          ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadRelatorio,
                      child: const Text('Gerar Relatório'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _livros.isEmpty
                    ? const Center(
                        child: Text(
                          'Selecione uma categoria e gere o relatório',
                        ),
                      )
                    : ListView.builder(
                        itemCount: _livros.length,
                        itemBuilder: (context, index) {
                          final livro = _livros[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.book, color: Colors.orange),
                              title: Text(
                                livro['titulo']?.toString() ?? 'Sem título',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (livro['anoPublicacao'] != null)
                                    Text('Ano: ${livro['anoPublicacao']}'),
                                  if (livro['preco'] != null)
                                    Text(
                                      'Preço: R\$ ${(livro['preco'] as num).toStringAsFixed(2)}',
                                    ),
                                  if (livro['estoque'] != null)
                                    Text('Estoque: ${livro['estoque']}'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

