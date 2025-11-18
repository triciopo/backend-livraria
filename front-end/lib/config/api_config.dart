class ApiConfig {
  // Altere para o IP da sua máquina quando testar no emulador/device físico
  // Para emulador Android: use 10.0.2.2
  // Para device físico: use o IP da sua máquina na rede local
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Endpoints
  static const String autorEndpoint = '/autor';
  static const String categoriaEndpoint = '/categoria';
  static const String livroEndpoint = '/livro';
  static const String relatorioEndpoint = '/relatorio';
}

