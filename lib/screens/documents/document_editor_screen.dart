import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';

class DocumentEditorScreen extends StatefulWidget {
  final DocumentModel? initialData;
  final TemplateModel? template;

  const DocumentEditorScreen({ this.initialData, this.template, Key? key }) : super(key: key);

  @override
  _DocumentEditorScreenState createState() => _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends State<DocumentEditorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: const Center(),
    );
  }
}