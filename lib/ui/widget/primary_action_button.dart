import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';

/// Botão principal arredondado, verde com texto branco.
///
/// Features:
/// - Animação de scale ao ser pressionado (press down → scale 0.95)
/// - Haptic feedback no tap
/// - Estado de loading com CircularProgressIndicator
/// - Ícone opcional à esquerda do label
class PrimaryActionButton extends StatefulWidget {
  /// Texto do botão
  final String label;

  /// Ícone opcional (exibido à esquerda do label)
  final IconData? icon;

  /// Callback ao pressionar
  final VoidCallback? onPressed;

  /// Se true, exibe um spinner ao invés do conteúdo
  final bool isLoading;

  /// Cor de fundo (padrão: AppColors.primary)
  final Color? backgroundColor;

  /// Cor do texto/ícone (padrão: branco)
  final Color? foregroundColor;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  State<PrimaryActionButton> createState() => _PrimaryActionButtonState();
}

class _PrimaryActionButtonState extends State<PrimaryActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    HapticFeedback.mediumImpact();
    widget.onPressed?.call();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final bg = widget.backgroundColor ?? AppColors.primary;
    final fg = widget.foregroundColor ?? Colors.white;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: widget.isLoading ? null : _onTapDown,
        onTapUp: widget.isLoading ? null : _onTapUp,
        onTapCancel: widget.isLoading ? null : _onTapCancel,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: widget.isLoading ? bg.withValues(alpha: 0.7) : bg,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: bg.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading ? _buildLoader(fg) : _buildContent(fg),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color fg) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: fg, size: 20),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLoader(Color fg) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(fg),
      ),
    );
  }
}
