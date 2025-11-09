import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';

part 'people_state.freezed.dart';

@freezed
class PeopleState with _$PeopleState {
  const factory PeopleState.initial() = _Initial;
  const factory PeopleState.loading() = _Loading;
  const factory PeopleState.loaded(PeopleEntity people) = _Loaded;
  const factory PeopleState.error(String message) = _Error;
}

