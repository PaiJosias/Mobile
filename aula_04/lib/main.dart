import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=c3367cdd";

void main() async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final realController = TextEditingController();

  double? dolar;
  double? euro;

  void _realChange(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dolar!).toStringAsFixed(2);
    euroController.text = (real / euro!).toStringAsFixed(2);
  }
  
  void _dolarChange(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar!/euro!).toStringAsFixed(2);
  }

  void _euroChange(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro!).toStringAsFixed(2);
    dolarController.text = (euro * this.euro!/dolar!).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

   Widget build(BuildContext context) {
     return Scaffold();
   }
}