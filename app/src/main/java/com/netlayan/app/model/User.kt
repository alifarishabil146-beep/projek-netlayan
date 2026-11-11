package com.netlayan.app.model

enum class UserRole {
    NELAYAN,
    PEMBELI,
    KEMENTERIAN_PERDAGANGAN
}

data class User(
    val id: String,
    val name: String,
    val email: String,
    val phone: String,
    val role: UserRole,
    val location: String = "Padang, Sumatera Barat",
    val boatName: String? = null // Khusus Nelayan
)
