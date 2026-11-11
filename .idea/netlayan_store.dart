import 'package:flutter/foundation.dart';
import '../models/netlayan_models.dart';

class NetlayanStore extends ChangeNotifier {
  UserModel? _currentUser;
  final List<FishItem> _fishList = [];
  final List<CartItem> _cart = [];
  final List<OrderModel> _orders = [];
  final List<RecipeModel> _recipes = [];

  NetlayanStore() {
    _initDefaultData();
  }

  UserModel? get currentUser => _currentUser;
  List<FishItem> get fishList => List.unmodifiable(_fishList);
  List<CartItem> get cart => List.unmodifiable(_cart);
  List<OrderModel> get orders => List.unmodifiable(_orders);
  List<RecipeModel> get recipes => List.unmodifiable(_recipes);

  List<FishItem> get smartRecommendations {
    List<FishItem> sorted = List.from(_fishList);
    sorted.sort((a, b) => b.freshnessScore.compareTo(a.freshnessScore));
    return sorted;
  }

  double get cartTotalPrice {
    double total = 0;
    for (var item in _cart) {
      total += item.totalPrice;
    }
    return total;
  }

  void _initDefaultData() {
    // Default logged-in user
    _currentUser = UserModel(
      id: 'nelayan_01',
      name: 'Pak Syamsul (Nelayan)',
      email: 'syamsul@netlayan.id',
      phone: '081267890123',
      role: UserRole.nelayan,
      city: 'Kota Padang',
      address: 'Dermaga TPI Muara Padang No. 12',
      portLocation: 'Pelabuhan Muara Padang',
    );

    // Default Fish Catalog
    _fishList.addAll([
      FishItem(
        id: 'fish_1',
        fishermanId: 'nelayan_01',
        fishermanName: 'Pak Syamsul',
        fishermanCity: 'Kota Padang',
        title: 'Ikan Tongkol Segar Tangkapan Subuh',
        category: 'Ikan Laut',
        pricePerKg: 35000,
        stockKg: 120.0,
        imageUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=600&auto=format&fit=crop&q=80',
        catchDate: DateTime.now().subtract(const Duration(hours: 3)),
        portLocation: 'Pelabuhan Muara Padang',
        description: 'Ikan tongkol segar hasil tangkapan kapal KM Netlayan Utama di perairan Mentawai. Daging padat dan manis.',
        freshnessScore: 99,
      ),
      FishItem(
        id: 'fish_2',
        fishermanId: 'nelayan_01',
        fishermanName: 'Pak Syamsul',
        fishermanCity: 'Kota Padang',
        title: 'Ikan Kakap Merah Super',
        category: 'Ikan Karang',
        pricePerKg: 75000,
        stockKg: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&auto=format&fit=crop&q=80',
        catchDate: DateTime.now().subtract(const Duration(hours: 4)),
        portLocation: 'Pelabuhan Bungus Padang',
        description: 'Kakap merah segar kualitas ekspor, sangat empuk untuk Gulai Kepala Kakap Khas Minang.',
        freshnessScore: 97,
      ),
      FishItem(
        id: 'fish_3',
        fishermanId: 'nelayan_02',
        fishermanName: 'Pak Amir',
        fishermanCity: 'Kota Padang',
        title: 'Udang Vaname Segar Laut',
        category: 'Udang & Cumi',
        pricePerKg: 90000,
        stockKg: 30.0,
        imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=600&auto=format&fit=crop&q=80',
        catchDate: DateTime.now().subtract(const Duration(hours: 2)),
        portLocation: 'Dermaga Teluk Bayur',
        description: 'Udang vaname ukuran besar (size 30), kondisi sangat segar dan gurih manis.',
        freshnessScore: 100,
      ),
      FishItem(
        id: 'fish_4',
        fishermanId: 'nelayan_02',
        fishermanName: 'Pak Amir',
        fishermanCity: 'Kota Padang',
        title: 'Cumi-Cumi Segar Jarum',
        category: 'Udang & Cumi',
        pricePerKg: 65000,
        stockKg: 50.0,
        imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80',
        catchDate: DateTime.now().subtract(const Duration(hours: 5)),
        portLocation: 'Dermaga Teluk Bayur',
        description: 'Cumi segar tanpa bahan pengawet, kenyal dan gurih saat digoreng tepung crispy.',
        freshnessScore: 95,
      ),
      FishItem(
        id: 'fish_5',
        fishermanId: 'nelayan_03',
        fishermanName: 'Kapten Rahmat',
        fishermanCity: 'Pesisir Selatan',
        title: 'Ikan Tuna Sirip Kuning (Yellowfin)',
        category: 'Ikan Besar',
        pricePerKg: 85000,
        stockKg: 200.0,
        imageUrl: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=600&auto=format&fit=crop&q=80',
        catchDate: DateTime.now().subtract(const Duration(hours: 6)),
        portLocation: 'Pelabuhan Carocok Painan',
        description: 'Tuna segar kualitias sashimi, ditangkap dengan pancing ulur ramah lingkungan.',
        freshnessScore: 96,
      ),
    ]);

    // Default Recipes
    _recipes.addAll([
      RecipeModel(
        id: 'rec_1',
        title: 'Asam Padeh Ikan Tongkol Khas Minang',
        targetFishName: 'Ikan Tongkol Segar Tangkapan Subuh',
        fishCategory: 'Ikan Laut',
        cookingTime: '35 Menit',
        difficulty: 'Mudah',
        imageUrl: 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=600&auto=format&fit=crop&q=80',
        description: 'Masakan khas Sumatera Barat dengan rasa gurih asam dan pedas rempah yang meresap sempurna ke serat daging ikan tongkol segar.',
        ingredients: [
          '1 Kg Ikan Tongkol Segar Tangkapan Subuh',
          '8 siung Bawang Merah & 4 siung Bawang Putih',
          '100g Cabai Merah Keriting halus',
          '2 lembar Daun Kunyit & 2 batang Serai',
          '3 buah Asam Kandis',
          '1 liter Air & Garam secukupnya',
        ],
        steps: [
          'Bersihkan ikan tongkol segar dan potong-potong sesuai selera.',
          'Haluskan bawang merah, bawang putih, dan cabai merah keriting.',
          'Didihkan air bersama bumbu halus, serai, daun kunyit, dan asam kandis.',
          'Masukkan potongan ikan tongkol segar, masak dengan api sedang hingga kuah mengental dan meresap.',
          'Sajikan selagi hangat dengan nasi putih pulen.',
        ],
        smartTip: 'Gunakan ikan tongkol tangkapan subuh (< 6 jam) agar serat dagingnya tidak hancur saat dimasak asam padeh.',
      ),
      RecipeModel(
        id: 'rec_2',
        title: 'Gulai Kepala Kakap Merah Santan Gurih',
        targetFishName: 'Ikan Kakap Merah Super',
        fishCategory: 'Ikan Karang',
        cookingTime: '45 Menit',
        difficulty: 'Sedang',
        imageUrl: 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=600&auto=format&fit=crop&q=80',
        description: 'Hidangan populer di Rumah Makan Padang, kepala kakap merah dengan kuah gulai kental beraroma jeruk purut dan ruku-ruku.',
        ingredients: [
          '1 Kg Ikan Kakap Merah Super segar',
          '800 ml Santan Kelapa asli',
          'Bumbu halus: Kunyit, Jahe, Lengkuas, Kemiri, Bawang Merah & Putih',
          'Daun Ruku-Ruku & Daun Jeruk Purut',
          'Cabai Rawit utuh secukupnya',
        ],
        steps: [
          'Cuci bersih kepala kakap merah segar dan lumuri perasan jeruk nipis.',
          'Tumis bumbu halus bersama daun ruku-ruku dan daun jeruk hingga wangi.',
          'Tuang santan dan timba-timba kuah agar santan tidak pecah.',
          'Masukkan kakap merah dan cabai rawit utuh, masak hingga matang berminyak.',
        ],
        smartTip: 'Kakap merah dari perairan karang Bungus memiliki tesktur daging pipi yang sangat gurih manis.',
      ),
      RecipeModel(
        id: 'rec_3',
        title: 'Udang Vaname Tumis Balado Petai',
        targetFishName: 'Udang Vaname Segar Laut',
        fishCategory: 'Udang & Cumi',
        cookingTime: '20 Menit',
        difficulty: 'Sangat Mudah',
        imageUrl: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?w=600&auto=format&fit=crop&q=80',
        description: 'Udang vaname segar rasa manis gurih alami ditumis cepat dengan sambal balado merah pedas dan aroma petai yang mantap.',
        ingredients: [
          '500g Udang Vaname Segar Laut',
          '150g Cabai Merah ditumbuk kasar',
          '6 siung Bawang Merah',
          '2 papan Petai dikupas',
          'Minyak goreng & garam secukupnya',
        ],
        steps: [
          'Goreng udang vaname sebentar (1-2 menit) agar tetap juicy dan tidak kenyal.',
          'Tumis cabai merah kasar dan bawang merah hingga harum.',
          'Masukkan petai dan udang goreng, aduk cepat lalu angkat.',
        ],
        smartTip: 'Udang segar kulitnya bening mengkilap dan tidak bau amis menyengat.',
      ),
      RecipeModel(
        id: 'rec_4',
        title: 'Cumi-Cumi Goreng Tepung Crispy Renyah',
        targetFishName: 'Cumi-Cumi Segar Jarum',
        fishCategory: 'Udang & Cumi',
        cookingTime: '15 Menit',
        difficulty: 'Sangat Mudah',
        imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&auto=format&fit=crop&q=80',
        description: 'Cumi cumi dipotong cincin dibalut tepung berbumbu gurih renyah, favorit anak-anak dan keluarga.',
        ingredients: [
          '500g Cumi-Cumi Segar Jarum',
          'Tepung Terigu & Tepung Maizena (3:1)',
          'Bawang Putih bubuk, Merica, & Garam',
          '1 butir Telur dikocok',
        ],
        steps: [
          'Potong cumi bentuk cincin, beri perasan jeruk nipis.',
          'Celupkan ke telur lalu gulingkan ke adonan tepung kering.',
          'Goreng dalam minyak panas hingga berwarna kuning keemasan renyah.',
        ],
        smartTip: 'Jangan menggoreng cumi terlalu lama (maksimal 3 menit) agar teksturnya tidak alot.',
      ),
    ]);

    // Sample Default Order
    _orders.add(
      OrderModel(
        id: 'ORD-20261111-001',
        buyerId: 'pembeli_01',
        buyerName: 'Swalayan Grand Lucky Bukittinggi',
        buyerPhone: '081398765432',
        buyerCity: 'Kota Bukittinggi',
        deliveryAddress: 'Jl. Sudirman No. 45, Bukittinggi',
        items: [
          CartItem(
            fish: _fishList[0],
            quantityKg: 20.0,
          ),
          CartItem(
            fish: _fishList[1],
            quantityKg: 10.0,
          ),
        ],
        itemsTotalPrice: (35000 * 20) + (75000 * 10),
        shippingFee: 75000,
        courierName: 'Cold Chain Express (Antar Kota Subuh)',
        paymentMethod: 'QRIS Instant Payment',
        qrisCode: '00020101021226680014ID.LINKAJA.WWW011893600911002202611110015204581253033605802ID5910NETLAYAN ID6006PADANG61052511162070703A0163044F8E',
        status: OrderStatus.dalamPengiriman,
        orderDate: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    );
  }

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void addFish(FishItem fish) {
    _fishList.insert(0, fish);
    notifyListeners();
  }

  void removeFish(String fishId) {
    _fishList.removeWhere((item) => item.id == fishId);
    notifyListeners();
  }

  void addToCart(FishItem fish, double quantityKg) {
    int existingIndex = _cart.indexWhere((item) => item.fish.id == fish.id);
    if (existingIndex >= 0) {
      _cart[existingIndex].quantityKg += quantityKg;
    } else {
      _cart.add(CartItem(fish: fish, quantityKg: quantityKg));
    }
    notifyListeners();
  }

  void updateCartQuantity(String fishId, double newQty) {
    int index = _cart.indexWhere((item) => item.fish.id == fishId);
    if (index >= 0) {
      if (newQty <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantityKg = newQty;
      }
      notifyListeners();
    }
  }

  void removeFromCart(String fishId) {
    _cart.removeWhere((item) => item.fish.id == fishId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  OrderModel placeOrder({
    required String buyerName,
    required String buyerPhone,
    required String buyerCity,
    required String deliveryAddress,
    required String courierName,
    required double shippingFee,
    required String paymentMethod,
  }) {
    final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final qrisPayload = '00020101021226680014ID.NETLAYAN.WWW0118${orderId}5204581253033605802ID5910NETLAYAN ID6006PADANG61052511162070703A0163044F8E';

    final newOrder = OrderModel(
      id: orderId,
      buyerId: _currentUser?.id ?? 'guest_buyer',
      buyerName: buyerName,
      buyerPhone: buyerPhone,
      buyerCity: buyerCity,
      deliveryAddress: deliveryAddress,
      items: List.from(_cart),
      itemsTotalPrice: cartTotalPrice,
      shippingFee: shippingFee,
      courierName: courierName,
      paymentMethod: paymentMethod,
      qrisCode: qrisPayload,
      status: OrderStatus.menungguKonfirmasi,
      orderDate: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    _cart.clear();
    notifyListeners();
    return newOrder;
  }

  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    int idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx >= 0) {
      _orders[idx].status = newStatus;
      notifyListeners();
    }
  }
}
