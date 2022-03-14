import 'dart:math' as math;

import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/app_bar_back_button.dart';
import 'package:docuzer/widgets/app_bar/app_bar_close_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class _PreferredAppBarSize extends Size {
  final double? toolbarHeight;
  final double? bottomHeight;

  _PreferredAppBarSize(this.toolbarHeight, this.bottomHeight) : super.fromHeight((toolbarHeight ?? kToolbarHeight) + (bottomHeight ?? 0));
}

class _AppBarTitleBox extends SingleChildRenderObjectWidget {
  const _AppBarTitleBox({required Widget child, Key? key}) : super(key: key, child: child);

  @override
  _RenderAppBarTitleBox createRenderObject(BuildContext context) {
    return _RenderAppBarTitleBox(
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderAppBarTitleBox renderObject) {
    renderObject.textDirection = Directionality.of(context);
  }
}

class _RenderAppBarTitleBox extends RenderAligningShiftedBox {
  _RenderAppBarTitleBox({
    RenderBox? child,
    TextDirection? textDirection,
  }) : super(child: child, alignment: Alignment.center, textDirection: textDirection);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    final childSize = child!.getDryLayout(innerConstraints);
    return constraints.constrain(childSize);
  }

  @override
  void performLayout() {
    final innerConstraints = constraints.copyWith(maxHeight: double.infinity);
    child!.layout(innerConstraints, parentUsesSize: true);
    size = constraints.constrain(child!.size);
    alignChild();
  }
}

class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
  final double toolbarHeight;

  const _ToolbarContainerLayout(this.toolbarHeight);

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.tighten(height: toolbarHeight);
  }

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(constraints.maxWidth, toolbarHeight);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(0.0, size.height - childSize.height);
  }

  @override
  bool shouldRelayout(_ToolbarContainerLayout oldDelegate) => toolbarHeight != oldDelegate.toolbarHeight;
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;
  final double? elevation;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Brightness? brightness;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextTheme? textTheme;
  final bool primary;
  final bool? centerTitle;
  final bool excludeHeaderSemantics;
  final double? titleSpacing;
  final double toolbarOpacity;
  final double bottomOpacity;
  @override
  final Size preferredSize;
  final double? toolbarHeight;
  final double? leadingWidth;
  final bool? backwardsCompatibility;
  final TextStyle? toolbarTextStyle;
  final TextStyle? titleTextStyle;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final VoidCallback? onBackButtonPressed;
  final bool applyShadow;

  CustomAppBar({
    Key? key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title = const Icon(CustomIcons.lock, size: 32),
    this.actions,
    this.flexibleSpace,
    this.bottom,
    this.elevation,
    this.shadowColor,
    this.shape,
    this.backgroundColor,
    this.foregroundColor,
    this.brightness,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.primary = true,
    this.centerTitle = true,
    this.excludeHeaderSemantics = false,
    this.titleSpacing,
    this.toolbarOpacity = 1.0,
    this.bottomOpacity = 1.0,
    this.toolbarHeight = 56,
    this.leadingWidth,
    this.backwardsCompatibility,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.onBackButtonPressed,
    this.applyShadow = true,
  })  : assert(elevation == null || elevation >= 0.0),
        preferredSize = _PreferredAppBarSize(toolbarHeight, bottom?.preferredSize.height),
        super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  static double preferredHeightFor(BuildContext context, Size preferredSize) {
    if (preferredSize is _PreferredAppBarSize && preferredSize.toolbarHeight == null) {
      return (AppBarTheme.of(context).toolbarHeight ?? kToolbarHeight) + (preferredSize.bottomHeight ?? 0);
    }
    return preferredSize.height;
  }

  bool _getEffectiveCenterTitle(ThemeData theme) {
    if (centerTitle != null) {
      return centerTitle!;
    }
    if (theme.appBarTheme.centerTitle != null) {
      return theme.appBarTheme.centerTitle!;
    }
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return actions == null || actions!.length < 2;
    }
  }
}

class _CustomAppBarState extends State<CustomAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
    }
    _scrollNotificationObserver = ScrollNotificationObserver.of(context);
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.addListener(_handleScrollNotification);
    }
  }

  @override
  void dispose() {
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.primary || debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = AppBarTheme.of(context);
    final scaffold = Scaffold.maybeOf(context);
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);

    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
    final states = <MaterialState>{
      if (settings?.isScrolledUnder ?? _scrolledUnder) MaterialState.scrolledUnder,
    };

    final hasDrawer = scaffold?.hasDrawer ?? false;
    final hasEndDrawer = scaffold?.hasEndDrawer ?? false;
    final canPop = parentRoute?.canPop ?? false;
    final useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    final toolbarHeight = (widget.toolbarHeight ?? appBarTheme.toolbarHeight ?? kToolbarHeight) + MediaQuery.of(context).padding.top;
    final backwardsCompatibility = widget.backwardsCompatibility ?? false;

    final backgroundColor = backwardsCompatibility
        ? widget.backgroundColor ?? appBarTheme.backgroundColor ?? theme.primaryColor
        : _resolveColor(
            states,
            widget.backgroundColor,
            appBarTheme.backgroundColor,
            colorScheme.brightness == Brightness.dark ? colorScheme.surface : colorScheme.primary,
          );

    final foregroundColor = widget.foregroundColor ??
        appBarTheme.foregroundColor ??
        (colorScheme.brightness == Brightness.dark ? colorScheme.onSurface : colorScheme.onPrimary);

    var overallIconTheme = backwardsCompatibility
        ? widget.iconTheme ?? appBarTheme.iconTheme ?? theme.primaryIconTheme
        : widget.iconTheme ?? appBarTheme.iconTheme ?? theme.iconTheme.copyWith(color: foregroundColor);

    var actionsIconTheme = widget.actionsIconTheme ?? appBarTheme.actionsIconTheme ?? overallIconTheme;

    var toolbarTextStyle = backwardsCompatibility
        ? widget.textTheme?.bodyText2 ?? theme.primaryTextTheme.bodyText2
        : widget.toolbarTextStyle ?? appBarTheme.toolbarTextStyle ?? theme.textTheme.bodyText2?.copyWith(color: foregroundColor);

    var titleTextStyle = backwardsCompatibility
        ? widget.textTheme?.headline6 ?? theme.primaryTextTheme.headline6
        : widget.titleTextStyle ?? appBarTheme.titleTextStyle ?? theme.textTheme.headline6?.copyWith(color: foregroundColor);

    if (widget.toolbarOpacity != 1.0) {
      final opacity = const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.toolbarOpacity);
      if (titleTextStyle?.color != null) {
        titleTextStyle = titleTextStyle!.copyWith(color: titleTextStyle.color!.withOpacity(opacity));
      }
      if (toolbarTextStyle?.color != null) {
        toolbarTextStyle = toolbarTextStyle!.copyWith(color: toolbarTextStyle.color!.withOpacity(opacity));
      }
      overallIconTheme = overallIconTheme.copyWith(
        opacity: opacity * (overallIconTheme.opacity ?? 1.0),
      );
      actionsIconTheme = actionsIconTheme.copyWith(
        opacity: opacity * (actionsIconTheme.opacity ?? 1.0),
      );
    }

    var leading = widget.leading;
    if (leading == null && widget.automaticallyImplyLeading) {
      if (hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: overallIconTheme.size ?? 24,
          onPressed: _handleDrawerButton,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (!hasEndDrawer && canPop) {
          leading = useCloseButton ? AppBarCloseButton(onPressed: widget.onBackButtonPressed) : AppBarBackButton(onPressed: widget.onBackButtonPressed);
        }
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? kToolbarHeight),
        child: leading,
      );
    }

    var title = widget.title;
    if (title != null) {
      bool? namesRoute;
      switch (theme.platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
        case TargetPlatform.linux:
        case TargetPlatform.windows:
          namesRoute = true;
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          break;
      }

      title = _AppBarTitleBox(child: title);
      if (!widget.excludeHeaderSemantics) {
        title = Semantics(
          namesRoute: namesRoute,
          header: true,
          child: title,
        );
      }

      title = DefaultTextStyle(
        style: titleTextStyle!,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        child: title,
      );

      // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
      // title to keep the visual hierarchy the same even with larger font
      // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
      // with [MediaQueryData.textScaleFactor] set to
      // `MediaQuery.textScaleFactorOf(context)`.
      final mediaQueryData = MediaQuery.of(context);
      title = MediaQuery(
        data: mediaQueryData.copyWith(
          textScaleFactor: math.min(
            mediaQueryData.textScaleFactor,
            1.34,
          ),
        ),
        child: title,
      );
    }

    Widget? actions;
    if (widget.actions != null && widget.actions!.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions!,
      );
    } else if (hasEndDrawer) {
      actions = IconButton(
        icon: const Icon(Icons.menu),
        iconSize: overallIconTheme.size ?? 24,
        onPressed: _handleDrawerButtonEnd,
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      );
    }

    // Allow the trailing actions to have their own theme if necessary.
    if (actions != null) {
      actions = IconTheme.merge(
        data: actionsIconTheme,
        child: actions,
      );
    }

    final Widget toolbar = NavigationToolbar(
      leading: leading,
      middle: title,
      trailing: actions,
      centerMiddle: widget._getEffectiveCenterTitle(theme),
      middleSpacing: widget.titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
    );

    // If the toolbar is allocated less than toolbarHeight make it
    // appear to scroll upwards within its shrinking container.
    Widget appBar = ClipRect(
      child: CustomSingleChildLayout(
        delegate: _ToolbarContainerLayout(toolbarHeight),
        child: IconTheme.merge(
          data: overallIconTheme,
          child: DefaultTextStyle(
            style: toolbarTextStyle!,
            child: toolbar,
          ),
        ),
      ),
    );
    if (widget.bottom != null) {
      appBar = Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: toolbarHeight),
              child: appBar,
            ),
          ),
          if (widget.bottomOpacity == 1.0)
            widget.bottom!
          else
            Opacity(
              opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
              child: widget.bottom,
            ),
        ],
      );
    }

    if (widget.primary) {
      appBar = SafeArea(
        bottom: false,
        child: appBar,
      );
    }

    appBar = Align(
      alignment: Alignment.topCenter,
      child: appBar,
    );

    if (widget.flexibleSpace != null) {
      appBar = Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Semantics(
            sortKey: const OrdinalSortKey(1.0),
            explicitChildNodes: true,
            child: widget.flexibleSpace,
          ),
          Semantics(
            sortKey: const OrdinalSortKey(0.0),
            explicitChildNodes: true,
            // Creates a material widget to prevent the flexibleSpace from
            // obscuring the ink splashes produced by appBar children.
            child: Material(
              type: MaterialType.transparency,
              child: appBar,
            ),
          ),
        ],
      );
    }

    final overlayStyle = backwardsCompatibility
        ? _systemOverlayStyleForBrightness(
            widget.brightness ?? theme.brightness,
          )
        : widget.systemOverlayStyle ??
            appBarTheme.systemOverlayStyle ??
            _systemOverlayStyleForBrightness(ThemeData.estimateBrightnessForColor(backgroundColor));

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: widget.applyShadow ? Themes.downShadow : null,
          ),
          child: Semantics(
            explicitChildNodes: true,
            child: appBar,
          ),
        ),
      ),
    );
  }

  void _handleDrawerButton() {
    Scaffold.of(context).openDrawer();
  }

  void _handleDrawerButtonEnd() {
    Scaffold.of(context).openEndDrawer();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final oldScrolledUnder = _scrolledUnder;
      _scrolledUnder = notification.depth == 0 && notification.metrics.extentBefore > 0 && notification.metrics.axis == Axis.vertical;
      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {
          // React to a change in MaterialState.scrolledUnder
        });
      }
    }
  }

  Color _resolveColor(Set<MaterialState> states, Color? widgetColor, Color? themeColor, Color defaultColor) {
    return MaterialStateProperty.resolveAs<Color?>(widgetColor, states) ??
        MaterialStateProperty.resolveAs<Color?>(themeColor, states) ??
        MaterialStateProperty.resolveAs<Color>(defaultColor, states);
  }

  SystemUiOverlayStyle _systemOverlayStyleForBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;
  }
}
