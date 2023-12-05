import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
   
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final List<Band> bands = [
    Band(id: '1', name: 'Los Tigres Del Norte', votes: 0),
    Band(id: '2', name: 'Cuisillos', votes: 0),
    Band(id: '3', name: 'Guns & Roses', votes: 0),
    Band(id: '4', name: 'Metallica', votes: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          title: const Text(
              "Band Names", 
              style: TextStyle(
                color: Colors.black
              ),
            ),
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
    return Dismissible(
      key: Key(band.id),
      onDismissed: (direction) {
        print("Dismissed ${band.name}");
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
        trailing: Text("${band.votes}", style: const TextStyle(fontSize: 20),),
        onTap: () {
          print(band.name);
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
      //Can add
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}