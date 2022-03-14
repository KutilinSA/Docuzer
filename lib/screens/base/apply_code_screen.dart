import 'dart:async';

import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/requests/requests_errors.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/async_state_manager.dart';
import 'package:docuzer/ui/snack_bars.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/overridden/custom_pin_code_text_field.dart';
import 'package:docuzer/widgets/providers/current_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum ApplyTarget {
  registration,
  passwordRecovery,
  passwordChange,
}

class ApplyCodeScreenData {
  final String login;
  final String? password;

  const ApplyCodeScreenData({ required this.login, this.password });
}

class ApplyCodeScreen extends StatefulWidget {
  final ApplyTarget applyTarget;

  const ApplyCodeScreen({ required this.applyTarget, Key? key }) : super(key: key);

  @override
  _ApplyCodeScreenState createState() => _ApplyCodeScreenState();
}

class _ApplyCodeScreenState extends State<ApplyCodeScreen> {
  final AsyncStateManager _asyncStateManager = AsyncStateManager();
  final _pinController = TextEditingController();
  final _errorController = StreamController<ErrorAnimationType>();

  late final ApplyCodeScreenData _data = (ModalRoute.of(context)?.settings.arguments as ApplyCodeScreenData?) ?? ApplyCodeScreenData(
    login: CurrentUserProvider.of(context)!.username,
  );

  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      const Duration(milliseconds: 150),
      Themes.appearanceAnimationDuration + const Duration(milliseconds: 150),
    ],
    items: const [
      AnimationItemConfiguration(item: 'main_block', itemType: AnimationItemType.from, step: 0),
      AnimationItemConfiguration(item: 'send_code_button', itemType: AnimationItemType.from, step: 1),
    ],
    setStateCallback: setState,
  ));

  String _code = '';

  @override
  void dispose() {
    _errorController.close();
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
                title: localization.verificationCode,
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: CustomPinCodeTextField(
                      enablePinAutofill: false,
                      controller: _pinController,
                      appContext: context,
                      length: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      pinTheme: PinTheme(
                        activeColor: Theme.of(context).primaryColorDark,
                        selectedColor: Theme.of(context).colorScheme.secondary,
                        inactiveColor: Theme.of(context).primaryColor,
                      ),
                      errorAnimationController: _errorController,
                      beforeTextPaste: (value) {
                        if (value == null) return null;
                        value = value.trim();
                        if (value.length != 6 && value.length != 7) return null;

                        final notSeparatedTest = int.tryParse(value) != null;
                        final separated = value.split('-');
                        if (separated.length != 2) return notSeparatedTest ? value : null;
                        separated[0] = separated[0].trim();
                        separated[1] = separated[1].trim();
                        if (separated[0].length != 3 || separated[1].length != 3) return notSeparatedTest ? value : null;
                        final separatedTest = int.tryParse(separated[0]) != null && int.tryParse(separated[1]) != null;

                        if (notSeparatedTest) return value;
                        if (separatedTest) return separated[0] + separated[1];
                        return null;
                      },
                      enabled: !_asyncStateManager.isRequesting,
                      animationType: AnimationType.scale,
                      useHapticFeedback: true,
                      keyboardType: TextInputType.number,
                      dialogConfig: DialogConfig(
                        dialogTitle: localization.insertCode,
                        dialogContent: '${localization.insertCode} ',
                        affirmativeText: localization.yes,
                        negativeText: localization.no,
                      ),
                      onCompleted: (_) => _verifyCode(),
                      onChanged: (value) => setState(() => _code = value),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            AppearanceBlock(
              inset: null,
              isAppeared: _animationManager.isActive('send_code_button'),
              child: TextButton(
                onPressed: _asyncStateManager.isRequesting ? null : _sendVerificationCode,
                child: Text(localization.resend),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onVerifyError(String message) {
    SnackBars.showErrorSnackBar(context, text: message);
    _errorController.add(ErrorAnimationType.shake);
    _code = '';
    _pinController.clear();
    setState(() => _asyncStateManager.removeRequest('verify'));
  }

  void _verifyCode() {
    FocusManager.instance.primaryFocus!.unfocus();
    setState(() => _asyncStateManager.addRequest('verify'));

    final localization = S.of(context)!;

    final onVerifySuccess = Utils.createApiResponseCallback(
      onSuccess: (body) {
        if (body['temporaryCodeValid'] as bool) {
          if (widget.applyTarget == ApplyTarget.registration) {
            Navigator.of(context).pushReplacementNamed('initial-loading');
          } else if (widget.applyTarget == ApplyTarget.passwordRecovery) {
            SnackBars.showSuccessSnackBar(context, text: localization.passwordUpdated);
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (widget.applyTarget == ApplyTarget.passwordChange) {
            SnackBars.showSuccessSnackBar(context, text: localization.passwordUpdated);
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        }
        else {
          final remainingAttempts = body['remainingAttempts'] as int;
          if (remainingAttempts == 0) {
            _onVerifyError(localization.noMoreAttempts);
          } else {
            _onVerifyError(localization.attemptsLeft(remainingAttempts));
          }
        }
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.noEmailCode],
          callback: () => _onVerifyError(localization.noMoreAttempts),
        ),
      ],
      onUndefined: () => _onVerifyError(localization.somethingWentWrong),
    );

    if (widget.applyTarget == ApplyTarget.registration) {
      Requests.makeRequest('account/actions/activate-email', 'POST', body: <String, String>{
        'code': _code,
        'login': _data.login,
      }).then(onVerifySuccess).onError((_, __) => _onVerifyError(localization.connectionError));
    } else if (widget.applyTarget == ApplyTarget.passwordRecovery || widget.applyTarget == ApplyTarget.passwordChange) {
      Requests.makeRequest('account/actions/recovery-password', 'POST', body: <String, String>{
        'code': _code,
        'login': _data.login,
        'password': _data.password!,
      }).then(onVerifySuccess).onError((_, __) => _onVerifyError(localization.connectionError));
    }
  }

  void _sendVerificationCode() {
    FocusManager.instance.primaryFocus!.unfocus();
    setState(() => _asyncStateManager.addRequest('send_code'));

    final localization = S.of(context)!;

    Requests.makeRequest('account/actions/send-verification-code', 'POST', body: <String, String?>{
      'login': _data.login,
    }).then(Utils.createApiResponseCallback(
      beforeAction: () => setState(() => _asyncStateManager.removeRequest('send_code')),
      onSuccess: (body) {
        if (body['result'] as bool) {
          SnackBars.showSuccessSnackBar(context, text: localization.codeSentAgain);
        } else {
          SnackBars.showErrorSnackBar(context, text: localization.failedToSendCode);
        }
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.userNotFound, RequestsErrors.incorrectScheme],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.userNotFound),
        ),
      ],
      onUndefined: () => SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong),
    )).onError((_, __) {
      SnackBars.showErrorSnackBar(context, text: localization.connectionError);
      setState(() => _asyncStateManager.removeRequest('send_code'));
    });
  }
}
