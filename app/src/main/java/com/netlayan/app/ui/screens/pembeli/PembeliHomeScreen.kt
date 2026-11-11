package com.netlayan.app.ui.screens.pembeli

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.FilterList
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.LocalShipping
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.FilterChipDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.netlayan.app.model.UserRole
import com.netlayan.app.ui.components.FishProductCard
import com.netlayan.app.ui.components.NetlayanTopBar
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun PembeliHomeScreen(
    viewModel: NetlayanViewModel,
    onNavigateFishDetail: (String) -> Unit,
    onNavigateCart: () -> Unit,
    onNavigateOrderHistory: () -> Unit
) {
    val fishProducts by viewModel.fishList.collectAsState()
    val cartItems by viewModel.cartItems.collectAsState()

    var searchQuery by remember { mutableStateOf("") }
    var selectedCategory by remember { mutableStateOf("Semua") }
    var interCityOnlyFilter by remember { mutableStateOf(false) }

    val categories = listOf("Semua", "Ikan Laut", "Udang & Kepiting", "Cumi & Gurita")

    val filteredProducts = fishProducts.filter { product ->
        val matchesSearch = product.name.contains(searchQuery, ignoreCase = true) ||
                product.fishermanLocation.contains(searchQuery, ignoreCase = true)
        val matchesCategory = selectedCategory == "Semua" || product.category.contains(selectedCategory, ignoreCase = true)
        val matchesInterCity = !interCityOnlyFilter || product.isInterCityAvailable

        matchesSearch && matchesCategory && matchesInterCity
    }

    Scaffold(
        topBar = {
            NetlayanTopBar(
                title = "NETLAYAN - Katalog Ikan Segar",
                userRole = UserRole.PEMBELI,
                cartItemCount = cartItems.sumOf { it.quantityKg.toInt() },
                onCartClick = onNavigateCart
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(MaterialTheme.colorScheme.background)
        ) {
            // Search Bar & History Button
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp, vertical = 8.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                OutlinedTextField(
                    value = searchQuery,
                    onValueChange = { searchQuery = it },
                    placeholder = { Text("Cari ikan, udang, cumi, atau pelabuhan...", fontSize = 13.sp) },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(12.dp),
                    singleLine = true
                )

                Spacer(modifier = Modifier.width(8.dp))

                IconButton(
                    onClick = onNavigateOrderHistory,
                    modifier = Modifier
                        .clip(RoundedCornerShape(12.dp))
                        .background(OceanBluePrimary)
                ) {
                    Icon(
                        imageVector = Icons.Default.History,
                        contentDescription = "Riwayat Pesanan",
                        tint = Color.White
                    )
                }
            }

            // Category Filter Chips & Inter-City Shipping Banner
            LazyRow(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 12.dp, vertical = 4.dp),
                horizontalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                item {
                    FilterChip(
                        selected = interCityOnlyFilter,
                        onClick = { interCityOnlyFilter = !interCityOnlyFilter },
                        label = { Text("Bisa Kirim Luar Kota", fontSize = 12.sp) },
                        leadingIcon = { Icon(Icons.Default.LocalShipping, contentDescription = null) },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = OceanBlueSecondary,
                            selectedLabelColor = Color.White
                        )
                    )
                }

                items(categories) { category ->
                    FilterChip(
                        selected = selectedCategory == category,
                        onClick = { selectedCategory = category },
                        label = { Text(category, fontSize = 12.sp) },
                        colors = FilterChipDefaults.filterChipColors(
                            selectedContainerColor = OceanBluePrimary,
                            selectedLabelColor = Color.White
                        )
                    )
                }
            }

            // Products List
            LazyColumn(modifier = Modifier.fillMaxSize()) {
                item {
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(horizontal = 12.dp, vertical = 6.dp)
                            .clip(RoundedCornerShape(10.dp))
                            .background(OceanBluePrimary.copy(alpha = 0.08f))
                            .padding(10.dp)
                    ) {
                        Text(
                            text = "💡 Pembeli dari Luar Kota Padang (Bukittinggi, Pekanbaru, dll.) dapat memilih produk bermerek 'Luar Kota OK' dengan kargo dingin terjamin.",
                            fontSize = 11.sp,
                            color = OceanBluePrimary,
                            fontWeight = FontWeight.Medium
                        )
                    }
                }

                items(filteredProducts) { product ->
                    FishProductCard(
                        product = product,
                        isNelayanView = false,
                        onClick = { onNavigateFishDetail(product.id) },
                        onAddToCart = {
                            viewModel.addToCart(product, 1.0)
                        }
                    )
                }
            }
        }
    }
}
