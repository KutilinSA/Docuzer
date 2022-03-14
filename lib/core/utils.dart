import 'package:docuzer/core/requests/responses.dart';
import 'package:docuzer/core/types.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:flutter/material.dart';

class Utils {
  static String? validateEmail(String? email, BuildContext context) {
    final localization = S.of(context)!;
    if (email == null) {
      return localization.incorrectEmail;
    }
    final regExp = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regExp.hasMatch(email) ? null : localization.incorrectEmail;
  }

  static String? validatePassword(String? password, BuildContext context) {
    final localization = S.of(context)!;
    if (password == null) {
      return localization.fromToSymbols(8, 128);
    }
    if (password.length < 8 || password.length > 128) {
      return localization.fromToSymbols(8, 128);
    }
    final regExp = RegExp(r'^(?=.*[a-z]){1,}(?=.*[A-Z]){1,}(?=.*\d){1,}.{8,}$');
    return regExp.hasMatch(password) ? null : localization.passwordShouldContain;
  }

  static String? validateNotEmpty(String? value, BuildContext context, { int? maxLength }) {
    final localization = S.of(context)!;
    if (value == null) {
      return localization.fieldCantBeEmpty;
    }
    if (value.isNotEmpty) {
      return null;
    }
    if (maxLength != null && value.length > maxLength) {
      return localization.fieldMaxLength(maxLength);
    }
    return localization.fieldCantBeEmpty;
  }

  static String getLanguage() {
    final locales = WidgetsBinding.instance!.window.locales;
    if (locales.isEmpty) {
      return 'eng';
    }
    switch (locales[0].languageCode) {
      case 'en':
        return 'eng';
      case 'ru':
        return 'rus';
      default:
        return 'eng';
    }
  }

  static bool compareLists(List<dynamic>? first, List<dynamic>? second) {
    if (first == null && second == null) {
      return true;
    } else if (first == null && second != null) {
      return false;
    } else if (first != null && second == null) {
      return false;
    }
    if (first!.length != second!.length) {
      return false;
    }
    for (var i = 0; i < first.length; i++) {
      if (first[i] != second[i]) return false;
    }
    return true;
  }

  static VoidCallbackWithParam<ApiResponse> createApiResponseCallback({
    VoidCallbackWithParam<DynamicMap>? onSuccess,
    List<ActionErrorsGroup>? errorsGroups,
    VoidCallback? onUndefined,
    VoidCallback? beforeAction,
    VoidCallback? errorAction,
  }) {
    return (response) {
      beforeAction?.call();
      if ((response.statusCode == 200 || response.statusCode == 201) && response.errorCode == null && response.body != null) {
        onSuccess?.call(response.body!);
      } else if (errorsGroups != null && errorsGroups.isNotEmpty) {
        var errorFound = false;
        for (final errorsGroup in errorsGroups) {
          for (final error in errorsGroup.errors) {
            if (error == response.errorCode) {
              errorFound = true;
              errorsGroup.callback?.call();
              break;
            }
          }
          if (errorFound) break;
        }
        if (!errorFound) {
          onUndefined?.call();
        }
        errorAction?.call();
      } else {
        onUndefined?.call();
        errorAction?.call();
      }
    };
  }
}

class ActionErrorsGroup {
  final List<String> errors;
  final VoidCallback? callback;

  const ActionErrorsGroup({ this.errors = const [], this.callback });
}