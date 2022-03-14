import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/requests/requests_errors.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/authorization/registration/registration_model.dart';
import 'package:docuzer/screens/authorization/registration/widgets/first_step.dart';
import 'package:docuzer/screens/authorization/registration/widgets/second_step.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/async_state_manager.dart';
import 'package:docuzer/ui/snack_bars.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/base/loading_indicator.dart';
import 'package:docuzer/widgets/base/steps_indicator.dart';
import 'package:docuzer/widgets/providers/current_user_provider.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({ Key? key, }) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _stepsController = PageController();
  final RegistrationModel _model = RegistrationModel();
  final List<GlobalKey<FormState>> _stepsKeys = [
    GlobalKey(),
    GlobalKey(),
  ];
  final AsyncStateManager _asyncStateManager = AsyncStateManager();
  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      Duration.zero,
      Themes.appearanceAnimationDuration + const Duration(milliseconds: 350),
    ],
    items: const [
      AnimationItemConfiguration(item: 'main_block', itemType: AnimationItemType.from, step: 0),
      AnimationItemConfiguration(item: 'steps_indicator', itemType: AnimationItemType.from, step: 1),
    ],
    setStateCallback: setState,
  ));

  var _currentStep = 0;

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return WillPopScope(
      onWillPop: _pop,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(onBackButtonPressed: _asyncStateManager.isRequesting ? null : _pop),
        body: Padding(
          padding: Themes.screenPadding.copyWith(bottom: 40),
          child: Column(
            children: [
              AppearanceBlock(
                isAppeared: _animationManager.isActive('main_block'),
                child: BlockCard(
                  title: localization.signUpTitle,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 160,
                    child: PageView(
                      controller: _stepsController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) => setState(() => _currentStep = index),
                      children: [
                        FirstStep(model: _model, inputsKey: _stepsKeys[0], onSubmitted: _nextPage, disabled: _asyncStateManager.isRequesting),
                        SecondStep(model: _model, inputsKey: _stepsKeys[1], onSubmitted: _nextPage, disabled: _asyncStateManager.isRequesting),
                      ],
                    ),
                  ),
                  bottomButtonInfo: BottomButtonInfo(
                    onTap: _asyncStateManager.isRequesting ? null : _nextPage,
                    child: _asyncStateManager.isRequesting ? const LoadingIndicator() : (_currentStep == 1 ? Text(localization.confirm) : Text(localization.next)),
                  ),
                ),
              ),
              const Spacer(),
              AppearanceBlock(
                inset: null,
                isAppeared: _animationManager.isActive('steps_indicator'),
                child: StepsIndicator(currentStep: _currentStep, maxSteps: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _pop() async {
    if (_asyncStateManager.isRequesting) {
      return false;
    }
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return false;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    await _stepsController.previousPage(
      duration: Themes.defaultAnimationDuration,
      curve: Themes.defaultAnimationCurve,
    );
    return false;
  }

  void _onError(String message) {
    SnackBars.showErrorSnackBar(context, text: message);
    setState(_asyncStateManager.clear);
  }

  void _processFirstStep() {
    setState(() => _asyncStateManager.addRequest('check'));

    final localization = S.of(context)!;

    final onUsernameCheckSuccess = Utils.createApiResponseCallback(
      beforeAction: () => setState(() => _asyncStateManager.removeRequest('check')),
      onSuccess: (body) {
        if (body['available'] as bool) {
          _stepsController.nextPage(
            duration: Themes.defaultAnimationDuration,
            curve: Themes.defaultAnimationCurve,
          );
        } else {
          SnackBars.showErrorSnackBar(context, text: localization.usernameAlreadyUsed);
        }
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.incorrectScheme],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.incorrectUsernameScheme),
        ),
      ],
      onUndefined: () => SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong),
    );

    final onEmailCheckSuccess = Utils.createApiResponseCallback(
      onSuccess: (body) {
        if (body['available'] as bool) {
          Requests.makeRequest('account/actions/check-username', 'POST', body: <String, String> {
            'username': _model.username!.toLowerCase(),
          }).then(onUsernameCheckSuccess).onError((_, __) => _onError(localization.connectionError));
        } else {
          SnackBars.showErrorSnackBar(context, text: localization.emailAlreadyUsed);
          setState(() => _asyncStateManager.removeRequest('check'));
        }
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.incorrectScheme],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.incorrectEmailScheme),
        ),
      ],
      onUndefined: () => SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong),
      errorAction: () => setState(() => _asyncStateManager.removeRequest('check')),
    );

    Requests.makeRequest('account/actions/check-email', 'POST', body: <String, String> {
      'email': _model.email!,
    }).then(onEmailCheckSuccess).onError((_, __) => _onError(localization.connectionError));
  }

  void _processLastStep() {
    final localization = S.of(context)!;

    setState(() => _asyncStateManager.addRequest('registration'));
    Requests.makeRequest('account/actions/registration', 'POST', body: <String, dynamic> {
      'username': _model.username!.toLowerCase(),
      'email': _model.email,
      'password': _model.password,
      'language': Utils.getLanguage(),
    }).then(Utils.createApiResponseCallback(
      onSuccess: (body) {
        CurrentUserProvider.update(context, body);
        Navigator.of(context).pushReplacementNamed('registration/apply');
      },
      errorsGroups: [
        ActionErrorsGroup(
          errors: [RequestsErrors.emailAlreadyUsed],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.emailAlreadyUsed),
        ),
        ActionErrorsGroup(
          errors: [RequestsErrors.usernameAlreadyUsed],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.usernameAlreadyUsed),
        ),
        ActionErrorsGroup(
          errors: [RequestsErrors.incorrectScheme],
          callback: () => SnackBars.showErrorSnackBar(context, text: localization.dataFilledIncorrectly),
        ),
      ],
      onUndefined: () => SnackBars.showErrorSnackBar(context, text: localization.somethingWentWrong),
      errorAction: () => setState(() => _asyncStateManager.removeRequest('registration')),
    )).onError((_, __) => _onError(localization.connectionError));
  }

  void _nextPage() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_stepsKeys[_currentStep].currentState!.validate()) return;
    _stepsKeys[_currentStep].currentState!.save();
    if (_currentStep == 0) {
      _processFirstStep();
    } else {
      _processLastStep();
    }
  }
}

