import 'package:docuzer/core/types.dart';
import 'package:equatable/equatable.dart';

abstract class FieldModel extends Equatable {
  final String type;
  final String? hint;

  @override
  List<Object?> get props => [type, hint];

  factory FieldModel(DynamicMap json) {
    final type = json['type'] as String?;
    if (type == 'int') {
      return IntegerFieldModel.fromJson(json);
    }
    throw UnimplementedError('Field type $type is not implemented');
  }

  FieldModel._fromJson(DynamicMap json) :
      type = json['type'] as String,
      hint = json['hint'] as String?;

  DynamicMap toJson() => <String, dynamic> {
    'hint': hint,
    'type': type,
    'value': getValue(),
  };

  dynamic getValue();
}

class IntegerFieldModel extends FieldModel {
  final int? minValue;
  final int? maxValue;
  final int? minLength;
  final int? maxLength;
  final int? value;

  @override
  List<Object?> get props => [...super.props, value, minValue, maxValue, minLength, maxLength];

  IntegerFieldModel.fromJson(DynamicMap json):
      minValue = json['minValue'] as int?,
      maxValue = json['maxValue'] as int?,
      minLength = json['minLength'] as int?,
      maxLength = json['maxLength'] as int?,
      value = json['value'] as int?,
      super._fromJson(json);

  @override
  DynamicMap toJson() => <String, dynamic> {
    'minValue': minValue,
    'maxValue': maxValue,
    'minLength': minLength,
    'maxLength': maxLength,
    ...super.toJson(),
  };

  @override
  dynamic getValue() => value;
}