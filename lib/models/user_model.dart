import 'package:get/get.dart';

class UserModel extends GetxController {
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? image;
  final int? dataUse;
  final int? timeDuration;
  final int? bandwidth;
  final int? status;
  final int? refferCode;
  final int? subscription;
  final int? lastSubscriptionId;
  final String? userCreated;
  final String? orderId;
  final String? paymentId;
  final String? paymentMethod;
  final String? subscriptionCreated;
  final String? expireDate;
  final String? currentSubscriptionPlan;
  final String? currentSubscriptionPrice;
  final bool? isSubscribed;

  UserModel({
    required this.id,
    this.email,
    this.name,
    this.phone,
    this.dataUse,
    this.timeDuration,
    this.bandwidth,
    this.status,
    this.refferCode,
    this.image,
    this.subscription,
    this.lastSubscriptionId,
    this.expireDate,
    this.subscriptionCreated,
    this.currentSubscriptionPlan,
    this.currentSubscriptionPrice,
    this.userCreated,
    this.isSubscribed,
    this.orderId,
    this.paymentId,
    this.paymentMethod,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    int? parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null || value == "") return defaultValue;
      return int.tryParse(value.toString()) ?? defaultValue;
    }

    return UserModel(
      id: data['id'].toString(),
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      image: data['image'],
      dataUse: parseInt(data['data_use'], 0),
      timeDuration: parseInt(data['time_duration'], 0),
      bandwidth: parseInt(data['bandwidth'], 10),
      status: parseInt(data['status'], 1),
      refferCode: parseInt(data['reffer_code']),
      subscription: parseInt(data['subscription']),
      lastSubscriptionId: parseInt(data['last_subscription_id']),
      expireDate: data['expireDate'] ?? "",
      subscriptionCreated: data['subscription_created'],
      currentSubscriptionPlan: data['title'],
      currentSubscriptionPrice: data['discount_price']?.toString(),
      userCreated: data['user_created'],
      isSubscribed: data['isSubscribed'],
      orderId: data['order_id'],
      paymentId: data['payment_id'],
      paymentMethod: data['payment_method'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image;
    data['data_use'] = dataUse;
    data['time_duration'] = timeDuration;
    data['bandwidth'] = bandwidth;
    data['reffer_code'] = refferCode;
    data['status'] = status;
    data['subscription'] = subscription;
    data['last_subscription_id'] = lastSubscriptionId;
    data['expireDate'] = expireDate;
    data['subscription_created'] = subscriptionCreated;
    data['title'] = currentSubscriptionPlan;
    data['discount_price'] = currentSubscriptionPrice;
    data['user_created'] = userCreated;
    data['isSubscribed'] = isSubscribed;
    data['order_id'] = orderId;
    data['payment_id'] = paymentId;
    data['payment_method'] = paymentMethod;

    return data;
  }
}
