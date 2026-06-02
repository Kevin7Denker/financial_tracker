import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/theme/app_theme.dart';

class PrimaryActionButton extends StatefulWidget {
  final String label;

  final IconData? icon;

  final VoidCallback? onPressed;

  final bool isLoading;

  final Gradient? gradient;

  final Color? backgroundColor;

  final Color? foregroundColor;

  const PrimaryActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.gradient,
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
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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

  Gradient _resolveGradient() {
    if (widget.gradient != null) return widget.gradient!;
    final base = widget.backgroundColor ?? AppColors.primary;
    final lighter = Color.lerp(base, Colors.white, 0.15)!;
    final darker = Color.lerp(base, Colors.black, 0.15)!;
    return LinearGradient(
      colors: [lighter, base, darker],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fg = widget.foregroundColor ?? Colors.white;
    final gradient = _resolveGradient();
    final shadowColor = widget.backgroundColor ?? AppColors.primary;

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
            gradient: widget.isLoading ? null : gradient,
            color:
                widget.isLoading
                    ? (widget.backgroundColor ?? AppColors.primary).withValues(
                      alpha: 0.5,
                    )
                    : null,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withValues(alpha: 0.3),
                blurRadius: 14,
                offset: const Offset(0, 6),
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
