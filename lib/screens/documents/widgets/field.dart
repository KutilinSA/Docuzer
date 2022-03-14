import 'package:docuzer/core/models/field_model.dart';
import 'package:docuzer/core/types.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Field extends StatelessWidget {
  final FieldModel fieldModel;
  final bool isLast;
  final VoidCallbackWithParam<FieldModel>? onSaved;

  const Field({ required this.fieldModel, this.onSaved, this.isLast = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    late final FieldModel castedModel;
    if (fieldModel.type == 'int') {
      castedModel = fieldModel as IntegerFieldModel;
    } else {
      throw UnimplementedError('Field type ${fieldModel.type} is not implemented');
    }

    return TextFormField(
      initialValue: fieldModel.getValue()?.toString(),
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      style: Theme.of(context).textTheme.headline3,
      inputFormatters: castedModel is IntegerFieldModel ? [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          if (newValue.text.isEmpty) {
            return newValue;
          }
          final parsed = int.tryParse(newValue.text);
          if (parsed != null) {
            return newValue;
          }
          return oldValue;
        }),
      ] : [],
      maxLength: castedModel is IntegerFieldModel ? castedModel.maxLength : null,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
          borderRadius: BorderRadius.circular(24),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark.withOpacity(0.26)),
          borderRadius: BorderRadius.circular(24),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 1.4),
          borderRadius: BorderRadius.circular(24),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).errorColor),
          borderRadius: BorderRadius.circular(24),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).errorColor, width: 1.4),
          borderRadius: BorderRadius.circular(24),
        ),
        label: castedModel.hint != null ? Text(castedModel.hint!) : null,
      ),
      onSaved: (value) {
        if (castedModel is IntegerFieldModel) {
          onSaved?.call(FieldModel(castedModel.toJson()..['value'] = value == null ? null : int.parse(value)));
          return;
        }
        throw UnimplementedError('Field ${castedModel.type} type is not implemented');
      },
      validator: (value) {
        if (castedModel is IntegerFieldModel) {
          if (value == null && castedModel.minLength != null && castedModel.minLength! > 0) {
            return localization.fromSymbols(castedModel.minLength!);
          }
          if (value == null && castedModel.minValue != null) {
            return localization.notLessThan(castedModel.minValue!);
          }
          if (value == null) {
            return null;
          }
          if (castedModel.maxLength != null && value.length > castedModel.maxLength!) {
            return localization.toSymbols(castedModel.maxLength!);
          }
          final parsedValue = int.tryParse(value);
          if (parsedValue == null) {
            return localization.incorrectFieldFormat;
          }
          if (castedModel.maxValue != null && parsedValue > castedModel.maxValue!) {
            return localization.notGreaterThan(castedModel.maxValue!);
          }
        }
        return null;
      },
    );
  }
}