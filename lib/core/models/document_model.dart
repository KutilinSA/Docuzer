import 'package:docuzer/core/types.dart';
import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  final String title;

  @override
  List<Object> get props => [title];

  DocumentModel.fromJson(DynamicMap json) :
      title = json['title'] as String;

  DynamicMap toJson() => <String, dynamic> {
    'title': title,
  };
}