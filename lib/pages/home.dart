import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bands_names/models/bands.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metaliza', votes: 3),
    Band(id: '2', name: 'Queen', votes: 2),
    Band(id: '3', name: 'Heroes ', votes: 5),
    Band(id: '4', name: 'Bon Jovi', votes: 9)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 3,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => _bandTitle(bands[i])),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 3,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTitle(Band banda) {
    return Dismissible(
      key: Key(banda.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('direction: $direction');
        print('ID: ${banda.id}');
        // TODO:  llamar el borrado en el server
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.teal,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Eliminando Banda..',
              style: TextStyle(color: Colors.yellow)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(banda.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(banda.name),
        trailing: Text('${banda.votes}', style: TextStyle(fontSize: 20)),
        onTap: () {
          print(banda.name);
        },
      ),
    );
  }

  addNewBand() {
    // print('??? Ohhh');
    // para capturar los datos de lo que se ingresa se usa un textController
    final textController = new TextEditingController();

    // Esto es para diferenciar entre Android e IOS
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band Name:'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                    child: Text('Adiciona'),
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () {
                      addBandToList(textController.text);
                    })
              ],
            );
          });
    }

    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('Nuevo nombre de banda'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Agregar'),
                onPressed: () {
                  addBandToList(textController.text);
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    print(name);
    if (name.length > 0) {
      // podemos agregar
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
