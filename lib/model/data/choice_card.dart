import 'package:flutter/material.dart';

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
  
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Quick add category',icon: Icons.add_box),
  const Choice(title: 'Reorder list', icon: Icons.cached)
];