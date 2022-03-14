import 'package:docuzer/core/models/user_model.dart';
import 'package:docuzer/core/types.dart';
import 'package:flutter/material.dart';

class _CurrentUserProviderScope extends InheritedWidget {
  final UserModel? user;
  final _CurrentUserProviderState providerState;

  const _CurrentUserProviderScope({
    required this.providerState,
    required Widget child,
    this.user,
    Key? key,
  }) : super(child: child, key: key);

  @override
  bool updateShouldNotify(covariant _CurrentUserProviderScope oldWidget) => user != oldWidget.user;
}

class CurrentUserProvider extends StatefulWidget {
  final Widget child;
  final UserModel? initialUser;

  const CurrentUserProvider({ required this.child, this.initialUser, Key? key }) : super(key: key);

  @override
  _CurrentUserProviderState createState() => _CurrentUserProviderState();

  static UserModel? of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_CurrentUserProviderScope>();
    return scope!.user;
  }

  static UserModel update(BuildContext context, DynamicMap? value) {
    final scope = context.dependOnInheritedWidgetOfExactType<_CurrentUserProviderScope>();
    if (value == null) {
      scope!.providerState._update(null);
    } else {
      scope!.providerState._update(UserModel.fromJson(value));
    }
    return scope.providerState._user!;
  }
}

class _CurrentUserProviderState extends State<CurrentUserProvider> {
  late UserModel? _user = widget.initialUser;

  @override
  Widget build(BuildContext context) {
    return _CurrentUserProviderScope(
      user: _user,
      providerState: this,
      child: widget.child,
    );
  }

  void _update(UserModel? value) {
    setState(() => _user = value);
  }
}