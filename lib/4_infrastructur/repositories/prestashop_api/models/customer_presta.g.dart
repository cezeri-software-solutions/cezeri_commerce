// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomersPresta _$CustomersPrestaFromJson(Map<String, dynamic> json) =>
    CustomersPresta(
      items: (json['customers'] as List<dynamic>)
          .map((e) => CustomerPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomersPrestaToJson(CustomersPresta instance) =>
    <String, dynamic>{
      'customers': instance.items,
    };

CustomerPresta _$CustomerPrestaFromJson(Map<String, dynamic> json) =>
    CustomerPresta(
      id: (json['id'] as num).toInt(),
      idDefaultGroup: json['id_default_group'] as String,
      idLang: json['id_lang'] as String,
      newsletterDateAdd: json['newsletter_date_add'] as String,
      ipRegistrationNewsletter: json['ip_registration_newsletter'] as String?,
      lastPasswdGen: json['last_passwd_gen'] as String,
      secureKey: json['secure_key'] as String,
      deleted: json['deleted'] as String,
      passwd: json['passwd'] as String,
      lastname: json['lastname'] as String,
      firstname: json['firstname'] as String,
      email: json['email'] as String,
      idGender: json['id_gender'] as String,
      birthday: json['birthday'] as String,
      newsletter: json['newsletter'] as String,
      optin: json['optin'] as String,
      website: json['website'] as String?,
      company: json['company'] as String?,
      siret: json['siret'] as String?,
      ape: json['ape'] as String?,
      outstandingAllowAmount: json['outstanding_allow_amount'] as String,
      showPublicPrices: json['show_public_prices'] as String,
      idRisk: json['id_risk'] as String,
      maxPaymentDays: json['max_payment_days'] as String,
      active: json['active'] as String,
      note: json['note'] as String?,
      isGuest: json['is_guest'] as String,
      idShop: json['id_shop'] as String,
      idShopGroup: json['id_shop_group'] as String,
      dateAdd: json['date_add'] as String,
      dateUpd: json['date_upd'] as String,
      resetPasswordToken: json['reset_password_token'] as String?,
      resetPasswordValidity: json['reset_password_validity'] as String,
      associations: AssociationsCustomer.fromJson(
          json['associations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CustomerPrestaToJson(CustomerPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_default_group': instance.idDefaultGroup,
      'id_lang': instance.idLang,
      'newsletter_date_add': instance.newsletterDateAdd,
      'ip_registration_newsletter': instance.ipRegistrationNewsletter,
      'last_passwd_gen': instance.lastPasswdGen,
      'secure_key': instance.secureKey,
      'deleted': instance.deleted,
      'passwd': instance.passwd,
      'lastname': instance.lastname,
      'firstname': instance.firstname,
      'email': instance.email,
      'id_gender': instance.idGender,
      'birthday': instance.birthday,
      'newsletter': instance.newsletter,
      'optin': instance.optin,
      'website': instance.website,
      'company': instance.company,
      'siret': instance.siret,
      'ape': instance.ape,
      'outstanding_allow_amount': instance.outstandingAllowAmount,
      'show_public_prices': instance.showPublicPrices,
      'id_risk': instance.idRisk,
      'max_payment_days': instance.maxPaymentDays,
      'active': instance.active,
      'note': instance.note,
      'is_guest': instance.isGuest,
      'id_shop': instance.idShop,
      'id_shop_group': instance.idShopGroup,
      'date_add': instance.dateAdd,
      'date_upd': instance.dateUpd,
      'reset_password_token': instance.resetPasswordToken,
      'reset_password_validity': instance.resetPasswordValidity,
      'associations': instance.associations,
    };

AssociationsCustomer _$AssociationsCustomerFromJson(
        Map<String, dynamic> json) =>
    AssociationsCustomer(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => GroupId.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssociationsCustomerToJson(
        AssociationsCustomer instance) =>
    <String, dynamic>{
      'groups': instance.groups,
    };

GroupId _$GroupIdFromJson(Map<String, dynamic> json) => GroupId(
      id: json['id'] as String,
    );

Map<String, dynamic> _$GroupIdToJson(GroupId instance) => <String, dynamic>{
      'id': instance.id,
    };
