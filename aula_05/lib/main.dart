import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(title: "Lista de Tarefas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _todoList = [];
  Map<String, dynamic> _lastRemoved = Map();
  int _lastRemovedPos = 0;
  TextEditingController _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _todoList = json.decode(data);
      });
    });
  }

   Widget build(BuildContext context) {
     return Scaffold(
       appBar:  AppBar(
         title:  const Text("Lista de Tarefas"),
         backgroundColor: Colors.black,
         centerTitle: true,
       ),
       body: Column(
         children: <Widget>[
           Container(
             padding: const EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
             child: Row(
               children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(labelText: "Nova Tarefa", labelStyle: TextStyle(color: Colors.black)),
                  ),
                ),
                ElevatedButton(onPressed: addTodo, child: const Text("ADD"))
               ],
             ),
           ),
           Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: _todoList.length,
                  itemBuilder: buildItem),
           ))
         ],
       )
     );
   }

   Widget buildItem(context, index){
     return Dismissible(
       key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
       background: Container(
         color: Colors.red,
         child: Align(
           alignment: Alignment(-0.9,0.9),
           child: Icon(
             Icons.delete,
             color: Colors.white,
           ))
       ),
     );
   }
   
}