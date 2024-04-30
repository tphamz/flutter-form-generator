// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:sample/pages/forms_page.dart';
import 'package:sample/pages/form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {FormPage.routeName: (context) => FormPage()},
        home: const FormsPage(),
        theme: ThemeData());
  }
}
