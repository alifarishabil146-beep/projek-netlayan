package com.netlayan.app.model

data class FishProduct(
    val id: String,
    val name: String,
    val category: String, // e.g. "Ikan Laut", "Udang & Kepiting", "Cumi & Gurita"
    val pricePerKg: Double,
    val stockKg: Double,
    val imageUrl: String,
    val fishermanName: String,
    val fishermanLocation: String,
    val isInterCityAvailable: Boolean, // Pengiriman Antar Kota
    val dateCaught: String,
    val description: String
)
