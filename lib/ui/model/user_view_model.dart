import '../../common/utils/formatter.dart';

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

  String get formattedBalance => Formatter.formatCurrency(balance);

  String get formattedIncome => Formatter.formatCurrency(totalIncome);

  String get formattedExpense => Formatter.formatCurrency(totalExpense);

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Bom dia';
    if (hour < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  String get firstName => name.split(' ').first;

  String get fullGreeting => '$greeting, $firstName';
}
