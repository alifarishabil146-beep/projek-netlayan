package com.netlayan.app.ui.navigation

sealed class Screen(val route: String) {
    object RoleSelection : Screen("role_selection")
    object Login : Screen("login")
    object Register : Screen("register")

    // Nelayan Screens
    object NelayanHome : Screen("nelayan_home")
    object UploadFish : Screen("upload_fish")
    object WeatherNavigation : Screen("weather_navigation")

    // Pembeli / Swalayan Screens
    object PembeliHome : Screen("pembeli_home")
    object FishDetail : Screen("fish_detail/{productId}") {
        fun createRoute(productId: String) = "fish_detail/$productId"
    }
    object CartCheckout : Screen("cart_checkout")
    object OrderHistory : Screen("order_history")
}
