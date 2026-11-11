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
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Home
import androidx.compose.material.icons.filled.LocalShipping
import androidx.compose.material.icons.filled.LocationCity
import androidx.compose.material.icons.filled.Payment
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
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
import com.netlayan.app.model.Order
import com.netlayan.app.model.PaymentMethod
import com.netlayan.app.ui.components.NetlayanTopBar
import com.netlayan.app.ui.components.QRISDialog
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun CartCheckoutScreen(
    viewModel: NetlayanViewModel,
    onNavigateBack: () -> Unit,
    onNavigateOrderHistory: () -> Unit
) {
    val cartItems by viewModel.cartItems.collectAsState()
    val currentUser by viewModel.currentUser.collectAsState()

    var destinationCity by remember { mutableStateOf("Kota Bukittinggi") }
    var address by remember { mutableStateOf("Jl. Ahmad Yani No. 45, Bukittinggi") }
    var isInterCityShipping by remember { mutableStateOf(true) }
    var paymentMethod by remember { mutableStateOf(PaymentMethod.QRIS) }

    var showQRISModal by remember { mutableStateOf(false) }
    var activeCreatedOrder by remember { mutableStateOf<Order?>(null) }

    val subtotal = cartItems.sumOf { it.totalPrice }
    val shippingFee = if (isInterCityShipping) 35000.0 else 15000.0
    val totalAmount = subtotal + shippingFee

    if (showQRISModal && activeCreatedOrder != null) {
        QRISDialog(
            orderId = activeCreatedOrder!!.id,
            totalAmountFormatted = viewModel.formatRupiah(activeCreatedOrder!!.totalAmount),
            onDismiss = { showQRISModal = false },
            onSimulatePaymentSuccess = {
                showQRISModal = false
                onNavigateOrderHistory()
            }
        )
    }

    Scaffold(
        topBar = {
            NetlayanTopBar(
                title = "Keranjang & Checkout",
                canNavigateBack = true,
                onNavigateBack = onNavigateBack
            )
        },
        bottomBar = {
            if (cartItems.isNotEmpty()) {
                Card(
                    modifier = Modifier.fillMaxWidth(),
                    colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
                    elevation = CardDefaults.cardElevation(defaultElevation = 8.dp)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween
                        ) {
                            Text(text = "Total Pembayaran:", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                            Text(
                                text = viewModel.formatRupiah(totalAmount),
                                fontWeight = FontWeight.Bold,
                                fontSize = 18.sp,
                                color = OceanBluePrimary
                            )
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        Button(
                            onClick = {
                                val order = viewModel.checkoutOrder(
                                    destinationCity = destinationCity,
                                    address = address,
                                    paymentMethod = paymentMethod,
                                    isInterCity = isInterCityShipping
                                )
                                if (paymentMethod == PaymentMethod.QRIS) {
                                    activeCreatedOrder = order
                                    showQRISModal = true
                                } else {
                                    onNavigateOrderHistory()
                                }
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(48.dp),
                            shape = RoundedCornerShape(10.dp),
                            colors = ButtonDefaults.buttonColors(containerColor = OceanBluePrimary)
                        ) {
                            Text(text = "BAYAR SEKARANG", fontWeight = FontWeight.Bold, fontSize = 15.sp)
                        }
                    }
                }
            }
        }
    ) { paddingValues ->
        if (cartItems.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentAlignment = Alignment.Center
            ) {
                Text(
                    text = "Keranjang belanja Anda kosong.",
                    fontSize = 15.sp,
                    color = Color.Gray
                )
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues)
                    .padding(16.dp)
            ) {
                item {
                    Text(
                        text = "DAFTAR PESANAN IKAN",
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp,
                        color = OceanBluePrimary,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )
                }

                items(cartItems) { item ->
                    Card(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(vertical = 4.dp),
                        shape = RoundedCornerShape(10.dp),
                        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface)
                    ) {
                        Row(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(12.dp),
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Column(modifier = Modifier.weight(1f)) {
                                Text(text = item.product.name, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                                Text(
                                    text = "${item.quantityKg.toInt()} kg x ${viewModel.formatRupiah(item.product.pricePerKg)}",
                                    fontSize = 12.sp,
                                    color = Color.Gray
                                )
                                Text(
                                    text = "Total: " + viewModel.formatRupiah(item.totalPrice),
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 13.sp,
                                    color = OceanBluePrimary
                                )
                            }

                            IconButton(onClick = { viewModel.removeFromCart(item.product.id) }) {
                                Icon(
                                    imageVector = Icons.Default.Delete,
                                    contentDescription = "Hapus",
                                    tint = Color.Red
                                )
                            }
                        }
                    }
                }

                item {
                    Spacer(modifier = Modifier.height(16.dp))

                    Text(
                        text = "ALAMAT PENGIRIMAN ANTAR KOTA",
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp,
                        color = OceanBluePrimary,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )

                    OutlinedTextField(
                        value = destinationCity,
                        onValueChange = {
                            destinationCity = it
                            isInterCityShipping = !it.contains("Padang", ignoreCase = true)
                        },
                        label = { Text("Kota Tujuan Pengiriman") },
                        leadingIcon = { Icon(Icons.Default.LocationCity, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(10.dp)
                    )

                    Spacer(modifier = Modifier.height(8.dp))

                    OutlinedTextField(
                        value = address,
                        onValueChange = { address = it },
                        label = { Text("Alamat Lengkap / Swalayan") },
                        leadingIcon = { Icon(Icons.Default.Home, contentDescription = null) },
                        modifier = Modifier.fillMaxWidth(),
                        shape = RoundedCornerShape(10.dp)
                    )

                    Spacer(modifier = Modifier.height(16.dp))

                    // Shipping Summary Box
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .clip(RoundedCornerShape(10.dp))
                            .background(OceanBlueSecondary.copy(alpha = 0.1f))
                            .padding(12.dp)
                    ) {
                        Column {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                Icon(Icons.Default.LocalShipping, contentDescription = null, tint = OceanBluePrimary)
                                Spacer(modifier = Modifier.width(8.dp))
                                Text(
                                    text = if (isInterCityShipping) "Pengiriman Antar Kota (Kargo Cold Chain)" else "Pengiriman Dalam Kota Padang",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 13.sp,
                                    color = OceanBluePrimary
                                )
                            }
                            Text(
                                text = "Ongkir: " + viewModel.formatRupiah(shippingFee),
                                fontSize = 12.sp,
                                color = Color.Gray,
                                modifier = Modifier.padding(top = 4.dp)
                            )
                        }
                    }

                    Spacer(modifier = Modifier.height(16.dp))

                    Text(
                        text = "METODE PEMBAYARAN",
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp,
                        color = OceanBluePrimary,
                        modifier = Modifier.padding(bottom = 8.dp)
                    )

                    PaymentOptionRow(
                        title = "QRIS (GoPay, OVO, DANA, m-Banking)",
                        selected = paymentMethod == PaymentMethod.QRIS,
                        onClick = { paymentMethod = PaymentMethod.QRIS }
                    )

                    PaymentOptionRow(
                        title = "Transfer Bank (BCA / Mandiri / BRI)",
                        selected = paymentMethod == PaymentMethod.TRANSFER_BANK,
                        onClick = { paymentMethod = PaymentMethod.TRANSFER_BANK }
                    )

                    PaymentOptionRow(
                        title = "E-Wallet Direct",
                        selected = paymentMethod == PaymentMethod.E_WALLET,
                        onClick = { paymentMethod = PaymentMethod.E_WALLET }
                    )
                }
            }
        }
    }
}

@Composable
private fun PaymentOptionRow(
    title: String,
    selected: Boolean,
    onClick: () -> Unit
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
            .clip(RoundedCornerShape(8.dp))
            .background(if (selected) OceanBluePrimary.copy(alpha = 0.1f) else Color.Transparent)
            .padding(horizontal = 8.dp, vertical = 4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        RadioButton(selected = selected, onClick = onClick)
        Spacer(modifier = Modifier.width(8.dp))
        Text(text = title, fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal, fontSize = 13.sp)
    }
}
