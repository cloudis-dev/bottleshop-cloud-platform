class StripeSessionRequest {
  final String userId;
  final String domain;
  final String locale;
  final String? deliveryType;
  final String? orderNote;

  const StripeSessionRequest({
    required this.userId,
    required this.domain,
    required this.locale,
    required this.deliveryType,
    required this.orderNote,
  });

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'userId': userId,
      'domain': domain,
      'locale': locale,
      'deliveryType': deliveryType,
      'orderNote': orderNote,
    } as Map<String, dynamic>;
  }
}
