import 'dart:async';
import 'dart:convert';

import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/core/types.dart';
import 'package:docuzer/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _DocumentsProviderScope extends InheritedWidget {
  final List<DocumentModel> documents;
  final _DocumentsProviderState providerState;

  const _DocumentsProviderScope({
    required this.providerState,
    required Widget child,
    this.documents = const [],
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _DocumentsProviderScope oldWidget) => !Utils.compareLists(documents, oldWidget.documents);
}

class DocumentsProvider extends StatefulWidget {
  final Widget child;

  const DocumentsProvider({ required this.child, Key? key }) : super(key: key);

  @override
  _DocumentsProviderState createState() => _DocumentsProviderState();

  static _DocumentsProviderState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_DocumentsProviderScope>();
    return scope!.providerState;
  }

  static Future<void> load(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_DocumentsProviderScope>();
    return scope!.providerState._load();
  }
}

class _DocumentsProviderState extends State<DocumentsProvider> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
  );

  List<DocumentModel> _documents = [];

  @override
  Widget build(BuildContext context) {
    return _DocumentsProviderScope(
      providerState: this,
      child: widget.child,
      documents: _documents,
    );
  }

  List<DocumentModel> getDocuments() => [..._documents];

  void add(DocumentModel value) {
    setState(() => _documents = [value, ..._documents]);
    unawaited(_updateStorage());
  }

  void update(DocumentModel value, DocumentModel oldValue) {
    final index = _documents.indexOf(oldValue);
    if (index == -1) {
      return;
    }
    final newDocuments = [..._documents];
    newDocuments[index] = value;
    setState(() => _documents = newDocuments);
    unawaited(_updateStorage());
  }

  void insert(DocumentModel value, int index) {
    setState(() => _documents = [..._documents]..insert(index, value));
    unawaited(_updateStorage());
  }

  DocumentModel remove(int index) {
    final newDocuments = [..._documents];
    final model = newDocuments.removeAt(index);
    setState(() => _documents = newDocuments);
    unawaited(_updateStorage());
    return model;
  }

  Future<void> _updateStorage() async {
    await _storage.write(key: 'documents', value: jsonEncode(_documents));
  }

  Future<void> _load() async {
    await _storage.delete(key: 'documents');
    final value = await _storage.read(key: 'documents');
    if (value == null) {
      setState(() => _documents = []);
      return;
    }

    try {
      _documents = [];
      final decoded = jsonDecode(value) as List<dynamic>;
      for (final documentJson in decoded) {
        final model = DocumentModel.fromJson(documentJson as DynamicMap);
        _documents.add(model);
      }
      setState(() {});
    } on Exception catch (_) {
      await _storage.delete(key: 'documents');
      setState(() => _documents = []);
    }
  }
}