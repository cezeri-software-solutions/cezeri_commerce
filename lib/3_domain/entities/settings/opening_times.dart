import 'package:json_annotation/json_annotation.dart';

part 'opening_times.g.dart';

@JsonSerializable()
class OpeningTimes {
  bool isActive;
  bool isOpenOnMonday;
  DateTime startMonday;
  DateTime endMonday;
  bool isOpenOnTuesday;
  DateTime startTuesday;
  DateTime endTuesday;
  bool isOpenOnWednesday;
  DateTime startWednesday;
  DateTime endWednesday;
  bool isOpenOnThursday;
  DateTime startThursday;
  DateTime endThursday;
  bool isOpenOnFriday;
  DateTime startFriday;
  DateTime endFriday;
  bool isOpenOnSaturday;
  DateTime startSaturday;
  DateTime endSaturday;
  bool isOpenOnSunday;
  DateTime startSunday;
  DateTime endSunday;
  String comment;

  OpeningTimes(
    this.isActive,
    this.isOpenOnMonday,
    this.startMonday,
    this.endMonday,
    this.isOpenOnTuesday,
    this.startTuesday,
    this.endTuesday,
    this.isOpenOnWednesday,
    this.startWednesday,
    this.endWednesday,
    this.isOpenOnThursday,
    this.startThursday,
    this.endThursday,
    this.isOpenOnFriday,
    this.startFriday,
    this.endFriday,
    this.isOpenOnSaturday,
    this.startSaturday,
    this.endSaturday,
    this.isOpenOnSunday,
    this.startSunday,
    this.endSunday,
    this.comment,
  );

  factory OpeningTimes.fromJson(Map<String, dynamic> json) =>
      _$OpeningTimesFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningTimesToJson(this);

  factory OpeningTimes.empty() {
    return OpeningTimes(
      false,
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      false,
      DateTime(0),
      DateTime(0),
      '',
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
      isActive ?? this.isActive,
      isOpenOnMonday ?? this.isOpenOnMonday,
      startMonday ?? this.startMonday,
      endMonday ?? this.endMonday,
      isOpenOnTuesday ?? this.isOpenOnTuesday,
      startTuesday ?? this.startTuesday,
      endTuesday ?? this.endTuesday,
      isOpenOnWednesday ?? this.isOpenOnWednesday,
      startWednesday ?? this.startWednesday,
      endWednesday ?? this.endWednesday,
      isOpenOnThursday ?? this.isOpenOnThursday,
      startThursday ?? this.startThursday,
      endThursday ?? this.endThursday,
      isOpenOnFriday ?? this.isOpenOnFriday,
      startFriday ?? this.startFriday,
      endFriday ?? this.endFriday,
      isOpenOnSaturday ?? this.isOpenOnSaturday,
      startSaturday ?? this.startSaturday,
      endSaturday ?? this.endSaturday,
      isOpenOnSunday ?? this.isOpenOnSunday,
      startSunday ?? this.startSunday,
      endSunday ?? this.endSunday,
      comment ?? this.comment,
    );
  }
}