import 'package:json_annotation/json_annotation.dart';

part 'opening_times.g.dart';

@JsonSerializable()
class OpeningTimes {
  // @JsonKey(name: 'is_active')
  final bool isActive;
  // @JsonKey(name: 'is_open_on_monday')
  final bool isOpenOnMonday;
  // @JsonKey(name: 'start_monday')
  final DateTime startMonday;
  // @JsonKey(name: 'end_monday')
  final DateTime endMonday;
  // @JsonKey(name: 'is_open_on_tuesday')
  final bool isOpenOnTuesday;
  // @JsonKey(name: 'start_tuesday')
  final DateTime startTuesday;
  // @JsonKey(name: 'end_tuesday')
  final DateTime endTuesday;
  // @JsonKey(name: 'is_open_on_wednesday')
  final bool isOpenOnWednesday;
  // @JsonKey(name: 'start_wednesday')
  final DateTime startWednesday;
  // @JsonKey(name: 'end_wednesday')
  final DateTime endWednesday;
  // @JsonKey(name: 'is_open_on_thursday')
  final bool isOpenOnThursday;
  // @JsonKey(name: 'start_thursday')
  final DateTime startThursday;
  // @JsonKey(name: 'end_thursday')
  final DateTime endThursday;
  // @JsonKey(name: 'is_open_on_friday')
  final bool isOpenOnFriday;
  // @JsonKey(name: 'start_friday')
  final DateTime startFriday;
  // @JsonKey(name: 'end_friday')
  final DateTime endFriday;
  // @JsonKey(name: 'is_open_on_saturday')
  final bool isOpenOnSaturday;
  // @JsonKey(name: 'start_saturday')
  final DateTime startSaturday;
  // @JsonKey(name: 'end_saturday')
  final DateTime endSaturday;
  // @JsonKey(name: 'is_open_on_sunday')
  final bool isOpenOnSunday;
  // @JsonKey(name: 'start_sunday')
  final DateTime startSunday;
  // @JsonKey(name: 'end_sunday')
  final DateTime endSunday;
  final String comment;

  const OpeningTimes({
    required this.isActive,
    required this.isOpenOnMonday,
    required this.startMonday,
    required this.endMonday,
    required this.isOpenOnTuesday,
    required this.startTuesday,
    required this.endTuesday,
    required this.isOpenOnWednesday,
    required this.startWednesday,
    required this.endWednesday,
    required this.isOpenOnThursday,
    required this.startThursday,
    required this.endThursday,
    required this.isOpenOnFriday,
    required this.startFriday,
    required this.endFriday,
    required this.isOpenOnSaturday,
    required this.startSaturday,
    required this.endSaturday,
    required this.isOpenOnSunday,
    required this.startSunday,
    required this.endSunday,
    required this.comment,
  });

  factory OpeningTimes.fromJson(Map<String, dynamic> json) => _$OpeningTimesFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningTimesToJson(this);

  factory OpeningTimes.empty() {
    return OpeningTimes(
      isActive: false,
      isOpenOnMonday: false,
      startMonday: DateTime(0),
      endMonday: DateTime(0),
      isOpenOnTuesday: false,
      startTuesday: DateTime(0),
      endTuesday: DateTime(0),
      isOpenOnWednesday: false,
      startWednesday: DateTime(0),
      endWednesday: DateTime(0),
      isOpenOnThursday: false,
      startThursday: DateTime(0),
      endThursday: DateTime(0),
      isOpenOnFriday: false,
      startFriday: DateTime(0),
      endFriday: DateTime(0),
      isOpenOnSaturday: false,
      startSaturday: DateTime(0),
      endSaturday: DateTime(0),
      isOpenOnSunday: false,
      startSunday: DateTime(0),
      endSunday: DateTime(0),
      comment: '',
    );
  }

  OpeningTimes copyWith({
    bool? isActive,
    bool? isOpenOnMonday,
    DateTime? startMonday,
    DateTime? endMonday,
    bool? isOpenOnTuesday,
    DateTime? startTuesday,
    DateTime? endTuesday,
    bool? isOpenOnWednesday,
    DateTime? startWednesday,
    DateTime? endWednesday,
    bool? isOpenOnThursday,
    DateTime? startThursday,
    DateTime? endThursday,
    bool? isOpenOnFriday,
    DateTime? startFriday,
    DateTime? endFriday,
    bool? isOpenOnSaturday,
    DateTime? startSaturday,
    DateTime? endSaturday,
    bool? isOpenOnSunday,
    DateTime? startSunday,
    DateTime? endSunday,
    String? comment,
  }) {
    return OpeningTimes(
      isActive: isActive ?? this.isActive,
      isOpenOnMonday: isOpenOnMonday ?? this.isOpenOnMonday,
      startMonday: startMonday ?? this.startMonday,
      endMonday: endMonday ?? this.endMonday,
      isOpenOnTuesday: isOpenOnTuesday ?? this.isOpenOnTuesday,
      startTuesday: startTuesday ?? this.startTuesday,
      endTuesday: endTuesday ?? this.endTuesday,
      isOpenOnWednesday: isOpenOnWednesday ?? this.isOpenOnWednesday,
      startWednesday: startWednesday ?? this.startWednesday,
      endWednesday: endWednesday ?? this.endWednesday,
      isOpenOnThursday: isOpenOnThursday ?? this.isOpenOnThursday,
      startThursday: startThursday ?? this.startThursday,
      endThursday: endThursday ?? this.endThursday,
      isOpenOnFriday: isOpenOnFriday ?? this.isOpenOnFriday,
      startFriday: startFriday ?? this.startFriday,
      endFriday: endFriday ?? this.endFriday,
      isOpenOnSaturday: isOpenOnSaturday ?? this.isOpenOnSaturday,
      startSaturday: startSaturday ?? this.startSaturday,
      endSaturday: endSaturday ?? this.endSaturday,
      isOpenOnSunday: isOpenOnSunday ?? this.isOpenOnSunday,
      startSunday: startSunday ?? this.startSunday,
      endSunday: endSunday ?? this.endSunday,
      comment: comment ?? this.comment,
    );
  }

  @override
  String toString() {
    return 'OpeningTimes(isActive: $isActive, isOpenOnMonday: $isOpenOnMonday, startMonday: $startMonday, endMonday: $endMonday, isOpenOnTuesday: $isOpenOnTuesday, startTuesday: $startTuesday, endTuesday: $endTuesday, isOpenOnWednesday: $isOpenOnWednesday, startWednesday: $startWednesday, endWednesday: $endWednesday, isOpenOnThursday: $isOpenOnThursday, startThursday: $startThursday, endThursday: $endThursday, isOpenOnFriday: $isOpenOnFriday, startFriday: $startFriday, endFriday: $endFriday, isOpenOnSaturday: $isOpenOnSaturday, startSaturday: $startSaturday, endSaturday: $endSaturday, isOpenOnSunday: $isOpenOnSunday, startSunday: $startSunday, endSunday: $endSunday, comment: $comment)';
  }
}
