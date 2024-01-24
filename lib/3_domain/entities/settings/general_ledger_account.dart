import 'package:json_annotation/json_annotation.dart';

part 'general_ledger_account.g.dart';

enum GeneralLedgerAccountType { gLAccount, debtor, creditor }

@JsonSerializable(explicitToJson: true)
class GeneralLedgerAccount {
  final String id;
  final String accountClass;
  final String accountGroup;
  final String accountSubGroup;
  final String individualAccount;
  final String generalLedgerAccount; //* Besteht aus den oberen 4
  final String name;
  final bool isActive;
  final bool isVisible;
  final GeneralLedgerAccountType type;

  GeneralLedgerAccount({
    required this.id,
    required this.generalLedgerAccount,
    required this.name,
    required this.isActive,
    required this.isVisible,
    required this.type,
  })  : accountClass = generalLedgerAccount.isNotEmpty ? generalLedgerAccount[0] : '0',
        accountGroup = generalLedgerAccount.length > 1 ? generalLedgerAccount.substring(1, 2) : '0',
        accountSubGroup = generalLedgerAccount.length > 2 ? generalLedgerAccount.substring(2, 3) : '0',
        individualAccount = generalLedgerAccount.length > 3 ? generalLedgerAccount.substring(3, 4) : '0';

  factory GeneralLedgerAccount.fromJson(Map<String, dynamic> json) => _$GeneralLedgerAccountFromJson(json);
  Map<String, dynamic> toJson() => _$GeneralLedgerAccountToJson(this);

  factory GeneralLedgerAccount.empty() {
    return GeneralLedgerAccount(
      id: '',
      generalLedgerAccount: '',
      name: '',
      isActive: true,
      isVisible: true,
      type: GeneralLedgerAccountType.gLAccount,
    );
  }

  GeneralLedgerAccount copyWith({
    String? id,
    String? generalLedgerAccount,
    String? name,
    bool? isActive,
    bool? isVisible,
    GeneralLedgerAccountType? type,
  }) {
    return GeneralLedgerAccount(
      id: id ?? this.id,
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
