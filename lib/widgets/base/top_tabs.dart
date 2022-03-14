import 'package:docuzer/core/types.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:flutter/material.dart';

class TopTabs extends StatefulWidget {
  final List<String> items;
  final List<Widget> views;
  final double? labelsSize;
  final bool enableViewScrolling;

  final VoidCallbackWithParam<int>? onTabChanged;

  const TopTabs({ required this.items, required this.views, this.labelsSize,
    this.onTabChanged, this.enableViewScrolling = true, Key? key, }) : super(key: key);

  @override
  _TopTabsState createState() => _TopTabsState();
}

class _TopTabsState extends State<TopTabs> with SingleTickerProviderStateMixin {
  late final _controller = TabController(length: widget.items.length, vsync: this);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.up,
      children: [
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: widget.views,
            physics: widget.enableViewScrolling ? null : const NeverScrollableScrollPhysics(),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: Themes.downShadow,
          ),
          height: Theme.of(context).appBarTheme.toolbarHeight! - 10,
          child: TabBar(
            indicatorWeight: 4,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            onTap: widget.onTabChanged,
            controller: _controller,
            labelStyle: Theme.of(context).tabBarTheme.labelStyle!.copyWith(fontSize: widget.labelsSize),
            unselectedLabelStyle: Theme.of(context).tabBarTheme.unselectedLabelStyle!.copyWith(fontSize: widget.labelsSize),
            tabs: [
              for (final item in widget.items)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(item),
                ),
            ],
          ),
        ),
      ],
    );
  }
}