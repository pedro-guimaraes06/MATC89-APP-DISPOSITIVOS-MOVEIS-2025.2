# Projeto: Kill Bills
# Tipo: Aplicativo Mobile Android desenvolvido em Flutter
# Público alvo: Iniciantes em desenvolvimento mobile
# Regras de implementação: manter tudo o mais simples possível

## Finalidade do App
Kill Bills é um aplicativo simples de lembretes de contas mensais.  
O objetivo é permitir que usuários cadastrem e visualizem as contas recorrentes do mês, como:
- Aluguel
- Água
- Luz
- Internet
- Outras despesas básicas

A ideia é fornecer uma interface fácil, direta e apropriada para iniciantes.

## Funcionalidades principais (mínimo necessário)
1. **Listagem de contas mensais**
   - Mostrar todas as contas cadastradas pelo usuário.
   - Usar widgets simples: ListView, Card, Column, Row, Text.

2. **Cadastro de nova conta**
   - Nome da conta (ex.: “Aluguel”)
   - Valor da conta
   - Dia do vencimento (apenas número)
   - Tipo recorrente mensal (não precisa permitir alterar recorrência)
   - Usar componentes básicos:
     - TextField
     - ElevatedButton
     - Form (opcional)

3. **Armazenamento local simples**
   - Pode ser:
     - SharedPreferences **OU**
     - Uma lista em memória (sem persistência) caso queira extrema simplicidade.
   - Não utilizar bancos de dados complexos como sqflite, Isar, ObjectBox, etc.

4. **Tela inicial extremamente simples**
   - AppBar com o nome “Kill Bills”
   - Botão flutuante (FloatingActionButton) para adicionar nova conta

5. **Não usar arquitetura complexa**
   - Nada de bloc, provider, GetX, MobX, Riverpod.
   - Apenas *setState()*.

6. **Não usar rotas elaboradas**
   - Pode usar:
     - Navigator.push()
     - Navigator.pop()

## Restrições e Simplicidades
- Não utilizar algoritmos complexos, padrões avançados ou estruturas de pasta elaboradas.
- Não implementar notificações push, background services ou alarmes nativos.
- Não integrar com APIs externas.
- Não utilizar bibliotecas externas além do Flutter padrão.
- Manter tudo centralizado na pasta `lib/`.
- Código focado no entendimento e aprendizado de iniciantes.

## Estrutura recomendada do projeto (muito simples)
lib/
 ├── main.dart
 ├── pages/
 │     ├── home_page.dart
 │     └── add_bill_page.dart
 ├── models/
 │     └── bill.dart
 └── storage/
       └── bill_storage.dart  (opcional para SharedPreferences)

## Modelo de dados sugerido
class Bill {
  final String name;
  final double value;
  final int dueDay;

  Bill({
    required this.name,
    required this.value,
    required this.dueDay,
  });
}

## Objetivo da IA (Copilot):
- Gerar código simples, fácil de ler e ideal para iniciantes.
- Seguir boas práticas básicas do Flutter.
- Evitar qualquer complexidade desnecessária.
- Ajudar a construir telas, formulários e listas com widgets nativos do Flutter.
- Sugerir implementações diretas usando setState().

## Estilo esperado
- Código limpo e comentado.
- Widgets simples.
- Organização mínima.
- Foco em clareza e didática.
