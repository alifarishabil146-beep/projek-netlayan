package com.netlayan.app.model

enum class SafetyStatus {
    AMAN,
    WASPADA,
    BAHAYA
}

data class WeatherData(
    val locationName: String,
    val temperatureCelsius: Int,
    val condition: String, // e.g. "Cerah Berawan", "Hujan Ringan", "Badai Lokal"
    val windSpeedKnot: Int,
    val waveHeightMeter: Double,
    val humidityPercent: Int,
    val safetyStatus: SafetyStatus,
    val recommendationText: String
)
