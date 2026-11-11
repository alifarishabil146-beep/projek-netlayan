package com.netlayan.app.viewmodel

import androidx.lifecycle.ViewModel
import com.netlayan.app.data.MockData
import com.netlayan.app.model.CartItem
import com.netlayan.app.model.FishProduct
import com.netlayan.app.model.Order
import com.netlayan.app.model.OrderStatus
import com.netlayan.app.model.PaymentMethod
import com.netlayan.app.model.SafetyStatus
import com.netlayan.app.model.User
import com.netlayan.app.model.UserRole
import com.netlayan.app.model.WeatherData
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.UUID

class NetlayanViewModel : ViewModel() {

    private val _currentUser = MutableStateFlow<User?>(MockData.sampleUsers[0]) // Default: Nelayan
    val currentUser: StateFlow<User?> = _currentUser.asStateFlow()

    private val _fishList = MutableStateFlow<List<FishProduct>>(MockData.sampleFishProducts)
    val fishList: StateFlow<List<FishProduct>> = _fishList.asStateFlow()

    private val _weatherData = MutableStateFlow<WeatherData>(MockData.sampleWeather)
    val weatherData: StateFlow<WeatherData> = _weatherData.asStateFlow()

    private val _cartItems = MutableStateFlow<List<CartItem>>(emptyList())
    val cartItems: StateFlow<List<CartItem>> = _cartItems.asStateFlow()

    private val _ordersList = MutableStateFlow<List<Order>>(emptyList())
    val ordersList: StateFlow<List<Order>> = _ordersList.asStateFlow()

    fun setCurrentUserRole(role: UserRole) {
        _currentUser.value = MockData.sampleUsers.find { it.role == role } ?: User(
            id = UUID.randomUUID().toString(),
            name = when (role) {
                UserRole.NELAYAN -> "Nelayan Padang"
                UserRole.PEMBELI -> "Pembeli / Swalayan"
                UserRole.KEMENTERIAN_PERDAGANGAN -> "Kementerian Perdagangan"
            },
            email = "user@netlayan.com",
            phone = "08123456789",
            role = role,
            location = "Padang, Sumatera Barat"
        )
    }

    fun loginUser(name: String, email: String, role: UserRole, location: String) {
        _currentUser.value = User(
            id = UUID.randomUUID().toString(),
            name = name,
            email = email,
            phone = "08123456789",
            role = role,
            location = location,
            boatName = if (role == UserRole.NELAYAN) "KM Netlayan Utama" else null
        )
    }

    fun addFishProduct(
        name: String,
        category: String,
        pricePerKg: Double,
        stockKg: Double,
        imageUrl: String,
        isInterCity: Boolean,
        description: String
    ) {
        val user = _currentUser.value
        val newProduct = FishProduct(
            id = "FISH-${System.currentTimeMillis() % 10000}",
            name = name,
            category = category,
            pricePerKg = pricePerKg,
            stockKg = stockKg,
            imageUrl = if (imageUrl.isBlank()) "https://images.unsplash.com/photo-1534483509719-3feaee7c30da?q=80&w=800" else imageUrl,
            fishermanName = user?.name ?: "Nelayan Padang",
            fishermanLocation = user?.location ?: "Pelabuhan Padang",
            isInterCityAvailable = isInterCity,
            dateCaught = "Hari ini, " + SimpleDateFormat("HH:mm", Locale.getDefault()).format(Date()) + " WIB",
            description = description
        )
        _fishList.value = listOf(newProduct) + _fishList.value
    }

    fun addToCart(product: FishProduct, quantityKg: Double) {
        val currentCart = _cartItems.value.toMutableList()
        val existingIndex = currentCart.indexOfFirst { it.product.id == product.id }
        if (existingIndex >= 0) {
            val item = currentCart[existingIndex]
            currentCart[existingIndex] = item.copy(quantityKg = item.quantityKg + quantityKg)
        } else {
            currentCart.add(CartItem(product, quantityKg))
        }
        _cartItems.value = currentCart
    }

    fun removeFromCart(productId: String) {
        _cartItems.value = _cartItems.value.filter { it.product.id != productId }
    }

    fun clearCart() {
        _cartItems.value = emptyList()
    }

    fun updateWeatherSimulation(waveMeter: Double, windKnot: Int) {
        val safety = when {
            waveMeter > 2.5 || windKnot > 22 -> SafetyStatus.BAHAYA
            waveMeter >= 1.5 || windKnot >= 15 -> SafetyStatus.WASPADA
            else -> SafetyStatus.AMAN
        }

        val text = when (safety) {
            SafetyStatus.AMAN -> "Kondisi perairan aman untuk melaut. Utamakan perbekalan keselamatan."
            SafetyStatus.WASPADA -> "Hati-hati, gelombang laut sedang meningkat. Hindari melaut terlalu jauh ke tengah laut."
            SafetyStatus.BAHAYA -> "PERINGATAN BAHAYA: Cuaca buruk & gelombang tinggi! Dituntut menunda aktivitas melaut."
        }

        _weatherData.value = _weatherData.value.copy(
            waveHeightMeter = waveMeter,
            windSpeedKnot = windKnot,
            safetyStatus = safety,
            recommendationText = text
        )
    }

    fun checkoutOrder(
        destinationCity: String,
        address: String,
        paymentMethod: PaymentMethod,
        isInterCity: Boolean
    ): Order {
        val items = _cartItems.value
        val subtotal = items.sumOf { it.totalPrice }
        val shippingFee = if (isInterCity) 35000.0 else 15000.0
        val user = _currentUser.value

        val newOrder = Order(
            id = "NTL-" + System.currentTimeMillis().toString().takeLast(6),
            buyerName = user?.name ?: "Pembeli",
            buyerAddress = address,
            destinationCity = destinationCity,
            items = items,
            shippingFee = shippingFee,
            totalAmount = subtotal + shippingFee,
            paymentMethod = paymentMethod,
            status = OrderStatus.MENUNGGU_PEMBAYARAN,
            orderDate = SimpleDateFormat("dd MMM yyyy, HH:mm", Locale.getDefault()).format(Date()),
            isInterCity = isInterCity
        )

        _ordersList.value = listOf(newOrder) + _ordersList.value
        clearCart()
        return newOrder
    }

    fun formatRupiah(amount: Double): String {
        val formatter = NumberFormat.getCurrencyInstance(Locale("id", "ID"))
        return formatter.format(amount).replace(",00", "")
    }
}
