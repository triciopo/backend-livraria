import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/autor.dart';
import '../../services/autor_service.dart';

class AutorFormScreen extends StatefulWidget {
  final Autor? autor;

  const AutorFormScreen({super.key, this.autor});

  @override
  State<AutorFormScreen> createState() => _AutorFormScreenState();
}

class _AutorFormScreenState extends State<AutorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _nacionalidadeController = TextEditingController();
  DateTime? _dataNascimento;

  @override
  void initState() {
    super.initState();
    if (widget.autor != null) {
      _nomeController.text = widget.autor!.nome;
      _nacionalidadeController.text = widget.autor!.nacionalidade;
      _dataNascimento = widget.autor!.dataNascimento;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dataNascimento = picked);
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        final autor = Autor(
          id: widget.autor?.id,
          nome: _nomeController.text,
          nacionalidade: _nacionalidadeController.text,
          dataNascimento: _dataNascimento,
        );

        if (widget.autor == null) {
          await AutorService.createAutor(autor);
        } else {
          await AutorService.updateAutor(widget.autor!.id!, autor);
        }

        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.autor == null
                    ? 'Autor criado com sucesso'
                    : 'Autor atualizado com sucesso',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar autor: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.autor == null ? 'Novo Autor' : 'Editar Autor'),
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
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nacionalidadeController,
              decoration: const InputDecoration(
                labelText: 'Nacionalidade',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira a nacionalidade';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                child: Text(
                  _dataNascimento != null
                      ? DateFormat('dd/MM/yyyy').format(_dataNascimento!)
                      : 'Selecione uma data',
                ),
              ),
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
    _nomeController.dispose();
    _nacionalidadeController.dispose();
    super.dispose();
  }
}

