enum InstrumentCategory { string, wind, percussion, keyboard, electronic }

class Instrument {
  final String id;
  final String name;
  final String brand;
  final double price;
  final InstrumentCategory category;
  final String description;
  int stockQuantity;
  final String imageUrl;
  final double? rentalDailyRate;
  final bool isAvailableForRent;
  String? color;

  Instrument({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.category,
    required this.description,
    required this.stockQuantity,
    required this.imageUrl,
    this.rentalDailyRate,
    this.isAvailableForRent = false,
    this.color,
  });

  Instrument copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    InstrumentCategory? category,
    String? description,
    int? stockQuantity,
    String? imageUrl,
    double? rentalDailyRate,
    bool? isAvailableForRent,
    String? color,
  }) {
    return Instrument(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      rentalDailyRate: rentalDailyRate ?? this.rentalDailyRate,
      isAvailableForRent: isAvailableForRent ?? this.isAvailableForRent,
      color: color ?? this.color,
    );
  }

  void setColor(String selectedColor) {
    color = selectedColor;
  }
}
