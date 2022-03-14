import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/requests/requests_errors.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/snack_bars.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/base/loading_indicator.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({Key? key}) : super(key: key);

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      Duration.zero,
    ],
    items: const [
      AnimationItemConfiguration(item: 'main_block', itemType: AnimationItemType.from, step: 0),
    ],
    setStateCallback: setState,
  ));
  
  String _login = '';

  bool _isRequesting = false;

  @override
  void dispose() {
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
        child: Form(
          key: _formKey,
          child: AppearanceBlock(
            isAppeared: _animationManager.isActive('main_block'),
            child: BlockCard(
              title: localization.passwordRecovery,
              child: SizedBox(
                height: 80,
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  autofillHints: _isRequesting ? null : const [AutofillHints.username],
                  decoration: InputDecoration(hintText: localization.loginUsernameEmail),
                  validator: (value) => Utils.validateNotEmpty(value, context),
                  onChanged: (value) => _login = value,
                  onFieldSubmitted: (_) => _recover(),
                ),
              ),
              bottomButtonInfo: BottomButtonInfo(
                onTap: _isRequesting ? null : _recover,
                child: _isRequesting ? const LoadingIndicator() : Text(localization.next),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _recover() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isRequesting = true);
    _formKey.currentState!.save();

    final localization = S.of(context)!;

    Requests.makeRequest('account/actions/send-verification-code', 'POST', body: <String, String?>{
      'login': _login,
    }).then(Utils.createApiResponseCallback(
      beforeAction: () => setState(() => _isRequesting = false),
      onSuccess: (body) {
        if (body['result'] as bool) {
          Navigator.of(context).pushNamed('recovery/set', arguments: _login);
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
      setState(() => _isRequesting = false);
    });
  }
}
