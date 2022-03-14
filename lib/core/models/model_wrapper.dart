import 'package:docuzer/core/types.dart';

abstract class ModelWrapper {
  final String uuid;

  ModelWrapper.fromJson(DynamicMap json) :
        uuid = json['uuid'] as String;

  DynamicMap toJson() => <String, dynamic> {
    'uuid': uuid,
  };
}