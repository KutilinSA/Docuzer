import 'dart:async';

import 'package:docuzer/core/types.dart';
import 'package:flutter/material.dart';

enum AnimationItemType {
  from,
  to,
}

class AnimationItemConfiguration {
  final String item;
  final AnimationItemType itemType;
  final int step;

  const AnimationItemConfiguration({ required this.item, required this.itemType, required this.step });
}

class AnimationManagerConfiguration {
  final VoidCallbackWithParam<VoidCallback>? setStateCallback;
  final List<Duration> stepsDurations;
  final List<AnimationItemConfiguration> items;

  const AnimationManagerConfiguration({ required this.stepsDurations, required this.items, this.setStateCallback });
}

class AnimationManager {
  final AnimationManagerConfiguration configuration;

  final List<Timer> _timers = [];

  int _step = -1;

  AnimationManager({ required this.configuration }) {
    for (final duration in configuration.stepsDurations) {
      if (duration.inMilliseconds == 0) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          configuration.setStateCallback?.call(() => _step++);
        });
      } else {
        _timers.add(Timer(duration, () {
          configuration.setStateCallback?.call(() => _step++);
        }));
      }
    }
  }

  void dispose() {
    for (final timer in _timers) {
      timer.cancel();
    }
  }

  bool isActive(String value) {
    for (final item in configuration.items) {
      if (item.item == value) {
        if (item.itemType == AnimationItemType.from) {
          return _step >= item.step;
        } else if (item.itemType == AnimationItemType.to) {
          return _step <= item.step;
        }
      }
    }
    return false;
  }
}