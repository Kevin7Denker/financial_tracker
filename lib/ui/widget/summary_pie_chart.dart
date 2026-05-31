import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';
import '../../common/utils/formatter.dart';

/// Widget de gráfico de pizza mostrando proporção Receitas vs. Despesas.
///
/// Utiliza a nova paleta verde/vermelho da identidade PicPay.
/// Exibe estado vazio quando não há dados disponíveis.
class SummaryPieChart extends StatelessWidget {
  /// Total de receitas
  final double totalIncome;

  /// Total de despesas
  final double totalExpense;

  const SummaryPieChart({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Cabeçalho ───
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Receitas vs. Despesas',
                style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Gráfico ou Estado Vazio ───
          if (totalIncome == 0 && totalExpense == 0)
            _buildEmptyState(context)
          else
            SizedBox(
              height: 150,
              child: Row(
                children: [
                  Expanded(flex: 3, child: _buildPieChart()),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendItem('Receitas', AppColors.income, totalIncome),
                        const SizedBox(height: 16),
                        _buildLegendItem('Despesas', AppColors.expense, totalExpense),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 28,
        sections: [
          PieChartSectionData(
            value: totalIncome,
            title: '',
            radius: 55,
            color: AppColors.income,
            showTitle: false,
          ),
          PieChartSectionData(
            value: totalExpense,
            title: '',
            radius: 55,
            color: AppColors.expense,
            showTitle: false,
          ),
        ],
        borderData: FlBorderData(show: false),
        pieTouchData: PieTouchData(enabled: false),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            Formatter.formatCurrency(amount),
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_chart_rounded, size: 48, color: AppColors.disabled),
            const SizedBox(height: 12),
            Text(
              'Sem transações cadastradas',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Adicione transações para ver o gráfico',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: AppColors.disabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
