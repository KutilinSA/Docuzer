import 'dart:io';

import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  final File image;

  const ImageScreen({ required this.image, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: Text(localization.viewing)),
      body: PhotoView(
        maxScale: PhotoViewComputedScale.contained * 3,
        minScale: PhotoViewComputedScale.contained / 3,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        imageProvider: FileImage(image),
      ),
    );
  }
}