// ignore_for_file: avoid_print

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  factory SocketService() => _instance;
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();

  io.Socket? _socket;

  io.Socket? get socket => _socket;

  void connect(String url) {
    print('The socket url is : $url');
    if (_socket != null && _socket!.connected) return;
    _socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket!.on('connect', (_) => print('Connected to WebSocket server'));
    _socket!.on('disconnect', (_) => print('Disconnected from WebSocket server'));
  }

  void onNewLog(void Function(dynamic) callback) {
    _socket?.on('newLog', callback);
  }

  void disconnect() {
    _socket?.disconnect();
  }
} 