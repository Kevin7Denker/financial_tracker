import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';
import '../model/transaction_view_model.dart';
import 'base_card.dart';

/// Item de lista responsivo para exibir uma transação.
///
/// Extende [BaseCard] por composição — utiliza a mesma base visual (sombra,
/// border radius) e implementa [buildCardContent] com layout específico.
///
/// Features:
/// - CircleAvatar com ícone de categoria (verde/vermelho)
/// - Título, data relativa e valor formatado com cor semântica
/// - InkWell com ripple effect
/// - Hero tag baseado no ID da transação para transições
class TransactionListItem extends BaseCard {
  /// ViewModel da transação com dados formatados
  final TransactionViewModel transaction;

  /// Callback ao tocar no item
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  }) : super(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.zero,
          borderRadius: 14,
        );

  @override
  Widget buildCardContent(BuildContext context) {
    return Hero(
      tag: 'transaction-${transaction.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // ─── Ícone de categoria ───
                _buildCategoryAvatar(),
                const SizedBox(width: 14),

                // ─── Título e data ───
                Expanded(child: _buildInfo(context)),

                // ─── Valor ───
                _buildAmount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Avatar circular com ícone da categoria
  Widget _buildCategoryAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: transaction.iconBackgroundColor,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        transaction.categoryIcon,
        color: transaction.amountColor,
        size: 22,
      ),
    );
  }

  /// Título e data relativa
  Widget _buildInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transaction.title,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          transaction.relativeDate,
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Valor formatado com cor semântica
  Widget _buildAmount() {
    return Text(
      transaction.signedAmount,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: transaction.amountColor,
      ),
    );
  }
}
