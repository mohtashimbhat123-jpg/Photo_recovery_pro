import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/recovery_screen.dart';
import 'providers/recovery_provider.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PhotoRecoveryApp());
}

class PhotoRecoveryApp extends StatelessWidget {
  const PhotoRecoveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecoveryProvider()),
      ],
      child: MaterialApp(
        title: 'DeepScan Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const RecoveryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
