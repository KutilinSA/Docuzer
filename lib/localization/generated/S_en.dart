// ignore_for_file: always_use_package_imports


import 'S.dart';

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String notGreaterThan(int value) {
    return 'Not greater than $value';
  }

  @override
  String notLessThan(int value) {
    return 'Not less than $value';
  }

  @override
  String get addField => 'Add field';

  @override
  String get incorrectFieldFormat => 'Incorrect field format';

  @override
  String get incorrectEmail => 'Incorrect E-mail is specified';

  @override
  String get passwordShouldContain => 'Must contain Latin letters of different case, as well as numbers';

  @override
  String fromToSymbols(int from, int to) {
    return 'From $from to $to symbols';
  }

  @override
  String fromSymbols(int from) {
    return 'From $from symbols';
  }

  @override
  String toSymbols(int to) {
    return 'Up to $to symbols';
  }

  @override
  String get loginUsernameEmail => 'E-mail / username';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInTitle => 'Signing in';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signUp => 'Sign up';

  @override
  String get signUpTitle => 'Registration';

  @override
  String get fieldCantBeEmpty => 'The field can\'t be empty';

  @override
  String fieldMaxLength(int value) {
    return 'The maximum field length is $value';
  }

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get incorrectCredentials => 'Incorrect credentials';

  @override
  String get connectionError => 'Connection error';

  @override
  String get emailAlreadyUsed => 'E-mail is already used';

  @override
  String get usernameAlreadyUsed => 'Username is already used';

  @override
  String get incorrectEmailScheme => 'Incorrect E-mail format';

  @override
  String get incorrectUsernameScheme => 'Incorrect username format';

  @override
  String get dataFilledIncorrectly => 'The data is filled incorrectly';

  @override
  String get repeatPassword => 'Repeat the password';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get insertCode => 'Insert code';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get passwordRecovery => 'Password recovery';

  @override
  String get tryAgain => 'Try again';

  @override
  String get next => 'Next';

  @override
  String get noMoreAttempts => 'The attempts ended\nRequest a new code';

  @override
  String get codeSentAgain => 'The code was sent again';

  @override
  String get failedToSendCode => 'Failed to send the code';

  @override
  String attemptsLeft(int count) {
    return 'Incorrect code\nAttempts left: $count';
  }

  @override
  String get userNotFound => 'User not found';

  @override
  String get resend => 'Resend';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String get newPassword => 'New password';

  @override
  String get email => 'E-mail';

  @override
  String get username => 'Username';

  @override
  String get accountDisabled => 'Your account is disabled. Contact support';

  @override
  String get notEnoughRights => 'Not enough rights';

  @override
  String get fromTemplate => 'By template';

  @override
  String get fromNothing => 'Empty document';

  @override
  String get addFirstDocument => 'Add the first document!';

  @override
  String get documentsEmpty => 'Oh, it\'s completely empty here :(';

  @override
  String get templates => 'Templates';

  @override
  String get documents => 'Documents';

  @override
  String get noTemplates => 'No templates';

  @override
  String get editing => 'Editing';

  @override
  String get creating => 'Creating';

  @override
  String get selectTemplate => 'Select a template';

  @override
  String get documentName => 'Document name';

  @override
  String get fromGallery => 'From gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get unableToAccessGallery => 'Unable to access the gallery. Check the app settings';

  @override
  String get unableToAccessCamera => 'Unable to access the camera. Check the app settings';

  @override
  String get images => 'Images';

  @override
  String get unableToAddMoreImages => 'Unable to add more than five images';

  @override
  String get viewing => 'Viewing';

  @override
  String get savingError => 'Saving error';
}
