import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/templates/widgets/template_item.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/providers/templates_provider.dart';
import 'package:flutter/material.dart';

class SelectTemplateScreen extends StatefulWidget {
  const SelectTemplateScreen({ Key? key }) : super(key: key);

  @override
  _SelectTemplateScreenState createState() => _SelectTemplateScreenState();
}

class _SelectTemplateScreenState extends State<SelectTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(S.of(context)!.selectTemplate),
      ),
      body: GridView.count(
        children: [
          for (final model in TemplatesProvider.of(context).getTemplates())
            GestureDetector(
              onTap: () => Navigator.of(context).pop(model),
              behavior: HitTestBehavior.translucent,
              child: TemplateItem(model: model),
            ),
        ],
        padding: Themes.listPadding,
        crossAxisCount: 2,
        crossAxisSpacing: 8,
      ),
    );
  }
}