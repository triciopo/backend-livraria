import 'package:flutter/material.dart';
import 'autores/autores_list_screen.dart';
import 'categorias/categorias_list_screen.dart';
import 'livros/livros_list_screen.dart';
import 'relatorios/relatorios_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livraria'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            'Autores',
            Icons.person,
            Colors.blue,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AutoresListScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Categorias',
            Icons.category,
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriasListScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Livros',
            Icons.book,
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LivrosListScreen()),
            ),
          ),
          _buildMenuCard(
            context,
            'Relatórios',
            Icons.assessment,
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RelatoriosScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

