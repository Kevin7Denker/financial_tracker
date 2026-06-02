import 'package:flutter/material.dart';

import '../../common/theme/app_theme.dart';

abstract class BaseCard extends StatelessWidget {
  final double borderRadius;

  final EdgeInsets margin;

  final EdgeInsets padding;

  final BoxDecoration? customDecoration;

  const BaseCard({
    super.key,
    this.borderRadius = 16,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.customDecoration,
  });

  Widget buildCardContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      decoration:
          customDecoration ??
          BoxDecoration(
            gradient: AppGradients.surfaceCard,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: AppTheme.cardShadow,
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(padding: padding, child: buildCardContent(context)),
      ),
    );
  }
}
