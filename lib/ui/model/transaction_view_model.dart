import 'package:flutter/material.dart';

import '../../common/theme/app_theme.dart';
import '../../common/utils/formatter.dart';
import '../../domain/entity/transaction_entity.dart';

/// ViewModel que encapsula a lógica de apresentação de uma transação.
///
/// Recebe uma [TransactionEntity] do domínio e expõe dados formatados
/// prontos para consumo direto pela camada de UI, seguindo o princípio
/// de encapsulamento — a View não precisa conhecer regras de formatação.
class TransactionViewModel {
  final TransactionEntity _entity;

  const TransactionViewModel(this._entity);

  /// Construtor nomeado a partir de uma entidade do domínio
  factory TransactionViewModel.fromEntity(TransactionEntity entity) {
    return TransactionViewModel(entity);
  }

  // ─── Acesso direto aos dados da entidade ───

  String get id => _entity.id;
  String get title => _entity.title;
  double get amount => _entity.amount;
  DateTime get date => _entity.date;
  TransactionType get type => _entity.type;
  bool get isIncome => type == TransactionType.income;

  /// Entidade original — necessária para passar ao controller/command
  TransactionEntity get entity => _entity;

  // ─── Dados formatados para UI ───

  /// Valor formatado em moeda brasileira (ex: R$ 1.234,56)
  String get formattedAmount => Formatter.formatCurrency(amount);

  /// Data formatada por extenso (ex: 01 de janeiro de 2025)
  String get formattedDate => Formatter.formatDate(date);

  /// Data compacta (ex: 01/01/2025)
  String get compactDate => Formatter.formatCompactDate(date);

  /// Data relativa legível (ex: Hoje, Ontem, Há 3 dias)
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

  /// Ícone representando a categoria da transação
  IconData get categoryIcon {
    return isIncome ? Icons.trending_up_rounded : Icons.trending_down_rounded;
  }

  /// Cor do valor baseada no tipo
  Color get amountColor => isIncome ? AppColors.income : AppColors.expense;

  /// Cor de fundo do avatar de categoria
  Color get iconBackgroundColor {
    return isIncome ? AppColors.incomeLight : AppColors.expenseLight;
  }

  /// Prefixo do valor (+ ou -)
  String get amountPrefix => isIncome ? '+' : '-';

  /// Valor formatado com sinal (ex: + R$ 1.234,56)
  String get signedAmount => '$amountPrefix $formattedAmount';
}
