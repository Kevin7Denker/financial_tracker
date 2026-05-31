import '../../common/utils/formatter.dart';

/// ViewModel que encapsula os dados do usuário para exibição na UI.
///
/// Contém lógica de apresentação como saudação baseada na hora do dia
/// e formatação de valores monetários. Dados de mock para desenvolvimento.
class UserViewModel {
  final String name;
  final String avatarUrl;
  final double balance;
  final double totalIncome;
  final double totalExpense;

  const UserViewModel({
    required this.name,
    this.avatarUrl = '',
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
  });

  /// Cria um UserViewModel de mock para desenvolvimento
  factory UserViewModel.mock({
    double balance = 0,
    double totalIncome = 0,
    double totalExpense = 0,
  }) {
    return UserViewModel(
      name: 'Kevin',
      balance: balance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    );
  }

  /// Saldo formatado em moeda brasileira
  String get formattedBalance => Formatter.formatCurrency(balance);

  /// Total de receitas formatado
  String get formattedIncome => Formatter.formatCurrency(totalIncome);

  /// Total de despesas formatado
  String get formattedExpense => Formatter.formatCurrency(totalExpense);

  /// Saudação baseada na hora do dia
  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  /// Primeiro nome do usuário
  String get firstName => name.split(' ').first;

  /// Saudação completa (ex: "Boa tarde, Kevin")
  String get fullGreeting => '$greeting, $firstName';
}
