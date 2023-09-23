// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'opening_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpeningTimes _$OpeningTimesFromJson(Map<String, dynamic> json) => OpeningTimes(
      json['isActive'] as bool,
      json['isOpenOnMonday'] as bool,
      DateTime.parse(json['startMonday'] as String),
      DateTime.parse(json['endMonday'] as String),
      json['isOpenOnTuesday'] as bool,
      DateTime.parse(json['startTuesday'] as String),
      DateTime.parse(json['endTuesday'] as String),
      json['isOpenOnWednesday'] as bool,
      DateTime.parse(json['startWednesday'] as String),
      DateTime.parse(json['endWednesday'] as String),
      json['isOpenOnThursday'] as bool,
      DateTime.parse(json['startThursday'] as String),
      DateTime.parse(json['endThursday'] as String),
      json['isOpenOnFriday'] as bool,
      DateTime.parse(json['startFriday'] as String),
      DateTime.parse(json['endFriday'] as String),
      json['isOpenOnSaturday'] as bool,
      DateTime.parse(json['startSaturday'] as String),
      DateTime.parse(json['endSaturday'] as String),
      json['isOpenOnSunday'] as bool,
      DateTime.parse(json['startSunday'] as String),
      DateTime.parse(json['endSunday'] as String),
      json['comment'] as String,
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
