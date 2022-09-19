import 'package:flutter/material.dart';
import 'result.dart';

class Home extends StatefulWidget{
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  void _resetCampos(){
    _formKey.currentState!.reset();
    pesoController = TextEditingController();
    alturaController = TextEditingController();
  }

  void _calcular() {

    String _texto = "";
    String _imagem = "";

    double peso = double.parse(pesoController.text);
    double altura = double.parse(alturaController.text) / 100;

    double imc = peso / (altura * altura);

    if (imc < 18.6){
      _texto = "Abaixo do peso (${imc.toStringAsPrecision(4)})";
      _imagem = "images/thin.jpg";
    }
    else if (imc > 18.6 && imc <  24.9){
      _texto = "Peso ideal (${imc.toStringAsPrecision(4)})";
      _imagem = "images/shape.jpg";
    }
    else if (imc > 24.9 && imc <  29.9){
      _texto = "Levemente acima do peso (${imc.toStringAsPrecision(4)})";
      _imagem = "images/fat.jpg";
    }
    else if (imc > 29.9 && imc <  34.9){
      _texto = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      _imagem = "images/fat.jpg";
    }
    else if (imc > 34.9 && imc <  39.9){
      _texto = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      _imagem = "images/fat.jpg";
    }
    else if (imc >=40){
      _texto = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      _imagem = "images/fat.jpg";
    }
    
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => Result(_imagem, _texto)));

  }

  Widget build (BuildContext context){

  return Scaffold(
    appBar: AppBar(
      title: Text("Calculadora de IMC V2"),
      centerTitle: true,
      actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetCampos,
          )
        ]
    ),

    body: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.person, size:120, color: Colors.blueAccent),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                labelStyle: TextStyle(color: Colors.blueAccent)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueAccent,fontSize: 25.0),
              controller: pesoController,
              validator: (value){
                if(value!.isEmpty){
                  return "Insira seu peso!";
                }
                else{
                  return null;
                }
              }
              
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (cm)",
                labelStyle: TextStyle(color: Colors.blueAccent)
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueAccent,fontSize: 25.0),
              controller: alturaController,
              validator: (value){
                if(value!.isEmpty){
                  return "Insira seu peso!";
                }
                else{
                  return null;
                }
              }
            ),
            Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: ButtonTheme(
                    height: 50.0,
                    highlightColor: Colors.amber,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()){
                          _calcular();
                        }
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                    )),
              ),
          ],
        )
      ),
    )

  );
}
}