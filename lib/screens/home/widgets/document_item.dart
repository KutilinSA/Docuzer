import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class DocumentItem extends StatelessWidget {
  final DocumentModel model;

  const DocumentItem({ required this.model, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).pushNamed<void>('home/edit-document', arguments: model),
      child: Container(
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
            SizedBox(height: model.images.isNotEmpty ? 16 : 8),
            Expanded(
              child: model.images.isNotEmpty ? Image.file(
                File(model.images[0]),
                fit: BoxFit.contain,
                frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: Themes.defaultAnimationDuration,
                    curve: Themes.defaultAnimationCurve,
                    child: child,
                  );
                },
              ) : const Text('❓', style: TextStyle(fontSize: 60)),
            ),
          ],
        ),
      ),
    );
  }
}