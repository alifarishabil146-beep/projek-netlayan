package com.netlayan.app.ui.screens.nelayan

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddPhotoAlternate
import androidx.compose.material.icons.filled.Category
import androidx.compose.material.icons.filled.Description
import androidx.compose.material.icons.filled.LocalShipping
import androidx.compose.material.icons.filled.MonetizationOn
import androidx.compose.material.icons.filled.PhonelinkRing
import androidx.compose.material.icons.filled.Scale
import androidx.compose.material.icons.filled.SetMeal
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.SwitchDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.AsyncImage
import com.netlayan.app.ui.components.NetlayanTopBar
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun UploadFishScreen(
    viewModel: NetlayanViewModel,
    onNavigateBack: () -> Unit
) {
    var fishName by remember { mutableStateOf("") }
    var category by remember { mutableStateOf("Ikan Laut") }
    var pricePerKgText by remember { mutableStateOf("") }
    var stockKgText by remember { mutableStateOf("") }
    var isInterCity by remember { mutableStateOf(true) }
    var description by remember { mutableStateOf("") }
    var selectedImageUrl by remember { mutableStateOf("https://images.unsplash.com/photo-1534483509719-3feaee7c30da?q=80&w=800") }

    Scaffold(
        topBar = {
            NetlayanTopBar(
                title = "Upload Foto & Tangkapan",
                canNavigateBack = true,
                onNavigateBack = onNavigateBack
            )
        }
    ) { paddingValues ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .verticalScroll(rememberScrollState())
                .padding(16.dp)
        ) {
            // Photo Upload Box Preview
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(180.dp)
                    .clip(RoundedCornerShape(12.dp))
                    .background(Color.LightGray.copy(alpha = 0.3f))
                    .border(2.dp, OceanBluePrimary.copy(alpha = 0.3f), RoundedCornerShape(12.dp))
                    .clickable {
                        // Toggle sample image simulation
                        selectedImageUrl = if (selectedImageUrl.contains("photo-1534483509719")) {
                            "https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?q=80&w=800"
                        } else {
                            "https://images.unsplash.com/photo-1534483509719-3feaee7c30da?q=80&w=800"
                        }
                    },
                contentAlignment = Alignment.Center
            ) {
                if (selectedImageUrl.isNotBlank()) {
                    AsyncImage(
                        model = selectedImageUrl,
                        contentDescription = "Foto Ikan",
                        contentScale = ContentScale.Crop,
                        modifier = Modifier.fillMaxSize()
                    )
                } else {
                    Column(horizontalAlignment = Alignment.CenterHorizontally) {
                        Icon(
                            imageVector = Icons.Default.AddPhotoAlternate,
                            contentDescription = "Upload Foto",
                            tint = OceanBluePrimary,
                            modifier = Modifier.size(48.dp)
                        )
                        Spacer(modifier = Modifier.height(8.dp))
                        Text(
                            text = "Tekan untuk Pilih / Ambil Foto Ikan Segar",
                            fontWeight = FontWeight.SemiBold,
                            fontSize = 13.sp,
                            color = OceanBluePrimary
                        )
                    }
                }
            }

            Spacer(modifier = Modifier.height(16.dp))

            OutlinedTextField(
                value = fishName,
                onValueChange = { fishName = it },
                label = { Text("Nama Hasil Tangkapan (mis: Ikan Tenggiri Segar)") },
                leadingIcon = { Icon(Icons.Default.SetMeal, contentDescription = null) },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(10.dp)
            )

            Spacer(modifier = Modifier.height(12.dp))

            OutlinedTextField(
                value = category,
                onValueChange = { category = it },
                label = { Text("Kategori (Ikan Laut / Udang / Cumi)") },
                leadingIcon = { Icon(Icons.Default.Category, contentDescription = null) },
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(10.dp)
            )

            Spacer(modifier = Modifier.height(12.dp))

            Row(modifier = Modifier.fillMaxWidth()) {
                OutlinedTextField(
                    value = pricePerKgText,
                    onValueChange = { pricePerKgText = it },
                    label = { Text("Harga / kg (Rp)") },
                    leadingIcon = { Icon(Icons.Default.MonetizationOn, contentDescription = null) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(10.dp)
                )

                Spacer(modifier = Modifier.width(12.dp))

                OutlinedTextField(
                    value = stockKgText,
                    onValueChange = { stockKgText = it },
                    label = { Text("Stok (kg)") },
                    leadingIcon = { Icon(Icons.Default.Scale, contentDescription = null) },
                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                    modifier = Modifier.weight(1f),
                    shape = RoundedCornerShape(10.dp)
                )
            }

            Spacer(modifier = Modifier.height(16.dp))

            // Inter-city Shipping Toggle Card
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .clip(RoundedCornerShape(12.dp))
                    .background(OceanBlueSecondary.copy(alpha = 0.1f))
                    .padding(12.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(
                        imageVector = Icons.Default.LocalShipping,
                        contentDescription = null,
                        tint = OceanBluePrimary,
                        modifier = Modifier.size(24.dp)
                    )

                    Spacer(modifier = Modifier.width(12.dp))

                    Column(modifier = Modifier.weight(1f)) {
                        Text(
                            text = "Bisa Kirim Luar Kota Padang?",
                            fontWeight = FontWeight.Bold,
                            fontSize = 14.sp,
                            color = OceanBluePrimary
                        )
                        Text(
                            text = "Aktifkan jika tangkapan aman dikirim kargo dingin ke Bukittinggi, Pekanbaru, dll.",
                            fontSize = 11.sp,
                            color = Color.Gray
                        )
                    }

                    Switch(
                        checked = isInterCity,
                        onCheckedChange = { isInterCity = it },
                        colors = SwitchDefaults.colors(checkedThumbColor = OceanBluePrimary)
                    )
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            OutlinedTextField(
                value = description,
                onValueChange = { description = it },
                label = { Text("Deskripsi Ikan & Lokasi Pendaratan") },
                leadingIcon = { Icon(Icons.Default.Description, contentDescription = null) },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(100.dp),
                shape = RoundedCornerShape(10.dp)
            )

            Spacer(modifier = Modifier.height(24.dp))

            Button(
                onClick = {
                    val name = fishName.ifBlank { "Ikan Tongkol Segar Padang" }
                    val price = pricePerKgText.toDoubleOrNull() ?: 55000.0
                    val stock = stockKgText.toDoubleOrNull() ?: 30.0
                    val desc = description.ifBlank { "Tangkapan segar nelayan Padang pagi hari ini. Kualitas terjamin." }

                    viewModel.addFishProduct(
                        name = name,
                        category = category,
                        pricePerKg = price,
                        stockKg = stock,
                        imageUrl = selectedImageUrl,
                        isInterCity = isInterCity,
                        description = desc
                    )
                    onNavigateBack()
                },
                modifier = Modifier
                    .fillMaxWidth()
                    .height(50.dp),
                shape = RoundedCornerShape(12.dp),
                colors = ButtonDefaults.buttonColors(containerColor = OceanBluePrimary)
            ) {
                Text(text = "PUBLIKASIKAN TANGKAPAN", fontWeight = FontWeight.Bold, fontSize = 16.sp)
            }
        }
    }
}
