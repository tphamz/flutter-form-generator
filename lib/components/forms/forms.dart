import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/pages_provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:sample/pages/form_page.dart';

class Forms extends StatelessWidget {
  const Forms({super.key});

  Widget elementContainer(Widget element) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: element);
  }

  @override
  Widget build(BuildContext context) {
    final pagesProvider = Provider.of<PagesProvider>(context, listen: true);
    var pages = pagesProvider.pages ?? [];
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [for (var ele in pages) ListItem(ele)],
    );
  }
}

class ListItem extends StatelessWidget {
  final dynamic item;
  const ListItem(this.item, {super.key});
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      onTap: () {
        Navigator.pushNamed(context, FormPage.routeName,
            arguments: item.packageName);
      },
      contentPadding: const EdgeInsets.all(8.0),
      leading: CircleAvatar(
          radius: 30.0, backgroundImage: NetworkImage("${item.icon}")),
      title: Text(item.label),
      subtitle: Text(item.description),
    ));
  }
}

class SkeletonForms extends StatelessWidget {
  const SkeletonForms({super.key});

  @override
  Widget build(BuildContext context) {
    return (Column(
        children: [_skeletonView(), _skeletonView(), _skeletonView()]));
  }
}

Widget _skeletonView() => SkeletonListTile(
      verticalSpacing: 12,
      leadingStyle: const SkeletonAvatarStyle(
          width: 64, height: 64, shape: BoxShape.circle),
      titleStyle: SkeletonLineStyle(
          height: 12, width: 200, borderRadius: BorderRadius.circular(12)),
      subtitleStyle: SkeletonLineStyle(
          height: 12, width: 400, borderRadius: BorderRadius.circular(12)),
      hasSubtitle: true,
    );
