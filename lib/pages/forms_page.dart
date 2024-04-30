// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:sample/components/forms/forms.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/pages_provider.dart';

class FormsPage extends StatelessWidget {
  const FormsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Provider(
        create: (_) => PagesProvider(), child: const FormsContent());
  }
}

class FormsContent extends StatelessWidget {
  const FormsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final pagesProvider = Provider.of<PagesProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pages"),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    constraints:
                        const BoxConstraints(minWidth: 400, maxWidth: 680),
                    child: FutureBuilder(
                        future: pagesProvider.setup(),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done)
                            return const SkeletonForms();
                          return const Forms();
                        })))));
  }
}
