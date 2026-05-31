import 'package:flutter/material.dart';

import '../../common/theme/app_theme.dart';

/// Widget base abstrato para cards do aplicativo.
///
/// Define a estrutura visual comum (sombra, bordas, padding) e força
/// subclasses a implementar [buildCardContent]. Segue o princípio de
/// herança da OOP — diferentes tipos de cards reutilizam a mesma base.
abstract class BaseCard extends StatelessWidget {
  /// Raio das bordas arredondadas
  final double borderRadius;

  /// Margem externa do card
  final EdgeInsets margin;

  /// Padding interno do card
  final EdgeInsets padding;

  /// Decoração customizada (opcional, sobrescreve os padrões)
  final BoxDecoration? customDecoration;

  const BaseCard({
    super.key,
    this.borderRadius = 16,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.customDecoration,
  });

  /// Método abstrato que subclasses devem implementar
  /// para definir o conteúdo específico do card.
  Widget buildCardContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      decoration: customDecoration ??
          BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: AppTheme.cardShadow,
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding,
          child: buildCardContent(context),
        ),
      ),
    );
  }
}
