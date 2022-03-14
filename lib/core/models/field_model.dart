import 'package:docuzer/core/types.dart';

class FieldModel<T> {
  final T? value;
  final String label;

  Type get type => T;

  FieldModel._(DynamicMap json) :
      value = json['value'] as T?,
      label = (json['label'] as String?) ?? '?';

  static FieldModel fromJson(DynamicMap json) {
    final fieldType = json['type'] as String;
    if (fieldType == 'int') {
      return FieldModel<int>._(json);
    } else if (fieldType == 'String') {
      return FieldModel<String>._(json);
    }
    throw UnimplementedError('Field type ${fieldType} is not implemented');
  }

  DynamicMap toJson() => <String, dynamic> {
    'label': label,
    'type': type.toString(),
    'value': value,
  };
}