import 'package:json_annotation/json_annotation.dart';

part 'lakon.g.dart';

const Map<String, String> lakonCategories = {
  'desain': 'Desain',
  'musik': 'Musik',
  'seni': 'Seni',
  'tulisan': 'Tulisan',
  'dapur': 'Dapur',
  'coding': 'Coding',
};

@JsonSerializable(fieldRename: FieldRename.snake)
class Lakon {
  const Lakon({
    required this.title,
    required this.category,
    this.photo = '',
    this.id,
    this.categoryDisplay = '',
    this.starCount = 0,
    this.isStarred = false,
    this.starredByNames = '',
  });

  factory Lakon.fromJson(Map<String, dynamic> json) => _$LakonFromJson(json);

  @JsonKey(includeToJson: false)
  final String? id;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;

  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;

  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  @JsonKey(includeToJson: false, defaultValue: '')
  final String starredByNames;

  final String title;
  final String category;

  @JsonKey(defaultValue: '')
  final String photo;

  Map<String, dynamic> toJson() => _$LakonToJson(this);
}
