import 'package:json_annotation/json_annotation.dart';

part 'user_stats.g.dart';

@JsonSerializable()
class UserStats {
  @JsonKey(name: 'messageCount')
  final int messageCount;
  @JsonKey(name: 'photoPoints')
  final int photoPoints;

  UserStats({
    required this.messageCount,
    required this.photoPoints,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsToJson(this);
}
