import 'package:json_annotation/json_annotation.dart';

part 'plan.g.dart';

@JsonSerializable()
class Plan {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'price')
  final String price;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'props')
  final List<String> props;

  Plan(
      {required this.name,
      required this.price,
      required this.description,
      required this.props});

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);

  Map<String, dynamic> toJson() => _$PlanToJson(this);
}
