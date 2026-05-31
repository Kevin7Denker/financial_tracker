import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/errors/errors_classes.dart';
import '../../common/patterns/command.dart';
import '../../common/theme/app_theme.dart';
import '../../domain/entity/transaction_entity.dart';
import 'transaction_form.dart';

/// Bottom sheet modal para adicionar transações.
///
/// Re-estilizado com bordas arredondadas (24px), cabeçalho verde,
/// alça de arraste translúcida e animações de entrada suaves.
class TransactionBottomSheet extends StatelessWidget {
  /// Tipo da transação (receita ou despesa)
  final TransactionType type;

  /// Comando para submeter a transação
  final Command1<void, Failure, TransactionEntity> submitCommand;

  const TransactionBottomSheet({
    super.key,
    required this.type,
    required this.submitCommand,
  });

  /// Método auxiliar para exibir o bottom sheet como modal
  static Future<void> show({
    required BuildContext context,
    required TransactionType type,
    required Command1<void, Failure, TransactionEntity> submitCommand,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionBottomSheet(
        type: type,
        submitCommand: submitCommand,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = type == TransactionType.income;
    final color = isIncome ? AppColors.primary : AppColors.expense;
    final formTitle = type.nameSingular;
    final availableHeight = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: availableHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppTheme.sheetBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Cabeçalho colorido ───
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppTheme.sheetBorderRadius,
            ),
            child: Column(
              children: [
                // Alça de arraste
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Título
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isIncome
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Adicionar $formTitle',
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ─── Formulário ───
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: TransactionForm(
                  type: type,
                  color: color,
                  submitCommand: submitCommand,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
