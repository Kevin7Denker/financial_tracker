import 'common/config/dependencies.dart';
import 'common/theme/app_theme.dart';
import 'ui/view/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  setupDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);

  runApp(
    MaterialApp(
      title: 'Financial Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const DashboardScreen(),
    ),
  );
}
