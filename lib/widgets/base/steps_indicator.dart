import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class StepsIndicator extends StatelessWidget {
  final int currentStep;
  final int maxSteps;

  const StepsIndicator({ required this.currentStep, required this.maxSteps, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < maxSteps; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: AnimatedContainer(
                width: currentStep == i ? 10 : 8,
                height: currentStep == i ? 10 : 8,
                duration: Themes.defaultAnimationDuration,
                curve: Themes.defaultAnimationCurve,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentStep == i ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorDark.withOpacity(0.2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
