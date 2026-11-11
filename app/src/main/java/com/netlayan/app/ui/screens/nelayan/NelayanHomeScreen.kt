package com.netlayan.app.ui.screens.nelayan

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
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
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ChevronRight
import androidx.compose.material.icons.filled.Navigation
import androidx.compose.material.icons.filled.Sailing
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
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
import com.netlayan.app.ui.components.WeatherCard
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun NelayanHomeScreen(
    viewModel: NetlayanViewModel,
    onNavigateUpload: () -> Unit,
    onNavigateWeather: () -> Unit
) {
    val currentUser by viewModel.currentUser.collectAsState()
    val fishProducts by viewModel.fishList.collectAsState()
    val weatherData by viewModel.weatherData.collectAsState()

    Scaffold(
        topBar = {
            NetlayanTopBar(
                title = "NETLAYAN - Dashboard",
                userRole = UserRole.NELAYAN
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = onNavigateUpload,
                containerColor = OceanBluePrimary,
                contentColor = Color.White
            ) {
                Row(
                    modifier = Modifier.padding(horizontal = 16.dp),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Icon(imageVector = Icons.Default.Add, contentDescription = "Upload Tangkapan")
                    Spacer(modifier = Modifier.width(6.dp))
                    Text(text = "Upload Ikan", fontWeight = FontWeight.Bold)
                }
            }
        }
    ) { paddingValues ->
        LazyColumn(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
                .background(MaterialTheme.colorScheme.background)
        ) {
            // Header Welcome
            item {
                Card(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(12.dp),
                    shape = RoundedCornerShape(16.dp),
                    colors = CardDefaults.cardColors(containerColor = OceanBluePrimary)
                ) {
                    Column(modifier = Modifier.padding(16.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(
                                imageVector = Icons.Default.Sailing,
                                contentDescription = null,
                                tint = Color.White,
                                modifier = Modifier.size(28.dp)
                            )
                            Spacer(modifier = Modifier.width(10.dp))
                            Column {
                                Text(
                                    text = "Halo, ${currentUser?.name ?: "Nelayan Padang"}!",
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 18.sp,
                                    color = Color.White
                                )
                                Text(
                                    text = currentUser?.boatName ?: "Kapal Tangkap Segar",
                                    fontSize = 12.sp,
                                    color = Color.White.copy(alpha = 0.8f)
                                )
                            }
                        }
                    }
                }
            }

            // Quick Weather Navigation Card
            item {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 16.dp, vertical = 4.dp),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Text(
                        text = "NAVIGASI CUACA LAUT",
                        fontWeight = FontWeight.Bold,
                        fontSize = 14.sp,
                        color = OceanBluePrimary
                    )

                    Row(
                        modifier = Modifier.clickable { onNavigateWeather() },
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "Buka Peta & Detail",
                            fontSize = 12.sp,
                            fontWeight = FontWeight.Bold,
                            color = OceanBlueSecondary
                        )
                        Icon(
                            imageVector = Icons.Default.ChevronRight,
                            contentDescription = null,
                            tint = OceanBlueSecondary,
                            modifier = Modifier.size(16.dp)
                        )
                    }
                }

                WeatherCard(weatherData = weatherData, onDetailClick = onNavigateWeather)
            }

            // Section Listing Tangkapan Nelayan
            item {
                Text(
                    text = "DAFTAR TANGKAPAN ANDA",
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp,
                    color = OceanBluePrimary,
                    modifier = Modifier.padding(start = 16.dp, end = 16.dp, top = 16.dp, bottom = 8.dp)
                )
            }

            items(fishProducts) { product ->
                FishProductCard(
                    product = product,
                    isNelayanView = true
                )
            }

            item {
                Spacer(modifier = Modifier.height(80.dp))
            }
        }
    }
}
