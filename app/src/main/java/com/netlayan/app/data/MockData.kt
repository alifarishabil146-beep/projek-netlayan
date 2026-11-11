package com.netlayan.app.data

import com.netlayan.app.model.FishProduct
import com.netlayan.app.model.OrderStatus
import com.netlayan.app.model.PaymentMethod
import com.netlayan.app.model.SafetyStatus
import com.netlayan.app.model.User
import com.netlayan.app.model.UserRole
import com.netlayan.app.model.WeatherData

object MockData {

    val sampleUsers = listOf(
        User(
            id = "U001",
            name = "Bapak Pakhrul (Nelayan)",
            email = "pakhrul@netlayan.com",
            phone = "081234567890",
            role = UserRole.NELAYAN,
            location = "Pelabuhan Muaro Padang",
            boatName = "KM Bintang Laut 02"
        ),
        User(
            id = "U002",
            name = "Swalayan Bintang Segar",
            email = "swalayan@bintang.com",
            phone = "082198765432",
            role = UserRole.PEMBELI,
            location = "Kota Bukittinggi"
        ),
        User(
            id = "U003",
            name = "Kementerian Perdagangan RI",
            email = "kemendag@ri.go.id",
            phone = "08111222333",
            role = UserRole.KEMENTERIAN_PERDAGANGAN,
            location = "Kantor Pusat / Perwakilan Padang"
        )
    )

    val sampleWeather = WeatherData(
        locationName = "Perairan Padang - Samudra Hindia",
        temperatureCelsius = 29,
        condition = "Cerah Berawan",
        windSpeedKnot = 12,
        waveHeightMeter = 1.2,
        humidityPercent = 78,
        safetyStatus = SafetyStatus.AMAN,
        recommendationText = "Kondisi perairan relatif aman untuk melaut. Tetap utamakan alat keselamatan darurat."
    )

    val sampleFishProducts = mutableListOf(
        FishProduct(
            id = "FISH-001",
            name = "Ikan Tuna Tenggiri Segar",
            category = "Ikan Laut",
            pricePerKg = 65000.0,
            stockKg = 85.0,
            imageUrl = "https://images.unsplash.com/photo-1534483509719-3feaee7c30da?q=80&w=800",
            fishermanName = "Pakhrul Nelayan",
            fishermanLocation = "Pelabuhan Muaro, Padang",
            isInterCityAvailable = true,
            dateCaught = "Hari ini, 05:30 WIB",
            description = "Ikan tuna hasil tangkapan pagi hari di Samudra Hindia. Segar, tanpa pengawet kimia, dikemas dengan es kargo dingin aman kirim antar kota."
        ),
        FishProduct(
            id = "FISH-002",
            name = "Udang Vaname Size Jumbo",
            category = "Udang & Kepiting",
            pricePerKg = 95000.0,
            stockKg = 40.0,
            imageUrl = "https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?q=80&w=800",
            fishermanName = "Uda Buyung",
            fishermanLocation = "Bungus, Padang",
            isInterCityAvailable = true,
            dateCaught = "Kemarin, 16:00 WIB",
            description = "Udang Vaname kualitas ekspor dari tambak & pesisir Padang. Tekstur manis dan padat."
        ),
        FishProduct(
            id = "FISH-003",
            name = "Cumi-Cumi Telur Segar",
            category = "Cumi & Gurita",
            pricePerKg = 78000.0,
            stockKg = 25.0,
            imageUrl = "https://images.unsplash.com/photo-1545247181-516773cae754?q=80&w=800",
            fishermanName = "Pakhrul Nelayan",
            fishermanLocation = "Pelabuhan Muaro, Padang",
            isInterCityAvailable = false,
            dateCaught = "Hari ini, 04:00 WIB",
            description = "Cumi-cumi segar isi telur. Sangat cocok untuk olahan asam manis atau gulai."
        ),
        FishProduct(
            id = "FISH-004",
            name = "Ikan Kerapu Bintang",
            category = "Ikan Laut",
            pricePerKg = 120000.0,
            stockKg = 15.0,
            imageUrl = "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?q=80&w=800",
            fishermanName = "Mak Etek Syahrul",
            fishermanLocation = "Teluk Bayur, Padang",
            isInterCityAvailable = true,
            dateCaught = "Hari ini, 06:15 WIB",
            description = "Ikan kerapu segar pilihan kualitas resto seafood. Siap dikirim kargo dingin ke Pekanbaru, Medan, Jakarta."
        )
    )
}
