import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/base/apply_code_screen.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:flutter/material.dart';

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({Key? key}) : super(key: key);

  @override
  _SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _login = ModalRoute.of(context)!.settings.arguments as String;
  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      Duration.zero,
    ],
    items: const [
      AnimationItemConfiguration(item: 'main_block', itemType: AnimationItemType.from, step: 0),
    ],
    setStateCallback: setState,
  ));

  String _password = '';
  String _repeatPassword = '';
  bool _obscureText = true;

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
        child: AppearanceBlock(
          isAppeared: _animationManager.isActive('main_block'),
          child: BlockCard(
            title: localization.newPassword,
            child: SizedBox(
              height: 160,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: localization.newPassword,
                          errorMaxLines: 2,
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
                        validator: (value) => Utils.validatePassword(value, context),
                        onChanged: (value) => _password = value,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(hintText: localization.repeatPassword),
                        onFieldSubmitted: (_) => _openApplyCode(),
                        onChanged: (value) => _repeatPassword = value,
                        validator: (value) {
                          if (Utils.validatePassword(_password, context) != null) {
                            return null;
                          }
                          return _repeatPassword == _password ? null : localization.passwordsDontMatch;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomButtonInfo: BottomButtonInfo(
              onTap: _openApplyCode,
              child: Text(localization.confirm),
            ),
          ),
        ),
      ),
    );
  }
  
  void _openApplyCode() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    Navigator.of(context).pushNamed('recovery/apply', arguments: ApplyCodeScreenData(login: _login, password: _password));
  }
}
