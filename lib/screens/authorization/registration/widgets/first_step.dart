import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/authorization/registration/registration_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FirstStep extends StatelessWidget {
  final RegistrationModel model;
  final GlobalKey inputsKey;
  final VoidCallback? onSubmitted;
  final bool disabled;

  const FirstStep({ required this.model, required this.inputsKey, this.onSubmitted,
    this.disabled = false, Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: inputsKey,
        child: Column(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: model.email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: localization.email),
                validator: (value) => Utils.validateEmail(value, context),
                autocorrect: false,
                onChanged: (value) => model.email = value,
                enabled: !disabled,
                autofillHints: disabled ? null : const [AutofillHints.email],
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: model.username,
                decoration: InputDecoration(hintText: localization.username),
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) => newValue.copyWith(text: newValue.text.toLowerCase())),
                  FilteringTextInputFormatter.allow(RegExp('[a-z0-9._]')),
                ],
                onChanged: (value) => model.username = value,
                autocorrect: false,
                onFieldSubmitted: disabled ? null : (_) => onSubmitted?.call(),
                validator: (value) {
                  if (value == null) {
                    return localization.fromToSymbols(3, 32);
                  }
                  if (value.length < 3 || value.length > 32) {
                    return localization.fromToSymbols(3, 32);
                  }
                  return null;
                },
                enabled: !disabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}