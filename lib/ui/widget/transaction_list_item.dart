import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';
import '../model/transaction_view_model.dart';
import 'base_card.dart';

class TransactionListItem extends BaseCard {
  final TransactionViewModel transaction;

  final VoidCallback? onTap;

  const TransactionListItem({super.key, required this.transaction, this.onTap})
    : super(
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
                _buildCategoryAvatar(),
                const SizedBox(width: 14),

                Expanded(child: _buildInfo(context)),

                _buildAmount(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient:
            transaction.isIncome
                ? AppGradients.incomeLight
                : AppGradients.expenseLight,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        transaction.categoryIcon,
        color: transaction.amountColor,
        size: 22,
      ),
    );
  }

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
