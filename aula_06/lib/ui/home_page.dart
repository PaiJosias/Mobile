import 'dart:io';

import 'package:aula_06/domain/contact.dart';
import 'package:aula_06/helper/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contatos = [];

  void initState() {
    super.initState();
    //then retorna um futuro e coloca em list
    updateList();
  }

  void updateList() {
    helper.getAllContact().then((list) {
      //atualizando a lista de contatos na tela
      setState(() {
        contatos = list.cast<Contact>();
      });
    });
  }

  

}