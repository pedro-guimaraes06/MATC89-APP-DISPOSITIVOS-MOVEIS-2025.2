# 🚀 Guia Rápido de Execução

## Passo 1: Instalar Dependências
```bash
flutter pub get
```

## Passo 2: Gerar Código Riverpod
```bash
dart run build_runner build --delete-conflicting-outputs
```

⚠️ **IMPORTANTE**: Este comando irá gerar os arquivos `.g.dart` necessários. 
Você verá arquivos como:
- `lib/models/bill.g.dart`
- `lib/models/category.g.dart`
- `lib/controllers/bill_controller.g.dart`
- `lib/controllers/category_controller.g.dart`
- `lib/services/notification_service.g.dart`

## Passo 3: Configurar Supabase

### 3.1. Criar Conta e Projeto
1. Acesse https://supabase.com
2. Crie uma conta (gratuita)
3. Crie um novo projeto
4. Aguarde a inicialização (1-2 minutos)

### 3.2. Criar Tabelas
1. No painel do Supabase, vá em **SQL Editor**
2. Cole e execute o SQL abaixo:

```sql
-- Tabela de categorias
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  color TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de contas (relação 1:N)
CREATE TABLE bills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  value DECIMAL(10, 2) NOT NULL,
  due_day INTEGER NOT NULL CHECK (due_day >= 1 AND due_day <= 31),
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  is_paid BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_bills_category_id ON bills(category_id);
CREATE INDEX idx_bills_due_day ON bills(due_day);

-- RLS (Row Level Security)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE bills ENABLE ROW LEVEL SECURITY;

-- Políticas (permitir tudo)
CREATE POLICY "Enable all for categories" ON categories FOR ALL USING (true);
CREATE POLICY "Enable all for bills" ON bills FOR ALL USING (true);
```

### 3.3. Obter Credenciais
1. Vá em **Settings** > **API**
2. Copie:
   - **Project URL**
   - **anon/public key**

### 3.4. Configurar no App
Abra `lib/main.dart` e substitua:

```dart
await Supabase.initialize(
  url: 'COLE_SUA_URL_AQUI',
  anonKey: 'COLE_SUA_CHAVE_AQUI',
);
```

Exemplo:
```dart
await Supabase.initialize(
  url: 'https://xyzabcdef123.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
);
```

## Passo 4: Executar no AVD

### 4.1. Abrir Android Studio
1. File > Open > Selecione a pasta do projeto
2. Aguarde o Gradle sync

### 4.2. Criar AVD (se não tiver)
1. Tools > Device Manager
2. Create Device
3. Escolha Pixel 5 ou similar
4. API Level 33 (ou superior)
5. Finish

### 4.3. Executar
1. Selecione o AVD criado
2. Run > Run 'main.dart' (ou pressione ▶️)

**OU via terminal:**
```bash
flutter run
```

## 🎯 Testando o App

### 1. Primeira vez: Criar Categoria
1. Toque no ícone de **categoria** (canto superior direito)
2. Toque no botão **+**
3. Preencha:
   - Nome: "Moradia"
   - Escolha ícone: 🏠
   - Escolha cor: Verde
4. Salvar

### 2. Adicionar Conta
1. Toque na categoria criada
2. Toque no botão **+**
3. Preencha:
   - Nome: "Aluguel"
   - Valor: 1500
   - Dia: 10
4. Salvar

### 3. Verificar Notificação
- Uma notificação deve aparecer confirmando a criação!

### 4. Testar CRUD
- ✅ Create: Já testado
- ✅ Read: Veja a lista
- ✅ Update: Marque como pago (checkbox)
- ✅ Delete: Toque no ícone de lixeira

## ❗ Problemas Comuns

### Erro: "MissingPluginException"
```bash
flutter clean
flutter pub get
flutter run
```

### Erro: "part 'xxx.g.dart' not found"
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Erro: "Supabase not initialized"
- Verifique se configurou URL e chave em `main.dart`

### Erro de build no Android
```bash
cd android
./gradlew clean
cd ..
flutter run
```

## 📱 Requisitos Atendidos

✅ 1. Dois CRUDs com relação 1:N (Category ← Bill)
✅ 2. Riverpod 2.5+ com code generation
✅ 3. Arquitetura MVC (Models, Controllers, Repositories, Views)
✅ 4. Persistência na nuvem (Supabase)
✅ 5. Recurso extra (Notificações Locais + SharedPreferences)

---

🎉 **Pronto para executar!**
