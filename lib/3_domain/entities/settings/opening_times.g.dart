// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opening_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpeningTimes _$OpeningTimesFromJson(Map<String, dynamic> json) => OpeningTimes(
      isActive: json['isActive'] as bool,
      isOpenOnMonday: json['isOpenOnMonday'] as bool,
      startMonday: DateTime.parse(json['startMonday'] as String),
      endMonday: DateTime.parse(json['endMonday'] as String),
      isOpenOnTuesday: json['isOpenOnTuesday'] as bool,
      startTuesday: DateTime.parse(json['startTuesday'] as String),
      endTuesday: DateTime.parse(json['endTuesday'] as String),
      isOpenOnWednesday: json['isOpenOnWednesday'] as bool,
      startWednesday: DateTime.parse(json['startWednesday'] as String),
      endWednesday: DateTime.parse(json['endWednesday'] as String),
      isOpenOnThursday: json['isOpenOnThursday'] as bool,
      startThursday: DateTime.parse(json['startThursday'] as String),
      endThursday: DateTime.parse(json['endThursday'] as String),
      isOpenOnFriday: json['isOpenOnFriday'] as bool,
      startFriday: DateTime.parse(json['startFriday'] as String),
      endFriday: DateTime.parse(json['endFriday'] as String),
      isOpenOnSaturday: json['isOpenOnSaturday'] as bool,
      startSaturday: DateTime.parse(json['startSaturday'] as String),
      endSaturday: DateTime.parse(json['endSaturday'] as String),
      isOpenOnSunday: json['isOpenOnSunday'] as bool,
      startSunday: DateTime.parse(json['startSunday'] as String),
      endSunday: DateTime.parse(json['endSunday'] as String),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$OpeningTimesToJson(OpeningTimes instance) =>
    <String, dynamic>{
      'isActive': instance.isActive,
      'isOpenOnMonday': instance.isOpenOnMonday,
      'startMonday': instance.startMonday.toIso8601String(),
      'endMonday': instance.endMonday.toIso8601String(),
      'isOpenOnTuesday': instance.isOpenOnTuesday,
      'startTuesday': instance.startTuesday.toIso8601String(),
      'endTuesday': instance.endTuesday.toIso8601String(),
      'isOpenOnWednesday': instance.isOpenOnWednesday,
      'startWednesday': instance.startWednesday.toIso8601String(),
      'endWednesday': instance.endWednesday.toIso8601String(),
      'isOpenOnThursday': instance.isOpenOnThursday,
      'startThursday': instance.startThursday.toIso8601String(),
      'endThursday': instance.endThursday.toIso8601String(),
      'isOpenOnFriday': instance.isOpenOnFriday,
      'startFriday': instance.startFriday.toIso8601String(),
      'endFriday': instance.endFriday.toIso8601String(),
      'isOpenOnSaturday': instance.isOpenOnSaturday,
      'startSaturday': instance.startSaturday.toIso8601String(),
      'endSaturday': instance.endSaturday.toIso8601String(),
      'isOpenOnSunday': instance.isOpenOnSunday,
      'startSunday': instance.startSunday.toIso8601String(),
      'endSunday': instance.endSunday.toIso8601String(),
      'comment': instance.comment,
    };
