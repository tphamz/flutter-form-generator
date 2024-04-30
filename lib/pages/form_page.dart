// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/record_provider.dart';
import 'package:sample/providers/package_provider.dart';
import 'package:sample/providers/page_provider.dart';
import 'package:sample/providers/elements_provider.dart';
import 'package:sample/components/elements/form_elements.dart';
import 'package:sample/utilities/camera.dart';

class FormPage extends StatelessWidget {
  static const routeName = "/pages";
  FormPage({super.key}) {
    cameraInit();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null) {
      Future.delayed(
          const Duration(milliseconds: 100), () => Navigator.pop(context));
      return Container();
    }
    return MultiProvider(
        providers: [
          Provider(create: (_) => PackageProvider()),
          ProxyProvider<PackageProvider, PageProvider>(
              update: (_, __, ___) => PageProvider(packageProvider: __)),
          ProxyProvider<PageProvider, ElementsProvider>(
              update: (_, __, ___) => ElementsProvider(pageProvider: __)),
          ProxyProvider2<PageProvider, ElementsProvider, RecordProvider>(
              create: (_) => RecordProvider(),
              update: (_, pageProvider, elementsProvider, self) => self?.setup(
                  elementsProvider: elementsProvider,
                  page: pageProvider.page?["page_level"],
                  pageLevel: pageProvider.pageLevel,
                  index: pageProvider.pageIndex)),
        ],
        child: Builder(builder: (BuildContext innerContext) {
          final packageProvider = Provider.of<PackageProvider>(innerContext);
          return FutureBuilder<Map<String, dynamic>?>(
              future: packageProvider.setup(args.toString()),
              builder: (_, snapshot) {
                if (snapshot.connectionState != ConnectionState.done)
                  return const Text("Loading....",
                      textDirection: TextDirection.ltr);
                return const FormDetailContent();
              });
        }));
  }
}

class FormDetailContent extends StatelessWidget {
  const FormDetailContent({super.key});

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context, listen: true);
    final page = pageProvider.page;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(page?["page_level"]["label"]),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(8.0),
                    constraints:
                        const BoxConstraints(minWidth: 400, maxWidth: 800),
                    child: const FormElements()))));
  }
}
