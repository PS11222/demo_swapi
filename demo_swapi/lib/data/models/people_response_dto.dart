import 'package:json_annotation/json_annotation.dart';
import 'person_dto.dart';

part 'people_response_dto.g.dart';

@JsonSerializable()
class PeopleResponseDto {
  const PeopleResponseDto({required this.count, required this.next, required this.previous, required this.results});

  final int count;
  final String? next;
  final String? previous;
  final List<PersonDto> results;

  factory PeopleResponseDto.fromJson(Map<String, dynamic> json) => _$PeopleResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PeopleResponseDtoToJson(this);
}
