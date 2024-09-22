import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'authentication_response.g.dart';

@JsonSerializable()
class AuthenticationResponse {
  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "user")
  final User? user;

  AuthenticationResponse(this.message, this.success, this.user);

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenticationResponseToJson(this);
}
