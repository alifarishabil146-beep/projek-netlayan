enum UserRole { nelayan, pembeli }

enum OrderStatus {
  menungguKonfirmasi,
  diprosesNelayan,
  dalamPengiriman,
  pesananSelesai,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final String city;
  final String address;
  final String? portLocation;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.city,
    required this.address,
    this.portLocation,
  });
}

class FishItem {
  final String id;
  final String fishermanId;
  final String fishermanName;
  final String fishermanCity;
  final String title;
  final String category;
  final double pricePerKg;
  double stockKg;
  final String imageUrl;
  final DateTime catchDate;
  final String portLocation;
  final String description;
  final bool isFresh;
  final int freshnessScore; // Score 1-100%

  FishItem({
    required this.id,
    required this.fishermanId,
    required this.fishermanName,
    required this.fishermanCity,
    required this.title,
    required this.category,
    required this.pricePerKg,
    required this.stockKg,
    required this.imageUrl,
    required this.catchDate,
    required this.portLocation,
    required this.description,
    this.isFresh = true,
    this.freshnessScore = 98,
  });

  String get catchHoursAgo {
    final diff = DateTime.now().difference(catchDate).inHours;
    if (diff <= 0) return 'Baru Saja Ditangkap Subuh Ini';
    return '$diff Jam yang Lalu';
  }
}

class CartItem {
  final FishItem fish;
  double quantityKg;

  CartItem({
    required this.fish,
    required this.quantityKg,
  });

  double get totalPrice => fish.pricePerKg * quantityKg;
}

class OrderModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String buyerPhone;
  final String buyerCity;
  final String deliveryAddress;
  final List<CartItem> items;
  final double itemsTotalPrice;
  final double shippingFee;
  final String courierName;
  final String paymentMethod;
  final String qrisCode;
  OrderStatus status;
  final DateTime orderDate;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.buyerPhone,
    required this.buyerCity,
    required this.deliveryAddress,
    required this.items,
    required this.itemsTotalPrice,
    required this.shippingFee,
    required this.courierName,
    required this.paymentMethod,
    required this.qrisCode,
    this.status = OrderStatus.menungguKonfirmasi,
    required this.orderDate,
  });

  double get grandTotal => itemsTotalPrice + shippingFee;

  String get statusText {
    switch (status) {
      case OrderStatus.menungguKonfirmasi:
        return 'Menunggu Konfirmasi Nelayan';
      case OrderStatus.diprosesNelayan:
        return 'Ikan Diproses & Dikemas';
      case OrderStatus.dalamPengiriman:
        return 'Dalam Pengiriman Antar-Kota';
      case OrderStatus.pesananSelesai:
        return 'Pesanan Selesai';
    }
  }
}

class WeatherForecast {
  final String day;
  final String condition;
  final double tempC;
  final double waveHeightM;
  final double windSpeedKmh;

  WeatherForecast({
    required this.day,
    required this.condition,
    required this.tempC,
    required this.waveHeightM,
    required this.windSpeedKmh,
  });
}

class RecipeModel {
  final String id;
  final String title;
  final String targetFishName;
  final String fishCategory;
  final String cookingTime;
  final String difficulty;
  final String imageUrl;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String smartTip;

  RecipeModel({
    required this.id,
    required this.title,
    required this.targetFishName,
    required this.fishCategory,
    required this.cookingTime,
    required this.difficulty,
    required this.imageUrl,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.smartTip,
  });
}
