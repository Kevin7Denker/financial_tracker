import 'package:flutter/material.dart';

mixin AnimatedViewMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  AnimationController get entryController => _entryController;

  Animation<double> get fadeAnimation => _fadeAnimation;

  Animation<Offset> get slideAnimation => _slideAnimation;

  void initEntryAnimation({
    Duration duration = const Duration(milliseconds: 600),
    Curve curve = Curves.easeOutCubic,
  }) {
    _entryController = AnimationController(vsync: this, duration: duration);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _entryController, curve: curve));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryController, curve: curve));

    _entryController.forward();
  }

  void disposeEntryAnimation() {
    _entryController.dispose();
  }

  Widget animatedEntry({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: child),
    );
  }
}
