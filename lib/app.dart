import 'package:docuzer/core/models/user_model.dart';
import 'package:docuzer/core/routes.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/providers/current_user_provider.dart';
import 'package:docuzer/widgets/providers/documents_provider.dart';
import 'package:docuzer/widgets/providers/templates_provider.dart';
import 'package:flutter/material.dart';

class _OverscrollAbsorberBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class DocuzerApp extends StatelessWidget {
  final List<String> initialRoutes;
  final UserModel? initialUser;

  const DocuzerApp({this.initialRoutes = const ['login'], this.initialUser, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belt',
      theme: Themes.lightTheme,
      initialRoute: initialRoutes[0],
      routes: Routes.appRoutes,
      localizationsDelegates: S.localizationsDelegates,
      supportedLocales: S.supportedLocales,
      onGenerateInitialRoutes: (routeName) {
        return [
          for (final route in initialRoutes)
            MaterialPageRoute<void>(builder: (context) => Routes.appRoutes[route]!(context)),
        ];
      },
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ScrollConfiguration(
            behavior: _OverscrollAbsorberBehaviour(),
            child: CurrentUserProvider(
              initialUser: initialUser,
              child: TemplatesProvider(
                child: DocumentsProvider(
                  child: child ?? const Center(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}