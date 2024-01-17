import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus{
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.connecting;
  io.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket!;

  get emit => _socket!.emit;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    _socket = io.io('http://192.168.100.21:3000/', 
        {'transports': ['websocket'], 'autoConnect': true}
      );

    _socket!.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket!.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}