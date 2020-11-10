import 'package:flutter/material.dart';
import 'package:to_do_app/ui_layer/items_screen.dart';

/// A [StatelessWidget] subclass.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity),
      home: ItemsScreen(title: 'TODO'));
  }
}