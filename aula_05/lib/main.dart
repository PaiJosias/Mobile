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
                ElevatedButton(onPressed: addTodo, child: Text("ADD"), style: ElevatedButton.styleFrom(primary: Colors.black)),
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
         child: const Align(
           alignment: Alignment(-0.9,0.9),
           child: Icon(
             Icons.delete,
             color: Colors.white,
           ))
       ),
       direction: DismissDirection.startToEnd,
       child: CheckboxListTile(
         title: Text(_todoList[index]["title"], style: const TextStyle(color: Colors.black),),
         value: _todoList[index]["ok"],
         secondary: CircleAvatar(
           backgroundColor: Colors.black,
           child: Icon(_todoList[index]["ok"] ? Icons.check : Icons.error, color: Colors.white),
         ),
         onChanged: (c){
           checkTodo(index, c);
         },
       ),
       onDismissed: (direction){
         setState(() {
           _lastRemoved = Map.from(_todoList[index]);
           _lastRemovedPos = index;
           _todoList.removeAt(index);
           _saveData();

           final snack = SnackBar(
             content: Text("Tarefa ${_lastRemoved["title"]} removida."),
             action: SnackBarAction(
               label: "Desfazer",
               onPressed: (){
                 setState(() {
                   _todoList.insert(_lastRemovedPos, _lastRemoved);
                   _saveData();
                 });
               }),
               duration: const Duration(seconds: 2),
           );
           ScaffoldMessenger.of(context).removeCurrentSnackBar();
           ScaffoldMessenger.of(context).showSnackBar(snack);
       });
      },  
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    final file = await _getFile();
    return file.readAsString();
  }

  void addTodo() {
    setState(() {
      Map<String, dynamic> newTodo = Map();
      newTodo["title"] = _todoController.text;
      _todoController.text = "";
      newTodo["ok"] = false;
      _todoList.add(newTodo);
      _saveData();
    });
  }

  void checkTodo(index, c) {
    setState(() {
      _todoList[index]["ok"] = c;
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a["ok"] && !b["ok"])
          return 1;
        else if (!a["ok"] && b["ok"])
          return -1;
        else
          return 0;
      });

      _saveData();
    });

    return null;
  }
}

