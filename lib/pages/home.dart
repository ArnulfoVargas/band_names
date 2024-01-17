import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final SocketService service = Provider.of<SocketService>(context, listen: false);

    service.socket.on("active-bands", (bands) {
      this.bands = (bands as List)
        .map((band) => Band.fromMap(band))
        .toList();

      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final SocketService service = Provider.of<SocketService>(context, listen: false);

    service.socket.off("active-bands");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final SocketService service = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          title: const Text(
              "Band Names", 
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                child: 
                  service.serverStatus == ServerStatus.online 
                ? Icon(Icons.wifi_tethering_outlined, color: Colors.blue[300],)
                : Icon(Icons.wifi_tethering_off_rounded, color: Colors.red[300],),
              )
            ],
            backgroundColor: Colors.white,
        ),

      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (ctx, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {

    final service = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      onDismissed: (_) {
        service.Emit("delete-band", {"id" : band.id});
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.redAccent,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.delete_outline_rounded, 
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
      child: ListTile(
        title: Text(band.name),
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        trailing: Text("${band.votes}", style: const TextStyle(fontSize: 15),),
        onTap: () {
          service.Emit("vote-band", {"id": band.id});
        }
      ),
    );
  }

  addNewBand(){
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return _androidDialog(textController);
    }

    return showCupertinoDialog(
      context: context, 
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text("New Band Name: "),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => {
                _addBandNameToList(textController.text)
              },
              child: const Text("Add"),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () => {
                Navigator.pop(context)
              },
              child: const Text("Cancel"),
            )
          ],
        );
      }
    );
  }

  Future<dynamic> _androidDialog(TextEditingController textController) {
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text("New Band Name: "),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => _addBandNameToList(textController.text),

              child: const Text("Add"),
            )
          ],
        );
      }
    );
  }

  void _addBandNameToList( String name) {
    if (name.isNotEmpty) {
      final service = Provider.of<SocketService>(context, listen: false);
      service.Emit("add-band", {"name" : name});
    }
    Navigator.pop(context);
  }
}