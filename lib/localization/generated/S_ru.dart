// ignore_for_file: always_use_package_imports


import 'S.dart';

/// The translations for Russian (`ru`).
class SRu extends S {
  SRu([String locale = 'ru']) : super(locale);

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get ok => 'OK';

  @override
  String notGreaterThan(int value) {
    return 'Не больше, чем $value';
  }

  @override
  String notLessThan(int value) {
    return 'Не меньше, чем $value';
  }

  @override
  String get addField => 'Добавить поле';

  @override
  String get incorrectFieldFormat => 'Неверный формат поля';

  @override
  String get incorrectEmail => 'Указан некорректный E-mail';

  @override
  String get passwordShouldContain => 'Должен содержать латинские буквы разного регистра, а также цифры';

  @override
  String fromToSymbols(int from, int to) {
    return 'От $from до $to символов';
  }

  @override
  String fromSymbols(int from) {
    return 'От $from символов';
  }

  @override
  String toSymbols(int to) {
    return 'До $to символов';
  }

  @override
  String get loginUsernameEmail => 'E-mail / имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get signInTitle => 'Вход';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get signUp => 'Зарегистрироваться';

  @override
  String get signUpTitle => 'Регистрация';

  @override
  String get fieldCantBeEmpty => 'Поле не может быть пустым';

  @override
  String fieldMaxLength(int value) {
    return 'Максимальная длина поля $value';
  }

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get incorrectCredentials => 'Неверные учетные данные';

  @override
  String get connectionError => 'Ошибка подключения';

  @override
  String get emailAlreadyUsed => 'E-mail уже занят';

  @override
  String get usernameAlreadyUsed => 'Имя пользователя уже занято';

  @override
  String get incorrectEmailScheme => 'Неверный формат E-mail';

  @override
  String get incorrectUsernameScheme => 'Неверный формат имени пользователя';

  @override
  String get dataFilledIncorrectly => 'Неверно заполнены данные';

  @override
  String get repeatPassword => 'Повторите пароль';

  @override
  String get verificationCode => 'Код подтверждения';

  @override
  String get insertCode => 'Вставить код';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get cancel => 'Отмена';

  @override
  String get passwordsDontMatch => 'Пароли не совпадают';

  @override
  String get passwordRecovery => 'Восстановление пароля';

  @override
  String get tryAgain => 'Попробовать снова';

  @override
  String get next => 'Далее';

  @override
  String get noMoreAttempts => 'Попытки закончились\nЗапросите новый код';

  @override
  String get codeSentAgain => 'Код выслан повторно';

  @override
  String get failedToSendCode => 'Не удалось выслать код';

  @override
  String attemptsLeft(int count) {
    return 'Неверный код\nОсталось попыток: $count';
  }

  @override
  String get userNotFound => 'Пользователь не найден';

  @override
  String get resend => 'Выслать повторно';

  @override
  String get passwordUpdated => 'Пароль обновлен';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get email => 'E-mail';

  @override
  String get username => 'Имя пользователя';

  @override
  String get accountDisabled => 'Ваш аккаунт отключен. Обратитесь в службу поддержки';

  @override
  String get notEnoughRights => 'Недостаточно прав';

  @override
  String get fromTemplate => 'По шаблону';

  @override
  String get fromNothing => 'Пустой документ';

  @override
  String get addFirstDocument => 'Добавить первый документ!';

  @override
  String get documentsEmpty => 'Ох, здесь совсем пусто :(';

  @override
  String get templates => 'Шаблоны';

  @override
  String get documents => 'Документы';

  @override
  String get noTemplates => 'Нет шаблонов';

  @override
  String get editing => 'Редактирование';

  @override
  String get creating => 'Создание';

  @override
  String get selectTemplate => 'Выберите шаблон';

  @override
  String get documentName => 'Название документа';

  @override
  String get fromGallery => 'Из галереи';

  @override
  String get takePhoto => 'Сфотографировать';

  @override
  String get unableToAccessGallery => 'Не удалось получить доступ к галерее. Проверьте настройки приложения';

  @override
  String get unableToAccessCamera => 'Не удалось получить доступ к камере. Проверьте настройки приложения';

  @override
  String get images => 'Изображения';

  @override
  String get unableToAddMoreImages => 'Невозможно добавить более пяти изображений';

  @override
  String get viewing => 'Просмотр';

  @override
  String get savingError => 'Ошибка сохранения';
}
