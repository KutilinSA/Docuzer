import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/authorization/registration/registration_model.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:flutter/material.dart';

class SecondStep extends StatefulWidget {
  final RegistrationModel model;
  final GlobalKey inputsKey;
  final VoidCallback? onSubmitted;
  final bool disabled;

  const SecondStep({ required this.model, required this.inputsKey, this.onSubmitted,
    this.disabled = false, Key? key, }) : super(key: key);

  @override
  _SecondStepState createState() => _SecondStepState();
}

class _SecondStepState extends State<SecondStep> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: widget.inputsKey,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                obscureText: _obscureText,
                initialValue: widget.model.password,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enabled: !widget.disabled,
                decoration: InputDecoration(
                  hintText: localization.password,
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
                onChanged: (value) => widget.model.password = value,
              ),
            ),
            Expanded(
              child: TextFormField(
                obscureText: true,
                autocorrect: false,
                enabled: !widget.disabled,
                initialValue: widget.model.repeatPassword,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: localization.repeatPassword),
                onFieldSubmitted: widget.disabled ? null : (_) => widget.onSubmitted?.call(),
                onChanged: (value) => widget.model.repeatPassword = value,
                validator: (value) {
                  if (Utils.validatePassword(widget.model.password, context) != null) {
                    return null;
                  }
                  return widget.model.repeatPassword == widget.model.password ? null : localization.passwordsDontMatch;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
