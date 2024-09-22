import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'senderId')
  final String senderId;

  @JsonKey(name: 'receiverId')
  final String receiverId;

  @JsonKey(name: 'photoUrl')
  final String photoUrl;

  @JsonKey(name: 'type')
  final String type;

  Photo({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.photoUrl,
    required this.type,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
