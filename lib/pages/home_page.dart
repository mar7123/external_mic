import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:flutter/material.dart';

class HomePage extends OptionalNavigatedPage {
  @override
  String get path => "/home";

  @override
  String get fullPath => path;

  @override
  StatelessWidget get widget => _HomePage();
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: Text(tr("action_play"))),
          ],
        ),
      ),
    );
  }
}
