import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta de cores centralizada — identidade visual inspirada no PicPay.
/// Verde vibrante como primária, superfícies brancas, tipografia Montserrat.
class AppColors {
  AppColors._();

  // ─── Primárias ───
  static const Color primary = Color(0xFF11C76F);
  static const Color primaryDark = Color(0xFF0DA85C);
  static const Color primaryLight = Color(0xFFE8F9F0);

  // ─── Superfícies ───
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF7F8FA);

  // ─── Texto ───
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Semânticas ───
  static const Color income = Color(0xFF11C76F);
  static const Color expense = Color(0xFFEF4444);
  static const Color expenseLight = Color(0xFFFEE2E2);
  static const Color incomeLight = Color(0xFFE8F9F0);

  // ─── Neutros ───
  static const Color divider = Color(0xFFE5E7EB);
  static const Color disabled = Color(0xFF9CA3AF);
  static const Color cardShadow = Color(0x0F000000);

  // ─── Dark mode ───
  static const Color darkBackground = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF242438);
}

/// Gradientes reutilizáveis para profundidade e movimento na UI.
/// Substitui cores sólidas por transições suaves que criam sensação
/// de iluminação, volume e dinamismo.
class AppGradients {
  AppGradients._();

  // ─── Primários (verde) ───
  /// Gradiente principal para AppBar, headers, balance card
  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF15D978), Color(0xFF0DA85C), Color(0xFF089648)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente verde mais suave para botões de receita
  static const LinearGradient incomeButton = LinearGradient(
    colors: [Color(0xFF1FE07E), Color(0xFF11C76F), Color(0xFF0BAF5E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente leve para fundos de ícones de receita
  static const LinearGradient incomeLight = LinearGradient(
    colors: [Color(0xFFE8F9F0), Color(0xFFD5F5E3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Despesa (vermelho) ───
  /// Gradiente para botões de despesa e dismiss backgrounds
  static const LinearGradient expenseButton = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente leve para fundos de ícones de despesa
  static const LinearGradient expenseLight = LinearGradient(
    colors: [Color(0xFFFEE2E2), Color(0xFFFECACA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Superfícies ───
  /// Gradiente sutil para cards, criando sensação de profundidade
  static const LinearGradient surfaceCard = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente para o fundo do scaffold (leve profundidade vertical)
  static const LinearGradient scaffoldBackground = LinearGradient(
    colors: [Color(0xFFF0F2F5), Color(0xFFF7F8FA), Color(0xFFF0F2F5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente para seções de cabeçalho e badges
  static const LinearGradient accentBadge = LinearGradient(
    colors: [Color(0xFFE8F9F0), Color(0xFFD1FAE5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Bottom Sheet ───
  /// Gradiente para cabeçalho do bottom sheet de receita
  static const LinearGradient sheetHeaderIncome = LinearGradient(
    colors: [Color(0xFF15D978), Color(0xFF0DA85C)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Gradiente para cabeçalho do bottom sheet de despesa
  static const LinearGradient sheetHeaderExpense = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFDC2626)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─── Filtro ───
  /// Gradiente para o painel de filtros
  static const LinearGradient filterPanel = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF3FAF7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ─── Dark Mode ───
  /// Gradiente escuro para cards no dark mode
  static const LinearGradient darkCard = LinearGradient(
    colors: [Color(0xFF2A2A42), Color(0xFF1E1E34)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente escuro para AppBar no dark mode
  static const LinearGradient darkPrimary = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16162A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// Classe dedicada ao sistema de temas do aplicativo.
/// Centraliza ThemeData, tipografia Montserrat e todos os estilos
/// de componentes (botões, inputs, cards, bottom sheets).
class AppTheme {
  AppTheme._();

  /// Sombra suave padrão para cards flutuantes sobre fundo branco
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: AppColors.cardShadow,
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  /// Borda arredondada padrão (16px)
  static BorderRadius get cardBorderRadius => BorderRadius.circular(16);

  /// Borda arredondada para bottom sheets (24px, apenas topo)
  static BorderRadius get sheetBorderRadius => const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  // ─── TEMA CLARO ───
  static ThemeData lightTheme() {
    final base = GoogleFonts.montserratTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.expense,
        onSecondary: AppColors.textOnPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.expense,
        outline: AppColors.divider,
      ),
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: base.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: base.bodyLarge?.copyWith(color: AppColors.textPrimary),
        bodyMedium: base.bodyMedium?.copyWith(color: AppColors.textSecondary),
        bodySmall: base.bodySmall?.copyWith(color: AppColors.textSecondary),
        labelLarge: base.labelLarge?.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        labelStyle: GoogleFonts.montserrat(color: AppColors.textSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ─── TEMA ESCURO ───
  static ThemeData darkTheme() {
    final base = GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.textOnPrimary,
        secondary: AppColors.expense,
        onSecondary: AppColors.textOnPrimary,
        surface: AppColors.darkSurface,
        onSurface: Colors.white,
        error: AppColors.expense,
        outline: AppColors.darkCard,
      ),
      textTheme: base.copyWith(
        headlineLarge: base.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        headlineMedium: base.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        titleLarge: base.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: base.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkCard),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.darkCard),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: GoogleFonts.montserrat(color: AppColors.textSecondary),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}