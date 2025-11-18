import 'package:flutter/material.dart';
import '../../models/livro.dart';
import '../../services/livro_service.dart';
import 'livro_form_screen.dart';
import 'livro_detail_screen.dart';

class LivrosListScreen extends StatefulWidget {
  const LivrosListScreen({super.key});

  @override
  State<LivrosListScreen> createState() => _LivrosListScreenState();
}

class _LivrosListScreenState extends State<LivrosListScreen> {
  List<Livro> _livros = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  Future<void> _loadLivros({String? titulo}) async {
    setState(() => _isLoading = true);
    try {
      final livros = await LivroService.getAllLivros(titulo: titulo);
      setState(() {
        _livros = livros;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar livros: $e')),
        );
      }
    }
  }

  Future<void> _deleteLivro(int id) async {
    try {
      await LivroService.deleteLivro(id);
      _loadLivros();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Livro deletado com sucesso')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar livro: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(Livro livro) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente deletar o livro "${livro.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLivro(livro.id!);
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LivroFormScreen()),
              );
              if (result == true) {
                _loadLivros();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por título...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadLivros();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadLivros();
                }
              },
              onSubmitted: (value) => _loadLivros(titulo: value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _livros.isEmpty
                    ? const Center(child: Text('Nenhum livro encontrado'))
                    : RefreshIndicator(
                        onRefresh: () => _loadLivros(),
                        child: ListView.builder(
                          itemCount: _livros.length,
                          itemBuilder: (context, index) {
                            final livro = _livros[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: const Icon(Icons.book, color: Colors.white),
                                ),
                                title: Text(livro.titulo),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (livro.autor != null)
                                      Text('Autor: ${livro.autor!.nome}'),
                                    if (livro.categoria != null)
                                      Text('Categoria: ${livro.categoria!.nome}'),
                                    Text('R\$ ${livro.preco.toStringAsFixed(2)}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LivroFormScreen(livro: livro),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadLivros();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _showDeleteDialog(livro),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LivroDetailScreen(livro: livro),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

