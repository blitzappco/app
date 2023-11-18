import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';

import '../providers/balance_provider.dart';
import '../providers/account_provider.dart';
import '../utils/url.dart';

class Topup extends StatefulWidget {
  const Topup({super.key});

  @override
  State<Topup> createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountProvider>(context, listen: false);
    flutterWebviewPlugin.show();
    flutterWebviewPlugin
        .launch('${AppURL.paymentsURL}/topup',
            withJavascript: true, withLocalStorage: true)
        .whenComplete(() {
      flutterWebviewPlugin.evalJavascript(
          "window.localStorage.setItem('token', '${account.token}')");
    });

    return WebviewScaffold(
      url: '${AppURL.paymentsURL}/topup',
      withJavascript: true,
      withLocalStorage: true,
      scrollBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () async {
                      final account =
                          Provider.of<AccountProvider>(context, listen: false);
                      final balance =
                          Provider.of<BalanceProvider>(context, listen: false);
                      await balance.getBalance(account.token);

                      flutterWebviewPlugin.hide();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back_ios_new)),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Adaugă sold',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'UberMoveBold'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
