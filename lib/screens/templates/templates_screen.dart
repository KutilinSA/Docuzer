import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/templates/widgets/template_item.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/providers/templates_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({ Key? key }) : super(key: key);

  @override
  _TemplatesScreenState createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  @override
  Widget build(BuildContext context) {
    final templatesProvider = TemplatesProvider.of(context);
    final templates = templatesProvider.getTemplates();
    final localization = S.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: Text(localization.templates),
        actions: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
            icon: const Icon(CustomIcons.add, size: 20),
            onPressed: () {

            },
          ),
        ],
      ),
      body: templates.isEmpty ? Padding(
        padding: Themes.screenPadding,
        child: Center(
          child: SizedBox(
            width: 320,
            child: Text(
              localization.noTemplates,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ) : ReorderableBuilder(
        children: [
          for (final model in templates)
            TemplateItem(model: model, key: UniqueKey()),
        ],
        onReorder: (orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            final model = templatesProvider.remove(orderUpdateEntity.oldIndex);
            templatesProvider.insert(model, orderUpdateEntity.newIndex);
          }
        },
        dragChildBoxDecoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Color(0x2914375F), offset: Offset(2, 4), blurRadius: 9, spreadRadius: 3),
          ],
        ),
        builder: (children, scrollController) {
          return GridView.count(
            controller: scrollController,
            children: children,
            padding: Themes.listPadding,
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          );
        },
      ),
    );
  }
}