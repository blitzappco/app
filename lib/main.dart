import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../v2/pages/splashscreen.dart';
import '../v2/providers/account_provider.dart';
import '../v2/providers/balance_provider.dart';
import '../v2/providers/route_provider.dart';
import '../v2/providers/tickets_provider.dart';
import '../v2/providers/trips_provider.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFFF8F8F8),
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFF8F8F8),
        ),
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AccountProvider()),
              ChangeNotifierProvider(create: (_) => TripsProvider()),
              ChangeNotifierProvider(create: (_) => RouteProvider()),
              ChangeNotifierProvider(create: (_) => BalanceProvider()),
              ChangeNotifierProvider(create: (_) => TicketsProvider()),
            ],
            child: MaterialApp(
                theme:
                    ThemeData(scaffoldBackgroundColor: const Color(0xFFF8F8F8)),
                debugShowCheckedModeBanner: false,
                home: const SplashScreen())));
  }
}
