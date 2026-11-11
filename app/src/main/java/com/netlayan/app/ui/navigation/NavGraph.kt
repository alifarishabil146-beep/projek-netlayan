package com.netlayan.app.ui.navigation

import androidx.compose.runtime.Composable
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.netlayan.app.model.UserRole
import com.netlayan.app.ui.screens.auth.LoginScreen
import com.netlayan.app.ui.screens.auth.RegisterScreen
import com.netlayan.app.ui.screens.auth.RoleSelectionScreen
import com.netlayan.app.ui.screens.nelayan.NelayanHomeScreen
import com.netlayan.app.ui.screens.nelayan.UploadFishScreen
import com.netlayan.app.ui.screens.nelayan.WeatherNavigationScreen
import com.netlayan.app.ui.screens.pembeli.CartCheckoutScreen
import com.netlayan.app.ui.screens.pembeli.FishDetailScreen
import com.netlayan.app.ui.screens.pembeli.OrderHistoryScreen
import com.netlayan.app.ui.screens.pembeli.PembeliHomeScreen
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun NavGraph(
    navController: NavHostController = rememberNavController(),
    netlayanViewModel: NetlayanViewModel = viewModel()
) {
    NavHost(
        navController = navController,
        startDestination = Screen.RoleSelection.route
    ) {
        composable(Screen.RoleSelection.route) {
            RoleSelectionScreen(
                onSelectRole = { role ->
                    netlayanViewModel.setCurrentUserRole(role)
                    navController.navigate(Screen.Login.route)
                }
            )
        }

        composable(Screen.Login.route) {
            LoginScreen(
                initialRole = netlayanViewModel.currentUser.value?.role ?: UserRole.NELAYAN,
                onLoginSuccess = { role ->
                    netlayanViewModel.setCurrentUserRole(role)
                    if (role == UserRole.NELAYAN) {
                        navController.navigate(Screen.NelayanHome.route) {
                            popUpTo(Screen.RoleSelection.route) { inclusive = true }
                        }
                    } else {
                        navController.navigate(Screen.PembeliHome.route) {
                            popUpTo(Screen.RoleSelection.route) { inclusive = true }
                        }
                    }
                },
                onNavigateRegister = { role ->
                    navController.navigate(Screen.Register.route)
                }
            )
        }

        composable(Screen.Register.route) {
            RegisterScreen(
                role = netlayanViewModel.currentUser.value?.role ?: UserRole.NELAYAN,
                onRegisterSuccess = { name, email, role, location ->
                    netlayanViewModel.loginUser(name, email, role, location)
                    if (role == UserRole.NELAYAN) {
                        navController.navigate(Screen.NelayanHome.route) {
                            popUpTo(Screen.RoleSelection.route) { inclusive = true }
                        }
                    } else {
                        navController.navigate(Screen.PembeliHome.route) {
                            popUpTo(Screen.RoleSelection.route) { inclusive = true }
                        }
                    }
                },
                onNavigateLogin = {
                    navController.navigate(Screen.Login.route)
                }
            )
        }

        // Nelayan Routes
        composable(Screen.NelayanHome.route) {
            NelayanHomeScreen(
                viewModel = netlayanViewModel,
                onNavigateUpload = { navController.navigate(Screen.UploadFish.route) },
                onNavigateWeather = { navController.navigate(Screen.WeatherNavigation.route) }
            )
        }

        composable(Screen.UploadFish.route) {
            UploadFishScreen(
                viewModel = netlayanViewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        composable(Screen.WeatherNavigation.route) {
            WeatherNavigationScreen(
                viewModel = netlayanViewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }

        // Pembeli Routes
        composable(Screen.PembeliHome.route) {
            PembeliHomeScreen(
                viewModel = netlayanViewModel,
                onNavigateFishDetail = { productId ->
                    navController.navigate(Screen.FishDetail.createRoute(productId))
                },
                onNavigateCart = { navController.navigate(Screen.CartCheckout.route) },
                onNavigateOrderHistory = { navController.navigate(Screen.OrderHistory.route) }
            )
        }

        composable(
            route = Screen.FishDetail.route,
            arguments = listOf(navArgument("productId") { type = NavType.StringType })
        ) { backStackEntry ->
            val productId = backStackEntry.arguments?.getString("productId") ?: ""
            FishDetailScreen(
                productId = productId,
                viewModel = netlayanViewModel,
                onNavigateBack = { navController.popBackStack() },
                onNavigateCart = { navController.navigate(Screen.CartCheckout.route) }
            )
        }

        composable(Screen.CartCheckout.route) {
            CartCheckoutScreen(
                viewModel = netlayanViewModel,
                onNavigateBack = { navController.popBackStack() },
                onNavigateOrderHistory = { navController.navigate(Screen.OrderHistory.route) }
            )
        }

        composable(Screen.OrderHistory.route) {
            OrderHistoryScreen(
                viewModel = netlayanViewModel,
                onNavigateBack = { navController.popBackStack() }
            )
        }
    }
}
