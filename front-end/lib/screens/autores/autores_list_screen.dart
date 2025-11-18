import 'package:flutter/material.dart';
import '../../models/autor.dart';
import '../../services/autor_service.dart';
import 'autor_form_screen.dart';
import 'autor_detail_screen.dart';

class AutoresListScreen extends StatefulWidget {
  const AutoresListScreen({super.key});

  @override
  State<AutoresListScreen> createState() => _AutoresListScreenState();
}

class _AutoresListScreenState extends State<AutoresListScreen> {
  List<Autor> _autores = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAutores();
  }

  Future<void> _loadAutores({String? nome}) async {
    setState(() => _isLoading = true);
    try {
      final autores = await AutorService.getAllAutores(nome: nome);
      setState(() {
        _autores = autores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar autores: $e')),
        );
      }
    }
  }

  Future<void> _deleteAutor(int id) async {
    try {
      await AutorService.deleteAutor(id);
      _loadAutores();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autor deletado com sucesso')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao deletar autor: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(Autor autor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente deletar o autor "${autor.nome}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteAutor(autor.id!);
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
        title: const Text('Autores'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AutorFormScreen()),
              );
              if (result == true) {
                _loadAutores();
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
                hintText: 'Buscar por nome...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _loadAutores();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadAutores();
                }
              },
              onSubmitted: (value) => _loadAutores(nome: value),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _autores.isEmpty
                    ? const Center(child: Text('Nenhum autor encontrado'))
                    : RefreshIndicator(
                        onRefresh: () => _loadAutores(),
                        child: ListView.builder(
                          itemCount: _autores.length,
                          itemBuilder: (context, index) {
                            final autor = _autores[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text(autor.nome[0].toUpperCase()),
                                ),
                                title: Text(autor.nome),
                                subtitle: Text(autor.nacionalidade),
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
                                                AutorFormScreen(autor: autor),
                                          ),
                                        );
                                        if (result == true) {
                                          _loadAutores();
                                        }
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _showDeleteDialog(autor),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AutorDetailScreen(autor: autor),
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

