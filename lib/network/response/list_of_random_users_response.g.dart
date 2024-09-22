// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_of_random_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListOfRandomUsersResponse _$ListOfRandomUsersResponseFromJson(
        Map<String, dynamic> json) =>
    ListOfRandomUsersResponse(
      json['message'] as String,
      json['success'] as bool,
      (json['users'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListOfRandomUsersResponseToJson(
        ListOfRandomUsersResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'success': instance.success,
      'users': instance.users,
    };
