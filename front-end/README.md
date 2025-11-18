# App Livraria - Flutter

App Flutter para gerenciar uma livraria, consumindo APIs REST do backend Spring Boot.

## Funcionalidades

- **Autores**: CRUD completo (Criar, Ler, Atualizar, Deletar)
- **Categorias**: CRUD completo + atualização de preços por percentual
- **Livros**: CRUD completo com relacionamento com Autores e Categorias
- **Relatórios**: Visualização de livros por categoria

## Estrutura do Projeto

```
lib/
├── config/
│   └── api_config.dart          # Configuração da URL base da API
├── models/
│   ├── autor.dart               # Model de Autor
│   ├── categoria.dart           # Model de Categoria
│   └── livro.dart               # Model de Livro
├── services/
│   ├── autor_service.dart       # Service para chamadas de API de Autores
│   ├── categoria_service.dart   # Service para chamadas de API de Categorias
│   ├── livro_service.dart       # Service para chamadas de API de Livros
│   └── relatorio_service.dart   # Service para chamadas de API de Relatórios
├── screens/
│   ├── home_screen.dart         # Tela principal com menu
│   ├── autores/
│   │   ├── autores_list_screen.dart
│   │   ├── autor_form_screen.dart
│   │   └── autor_detail_screen.dart
│   ├── categorias/
│   │   ├── categorias_list_screen.dart
│   │   ├── categoria_form_screen.dart
│   │   └── categoria_detail_screen.dart
│   ├── livros/
│   │   ├── livros_list_screen.dart
│   │   ├── livro_form_screen.dart
│   │   └── livro_detail_screen.dart
│   └── relatorios/
│       └── relatorios_screen.dart
└── main.dart                    # Ponto de entrada da aplicação
```

## Configuração

### 1. Instalar Dependências

```bash
flutter pub get
```

### 2. Configurar URL da API

Edite o arquivo `lib/config/api_config.dart` e ajuste a URL base da API:

```dart
static const String baseUrl = 'http://10.0.2.2:8080';
```

**Importante:**
- Para **emulador Android**: use `http://10.0.2.2:8080` (redireciona para localhost)
- Para **device físico**: use o IP da sua máquina na rede local (ex: `http://192.168.1.100:8080`)
- Para **iOS Simulator**: use `http://localhost:8080`

### 3. Executar o App

```bash
flutter run
```

## Requisitos

- Flutter SDK 3.0.0 ou superior
- Dart 3.0.0 ou superior
- Backend Spring Boot rodando na porta 8080

## Dependências

- `http`: ^1.1.0 - Para fazer requisições HTTP
- `intl`: ^0.18.1 - Para formatação de datas

## Endpoints Consumidos

### Autores
- `GET /autor` - Listar todos os autores (com filtro opcional por nome)
- `GET /autor/{id}` - Buscar autor por ID
- `POST /autor` - Criar novo autor
- `PUT /autor/{id}` - Atualizar autor
- `DELETE /autor/{id}` - Deletar autor

### Categorias
- `GET /categoria` - Listar todas as categorias (com filtro opcional por nome)
- `GET /categoria/{id}` - Buscar categoria por ID
- `POST /categoria` - Criar nova categoria
- `PUT /categoria/{id}` - Atualizar categoria
- `DELETE /categoria/{id}` - Deletar categoria
- `GET /categoria/atualizarpreco` - Atualizar preços por percentual

### Livros
- `GET /livro` - Listar todos os livros (com filtro opcional por título)
- `GET /livro/{id}` - Buscar livro por ID
- `POST /livro` - Criar novo livro
- `PUT /livro/{id}` - Atualizar livro
- `DELETE /livro/{id}` - Deletar livro

### Relatórios
- `GET /relatorio/categoria/{id}/livros` - Listar livros por categoria

## Notas

- Certifique-se de que o backend Spring Boot está rodando antes de executar o app
- O app usa Material Design 3 para a interface
- Todas as operações CRUD estão implementadas com tratamento de erros
- A busca funciona em tempo real nas telas de listagem

