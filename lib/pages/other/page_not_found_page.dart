import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:external_mic/navigation/main_navigator.dart';
import 'package:external_mic/pages/home_page.dart';
import 'package:external_mic/res/dimens.dart';
import 'package:flutter/material.dart';

class PageNotFoundPage extends OptionalNavigatedPage {
  @override
  String get path => "/unknown";

  @override
  String get fullPath => path;

  @override
  StatelessWidget get widget => _PageNotFoundPage();
}

class _PageNotFoundPage extends StatelessWidget {
  const _PageNotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr("page_not_found_title"))),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: Dimens.paddingSmall),
            Text(tr("page_not_found_message"), textAlign: TextAlign.center),
            const SizedBox(height: Dimens.paddingSmall),
            ElevatedButton(
              onPressed: () => MainNavigator().go(HomePage()),
              child: Text(tr("go_home_message")),
            ),
          ],
        ),
      ),
    );
  }
}
