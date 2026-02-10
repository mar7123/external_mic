import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:external_mic/model/network_host.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:external_mic/res/dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniaudio_dart/miniaudio_dart.dart' as ma;
import 'package:record/record.dart';

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

enum _ConnectionOption { LISTEN, CONNECT }

class ConnectionOptionNotifier extends Notifier<_ConnectionOption> {
  @override
  _ConnectionOption build() => _ConnectionOption.CONNECT;

  void set(_ConnectionOption connectionOption) {
    state = connectionOption;
  }
}

final _networkHostProvider = NotifierProvider(NetworkHostNotifier.new);

final _connectionOptionProvider = NotifierProvider(ConnectionOptionNotifier.new);

class _HomePage extends StatelessWidget {
  const _HomePage();

  void _listen({required String ipAddress, required int port}) async {
    final streamPlayer = ma.StreamPlayer();

    RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);

    socket.listen((RawSocketEvent event) {
      if (event == RawSocketEvent.read) {
        Datagram? dg = socket.receive();
        if (dg != null) {
          streamPlayer.pushData(dg.data.buffer.asByteData());
        }
      }
    });
  }

  void _connect({required String ipAddress, required int port}) async {
    final record = AudioRecorder();
    if (!(await record.hasPermission(request: true))) return;
    const config = RecordConfig(
      encoder: AudioEncoder.pcm16bits,
      sampleRate: 48000,
      numChannels: 1,
      androidConfig: AndroidRecordConfig(audioSource: AndroidAudioSource.voiceCommunication),
    );
    final micStream = await record.startStream(config);

    RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

    InternetAddress windowsIp = InternetAddress(ipAddress);

    micStream.listen((Uint8List audioData) {
      socket.send(audioData, windowsIp, port);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimens.dialogWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer(
                builder: (context, ref, child) => DropdownButtonFormField(
                  decoration: InputDecoration(label: Text(tr("connection_option"))),
                  initialValue: ref.watch(_connectionOptionProvider),
                  items: _ConnectionOption.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    ref.read(_connectionOptionProvider.notifier).set(value);
                  },
                ),
              ),
              SizedBox(height: Dimens.paddingWidget),
              Consumer(
                builder: (context, ref, child) => TextFormField(
                  decoration: InputDecoration(label: Text(tr("ip_address"))),
                  onChanged: (value) {
                    ref.read(_networkHostProvider.notifier).setIpAddress(value);
                  },
                ),
              ),
              SizedBox(height: Dimens.paddingWidget),
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
              SizedBox(height: Dimens.paddingWidget),
              Consumer(
                builder: (context, ref, child) {
                  var connectionOption = ref.watch(_connectionOptionProvider);
                  var networkHost = ref.watch(_networkHostProvider);
                  return ElevatedButton(
                    onPressed: () => switch (connectionOption) {
                      _ConnectionOption.LISTEN => _listen(ipAddress: networkHost.ipAddress, port: networkHost.port),
                      _ConnectionOption.CONNECT => _connect(ipAddress: networkHost.ipAddress, port: networkHost.port),
                    },
                    child: Text(switch (connectionOption) {
                      _ConnectionOption.LISTEN => tr("action_listen"),
                      _ConnectionOption.CONNECT => tr("action_connect"),
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
