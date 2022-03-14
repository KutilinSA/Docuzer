import 'dart:io';

import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SaveDocumentImagesScreen extends StatefulWidget {
  final List<File> images;
  final List<String>? previousPaths;

  const SaveDocumentImagesScreen({ required this.images, this.previousPaths = const [], Key? key }) : super(key: key);

  @override
  _SaveDocumentImagesScreenState createState() => _SaveDocumentImagesScreenState();
}

class _SaveDocumentImagesScreenState extends State<SaveDocumentImagesScreen> {
  @override
  void initState() {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _saveDocumentImages().then((images) {
          Navigator.of(context).pop(images);
        }).onError((error, stackTrace) { _onError(); });
      });
    } else {
      _onError();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: LoadingIndicator(color: Theme.of(context).primaryColorDark, fullScreen: true),
      ),
    );
  }

  void _onError() {
    Navigator.of(context).pop();
  }

  Future<List<String>> _saveDocumentImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final images = <String>[];
    final previousPaths = widget.previousPaths ?? [];
    final currentPaths = widget.images.map((e) => e.path);
    for (final previousPath in previousPaths) {
      if (!currentPaths.contains(previousPath)) {
        File(previousPath).deleteSync();
      }
    }
    for (final image in widget.images) {
      final path = '${directory.path}/${image.uri.pathSegments.last}';
      images.add(path);
      if (previousPaths.contains(path)) {
        continue;
      } else {
        await image.copy(path);
      }
    }
    return images;
  }
}