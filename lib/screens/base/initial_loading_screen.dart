import 'dart:async';

import 'package:docuzer/core/requests/requests.dart';
import 'package:docuzer/core/utils.dart';
import 'package:docuzer/localization/generated/S.dart';
import 'package:docuzer/ui/themes.dart';
import 'package:docuzer/widgets/app_bar/custom_app_bar.dart';
import 'package:docuzer/widgets/base/appearance_block.dart';
import 'package:docuzer/widgets/base/block_card.dart';
import 'package:docuzer/widgets/base/loading_indicator.dart';
import 'package:docuzer/widgets/providers/current_user_provider.dart';
import 'package:docuzer/widgets/providers/documents_provider.dart';
import 'package:docuzer/widgets/providers/templates_provider.dart';
import 'package:flutter/material.dart';

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({ Key? key }) : super(key: key);

  @override
  _InitialLoadingScreen createState() => _InitialLoadingScreen();
}

class _InitialLoadingScreen extends State<InitialLoadingScreen> {
  bool _isRequesting = true;
  String? _errorOccurred;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) => _loadDataWithUserCheck());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(automaticallyImplyLeading: !_isRequesting),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: _errorOccurred != null ? BlockCard(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Text(_errorOccurred!, style: Theme.of(context).textTheme.headline1, textAlign: TextAlign.center),
            ) : LoadingIndicator(color: Theme.of(context).primaryColorDark, fullScreen: true),
          ),
          Positioned(
            bottom: Themes.screenPadding.bottom,
            child: AppearanceBlock(
              inset: null,
              isAppeared: !_isRequesting,
              child: SizedBox(
                width: 260,
                child: OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                    side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.transparent)),
                  ),
                  onPressed: _isRequesting ? null : _loadDataWithUserCheck,
                  child: Text(S.of(context)!.tryAgain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _onError(String error) {
    setState(() {
      _isRequesting = false;
      _errorOccurred = error;
    });
  }

  void _loadData() {
    DocumentsProvider.load(context).then((_) {
      TemplatesProvider.load(context).then((_) {
        Navigator.of(context).pushNamedAndRemoveUntil('', (route) => false);
      });
    });
  }

  void _loadDataWithUserCheck() {
    final localization = S.of(context)!;

    setState(() {
      _errorOccurred = null;
      _isRequesting = true;
    });
    if (CurrentUserProvider.of(context) == null) {
      Requests.makeRequest('account/actions/is-authenticated', 'GET').then(Utils.createApiResponseCallback(
        onSuccess: (body) {
          final model = CurrentUserProvider.update(context, body);
          if (model.publicActive) {
            _loadData();
          } else if (!model.emailCheck) {
            Navigator.of(context).pushReplacementNamed('registration/apply');
          } else {
            Navigator.of(context).pop();
          }
        },
        onUndefined: () => Navigator.of(context).pop(),
      )).onError((_, __) => _onError(localization.connectionError));
    } else {
      _loadData();
    }
  }
}