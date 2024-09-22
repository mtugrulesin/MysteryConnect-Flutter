import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "user")
  final User user;

  LoginResponse(this.message, this.success, this.user);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
