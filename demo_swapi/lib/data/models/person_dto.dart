import 'package:json_annotation/json_annotation.dart';

part 'person_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PersonDto {
  const PersonDto({
    required this.name,
    required this.height,
    required this.mass,
    required this.hairColor,
    required this.skinColor,
    required this.eyeColor,
    required this.birthYear,
    required this.gender,
    required this.homeworld,
    required this.films,
    required this.species,
    required this.vehicles,
    required this.starships,
    required this.created,
    required this.edited,
    required this.url,
  });

  final String name;
  final String height;
  final String mass;
  final String hairColor;
  final String skinColor;
  final String eyeColor;
  final String birthYear;
  final String gender;
  final String homeworld;
  final List<String> films;
  final List<String> species;
  final List<String> vehicles;
  final List<String> starships;
  final String created;
  final String edited;
  final String url;

  factory PersonDto.fromJson(Map<String, dynamic> json) => _$PersonDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonDtoToJson(this);
}
