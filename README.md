# Kill Bills - Aplicativo de Gerenciamento de Contas

Aplicativo Flutter para gerenciar contas a pagar, organizadas por categorias.

## 📋 Requisitos Implementados

### ✅ 1. Dois CRUDs com Relação 1:N
- **Category (1)** ← **Bill (N)**
- Cada categoria pode ter múltiplas contas
- CRUD completo para ambas as entidades:
  - Create (Criar)
  - Read (Ler/Listar)
  - Update (Atualizar)
  - Delete (Apagar)

### ✅ 2. Riverpod 2.5+ com Code Generation
- `flutter_riverpod: ^2.5.1`
- `riverpod_annotation: ^2.3.5`
- `riverpod_generator: ^2.4.0`
- Controllers implementados com `@riverpod`
- Providers auto-gerados

### ✅ 3. Arquitetura MVC Completa
```
lib/
├── models/          # Models (dados)
│   ├── bill.dart
│   └── category.dart
├── controllers/     # Controllers (lógica de negócio)
│   ├── bill_controller.dart
│   └── category_controller.dart
├── repositories/    # Repositories (acesso a dados)
│   ├── bill_repository.dart
│   └── category_repository.dart
├── pages/          # Views/Widgets (UI)
│   ├── home_page.dart
│   ├── categories_page.dart
│   ├── add_category_page.dart
│   ├── category_bills_page.dart
│   └── add_bill_page_new.dart
└── services/       # Serviços auxiliares
    └── notification_service.dart
```

### ✅ 4. Persistência na Nuvem (Supabase)
- `supabase_flutter: ^2.3.4`
- Banco de dados PostgreSQL na nuvem
- Sincronização em tempo real
- Relação 1:N implementada com Foreign Keys

### ✅ 5. Recursos Extras
- **Notificações Locais**: `flutter_local_notifications: ^17.0.0`
  - Notificações ao adicionar categorias/contas
  - Lembretes de vencimento
- **SharedPreferences**: Já implementado (requisito cumprido)
- **Pull to Refresh**: Atualizar dados da nuvem
- **Loading States**: Feedback visual durante operações

## 🚀 Como Executar

### Pré-requisitos
- Flutter SDK 3.0.0+
- Android Studio (versão 2021.2+)
- Conta no Supabase

### 1. Instalar Dependências
```bash
flutter pub get
```

### 2. Gerar Código Riverpod
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Configurar Supabase
Siga as instruções em `SUPABASE_SETUP.md`:
1. Crie projeto no Supabase
2. Execute o SQL para criar tabelas
3. Copie URL e chave anon
4. Cole em `lib/main.dart`

### 4. Executar
```bash
flutter run
```

## 📱 Funcionalidades

### Categorias
- ✅ Criar categoria com ícone e cor personalizados
- ✅ Listar todas as categorias
- ✅ Ver quantidade de contas por categoria
- ✅ Deletar categoria (cascade delete nas contas)
- ✅ Navegar para ver contas da categoria

### Contas
- ✅ Criar conta vinculada a uma categoria
- ✅ Listar todas as contas
- ✅ Filtrar contas por categoria (demonstra relação 1:N)
- ✅ Marcar conta como paga/não paga
- ✅ Deletar conta
- ✅ Ordenação por dia de vencimento

### Notificações
- ✅ Notificação ao criar categoria
- ✅ Notificação ao criar conta
- ✅ Sistema de lembretes implementado

## 🏗️ Arquitetura

### Fluxo de Dados
```
Widget → Controller → Repository → Supabase
  ↑          ↓
  └─── Riverpod State
```

### Relação 1:N
```
Category (1)
    ↓
    └── Bills (N)
```

## 📦 Dependências Principais

```yaml
dependencies:
  flutter_riverpod: ^2.5.1        # Gerenciamento de estado
  riverpod_annotation: ^2.3.5     # Anotações Riverpod
  supabase_flutter: ^2.3.4        # Backend na nuvem
  flutter_local_notifications: ^17.0.0  # Notificações
  shared_preferences: ^2.2.2      # Storage local
  intl: ^0.19.0                   # Formatação

dev_dependencies:
  build_runner: ^2.4.8            # Code generation
  riverpod_generator: ^2.4.0      # Gerador Riverpod
  riverpod_lint: ^2.3.10          # Linter Riverpod
```

## ✅ Compatibilidade AVD

Configurado para rodar em:
- Android API 21+ (Lollipop)
- compileSdk: 33
- targetSdk: 33
- Gradle 7.5
- Android Gradle Plugin 7.3.0

Testado em Android Studio 2021.2+ (Chipmunk e posteriores)

## 📝 Notas

- Todos os requisitos foram implementados
- Código documentado e organizado
- Pronto para entrega do projeto prático
- Compatível com AVD do Android Studio

## 👨‍💻 Desenvolvimento

Para regenerar código Riverpod após mudanças:
```bash
dart run build_runner watch
```

Para limpar build anterior:
```bash
dart run build_runner clean
```
