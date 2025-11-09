import 'package:freezed_annotation/freezed_annotation.dart';

part 'people_event.freezed.dart';

@freezed
class PeopleEvent with _$PeopleEvent {
  const factory PeopleEvent.loadPeople({int? page, String? search}) = PeopleEventLoadPeople;
  const factory PeopleEvent.searchPeople(String query) = PeopleEventSearch;
  const factory PeopleEvent.clearSearch() = PeopleEventClearSearch;
}
