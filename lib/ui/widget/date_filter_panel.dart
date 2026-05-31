import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../common/theme/app_theme.dart';
import '../../common/types/date_filter_type.dart';

/// Painel de filtro de data para transações.
///
/// Re-estilizado com a paleta PicPay — chips verdes, superfícies brancas,
/// bordas arredondadas. Mantém toda a lógica funcional original.
class DateFilterPanel extends StatefulWidget {
  /// Callback quando o filtro muda (com start/end date)
  final Function(DateTime? startDate, DateTime? endDate) onFilterChanged;

  /// Callback para buscar todas as transações (filtro "Tudo")
  final Function() onAllTransactionsFiltered;

  /// Callback para atualizar os parâmetros do filtro no controller
  final Function(DateFilterType type, DateTime? startDate, DateTime? endDate)
      onUpdateFilter;

  /// Callback para ocultar o painel de filtros
  final VoidCallback? onTapHideFilter;

  /// Estado atual do filtro (tipo, start, end)
  final ({DateFilterType type, DateTime? startDate, DateTime? endDate}) filtro;

  const DateFilterPanel({
    super.key,
    required this.onFilterChanged,
    required this.filtro,
    this.onTapHideFilter,
    required this.onAllTransactionsFiltered,
    required this.onUpdateFilter,
  });

  @override
  State<DateFilterPanel> createState() => _DateFilterPanelState();
}

class _DateFilterPanelState extends State<DateFilterPanel> {
  late DateFilterType _filterType;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _filterType = widget.filtro.type;
    _startDate = widget.filtro.startDate;
    _endDate = widget.filtro.endDate;
    _initializeDates();
  }

  void _initializeDates() {
    final now = DateTime.now();
    final range = _filterType.resolveRange(now, _startDate, _endDate);
    setState(() {
      _startDate = range?.start;
      _endDate = range?.end;
    });
  }

  void _applyFilter(DateFilterType type) {
    setState(() {
      _filterType = type;
      _initializeDates();
    });

    if (type == DateFilterType.all) {
      widget.onAllTransactionsFiltered();
    } else {
      widget.onFilterChanged(_startDate, _endDate);
    }
    widget.onUpdateFilter(_filterType, _startDate, _endDate);
  }

  Future<void> _selectCustomDateRange() async {
    final now = DateTime.now();
    final maxDate = now.add(const Duration(days: 1));
    final safeRange = _filterType
        .resolveRange(now, _startDate, _endDate)
        ?.cappedAt(maxDate);

    final pickedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: safeRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _filterType = DateFilterType.custom;
        _startDate = pickedDateRange.start;
        _endDate = DateTime(
          pickedDateRange.end.year,
          pickedDateRange.end.month,
          pickedDateRange.end.day,
          23,
          59,
          59,
        );
      });
      widget.onFilterChanged(_startDate, _endDate);
      widget.onUpdateFilter(_filterType, _startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
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
              GestureDetector(
                onTap: widget.onTapHideFilter,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Filtro por Período',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              // Botão de fechar
              GestureDetector(
                onTap: widget.onTapHideFilter,
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ─── Chips de filtro ───
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip(DateFilterType.all, 'Tudo'),
              _buildFilterChip(DateFilterType.today, 'Hoje'),
              _buildFilterChip(DateFilterType.week, 'Esta Semana'),
              _buildFilterChip(DateFilterType.month, 'Este Mês'),
              _buildFilterChip(DateFilterType.custom, 'Personalizado'),
            ],
          ),

          // ─── Range de data customizado ───
          if (_filterType == DateFilterType.custom &&
              _startDate != null &&
              _endDate != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: _selectCustomDateRange,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.edit_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilterChip(DateFilterType type, String label) {
    final isSelected = _filterType == type;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.background,
        checkmarkColor: Colors.white,
        labelStyle: GoogleFonts.montserrat(
          fontSize: 13,
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        onSelected: (selected) {
          if (selected) {
            if (type == DateFilterType.custom) {
              _selectCustomDateRange();
            } else {
              _applyFilter(type);
            }
          }
        },
      ),
    );
  }
}
