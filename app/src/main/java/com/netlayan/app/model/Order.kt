package com.netlayan.app.model

enum class PaymentMethod {
    QRIS,
    TRANSFER_BANK,
    E_WALLET
}

enum class OrderStatus {
    MENUNGGU_PEMBAYARAN,
    DIPROSES,
    DALAM_PENGIRIMAN_ANTAR_KOTA,
    SELESAI
}

data class CartItem(
    val product: FishProduct,
    var quantityKg: Double
) {
    val totalPrice: Double get() = product.pricePerKg * quantityKg
}

data class Order(
    val id: String,
    val buyerName: String,
    val buyerAddress: String,
    val destinationCity: String,
    val items: List<CartItem>,
    val shippingFee: Double,
    val totalAmount: Double,
    val paymentMethod: PaymentMethod,
    var status: OrderStatus,
    val orderDate: String,
    val isInterCity: Boolean
)
