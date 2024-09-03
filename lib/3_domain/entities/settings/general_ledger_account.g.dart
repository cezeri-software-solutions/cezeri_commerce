// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_ledger_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralLedgerAccount _$GeneralLedgerAccountFromJson(
        Map<String, dynamic> json) =>
    GeneralLedgerAccount(
      id: json['id'] as String,
      generalLedgerAccount: json['generalLedgerAccount'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      isVisible: json['isVisible'] as bool,
      type: $enumDecode(_$GeneralLedgerAccountTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$GeneralLedgerAccountToJson(
        GeneralLedgerAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'generalLedgerAccount': instance.generalLedgerAccount,
      'name': instance.name,
      'isActive': instance.isActive,
      'isVisible': instance.isVisible,
      'type': _$GeneralLedgerAccountTypeEnumMap[instance.type]!,
    };

const _$GeneralLedgerAccountTypeEnumMap = {
  GeneralLedgerAccountType.gLAccount: 'gLAccount',
  GeneralLedgerAccountType.debtor: 'debtor',
  GeneralLedgerAccountType.creditor: 'creditor',
};
