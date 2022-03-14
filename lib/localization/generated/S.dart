// ignore_for_file: always_use_package_imports
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'S_en.dart';
import 'S_ru.dart';

/// Callers can lookup localized strings with an instance of S returned
/// by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'generated/S.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @notGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'Not greater than {value}'**
  String notGreaterThan(int value);

  /// No description provided for @notLessThan.
  ///
  /// In en, this message translates to:
  /// **'Not less than {value}'**
  String notLessThan(int value);

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field name'**
  String get fieldName;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get addField;

  /// No description provided for @incorrectFieldFormat.
  ///
  /// In en, this message translates to:
  /// **'Incorrect field format'**
  String get incorrectFieldFormat;

  /// No description provided for @incorrectEmail.
  ///
  /// In en, this message translates to:
  /// **'Incorrect E-mail is specified'**
  String get incorrectEmail;

  /// No description provided for @passwordShouldContain.
  ///
  /// In en, this message translates to:
  /// **'Must contain Latin letters of different case, as well as numbers'**
  String get passwordShouldContain;

  /// No description provided for @fromToSymbols.
  ///
  /// In en, this message translates to:
  /// **'From {from} to {to} symbols'**
  String fromToSymbols(int from, int to);

  /// No description provided for @fromSymbols.
  ///
  /// In en, this message translates to:
  /// **'From {from} symbols'**
  String fromSymbols(int from);

  /// No description provided for @toSymbols.
  ///
  /// In en, this message translates to:
  /// **'Up to {to} symbols'**
  String toSymbols(int to);

  /// No description provided for @loginUsernameEmail.
  ///
  /// In en, this message translates to:
  /// **'E-mail / username'**
  String get loginUsernameEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Signing in'**
  String get signInTitle;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get signUpTitle;

  /// No description provided for @fieldCantBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The field can\'t be empty'**
  String get fieldCantBeEmpty;

  /// No description provided for @fieldMaxLength.
  ///
  /// In en, this message translates to:
  /// **'The maximum field length is {value}'**
  String fieldMaxLength(int value);

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials'**
  String get incorrectCredentials;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connectionError;

  /// No description provided for @emailAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'E-mail is already used'**
  String get emailAlreadyUsed;

  /// No description provided for @usernameAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Username is already used'**
  String get usernameAlreadyUsed;

  /// No description provided for @incorrectEmailScheme.
  ///
  /// In en, this message translates to:
  /// **'Incorrect E-mail format'**
  String get incorrectEmailScheme;

  /// No description provided for @incorrectUsernameScheme.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username format'**
  String get incorrectUsernameScheme;

  /// No description provided for @dataFilledIncorrectly.
  ///
  /// In en, this message translates to:
  /// **'The data is filled incorrectly'**
  String get dataFilledIncorrectly;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat the password'**
  String get repeatPassword;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @insertCode.
  ///
  /// In en, this message translates to:
  /// **'Insert code'**
  String get insertCode;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @passwordRecovery.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get passwordRecovery;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noMoreAttempts.
  ///
  /// In en, this message translates to:
  /// **'The attempts ended\nRequest a new code'**
  String get noMoreAttempts;

  /// No description provided for @codeSentAgain.
  ///
  /// In en, this message translates to:
  /// **'The code was sent again'**
  String get codeSentAgain;

  /// No description provided for @failedToSendCode.
  ///
  /// In en, this message translates to:
  /// **'Failed to send the code'**
  String get failedToSendCode;

  /// No description provided for @attemptsLeft.
  ///
  /// In en, this message translates to:
  /// **'Incorrect code\nAttempts left: {count}'**
  String attemptsLeft(int count);

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account is disabled. Contact support'**
  String get accountDisabled;

  /// No description provided for @notEnoughRights.
  ///
  /// In en, this message translates to:
  /// **'Not enough rights'**
  String get notEnoughRights;

  /// No description provided for @fromTemplate.
  ///
  /// In en, this message translates to:
  /// **'By template'**
  String get fromTemplate;

  /// No description provided for @fromNothing.
  ///
  /// In en, this message translates to:
  /// **'Empty document'**
  String get fromNothing;

  /// No description provided for @addFirstDocument.
  ///
  /// In en, this message translates to:
  /// **'Add the first document!'**
  String get addFirstDocument;

  /// No description provided for @documentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Oh, it\'s completely empty here :('**
  String get documentsEmpty;

  /// No description provided for @templates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templates;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @noTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates'**
  String get noTemplates;

  /// No description provided for @editing.
  ///
  /// In en, this message translates to:
  /// **'Editing'**
  String get editing;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating'**
  String get creating;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select a template'**
  String get selectTemplate;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get documentName;

  /// No description provided for @fromGallery.
  ///
  /// In en, this message translates to:
  /// **'From gallery'**
  String get fromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @unableToAccessGallery.
  ///
  /// In en, this message translates to:
  /// **'Unable to access the gallery. Check the app settings'**
  String get unableToAccessGallery;

  /// No description provided for @unableToAccessCamera.
  ///
  /// In en, this message translates to:
  /// **'Unable to access the camera. Check the app settings'**
  String get unableToAccessCamera;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @unableToAddMoreImages.
  ///
  /// In en, this message translates to:
  /// **'Unable to add more than five images'**
  String get unableToAddMoreImages;

  /// No description provided for @viewing.
  ///
  /// In en, this message translates to:
  /// **'Viewing'**
  String get viewing;

  /// No description provided for @savingError.
  ///
  /// In en, this message translates to:
  /// **'Saving error'**
  String get savingError;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SEn();
    case 'ru': return SRu();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
