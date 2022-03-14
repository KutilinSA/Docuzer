import 'dart:io';

import 'package:dio/dio.dart';
import 'package:docuzer/core/settings.dart';
import 'package:docuzer/core/types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Middleware {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
  );

  static Future<void> processResponse(Response response) async {
    for (final header in response.headers.map.entries) {
      if (header.key.toLowerCase() == 'set-cookie') {
        for (final value in header.value) {
          final cookie = Cookie.fromSetCookieValue(value);
          if (cookie.value.isNotEmpty) {
            await _storage.write(key: cookie.name, value: cookie.value);
          } else {
            await _storage.delete(key: cookie.name);
          }
        }
      }
    }
  }

  static Future<StringMap> getHeaders() async {
    final csrfToken = await _storage.read(key: Settings.csrfTokenName);
    var cookieHeader = csrfToken != null ?
    ('${Settings.csrfTokenName}=$csrfToken') : '';
    if (await _storage.containsKey(key: 'sessionid')) {
      if (cookieHeader.isNotEmpty) {
        cookieHeader += ';';
      }
      cookieHeader += 'sessionid=${await _storage.read(key: 'sessionid')}';
    }
    return {
      if (csrfToken != null)
        'X-CSRFToken': csrfToken,
      if (cookieHeader.isNotEmpty)
        'Cookie': cookieHeader,
      'Referer': Settings.apiAddress,
    };
  }

  static Future<bool> hasCSRFToken() => _storage.containsKey(key: Settings.csrfTokenName);
}