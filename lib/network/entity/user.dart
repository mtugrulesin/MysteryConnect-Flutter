import 'package:json_annotation/json_annotation.dart';

import 'photo.dart';
import 'user_stats.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'fullName')
  final String fullName;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'age')
  final int age;

  @JsonKey(name: 'photoId')
  final String photoId;

  @JsonKey(name: 'stats')
  final UserStats userStats;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'diamondCount')
  final int diamondCount;

  @JsonKey(name: 'gender')
  final String gender;

  @JsonKey(name: 'premium')
  final bool premium;

  @JsonKey(name: 'photoList')
  final List<Photo> photoList;

  

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.photoId,
    required this.age,
    required this.userStats,
    required this.country,
    required this.diamondCount,
    required this.gender,
    required this.premium,
    required this.photoList,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
