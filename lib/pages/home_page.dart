import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/model/network_host.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:external_mic/res/dimens.dart';
import 'package:external_mic/utils/id_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends OptionalNavigatedPage {
  @override
  String get path => "/home";

  @override
  String get fullPath => path;

  @override
  StatelessWidget get widget => _HomePage();
}

class NetworkHostNotifier extends Notifier<NetworkHost> {
  @override
  NetworkHost build() => NetworkHost(ipAddress: "", port: 0);

  void setIpAddress(String ipAddress) {
    state = state.copyWith(ipAddress: ipAddress);
  }

  void setPort(int port) {
    state = state.copyWith(port: port);
  }
}

final _networkHostProvider = NotifierProvider(NetworkHostNotifier.new);

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(Dimens.paddingWidget),
              child: Consumer(
                builder: (context, ref, child) {
                  final homePage = ref.watch(_networkHostProvider);
                  return Text(homePage.ipAddress);
                },
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                return ElevatedButton(
                  onPressed: () {
                    ref
                        .read(_networkHostProvider.notifier)
                        .setIpAddress(IdUtils.generateRandomId());
                  },
                  child: Text(tr("action_add")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
