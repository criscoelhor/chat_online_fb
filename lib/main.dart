import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main(){

  Firestore.instance.collection("teste").document("testeDocument").setData({"teste" : "teste"});

 runApp(MyApp());
}

final ThemeData kIOSTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  primaryColorBrightness: Brightness.light,
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
    );
  }
}
