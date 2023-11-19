import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import '../maps/place.dart';
import 'home_page.dart';
import '../pages/onboarding/onboarding.dart';

import '../providers/route_provider.dart';
import '../providers/trips_provider.dart';
import '../providers/account_provider.dart';

import '../utils/env.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showImage = true;

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  Future<void> requestLocationPermissions() async {
    await Permission.location.request();
  }

  @override
  void initState() {
    requestLocationPermissions();

    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _showImage = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final route = Provider.of<RouteProvider>(context, listen: false);

        final account = Provider.of<AccountProvider>(context, listen: false);
        final trips = Provider.of<TripsProvider>(context, listen: false);

        await route.initFrom();
        // route.selectFrom(Place(
        //     name: 'United Business Center 0',
        //     address: 'Timisoara',
        //     type: 'comm'));
        await account.loadAccount();

        if (account.token == '' || account.account.id == '') {
          Timer(
              const Duration(milliseconds: 100),
              () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Onboarding())));
        } else {
          await trips.getTrips(account.token);
          Timer(const Duration(milliseconds: 100), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          });
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final account = Provider.of<AccountProvider>(context, listen: false);

    // flutterWebviewPlugin
    //     .launch(AppURL.paymentsURL,
    //         withJavascript: true, withLocalStorage: true)
    //     .whenComplete(() {
    //   flutterWebviewPlugin.evalJavascript(
    //       "window.localStorage.setItem('token', '${account.token}')");
    // });
    // flutterWebviewPlugin.hide();
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _showImage
              ? Image.asset(
                  'assets/Images/logoa.png',
                  height: 100,
                )
              : const CircularProgressIndicator(
                  color: blitzPurple,
                ),
        ),
      ),
    );
  }
}
