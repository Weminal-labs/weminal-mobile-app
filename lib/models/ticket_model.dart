import 'dart:convert';

Ticket ticketFromJson(String str) => Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  int total;
  int price;
  bool isSoldOut;
  int spotsRemaining;
  bool isNearCapacity;
  String ticketCurrency;

  Ticket({
    required this.total,
    required this.price,
    required this.isSoldOut,
    required this.spotsRemaining,
    required this.isNearCapacity,
    required this.ticketCurrency,
  });

  Ticket copyWith({
    int? total,
    int? price,
    bool? isSoldOut,
    int? spotsRemaining,
    bool? isNearCapacity,
    String? ticketCurrency,
  }) =>
      Ticket(
        total: total ?? this.total,
        price: price ?? this.price,
        isSoldOut: isSoldOut ?? this.isSoldOut,
        spotsRemaining: spotsRemaining ?? this.spotsRemaining,
        isNearCapacity: isNearCapacity ?? this.isNearCapacity,
        ticketCurrency: ticketCurrency ?? this.ticketCurrency,
      );

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        total: json["total"],
        price: json["price"],
        isSoldOut: json["is_sold_out"],
        spotsRemaining: json["spots_remaining"],
        isNearCapacity: json["is_near_capacity"],
        ticketCurrency: json["ticket_currency"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "price": price,
        "is_sold_out": isSoldOut,
        "spots_remaining": spotsRemaining,
        "is_near_capacity": isNearCapacity,
        "ticket_currency": ticketCurrency,
      };
}
