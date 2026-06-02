import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../common/config/dependencies.dart';
import '../../common/theme/app_theme.dart';
import '../../domain/entity/transaction_entity.dart';
import '../controller/home_page_controller.dart';
import '../mixin/animated_view_mixin.dart';
import '../model/transaction_view_model.dart';
import '../model/user_view_model.dart';
import '../widget/animated_balance_card.dart';
import '../widget/date_filter_panel.dart';
import '../widget/primary_action_button.dart';
import '../widget/summary_pie_chart.dart';
import '../widget/transaction_bottom_sheet.dart';
import '../widget/transaction_list_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin, AnimatedViewMixin {
  late HomePageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = injector.get<HomePageController>();
    _controller.load.execute();
    initEntryAnimation();
  }

  @override
  void dispose() {
    disposeEntryAnimation();
    super.dispose();
  }

  void _showTransactionSheet(TransactionType type) {
    TransactionBottomSheet.show(
      context: context,
      type: type,
      submitCommand:
          type == TransactionType.income
              ? _controller.addIncome
              : _controller.addExpense,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: animatedEntry(
        child: Watch((context) {
          final income = _controller.totalIncome.value;
          final expense = _controller.totalExpense.value;
          final balance = _controller.balance.value;
          final incomes = _controller.incomes.value;
          final expenses = _controller.expenses.value;
          final isFilterVisible = _controller.isFilterVisible.value;

          final user = UserViewModel.mock(
            balance: balance,
            totalIncome: income,
            totalExpense: expense,
          );

          final allTransactions = [...incomes, ...expenses]
            ..sort((a, b) => b.date.compareTo(a.date));
          final viewModels =
              allTransactions
                  .map((e) => TransactionViewModel.fromEntity(e))
                  .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              _buildSliverAppBar(user, isFilterVisible),

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    AnimatedBalanceCard(
                      balance: balance,
                      totalIncome: income,
                      totalExpense: expense,
                      greeting: user.fullGreeting,
                    ),

                    const SizedBox(height: 16),

                    _buildActionButtons(),

                    const SizedBox(height: 8),

                    AnimatedSize(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      child:
                          isFilterVisible
                              ? DateFilterPanel(
                                filtro: (
                                  type: _controller.filterType,
                                  startDate: _controller.startDate,
                                  endDate: _controller.endDate,
                                ),
                                onFilterChanged: (startDate, endDate) {
                                  _controller.searchTransactionsByDate.execute(
                                    startDate!,
                                    endDate!,
                                  );
                                },
                                onUpdateFilter: (type, startDate, endDate) {
                                  _controller.setFiltersParams(
                                    type,
                                    startDate,
                                    endDate,
                                  );
                                },
                                onAllTransactionsFiltered: () {
                                  _controller.load.execute();
                                },
                                onTapHideFilter:
                                    _controller.toggleFilterVisibility,
                              )
                              : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 8),

                    SummaryPieChart(totalIncome: income, totalExpense: expense),

                    const SizedBox(height: 16),

                    _buildTransactionsHeader(viewModels.length),
                  ],
                ),
              ),

              if (viewModels.isEmpty)
                SliverToBoxAdapter(child: _buildEmptyTransactions())
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final vm = viewModels[index];

                    return Dismissible(
                      key: Key(vm.id),
                      direction: DismissDirection.endToStart,
                      background: _buildDismissBackground(),
                      onDismissed: (_) => _onTransactionDismissed(vm),
                      child: TransactionListItem(transaction: vm, onTap: () {}),
                    );
                  }, childCount: viewModels.length),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSliverAppBar(UserViewModel user, bool isFilterVisible) {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
        title: Text(
          'Controle Financeiro',
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isFilterVisible
                ? Icons.filter_list_off_rounded
                : Icons.filter_list_rounded,
          ),
          tooltip: isFilterVisible ? 'Ocultar filtros' : 'Mostrar filtros',
          onPressed: _controller.toggleFilterVisibility,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: PrimaryActionButton(
              label: 'Receita',
              icon: Icons.add_circle_rounded,
              backgroundColor: AppColors.primary,
              onPressed: () => _showTransactionSheet(TransactionType.income),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryActionButton(
              label: 'Despesa',
              icon: Icons.remove_circle_rounded,
              backgroundColor: AppColors.expense,
              onPressed: () => _showTransactionSheet(TransactionType.expense),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsHeader(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Transações Recentes',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLight,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: AppColors.expense,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.delete_rounded, color: Colors.white, size: 24),
    );
  }

  Widget _buildEmptyTransactions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.receipt_long_rounded, size: 56, color: AppColors.disabled),
          const SizedBox(height: 14),
          Text(
            'Nenhuma transação ainda',
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Adicione receitas ou despesas para começar',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: AppColors.disabled,
            ),
          ),
        ],
      ),
    );
  }

  void _onTransactionDismissed(TransactionViewModel vm) async {
    final undoEntity = vm.entity.copyWith();
    await _controller.deleteTransaction.execute(vm.id);

    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vm.title} excluída!', style: GoogleFonts.montserrat()),
        backgroundColor: AppColors.expense,
        action: SnackBarAction(
          label: 'DESFAZER',
          textColor: Colors.white,
          onPressed: () async {
            await _controller.undoDelectedTransaction.execute(undoEntity);
            if (_controller
                    .undoDelectedTransaction
                    .resultSignal
                    .value
                    ?.isSuccess ??
                false) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${vm.title} restaurada!',
                    style: GoogleFonts.montserrat(),
                  ),
                  backgroundColor: AppColors.primary,
                ),
              );
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${_controller.undoDelectedTransaction.resultSignal.value?.failureValueOrNull ?? 'Erro desconhecido'}',
                    style: GoogleFonts.montserrat(),
                  ),
                  backgroundColor: AppColors.expense,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
