import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:semnox/colors/colors.dart';
import 'package:semnox/core/routes.dart';
import 'package:semnox/features/splash/splashscreen.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: Routes.routesMap,
        home: const SplashScreen(),
        theme: ThemeData(
          useMaterial3: true,
          iconTheme: const IconThemeData(color: CustomColors.customBlue),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            fillColor: Colors.transparent,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
