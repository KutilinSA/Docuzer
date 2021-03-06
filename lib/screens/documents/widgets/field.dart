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

    return TextFormField(
      initialValue: fieldModel.value?.toString(),
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
      style: Theme.of(context).textTheme.headline3,
      inputFormatters: fieldModel.type == int ? [
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
        label: Text(fieldModel.label),
      ),
      onSaved: (value) {
        late final Object? convertedValue;
        if (fieldModel.type == int) {
          convertedValue = int.tryParse(value ?? '');
        } else if (fieldModel.type == String) {
          convertedValue = value;
        } else {
          throw UnimplementedError('Field type ${fieldModel.type} is not implemented');
        }

        onSaved?.call(FieldModel.fromJson(fieldModel.toJson()..['value'] = convertedValue));
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return localization.fieldCantBeEmpty;
        }
        return null;
      },
    );
  }
}