enum UserRole { nelayan, pembeli, kementerianPerdagangan, kurirLogistik, petugasTpi }

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
  String qualityGrade;
  String vesselName;
  String fishingZone;
  DateTime unloadingDate;
  bool isVerifiedByTpi;

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
    this.qualityGrade = 'Grade A - Tangkapan Baru (Premium)',
    this.vesselName = 'KM. Netlayan Jaya 01',
    this.fishingZone = 'Zona WPP-572 (Samudera Hindia)',
    DateTime? unloadingDate,
    this.isVerifiedByTpi = true,
  }) : unloadingDate = unloadingDate ?? catchDate;

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

class EpodModel {
  final String orderId;
  final String photoUrl;
  final String receiverName;
  final String signatureText;
  final DateTime deliveryTime;

  EpodModel({
    required this.orderId,
    required this.photoUrl,
    required this.receiverName,
    required this.signatureText,
    required this.deliveryTime,
  });
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
  double coolingBoxTemp;
  EpodModel? epod;

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
    this.coolingBoxTemp = -2.1,
    this.epod,
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

class TradePriceRegulation {
  final String category;
  double maxPricePerKg;
  String regulationNumber;
  DateTime lastUpdated;

  TradePriceRegulation({
    required this.category,
    required this.maxPricePerKg,
    required this.regulationNumber,
    required this.lastUpdated,
  });
}

enum FinancialType { pemasukan, pengeluaran }

class FinancialRecord {
  final String id;
  final String title;
  final double amount;
  final FinancialType type;
  final DateTime date;
  final String category;

  FinancialRecord({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });
}

class ReviewModel {
  final String id;
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String fishermanId;
  final String fishTitle;
  final double freshnessRating; // 1-5
  final double deliveryRating; // 1-5
  final double weightRating; // 1-5
  final double overallRating;
  final String comment;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.buyerName,
    required this.fishermanId,
    required this.fishTitle,
    required this.freshnessRating,
    required this.deliveryRating,
    required this.weightRating,
    required this.overallRating,
    required this.comment,
    required this.date,
  });
}

enum ComplaintStatus { menungguVerifikasi, garansiDisetujui, refundDiproses, selesai }

class ComplaintModel {
  final String id;
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String issueType; // e.g. "Ikan tidak segar / busuk", "Timbangan kurang", "Tidak sesuai deskripsi"
  final String description;
  final String? photoUrl;
  ComplaintStatus status;
  final DateTime claimDate;
  double refundAmount;

  ComplaintModel({
    required this.id,
    required this.orderId,
    required this.buyerId,
    required this.buyerName,
    required this.issueType,
    required this.description,
    this.photoUrl,
    this.status = ComplaintStatus.menungguVerifikasi,
    required this.claimDate,
    required this.refundAmount,
  });

  String get statusText {
    switch (status) {
      case ComplaintStatus.menungguVerifikasi:
        return 'Menunggu Verifikasi Garansi';
      case ComplaintStatus.garansiDisetujui:
        return 'Garansi Kesegaran Disetujui';
      case ComplaintStatus.refundDiproses:
        return 'Dana Refund Sedang Diproses';
      case ComplaintStatus.selesai:
        return 'Klaim Selesai & Dana Dikembalikan';
    }
  }
}

class ExportReportModel {
  final String id;
  final String fishCategory;
  final double volumeTon;
  final String destinationCountry;
  final double estimatedValueUsd;
  final DateTime date;
  final String status;

  ExportReportModel({
    required this.id,
    required this.fishCategory,
    required this.volumeTon,
    required this.destinationCountry,
    required this.estimatedValueUsd,
    required this.date,
    required this.status,
  });
}
