import 'package:docuzer/core/models/field_model.dart';
import 'package:docuzer/core/types.dart';

class DocumentModel {
  final String title;
  final List<String> images;
  final List<FieldModel> fieldModels;

  DocumentModel.fromJson(DynamicMap json) :
      title = json['title'] as String,
      images = (json['images'] as List<Object?>?)?.map((e) => e as String).toList() ?? [],
      fieldModels = (json['fieldModels'] as List<Object?>?)?.map((e) => FieldModel.fromJson(e as DynamicMap)).toList() ?? [];

  DynamicMap toJson() => <String, dynamic> {
    'title': title,
    'fieldModels': fieldModels,
    'images': images,
  };
}