class NetworkHost {
  final String ipAddress;
  final int port;

  NetworkHost({required this.ipAddress, required this.port});

  NetworkHost copyWith({String? ipAddress, int? port}) => NetworkHost(
    ipAddress: ipAddress ?? this.ipAddress,
    port: port ?? this.port,
  );
}
