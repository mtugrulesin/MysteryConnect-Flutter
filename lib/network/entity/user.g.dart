// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      photoId: json['photoId'] as String,
      age: json['age'] as int,
      userStats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
      country: json['country'] as String,
      diamondCount: json['diamondCount'] as int,
      gender: json['gender'] as String,
      premium: json['premium'] as bool,
      photoList: (json['photoList'] as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'email': instance.email,
      'age': instance.age,
      'photoId': instance.photoId,
      'stats': instance.userStats,
      'country': instance.country,
      'diamondCount': instance.diamondCount,
      'gender': instance.gender,
      'premium': instance.premium,
      'photoList': instance.photoList,
    };
