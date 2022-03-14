import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/home/widgets/document_item.dart';
import 'package:docuzer/screens/templates/select_template_screen.dart';
import 'package:docuzer/ui/animation_manager.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/dialogs.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/providers/documents_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final _animationManager = AnimationManager(configuration: AnimationManagerConfiguration(
    stepsDurations: [
      const Duration(milliseconds: 100),
      Themes.appearanceAnimationDuration + const Duration(milliseconds: 100),
    ],
    items: const [
      AnimationItemConfiguration(item: 'empty_message', itemType: AnimationItemType.from, step: 0),
      AnimationItemConfiguration(item: 'add_button', itemType: AnimationItemType.from, step: 1),
    ],
    setStateCallback: setState,
  ));

  @override
  void dispose() {
    _animationManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentsProvider = DocumentsProvider.of(context);
    final documents = documentsProvider.getDocuments();
    final localization = S.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(localization.documents),
        actions: [
          IconButton(
            padding: const EdgeInsets.fromLTRB(8, 8, 24, 8),
            icon: const Icon(CustomIcons.add, size: 20),
            onPressed: _addDocument,
          ),
        ],
      ),
      body: documents.isEmpty ? Padding(
        padding: Themes.screenPadding,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AppearanceBlock(
                isAppeared: _animationManager.isActive('empty_message'),
                child: SizedBox(
                  width: 320,
                  child: Text(
                    localization.documentsEmpty,
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const Spacer(),
              AppearanceBlock(
                inset: null,
                isAppeared: _animationManager.isActive('add_button'),
                child: OutlinedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(const Size(320, 48)),
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.transparent)),
                  ),
                  onPressed: _addDocument,
                  child: Text(localization.addFirstDocument),
                ),
              ),
            ],
          ),
        ),
      ) : ReorderableBuilder(
        children: [
          for (final model in documents)
            DocumentItem(model: model, key: UniqueKey()),
        ],
        onReorder: (orderUpdateEntities) {
          for (final orderUpdateEntity in orderUpdateEntities) {
            final model = documentsProvider.remove(orderUpdateEntity.oldIndex);
            documentsProvider.insert(model, orderUpdateEntity.newIndex);
          }
        },
        builder: (children, scrollController) {
          return GridView(
            controller: scrollController,
            children: children,
            padding: Themes.listPadding,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 8,
            ),
          );
        },
      ),
    );
  }

  void _addDocument() {
    final localization = S.of(context)!;

    Dialogs.showChoicesDialog(
      context,
      styles: {
        0: Theme.of(context).textTheme.headline2!.copyWith(color: Theme.of(context).colorScheme.secondary),
      },
      items: [
        localization.fromTemplate,
        localization.fromNothing,
      ],
    ).then((value) {
      if (value == 0) {
        Navigator.of(context).push<TemplateModel?>(MaterialPageRoute(
          builder: (_) => const SelectTemplateScreen(),
        )).then((value) {
          if (value != null) {
            Navigator.of(context).pushNamed<void>('home/add-document', arguments: value);
          }
        });
      } else if (value == 1) {
        Navigator.of(context).pushNamed<void>('home/add-document');
      }
    });
  }
}