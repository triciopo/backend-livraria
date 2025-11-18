import 'package:flutter/material.dart';
import '../../models/livro.dart';
import '../../models/autor.dart';
import '../../models/categoria.dart';
import '../../services/livro_service.dart';
import '../../services/autor_service.dart';
import '../../services/categoria_service.dart';

class LivroFormScreen extends StatefulWidget {
  final Livro? livro;

  const LivroFormScreen({super.key, this.livro});

  @override
  State<LivroFormScreen> createState() => _LivroFormScreenState();
}

class _LivroFormScreenState extends State<LivroFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _anoController = TextEditingController();
  final _precoController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _descricaoController = TextEditingController();

  List<Autor> _autores = [];
  List<Categoria> _categorias = [];
  Autor? _selectedAutor;
  Categoria? _selectedCategoria;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final autores = await AutorService.getAllAutores();
      final categorias = await CategoriaService.getAllCategorias();
      setState(() {
        _autores = autores;
        _categorias = categorias;
        _isLoading = false;
      });

      if (widget.livro != null) {
        _tituloController.text = widget.livro!.titulo;
        _anoController.text = widget.livro!.anoPublicacao.toString();
        _precoController.text = widget.livro!.preco.toString();
        _estoqueController.text = widget.livro!.estoque.toString();
        _descricaoController.text = widget.livro!.descricao;
        _selectedAutor = widget.livro!.autor;
        _selectedCategoria = widget.livro!.categoria;
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedAutor == null || _selectedCategoria == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione autor e categoria')),
        );
        return;
      }

      try {
        final livro = Livro(
          id: widget.livro?.id,
          titulo: _tituloController.text,
          anoPublicacao: int.parse(_anoController.text),
          preco: double.parse(_precoController.text),
          estoque: int.parse(_estoqueController.text),
          descricao: _descricaoController.text,
          autor: _selectedAutor,
          categoria: _selectedCategoria,
        );

        if (widget.livro == null) {
          await LivroService.createLivro(livro);
        } else {
          await LivroService.updateLivro(widget.livro!.id!, livro);
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.livro == null
                    ? 'Livro criado com sucesso'
                    : 'Livro atualizado com sucesso',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar livro: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livro == null ? 'Novo Livro' : 'Editar Livro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o título';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _anoController,
                    decoration: const InputDecoration(
                      labelText: 'Ano de Publicação',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Obrigatório';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _precoController,
                    decoration: const InputDecoration(
                      labelText: 'Preço',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Obrigatório';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Número inválido';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _estoqueController,
              decoration: const InputDecoration(
                labelText: 'Estoque',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o estoque';
                }
                if (int.tryParse(value) == null) {
                  return 'Número inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Autor>(
              value: _selectedAutor,
              decoration: const InputDecoration(
                labelText: 'Autor',
                border: OutlineInputBorder(),
              ),
              items: _autores.map((autor) {
                return DropdownMenuItem(
                  value: autor,
                  child: Text(autor.nome),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedAutor = value),
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione um autor';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Categoria>(
              value: _selectedCategoria,
              decoration: const InputDecoration(
                labelText: 'Categoria',
                border: OutlineInputBorder(),
              ),
              items: _categorias.map((categoria) {
                return DropdownMenuItem(
                  value: categoria,
                  child: Text(categoria.nome),
                );
              }).toList(),
              onChanged: (value) => setState(() => _selectedCategoria = value),
              validator: (value) {
                if (value == null) {
                  return 'Por favor, selecione uma categoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _anoController.dispose();
    _precoController.dispose();
    _estoqueController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}

