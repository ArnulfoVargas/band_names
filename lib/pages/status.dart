import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
   
  const StatusPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    
    final SocketService socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("ServerStatus: ${socketService.serverStatus}"),
          ],
         ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed:  () {
          Map payload = {"name" : "Flutter", "message" : "Hello from flutter"};
          socketService.emit("new-message", payload);
        },
      ),
    );
  }
}