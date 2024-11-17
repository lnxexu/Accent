class Sale {
  final String id;
  final String instrumentId;
  final int quantity;
  final double totalPrice;
  final DateTime dateTime;

  Sale({
    required this.id,
    required this.instrumentId,
    required this.quantity,
    required this.totalPrice,
    required this.dateTime,
  });
}
