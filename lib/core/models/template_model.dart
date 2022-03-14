import 'package:docuzer/core/models/field_model.dart';
import 'package:docuzer/core/types.dart';
import 'package:equatable/equatable.dart';

class TemplateModel extends Equatable {
  final String title;
  final String emoji;
  final List<FieldModel> fieldModels;

  @override
  List<Object> get props => [title, fieldModels];

  TemplateModel.fromJson(DynamicMap json) :
        title = json['title'] as String,
        emoji = _getEmoji(json['emoji']),
        fieldModels = (json['fieldModels'] as List<Object?>?)?.map((e) => FieldModel(e as DynamicMap)).toList() ?? [];

  DynamicMap toJson() => <String, dynamic> {
    'title': title,
    'emoji': emoji,
    'fieldModels': fieldModels,
  };

  static String _getEmoji(Object? value) {
    if (value == null) {
      return '❓';
    }
    if (value is String && value.isNotEmpty) {
      return value;
    }
    return '❓';
  }
}