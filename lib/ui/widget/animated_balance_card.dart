import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';
import '../../common/utils/formatter.dart';

/// Card principal do dashboard mostrando o saldo do usuário.
///
/// Features:
/// - Gradiente verde vibrante como fundo
/// - Botão olho para ocultar/mostrar saldo (AnimatedSwitcher)
/// - Resumo de receitas e despesas na parte inferior
/// - Hero animation para transição de tela
/// - Scale animation na entrada
/// - Haptic feedback ao tocar no ícone do olho
class AnimatedBalanceCard extends StatefulWidget {
  /// Saldo atual do usuário
  final double balance;

  /// Total de receitas
  final double totalIncome;

  /// Total de despesas
  final double totalExpense;

  /// Saudação do usuário (ex: "Boa tarde, Kevin")
  final String greeting;

  const AnimatedBalanceCard({
    super.key,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    this.greeting = '',
  });

  @override
  State<AnimatedBalanceCard> createState() => _AnimatedBalanceCardState();
}

class _AnimatedBalanceCardState extends State<AnimatedBalanceCard>
    with SingleTickerProviderStateMixin {
  bool _isHidden = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    HapticFeedback.lightImpact();
    setState(() => _isHidden = !_isHidden);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'balance-card',
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Saudação + Botão olho ───
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.greeting.isNotEmpty)
                    Text(
                      widget.greeting,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  _buildEyeButton(),
                ],
              ),
              const SizedBox(height: 8),

              // ─── Label "Saldo disponível" ───
              Text(
                'Saldo disponível',
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 4),

              // ─── Valor do saldo (animado) ───
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  _isHidden
                      ? '••••••'
                      : Formatter.formatCurrency(widget.balance),
                  key: ValueKey('balance_${_isHidden}_${widget.balance}'),
                  style: GoogleFonts.montserrat(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ─── Resumo: Receitas e Despesas ───
              _buildSummaryRow(),
            ],
          ),
        ),
      ),
    );
  }

  /// Botão de ocultar/mostrar saldo com ripple
  Widget _buildEyeButton() {
    return Material(
      color: Colors.white.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _toggleVisibility,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Icon(
              _isHidden
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_rounded,
              key: ValueKey(_isHidden),
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// Linha inferior com receitas e despesas
  Widget _buildSummaryRow() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Receitas
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.arrow_upward_rounded,
              label: 'Receitas',
              value: _isHidden
                  ? '••••'
                  : Formatter.formatCurrency(widget.totalIncome),
              color: Colors.white,
            ),
          ),
          // Divisor vertical
          Container(
            width: 1,
            height: 36,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          // Despesas
          Expanded(
            child: _buildSummaryItem(
              icon: Icons.arrow_downward_rounded,
              label: 'Despesas',
              value: _isHidden
                  ? '••••'
                  : Formatter.formatCurrency(widget.totalExpense),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Item individual do resumo (ícone + label + valor)
  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
