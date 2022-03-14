import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:docuzer/core/models/document_model.dart';
import 'package:docuzer/core/models/field_model.dart';
import 'package:docuzer/core/models/template_model.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/screens/base/image_screen.dart';
import 'package:docuzer/screens/base/save_document_screen.dart';
import 'package:docuzer/screens/documents/widgets/field.dart';
import 'package:docuzer/ui/custom_icons.dart';
import 'package:docuzer/ui/dialogs.dart';
import 'package:docuzer/ui/snack_bars.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/base/steps_indicator.dart';
import 'package:docuzer/widgets/providers/documents_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentEditorScreen extends StatefulWidget {
  final DocumentModel? initialData;
  final TemplateModel? template;

  const DocumentEditorScreen({ this.initialData, this.template, Key? key }) :
      assert(initialData == null || template == null, 'Only initial data or template can be set'),
      super(key: key);

  @override
  _DocumentEditorScreenState createState() => _DocumentEditorScreenState();
}

class _DocumentEditorScreenState extends State<DocumentEditorScreen> {
  final _inputsKey = GlobalKey<FormState>();
  late final List<File> _images = widget.initialData != null ? [
    for (final image in widget.initialData!.images)
      File(image),
  ] : [];
  late final List<FieldModel> _filedModels = widget.initialData != null ? [
    for (final fieldModel in widget.initialData!.fieldModels)
      FieldModel.fromJson(fieldModel.toJson()),
  ] : [];

  int _currentCarouselStep = 0;
  String? _title;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: Text(widget.initialData == null ? localization.creating : localization.editing),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, size: 28),
            onPressed: _save,
          ),
        ],
      ),
      body: Form(
        key: _inputsKey,
        child: ListView(
          padding: Themes.listPadding,
          children: [
            BlockCard(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                initialValue: widget.initialData != null ? widget.initialData!.title : widget.template?.title,
                textInputAction: TextInputAction.next,
                style: Theme.of(context).textTheme.headline3,
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
                  label: Text(localization.documentName),
                ),
                onSaved: (value) => _title = value,
                validator: (value) => Utils.validateNotEmpty(value, context),
              ),
            ),
            const SizedBox(height: 8),
            BlockCard(
              title: localization.images,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CarouselSlider(
                    items: [
                      for (var index = 0; index < _images.length; index++)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: GestureDetector(
                            onTap: () => _onImageTapped(index),
                            child: Image.file(
                              _images[index],
                              fit: BoxFit.contain,
                              frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: Themes.defaultAnimationDuration,
                                  curve: Themes.defaultAnimationCurve,
                                  child: child,
                                );
                              },
                            ),
                          ),
                        ),
                      if (_images.length < 5)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _addImage,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(CustomIcons.add, size: 64),
                              ),
                            ),
                          ),
                        ),
                    ],
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      aspectRatio: 1,
                      viewportFraction: 1,
                      onPageChanged: (page, _) => setState(() => _currentCarouselStep = page),
                    ),
                  ),
                  if (_images.isNotEmpty)
                    const SizedBox(height: 24),
                  if (_images.isNotEmpty)
                    StepsIndicator(currentStep: _currentCarouselStep, maxSteps: _images.length + (_images.length < 5 ? 1 : 0)),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 8),
            BlockCard(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  for (var i = 0; i < _filedModels.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Field(
                        fieldModel: _filedModels[i],
                        onSaved: (value) => setState(() => _filedModels[i] = value),
                        isLast: i == _filedModels.length - 1,
                      ),
                    ),
                  OutlinedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.transparent)),
                    ),
                    onPressed: _addField,
                    child: Text(localization.addField),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addField() {
    Dialogs.showFieldLabelDialog(context).then((label) {
      if (label != null) {
        Dialogs.showChoicesDialog(context, items: [
          'Целочисленное',
          'Строковое',
        ]).then((value) {
          if (value == 0) {
            setState(() {
              _filedModels.add(FieldModel.fromJson(<String, dynamic> {
                'label': label,
                'type': 'int',
              }));
            });
          } else if (value == 1) {
            setState(() {
              _filedModels.add(FieldModel.fromJson(<String, dynamic> {
                'label': label,
                'type': 'string',
              }));
            });
          }
        });
      }
    });
  }

  void _onImageTapped(int index) {
    Dialogs.showChoicesDialog(
      context,
      items: [
        'Просмотреть',
        'Удалить',
      ],
      styles: {
        1: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).errorColor),
      },
    ).then((value) {
      if (value == 0) {
        Navigator.of(context).push<void>(MaterialPageRoute(
          builder: (_) => ImageScreen(image: _images[index]),
          fullscreenDialog: true,
        ));
      } else if (value == 1) {
        setState(() => _images.removeAt(index));
      }
    });
  }

  void _addImage() {
    final localization = S.of(context)!;
    Dialogs.showChoicesDialog(context, items: [
      localization.fromGallery,
      localization.takePhoto,
    ]).then((value) {
      if (value == 0) {
        ImagePicker().pickMultiImage().then((files) {
          if (files != null) {
            setState(() {
              for (final file in files) {
                if (_images.length < 5) {
                  _images.add(File(file.path));
                } else {
                  SnackBars.showErrorSnackBar(context, text: localization.unableToAddMoreImages);
                  return;
                }
              }
            });
          }
        }).onError((error, stackTrace) {
          SnackBars.showErrorSnackBar(
            context,
            text: localization.unableToAccessGallery,
            duration: const Duration(seconds: 3),
            onTap: AppSettings.openAppSettings,
          );
        });
      } else if (value == 1) {
        ImagePicker().pickImage(source: ImageSource.camera).then((file) {
          if (file != null) {
            setState(() => _images.add(File(file.path)));
          }
        }).onError((error, stackTrace) {
          SnackBars.showErrorSnackBar(
            context,
            text: localization.unableToAccessCamera,
            duration: const Duration(seconds: 3),
            onTap: AppSettings.openAppSettings,
          );
        });
      }
    });
  }

  void _save() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_inputsKey.currentState!.validate()) return;
    _inputsKey.currentState!.save();
    Navigator.of(context).push<List<String>?>(MaterialPageRoute(
      builder: (_) => SaveDocumentImagesScreen(images: _images, previousPaths: widget.initialData?.images),
    )).then((value) {
      if (value != null) {
        final model = DocumentModel.fromJson(<String, dynamic> {
          'title': _title,
          'images': value,
          'fieldModels': _filedModels.map((e) => e.toJson()).toList(),
        });
        if (widget.initialData == null) {
          DocumentsProvider.of(context).add(model);
        } else {
          DocumentsProvider.of(context).update(model, widget.initialData!);
        }
        Navigator.of(context).pop();
      } else {
        SnackBars.showErrorSnackBar(context, text: S.of(context)!.savingError);
      }
    });
  }
}