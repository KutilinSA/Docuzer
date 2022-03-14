import 'package:docuzer/core/models/model_wrapper.dart';
import 'package:docuzer/core/types.dart';

class UserModel extends ModelWrapper {
  final String username;
  final String email;
  final bool emailCheck;
  final String? avatar;
  final bool publicActive;
  final String language;

  UserModel.fromJson(DynamicMap json) :
    username = json['username'] as String,
    email = json['email'] as String,
    emailCheck = json['emailCheck'] as bool,
    language = json['language'] as String,
    avatar = json['avatar'] as String?,
    publicActive = json['publicActive'] as bool,
    super.fromJson(json);

  @override
  DynamicMap toJson() => <String, dynamic>{
    ...super.toJson(),
    'username' : username,
    'email' : email,
    'emailCheck' : emailCheck,
    'avatar' : avatar,
  };
}
