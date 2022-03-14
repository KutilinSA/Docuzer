import 'dart:async';
import 'dart:io';

import 'package:docuzer/app.dart';
import 'package:docuzer/core/models/user_model.dart';
import 'package:docuzer/core/requests/middleware.dart';
import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  } else {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  _initializeServices().then(
        (runData) => runApp(DocuzerApp(initialRoutes: runData.initialRoutes, initialUser: runData.initialUser)),
  );
}

Future<_RunData> _initializeServices() async {
  await Requests.initialize();
  late final _RunData runData;
  final hasCSRFToken = await Middleware.hasCSRFToken();
  if (hasCSRFToken) {
    await Requests.makeRequest('account/actions/is-authenticated', 'GET').then(Utils.createApiResponseCallback(
      onSuccess: (body) {
        final model = UserModel.fromJson(body);
        if (model.publicActive) {
          runData = _RunData(initialRoutes: ['login', 'initial-loading'], initialUser: model);
        } else if (!model.emailCheck) {
          runData = _RunData(initialRoutes: ['login', 'registration/apply'], initialUser: model);
        } else {
          runData = _RunData(initialUser: model);
        }
      },
      onUndefined: () => runData = const _RunData(),
    )).onError((_, __) => runData = const _RunData(initialRoutes: ['login', 'initial-loading']));
  } else {
    runData = const _RunData();
  }


  return runData;
}

class _RunData {
  final List<String> initialRoutes;
  final UserModel? initialUser;

  const _RunData({ this.initialRoutes = const ['login'], this.initialUser });
}