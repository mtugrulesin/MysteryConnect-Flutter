import 'package:json_annotation/json_annotation.dart';

import '../entity/user.dart';

part 'list_of_random_users_response.g.dart';

@JsonSerializable()
class ListOfRandomUsersResponse {
  @JsonKey(name: "message")
  final String message;

  @JsonKey(name: "success")
  final bool success;

  @JsonKey(name: "users")
  final List<User> users;

  ListOfRandomUsersResponse(this.message, this.success, this.users);

  factory ListOfRandomUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$ListOfRandomUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListOfRandomUsersResponseToJson(this);
}
