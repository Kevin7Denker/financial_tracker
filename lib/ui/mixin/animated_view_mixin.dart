import 'package:flutter/material.dart';

/// Mixin reutilizável para telas que compartilham lógica de animação de entrada.
///
/// Provê fade-in e slide-up suaves ao abrir a tela, evitando duplicação
/// de código em múltiplas views.
///
/// Uso:
/// ```dart
/// class _MyScreenState extends State<MyScreen>
///     with TickerProviderStateMixin, AnimatedViewMixin {
///   @override
///   void initState() {
///     super.initState();
///     initEntryAnimation();
///   }
///
///   @override
///   void dispose() {
///     disposeEntryAnimation();
///     super.dispose();
///   }
/// }
/// ```
mixin AnimatedViewMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  /// Controlador principal de animação de entrada
  AnimationController get entryController => _entryController;

  /// Animação de opacidade (fade in)
  Animation<double> get fadeAnimation => _fadeAnimation;

  /// Animação de posição (slide de baixo para cima)
  Animation<Offset> get slideAnimation => _slideAnimation;

  /// Inicializa as animações de entrada da tela.
  /// Deve ser chamado no `initState()`.
  void initEntryAnimation({
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
  }) {
    _entryController = AnimationController(vsync: this, duration: duration);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: curve));

    _entryController.forward();
  }

  /// Libera os recursos da animação. Deve ser chamado no `dispose()`.
  void disposeEntryAnimation() {
    _entryController.dispose();
  }

  /// Envolve um widget filho com a animação de entrada (fade + slide).
  Widget animatedEntry({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: child),
    );
  }
}
