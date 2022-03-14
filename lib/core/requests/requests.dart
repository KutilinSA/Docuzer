import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:docuzer/core/requests/middleware.dart';
import 'package:docuzer/core/requests/responses.dart';
import 'package:docuzer/core/settings.dart';
import 'package:docuzer/core/types.dart';

class Requests {
  static late final Dio _client;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _client = Dio(BaseOptions(responseType: ResponseType.bytes, validateStatus: (_) => true));
  }

  static Future<CleanResponse> loadImage(String path) {
    return _client.getUri<Uint8List>(Uri.parse(path)).then((response) {
      return CleanResponse(
        statusCode: response.statusCode!,
        body: response.data,
      );
    });
  }

  static Future<CleanResponse> makeCleanGET(String path) {
    return _client.getUri<List<int>>(Uri.parse(path)).then((response) {
      Object? responseJson;
      try {
        responseJson = jsonDecode(utf8.decode(response.data!));
      }
      on FormatException catch (_) { }
      return CleanResponse(
        statusCode: response.statusCode!,
        body: responseJson,
      );
    });
  }

  static Future<ApiResponse> makeRequest(String path, String method,
      { DynamicMap? body, Map<String, UploadFile>? files, bool relative = true, }) {
    final uri = Uri.parse('${relative ? Settings.apiAddress : ''}$path/');
    return Middleware.hasCSRFToken().then((value) {
      if (value) {
        if (files == null || files.isEmpty) {
          return _makeRequest(uri, method, body: body);
        } else {
          return _makeRequestWithFormData(uri, method, files, body: body);
        }
      } else {
        return _makeRequest(Uri.parse(Settings.apiAddress), 'GET').then((_) {
          if (files == null || files.isEmpty) {
            return _makeRequest(uri, method, body: body);
          } else {
            return _makeRequestWithFormData(uri, method, files, body: body);
          }
        });
      }
    });
  }

  static Future<Response<List<int>>> _getRequestFuture(Uri uri, String method, { DynamicMap? body }) async {
    final headers = await Middleware.getHeaders();
    if (method.toLowerCase() == 'get') {
      return _client.getUri<List<int>>(uri, options: Options(headers: headers));
    } else if (method.toLowerCase() == 'post') {
      return _client.postUri<List<int>>(uri, data: body, options: Options(headers: headers));
    } else if (method.toLowerCase() == 'patch') {
      return _client.patchUri<List<int>>(uri, data: body, options: Options(headers: headers));
    } else if (method.toLowerCase() == 'delete') {
      return _client.deleteUri<List<int>>(uri, data: body, options: Options(headers: headers));
    } else {
      throw UnimplementedError('Undefined method: $method');
    }
  }

  static Future<ApiResponse> _afterRequest(Response<List<int>> response) async {
    await Middleware.processResponse(response);
    DynamicMap? responseJson;
    String? errorCode;
    if (response.data != null) {
      try {
        responseJson = jsonDecode(utf8.decode(response.data!)) as DynamicMap;
        if (responseJson.containsKey('error')) {
          errorCode = (responseJson['error'] as DynamicMap)['code'] as String?;
        }
      }
      on FormatException catch (_) {}
    }
    return ApiResponse(
      statusCode: response.statusCode!,
      body: responseJson,
      errorCode: errorCode,
    );
  }

  static Future<ApiResponse> _makeRequest(Uri uri, String method, { DynamicMap? body }) {
    return _getRequestFuture(uri, method, body: body).then(_afterRequest);
  }

  static Future<ApiResponse> _makeRequestWithFormData(Uri uri, String method, Map<String, UploadFile> files, { DynamicMap? body, }) async {
    final headers = await Middleware.getHeaders();

    final data = FormData();
    if (body != null) {
      for (final entry in body.entries) {
        data.fields.add(MapEntry(entry.key, jsonEncode(entry.value)));
      }
    }
    for (final file in files.entries) {
      data.files.add(MapEntry(file.key, MultipartFile.fromBytes(file.value.bytes, filename: file.value.name)));
    }

    final options = RequestOptions(
      path: uri.toString(),
      method: method,
      data: data,
      headers: headers,
      responseType: ResponseType.bytes,
      validateStatus: (_) => true,
    );

    return _client.fetch<List<int>>(options).then(_afterRequest);
  }
}

class UploadFile {
  final Uint8List bytes;
  final String name;

  const UploadFile({ required this.bytes, required this.name });
}