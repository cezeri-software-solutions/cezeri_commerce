// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'general_ledger_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeneralLedgerAccount _$GeneralLedgerAccountFromJson(
        Map<String, dynamic> json) =>
    GeneralLedgerAccount(
      id: json['id'] as String,
      generalLedgerAccount: json['general_ledger_account'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
      isVisible: json['is_visible'] as bool,
      type: $enumDecode(_$GeneralLedgerAccountTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$GeneralLedgerAccountToJson(
        GeneralLedgerAccount instance) =>
    <String, dynamic>{
      'general_ledger_account': instance.generalLedgerAccount,
      'name': instance.name,
      'is_active': instance.isActive,
      'is_visible': instance.isVisible,
      'type': _$GeneralLedgerAccountTypeEnumMap[instance.type]!,
    };

const _$GeneralLedgerAccountTypeEnumMap = {
  GeneralLedgerAccountType.gLAccount: 'gLAccount',
  GeneralLedgerAccountType.debtor: 'debtor',
  GeneralLedgerAccountType.creditor: 'creditor',
};
