# Configuração do Supabase

## Passos para configurar:

1. Acesse https://supabase.com e crie uma conta
2. Crie um novo projeto
3. Vá em Settings > API
4. Copie a URL e a chave anon/public
5. Cole as credenciais no arquivo `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'SUA_URL_AQUI',
  anonKey: 'SUA_CHAVE_AQUI',
);
```

## SQL para criar as tabelas:

Execute este SQL no SQL Editor do Supabase:

```sql
-- Tabela de categorias (lado 1 da relação 1:N)
CREATE TABLE categories (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  icon TEXT NOT NULL,
  color TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tabela de contas (lado N da relação 1:N)
CREATE TABLE bills (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  value DECIMAL(10, 2) NOT NULL,
  due_day INTEGER NOT NULL CHECK (due_day >= 1 AND due_day <= 31),
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  is_paid BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índices para melhor performance
CREATE INDEX idx_bills_category_id ON bills(category_id);
CREATE INDEX idx_bills_due_day ON bills(due_day);

-- Habilitar Row Level Security (RLS)
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE bills ENABLE ROW LEVEL SECURITY;

-- Políticas de acesso (permitir tudo para desenvolvimento)
CREATE POLICY "Enable all for categories" ON categories FOR ALL USING (true);
CREATE POLICY "Enable all for bills" ON bills FOR ALL USING (true);
```

## Dados de exemplo (opcional):

```sql
-- Inserir categorias de exemplo
INSERT INTO categories (name, icon, color) VALUES
  ('Moradia', '🏠', 'FF4CAF50'),
  ('Transporte', '🚗', 'FF2196F3'),
  ('Alimentação', '🍔', 'FFFF9800');
```
