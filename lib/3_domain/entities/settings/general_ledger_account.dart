import 'package:json_annotation/json_annotation.dart';

part 'general_ledger_account.g.dart';

enum GeneralLedgerAccountType { gLAccount, debtor, creditor }

@JsonSerializable(explicitToJson: true)
class GeneralLedgerAccount {
  final String id;
  final int accountClass;
  final int accountGroup;
  final int accountSubGroup;
  final int individualAccount;
  final int generalLedgerAccount; //* Besteht aus den oberen 4
  final String name;
  final bool isActive;
  final bool isVisible;
  final GeneralLedgerAccountType type;

  const GeneralLedgerAccount({
    required this.id,
    required this.accountClass,
    required this.accountGroup,
    required this.accountSubGroup,
    required this.individualAccount,
    required this.generalLedgerAccount,
    required this.name,
    required this.isActive,
    required this.isVisible,
    required this.type,
  });

  factory GeneralLedgerAccount.fromJson(Map<String, dynamic> json) => _$GeneralLedgerAccountFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralLedgerAccountToJson(this);

  factory GeneralLedgerAccount.empty() {
    return const GeneralLedgerAccount(
      id: '',
      accountClass: 0,
      accountGroup: 0,
      accountSubGroup: 0,
      individualAccount: 0,
      generalLedgerAccount: 0,
      name: '',
      isActive: true,
      isVisible: true,
      type: GeneralLedgerAccountType.gLAccount,
    );
  }

  GeneralLedgerAccount copyWith({
    String? id,
    int? accountClass,
    int? accountGroup,
    int? accountSubGroup,
    int? individualAccount,
    int? generalLedgerAccount,
    String? name,
    bool? isActive,
    bool? isVisible,
    GeneralLedgerAccountType? type,
  }) {
    return GeneralLedgerAccount(
      id: id ?? this.id,
      accountClass: accountClass ?? this.accountClass,
      accountGroup: accountGroup ?? this.accountGroup,
      accountSubGroup: accountSubGroup ?? this.accountSubGroup,
      individualAccount: individualAccount ?? this.individualAccount,
      generalLedgerAccount: generalLedgerAccount ?? this.generalLedgerAccount,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      isVisible: isVisible ?? this.isVisible,
      type: type ?? this.type,
    );
  }

  @override
  String toString() {
    return 'GeneralLedgerAccount(id: $id, accountClass: $accountClass, accountGroup: $accountGroup, accountSubGroup: $accountSubGroup, individualAccount: $individualAccount, generalLedgerAccount: $generalLedgerAccount, name: $name, isActive: $isActive, isVisible: $isVisible, type: $type)';
  }
}
