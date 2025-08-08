import '../helpers/config.dart';

class SettingsModel {
  final String name;
  final String url;
  final String? phone;
  final String? share;
  final String? email;
  final String? facebook;
  final String? instagram;
  final String? twitter;
  final String? whatsapp;
  final String? linkedIn;
  final String? telegram;
  final String? logo;
  final String? privacyPolicy;
  final String? termsCondition;
  final String? androidRewardId;
  final String? appleRewardId;
  final String? androidOpenId;
  final String? appleOpenId;
  final String? androidNativeId;
  final String? appleNativeId;
  final String? androidInterstitialId;
  final String? appleInterstitialId;
  final String? androidBannerId;
  final String? appleBannerId;
  final String? admobId;
  final String? androidRevenuecatId;
  final String? appleRevenuecatId;
  final int? freeTime;
  final int? rechargeTime;
  final int? notificationTime;
  final String? createdAt;
  final String? updatedAt;

  SettingsModel({
    required this.name,
    required this.url,
    this.phone,
    this.share,
    this.email,
    this.facebook,
    this.instagram,
    this.twitter,
    this.whatsapp,
    this.linkedIn,
    this.logo,
    this.telegram,
    this.privacyPolicy,
    this.termsCondition,
    this.admobId,
    this.androidRewardId,
    this.appleRewardId,
    this.androidOpenId,
    this.appleOpenId,
    this.androidNativeId,
    this.appleNativeId,
    this.androidInterstitialId,
    this.appleInterstitialId,
    this.androidBannerId,
    this.appleBannerId,
    this.androidRevenuecatId,
    this.appleRevenuecatId,
    this.freeTime,
    this.rechargeTime,
    this.notificationTime,
    this.createdAt,
    this.updatedAt,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      name: json["name"] ?? "",
      url: json["url"] ?? "",
      phone: json["phone1"] ?? "",
      share: json["share"] ?? "",
      email: json["email1"] ?? "",
      facebook: json["facebook"] ?? "",
      instagram: json["instagram"] ?? "",
      twitter: json["twitter"] ?? "",
      whatsapp: json["whatsapp"] ?? "",
      linkedIn: json["linkedin"] ?? "",
      logo: json["logo"] ?? "",
      telegram: json["telegram"] ?? "",
      privacyPolicy: json["privacy_policy"] ?? Config.privacyPolicy,
      termsCondition: json["terms_condition"] ?? Config.termsCondition,
      admobId: json["admob_id"] ?? "",
      androidRewardId: json["android_reward_id"] ?? "",
      appleRewardId: json["apple_reward_id"] ?? "",
      androidOpenId: json["android_open_unit_id"] ?? "",
      appleOpenId: json["ios_open_unit_id"] ?? "",
      androidNativeId: json["android_native_unit_id"] ?? "",
      appleNativeId: json["ios_native_unit_id"] ?? "",
      androidInterstitialId: json["android_interstitial_unit_id"] ?? "",
      appleInterstitialId: json["ios_interstitial_unit_id"] ?? "",
      androidBannerId: json["android_banner_unit_id"] ?? "",
      appleBannerId: json["ios_banner_unit_id"] ?? "",
      androidRevenuecatId: json["android_revenuecat_unit_id"] ?? "",
      appleRevenuecatId: json["ios_revenuecat_unit_id"] ?? "",
      freeTime: json["free_time"] ?? 0,
      rechargeTime: json["recharge_time"] ?? 0,
      notificationTime: json["notification_time"] ?? 0,
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data["name"] = name;
    data["url"] = url;
    data['share'] = share;
    data["phone1"] = phone;
    data["email1"] = email;
    data["facebook"] = facebook;
    data["instagram"] = instagram;
    data["twitter"] = twitter;
    data["whatsapp"] = whatsapp;
    data["linked_in"] = linkedIn;
    data["logo"] = logo;
    data["telegram"] = telegram;
    data["terms_condition"] = termsCondition;
    data["privacy_policy"] = privacyPolicy;
    data["admob_id"] = admobId;
    data["android_reward_id"] = androidRewardId;
    data["apple_reward_id"] = appleRewardId;
    data["android_open_unit_id"] = androidOpenId;
    data["ios_open_unit_id"] = appleOpenId;
    data["android_native_unit_id"] = androidNativeId;
    data["ios_native_unit_id"] = appleNativeId;
    data["android_interstitial_unit_id"] = androidInterstitialId;
    data["ios_interstitial_unit_id"] = appleInterstitialId;
    data["android_banner_unit_id"] = androidBannerId;
    data["ios_banner_unit_id"] = appleBannerId;
    data["android_revenuecat_unit_id"] = androidRevenuecatId;
    data["ios_revenuecat_unit_id"] = appleRevenuecatId;
    data["free_time"] = freeTime;
    data["recharge_time"] = rechargeTime;
    data["notification_time"] = notificationTime;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;

    return data;
  }
}
