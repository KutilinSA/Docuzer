import 'dart:async';

import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/requests/requests_errors.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/async_state_manager.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/snack_bars.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/base/loading_indicator.dart';
import 'package:docuzer/widgets/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _asyncStateManager = AsyncStateManager();
  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      Duration.zero,
      const Duration(milliseconds: 350),
      Themes.appearanceAnimationDuration + const Duration(milliseconds: 350),
    ],
    items: const [
      AnimationItemConfiguration(item: 'main_block', itemType: AnimationItemType.from, step: 0),
      AnimationItemConfiguration(item: 'reset_password_button', itemType: AnimationItemType.from, step: 1),
      AnimationItemConfiguration(item: 'registration_button', itemType: AnimationItemType.from, step: 2),
    ],
    setStateCallback: setState,
  ));
  final _inputsKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  bool _obscureText = true;

  String? _username;
  String? _password;

  @override
  void dispose() {
    _passwordController.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: Padding(
        padding: Themes.screenPadding,
        child: Column(
          children: [
            AppearanceBlock(
              isAppeared: _animationManager.isActive('main_block'),
              child: BlockCard(
                title: localization.signInTitle,
                bottomButtonInfo: BottomButtonInfo(
                  onTap: _asyncStateManager.isRequesting ? null : _login,
                  child: _asyncStateManager.hasRequest('login') ? const LoadingIndicator() : Text(localization.signIn),
                ),
                child: SizedBox(
                  height: 160,
                  child: Form(
                    key: _inputsKey,
                    child: AutofillGroup(
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: CurrentUserProvider.of(context)?.username,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(hintText: localization.loginUsernameEmail),
                              validator: (value) => Utils.validateNotEmpty(value, context),
                              autofillHints: _asyncStateManager.isRequesting ? null : const [AutofillHints.username],
                              onSaved: (value) => _username = value,
                              enabled: !_asyncStateManager.isRequesting,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              autocorrect: false,
                              obscureText: _obscureText,
                              enabled: !_asyncStateManager.isRequesting,
                              decoration: InputDecoration(
                                hintText: localization.password,
                                suffixIconConstraints: const BoxConstraints(minHeight: 24, minWidth: 30, maxHeight: 24, maxWidth: 30),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: GestureDetector(
                                    onTap: () => setState(() => _obscureText = !_obscureText),
                                    child: Icon(
                                      _obscureText ? CustomIcons.visibility : CustomIcons.visibilityOff,
                                      color: Theme.of(context).textTheme.subtitle1!.color,
                                    ),
                                  ),
                                ),
                              ),
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              autofillHints: _asyncStateManager.isRequesting ? null : const [AutofillHints.password],
                              onFieldSubmitted: _asyncStateManager.isRequesting ? null : (_) => _login(),
                              onSaved: (value) => _password = value,
                              validator: (value) => Utils.validateNotEmpty(value, context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            AppearanceBlock(
              inset: 80,
              isAppeared: _animationManager.isActive('reset_password_button'),
              child: TextButton(
                onPressed: _asyncStateManager.isRequesting ? null : () {
                  _passwordController.clear();
                  FocusManager.instance.primaryFocus?.unfocus();
                  Navigator.of(context).pushNamed('recovery');
                },
                child: Text(localization.forgotPassword),
              ),
            ),
            const Spacer(),
            AppearanceBlock(
              inset: null,
              isAppeared: _animationManager.isActive('registration_button'),
              child: SizedBox(
                width: 260,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.transparent)),
                  ),
                  onPressed: _asyncStateManager.isRequesting ? null : _openRegistration,
                  child: _asyncStateManager.hasRequest('open_registration')
                      ? const LoadingIndicator()
                      : Text(localization.signUp),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openRegistration() {
    _passwordController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pushNamed('registration');
  }

  void _login() {
    final localization = S.of(context)!;

    FocusManager.instance.primaryFocus?.unfocus();
    if (!_inputsKey.currentState!.validate()) return;
    setState(() => _asyncStateManager.addRequest('login'));
    _inputsKey.currentState!.save();
    Requests.makeRequest('account/actions/login', 'POST', body: <String, String>{
      'login': _username ?? '',
      'password': _password ?? '',
    }).then(Utils.createApiResponseCallback(
      beforeAction: () => setState(() => _asyncStateManager.removeRequest('login')),
      onSuccess: (body) {
        final model = CurrentUserProvider.update(context, body);
        TextInput.finishAutofillContext();
        if (model.publicActive) {
          _passwordController.clear();
          Navigator.of(context).pushNamed('initial-loading');
        } else if (model.emailCheck) {
          SnackBars.showErrorSnackBar(context, text: localization.accountDisabled);
        } else if (!model.emailCheck) {
          Navigator.of(context).pushNamed('registration/apply');
        } else {
          SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong);
        }
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.incorrectCredentials, RequestsErrors.incorrectScheme, RequestsErrors.userNotFound],
          callback: () {
            _passwordController.clear();
            SnackBars.showErrorSnackBar(context, text: localization.incorrectCredentials);
          },
        ),
        ActionErrorsGroup(
          errors: [RequestsErrors.noPrivileges],
          callback: () {
            SnackBars.showErrorSnackBar(context, text: localization.notEnoughRights);
          },
        ),
        ActionErrorsGroup(
          errors: [RequestsErrors.authorizationError],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.accountDisabled),
        ),
      ],
      onUndefined: () => SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong),
    )).onError((_, __) {
      setState(() => _asyncStateManager.removeRequest('login'));
      SnackBars.showErrorSnackBar(context, text: localization.connectionError);
    });
  }
}