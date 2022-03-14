import 'dart:async';
import 'dart:convert';

import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/core/templates.dart';
import 'package:docuzer/core/types.dart';
import 'package:docuzer/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _TemplatesProviderScope extends InheritedWidget {
  final List<TemplateModel> templates;
  final _TemplatesProviderState providerState;

  const _TemplatesProviderScope({
    required this.providerState,
    required Widget child,
    this.templates = const [],
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _TemplatesProviderScope oldWidget) => !Utils.compareLists(templates, oldWidget.templates);
}

class TemplatesProvider extends StatefulWidget {
  final Widget child;

  const TemplatesProvider({ required this.child, Key? key }) : super(key: key);

  @override
  _TemplatesProviderState createState() => _TemplatesProviderState();

  static _TemplatesProviderState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_TemplatesProviderScope>();
    return scope!.providerState;
  }

  static Future<void> load(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_TemplatesProviderScope>();
    return scope!.providerState._load();
  }
}

class _TemplatesProviderState extends State<TemplatesProvider> {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
  );

  List<TemplateModel> _templates = [];

  @override
  Widget build(BuildContext context) {
    return _TemplatesProviderScope(
      providerState: this,
      child: widget.child,
      templates: _templates,
    );
  }

  List<TemplateModel> getTemplates() => [..._templates];

  void add(TemplateModel value) {
    setState(() => [..._templates].insert(0, value));
    unawaited(_updateStorage());
  }

  void insert(TemplateModel value, int index) {
    setState(() => [..._templates].insert(index, value));
    unawaited(_updateStorage());
  }

  TemplateModel remove(int index) {
    final newTemplates = [..._templates];
    final model = newTemplates.removeAt(index);
    setState(() => _templates = newTemplates);
    unawaited(_updateStorage());
    return model;
  }

  Future<void> _updateStorage() async {
    await _storage.write(key: 'templates', value: jsonEncode(_templates));
  }

  Future<void> _load() async {
    final value = await _storage.read(key: 'templates');
    if (value == null) {
      setState(() => _templates = [...Templates.initialTemplates()]);
      unawaited(_updateStorage());
      return;
    }

    try {
      _templates = [];
      final decoded = jsonDecode(value) as List<dynamic>;
      for (final templateJson in decoded) {
        final model = TemplateModel.fromJson(templateJson as DynamicMap);
        _templates.add(model);
      }
      setState(() {});
    } on Exception catch (_) {
      await _storage.delete(key: 'templates');
      setState(() => _templates = []);
    }
  }
}