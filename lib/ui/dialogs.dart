import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<bool?> showConfirmationDialog(BuildContext context, String text) {
    final localization = S.of(context)!;

    return showDialog<bool>(
      barrierColor: Colors.black87,
      context: context,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        titleTextStyle: Theme.of(context).textTheme.headline2,
        title: Text(text, textAlign: TextAlign.center),
        titlePadding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          SizedBox(
            width: 120,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).errorColor),
                side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.transparent)),
              ),
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(localization.no),
            ),
          ),
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(localization.yes),
            ),
          ),
        ],
      ),
    );
  }

  static Future<int?> showChoicesDialog(BuildContext context, { List<String> items = const [], Map<int, TextStyle>? styles }) {
    return showModalBottomSheet<int?>(
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black87,
      backgroundColor: Colors.transparent,
      builder: (newContext) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          color: Colors.white,
          boxShadow: Themes.upShadow,
        ),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 16 > MediaQuery.of(newContext).padding.bottom ? 16 : MediaQuery.of(newContext).padding.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).dividerColor,
                ),
                width: 30,
                height: 3,
              ),
              const SizedBox(height: 8),
              for (var i = 0; i < items.length; i++)
                GestureDetector(
                  onTap: () => Navigator.of(newContext).pop(i),
                  child: Container(
                    decoration: BoxDecoration(
                      border: i != items.length - 1 ? Border(
                        bottom: BorderSide(color: Theme.of(context).dividerColor),
                      ) : null,
                    ),
                    width: double.infinity,
                    padding: i == 0 ? const EdgeInsets.fromLTRB(24, 8, 24, 16) : i == items.length - 1 ? const EdgeInsets.fromLTRB(24, 16, 24, 0) : const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    alignment: Alignment.center,
                    child: Text(items[i], style: styles?[i] ?? Theme.of(context).textTheme.headline4),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
