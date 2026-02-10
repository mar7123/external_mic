import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/model/network_host.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
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

  void _listen() async {}

  void _connect() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, child) => TextFormField(
                decoration: InputDecoration(label: Text(tr("ip_address"))),
                onChanged: (value) {
                  ref.read(_networkHostProvider.notifier).setIpAddress(value);
                },
              ),
            ),
            Consumer(
              builder: (context, ref, child) => TextFormField(
                decoration: InputDecoration(label: Text(tr("port"))),
                validator: (value) {
                  if (value == null) return tr("invalid_input_message");
                  int? intValue = int.tryParse(value);
                  if (intValue == null) return tr("invalid_input_message");
                  return null;
                },
                onChanged: (value) {
                  int? intValue = int.tryParse(value);
                  if (intValue != null) {
                    ref.read(_networkHostProvider.notifier).setPort(intValue);
                  }
                },
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text(tr("action_add"))),
          ],
        ),
      ),
    );
  }
}
