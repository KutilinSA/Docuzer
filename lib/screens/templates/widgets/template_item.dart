import 'package:auto_size_text/auto_size_text.dart';
import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class TemplateItem extends StatelessWidget {
  final TemplateModel model;

  const TemplateItem({ required this.model, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: Themes.downShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AutoSizeText(
            model.title,
            maxLines: 2,
            wrapWords: false,
            style: Theme.of(context).textTheme.headline2,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: FittedBox(
              child: Text(
                model.emoji,
                style: const TextStyle(fontSize: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }
}