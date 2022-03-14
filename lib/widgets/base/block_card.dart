import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

enum BlockCardStyle {
  primary,
  secondary,
  secondaryContainer,
  inverse,
  light,
  flat,
}

class BottomButtonInfo {
  final Widget child;
  final VoidCallback? onTap;

  const BottomButtonInfo({ required this.child, this.onTap, });
}

class BlockCard extends StatelessWidget {
  final double? width;
  final double? height;
  final String? title;
  final Widget? child;
  final BottomButtonInfo? bottomButtonInfo;
  final EdgeInsets padding;
  final BlockCardStyle style;

  const BlockCard({ this.width, this.height, this.title, this.child, this.bottomButtonInfo,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
    this.style = BlockCardStyle.primary, Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: style == BlockCardStyle.primary ? Colors.white :
        style == BlockCardStyle.secondary ? Theme.of(context).colorScheme.secondary :
        style == BlockCardStyle.secondaryContainer ? Theme.of(context).colorScheme.secondaryContainer :
        style == BlockCardStyle.inverse ? Theme.of(context).primaryColorDark :
        style == BlockCardStyle.light ? Theme.of(context).primaryColor :
        null,
      boxShadow: style != BlockCardStyle.flat ? Themes.downShadow : null,
    );

    return Container(
      width: width,
      height: height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Text(title!, style: Theme.of(context).textTheme.headline2),
            ),
          Padding(
            padding: padding,
            child: child,
          ),
          if (bottomButtonInfo != null)
            OutlinedButton(
              onPressed: () => bottomButtonInfo!.onTap?.call(),
              child: bottomButtonInfo!.child,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)))),
                elevation: MaterialStateProperty.all<double>(0),
              ),
            ),
        ],
      ),
      decoration: decoration,
    );
  }
}