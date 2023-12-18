import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus{
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier{
  ServerStatus _serverStatus = ServerStatus.connecting;

  SocketService(){
    _initConfig();
  }

  void _initConfig(){
    IO.Socket socket = IO.io('http://192.168.100.21:3000/', 
        {'transports': ['websocket'], 'autoConnect': true}
      );

    socket.onConnect((_) {
      print('connect');
    });
    socket.onDisconnect((_) => print('disconnect'));
  }
}