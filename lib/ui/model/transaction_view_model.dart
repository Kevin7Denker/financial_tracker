import 'package:flutter/material.dart';

import '../../common/theme/app_theme.dart';
import '../../common/utils/formatter.dart';
import '../../domain/entity/transaction_entity.dart';

class TransactionViewModel {
  final TransactionEntity _entity;

  const TransactionViewModel(this._entity);

  factory TransactionViewModel.fromEntity(TransactionEntity entity) {
    return TransactionViewModel(entity);
  }

  String get id => _entity.id;
  String get title => _entity.title;
  double get amount => _entity.amount;
  DateTime get date => _entity.date;
  TransactionType get type => _entity.type;
  bool get isIncome => type == TransactionType.income;

  TransactionEntity get entity => _entity;

  String get formattedAmount => Formatter.formatCurrency(amount);

  String get formattedDate => Formatter.formatDate(date);

  String get compactDate => Formatter.formatCompactDate(date);

  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDay = DateTime(date.year, date.month, date.day);
    final difference = today.difference(transactionDay).inDays;

    if (difference == 0) return 'Hoje';
    if (difference == 1) return 'Ontem';
    if (difference < 7) return 'Há $difference dias';
    if (difference < 30) {
      final weeks = (difference / 7).floor();
      return 'Há $weeks semana${weeks > 1 ? 's' : ''}';
    }
    return compactDate;
  }

  IconData get categoryIcon {
    return isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded;
  }

  Color get amountColor => isIncome ? AppColors.income : AppColors.expense;

  Color get iconBackgroundColor {
    return isIncome ? AppColors.incomeLight : AppColors.expenseLight;
  }

  String get amountPrefix => isIncome ? '+' : '-';

  String get signedAmount => '$amountPrefix $formattedAmount';
}
