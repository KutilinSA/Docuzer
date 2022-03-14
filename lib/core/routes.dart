import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/screens/authorization/login/login_screen.dart';
import 'package:docuzer/screens/authorization/password_recovery/password_recovery_screen.dart';
import 'package:docuzer/screens/authorization/password_recovery/set_new_password_screen.dart';
import 'package:docuzer/screens/authorization/registration/registration_screen.dart';
import 'package:docuzer/screens/base/apply_code_screen.dart';
import 'package:docuzer/screens/base/initial_loading_screen.dart';
import 'package:docuzer/screens/base/root_screen.dart';
import 'package:docuzer/screens/documents/document_editor_screen.dart';
import 'package:docuzer/screens/home/home_screen.dart';
import 'package:docuzer/screens/templates/templates_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static final Map<String, WidgetBuilder> appRoutes = {
    '': (context) => const RootScreen(),
    'initial-loading': (context) => const InitialLoadingScreen(),
    'login': (context) => const LoginScreen(),
    'registration': (context) => const RegistrationScreen(),
    'registration/apply': (context) => const ApplyCodeScreen(applyTarget: ApplyTarget.registration),
    'recovery': (context) => const PasswordRecoveryScreen(),
    'recovery/set': (context) => const SetNewPasswordScreen(),
    'recovery/apply': (context) => const ApplyCodeScreen(applyTarget: ApplyTarget.passwordRecovery),
    'change-password/apply': (context) => const ApplyCodeScreen(applyTarget: ApplyTarget.passwordChange),
  };

  static final Map<String, Widget Function(Object?)> _routes = {
    'home': (_) => const HomeScreen(),
    'home/create-document': (template) => DocumentEditorScreen(template: template as TemplateModel?),
    'home/edit-document': (initialData) => DocumentEditorScreen(initialData: initialData as DocumentModel?),
    'templates': (_) => const TemplatesScreen(),
  };

  static Route<dynamic>? routesGenerator(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: RouteSettings(arguments: settings.arguments, name: settings.name),
      builder: (context) {
        return _routes[settings.name]?.call(settings.arguments) ?? const Scaffold(body: Center());
      },
    );
  }
}