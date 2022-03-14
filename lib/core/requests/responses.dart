import 'package:docuzer/core/types.dart';

abstract class _Response {
  final int statusCode;

  const _Response(this.statusCode);
}

class CleanResponse extends _Response {
  final Object? body;

  const CleanResponse({ required int statusCode, this.body }) : super(statusCode);
}

class ApiResponse extends _Response {
  final DynamicMap? body;
  final String? errorCode;

  const ApiResponse({ required int statusCode, this.body, this.errorCode }) : super(statusCode);
}