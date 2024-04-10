import 'dart:convert';

Ticket ticketFromJson(String str) => Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  TicketClass ticket;

  Ticket({
    required this.ticket,
  });

  Ticket copyWith({
    TicketClass? ticket,
  }) =>
      Ticket(
        ticket: ticket ?? this.ticket,
      );

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        ticket: TicketClass.fromJson(json["ticket"]),
      );

  Map<String, dynamic> toJson() => {
        "ticket": ticket.toJson(),
      };
}

class TicketClass {
  dynamic price;
  bool isSoldOut;
  dynamic spotsRemaining;
  bool isNearCapacity;
  String ticketCurrency;

  TicketClass({
    required this.price,
    required this.isSoldOut,
    required this.spotsRemaining,
    required this.isNearCapacity,
    required this.ticketCurrency,
  });

  TicketClass copyWith({
    dynamic price,
    bool? isSoldOut,
    dynamic spotsRemaining,
    bool? isNearCapacity,
    String? ticketCurrency,
  }) =>
      TicketClass(
        price: price ?? this.price,
        isSoldOut: isSoldOut ?? this.isSoldOut,
        spotsRemaining: spotsRemaining ?? this.spotsRemaining,
        isNearCapacity: isNearCapacity ?? this.isNearCapacity,
        ticketCurrency: ticketCurrency ?? this.ticketCurrency,
      );

  factory TicketClass.fromJson(Map<String, dynamic> json) => TicketClass(
        price: json["price"],
        isSoldOut: json["is_sold_out"],
        spotsRemaining: json["spots_remaining"],
        isNearCapacity: json["is_near_capacity"],
        ticketCurrency: json["ticket_currency"],
      );

  Map<String, dynamic> toJson() => {
        "price": price,
        "is_sold_out": isSoldOut,
        "spots_remaining": spotsRemaining,
        "is_near_capacity": isNearCapacity,
        "ticket_currency": ticketCurrency,
      };
}
