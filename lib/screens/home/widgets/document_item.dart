import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:flutter/material.dart';

class DocumentItem extends StatelessWidget {
  final DocumentModel model;

  const DocumentItem({ required this.model, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlockCard(
      child: Text(
        model.title,
      ),
    );
  }
}