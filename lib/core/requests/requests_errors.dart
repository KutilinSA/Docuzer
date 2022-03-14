class RequestsErrors {
  /// Ошибка формата входных данных
  static const String incorrectScheme = '-32000';
  /// Авторизационная пара логин/пароль не найдена
  static const String incorrectCredentials = '-32002';
  /// Ошибка авторизации
  static const String authorizationError = '-32004';
    /// Username занят
  static const String usernameAlreadyUsed = '-32008';
  /// Email занят
  static const String emailAlreadyUsed = '-32009';
  /// Пользователь не авторизован
  static const String notAuthorized = '-32010';
  /// Пользователь не имеет публичной активности
  static const String noPublicActivity = '-32011';

  /// Временный код отсутствует
  static const String noEmailCode = '-32012';
  /// Пользователь с данным логином не найден
  static const String userNotFound = '-32013';

  /// Поле originImage не подлежит обновлению
  static const String forbidOriginUpdate = '-32019';
  /// Поле userProcessedImage не может совпадать с originImage
  static const String equalProcessedOrigin = '-32020';
  /// Поле userProcessedImage не может совпадать с processedImage
  static const String equalOriginProcessed = '-32021';
  /// Поле userProcessedImage нельзя указать при создании
  static const String onCreateProcessed = '-32022';

  /// Нет необходимых привилегий
  static const String noPrivileges = '-32028';
}
 

