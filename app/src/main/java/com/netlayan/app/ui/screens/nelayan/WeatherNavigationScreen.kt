package com.netlayan.app.ui.screens.nelayan

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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Air
import androidx.compose.material.icons.filled.Navigation
import androidx.compose.material.icons.filled.Warning
import androidx.compose.material.icons.filled.Water
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.netlayan.app.model.SafetyStatus
import com.netlayan.app.ui.components.NetlayanTopBar
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanDark
import com.netlayan.app.ui.theme.StatusDanger
import com.netlayan.app.ui.theme.StatusSafe
import com.netlayan.app.ui.theme.StatusWarning
import com.netlayan.app.viewmodel.NetlayanViewModel

@Composable
fun WeatherNavigationScreen(
    viewModel: NetlayanViewModel,
    onNavigateBack: () -> Unit
) {
    val weatherData by viewModel.weatherData.collectAsState()

    var waveSliderValue by remember { mutableFloatStateOf(weatherData.waveHeightMeter.toFloat()) }
    var windSliderValue by remember { mutableFloatStateOf(weatherData.windSpeedKnot.toFloat()) }

    val currentStatusColor = when (weatherData.safetyStatus) {
        SafetyStatus.AMAN -> StatusSafe
        SafetyStatus.WASPADA -> StatusWarning
        SafetyStatus.BAHAYA -> StatusDanger
    }

    Scaffold(
        topBar = {
            NetlayanTopBar(
                title = "Navigasi Cuaca Laut Interaktif",
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
            // Animated/Interactive Status Header
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(16.dp),
                colors = CardDefaults.cardColors(containerColor = currentStatusColor),
                elevation = CardDefaults.cardElevation(defaultElevation = 4.dp)
            ) {
                Column(
                    modifier = Modifier.padding(20.dp),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Icon(
                        imageVector = if (weatherData.safetyStatus == SafetyStatus.BAHAYA) Icons.Default.Warning else Icons.Default.Navigation,
                        contentDescription = null,
                        tint = Color.White,
                        modifier = Modifier.size(48.dp)
                    )

                    Spacer(modifier = Modifier.height(10.dp))

                    Text(
                        text = when (weatherData.safetyStatus) {
                            SafetyStatus.AMAN -> "KONDISI AMAN UNTUK MELAUT"
                            SafetyStatus.WASPADA -> "STATUS WASPADA - PERHATIKAN WIND & WAVE"
                            SafetyStatus.BAHAYA -> "PERINGATAN BAHAYA: GELOMBANG TINGGI!"
                        },
                        color = Color.White,
                        fontWeight = FontWeight.Bold,
                        fontSize = 18.sp
                    )

                    Text(
                        text = weatherData.locationName,
                        color = Color.White.copy(alpha = 0.9f),
                        fontSize = 13.sp,
                        modifier = Modifier.padding(top = 4.dp)
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Interactive Simulator Controls
            Text(
                text = "SIMULASI NAVIGASI CUACA REAL-TIME",
                fontWeight = FontWeight.Bold,
                fontSize = 14.sp,
                color = OceanBluePrimary
            )

            Text(
                text = "Geser slider untuk mensimulasikan perubahan gelombang dan angin di laut:",
                fontSize = 12.sp,
                color = Color.Gray,
                modifier = Modifier.padding(bottom = 12.dp)
            )

            // Wave Height Slider
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = OceanBluePrimary.copy(alpha = 0.05f))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Water, contentDescription = null, tint = OceanBluePrimary)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(text = "Tinggi Gelombang Laut", fontWeight = FontWeight.Bold)
                        }
                        Text(
                            text = "${String.format("%.1f", waveSliderValue)} Meter",
                            fontWeight = FontWeight.Bold,
                            color = OceanBluePrimary
                        )
                    }

                    Slider(
                        value = waveSliderValue,
                        onValueChange = {
                            waveSliderValue = it
                            viewModel.updateWeatherSimulation(
                                waveMeter = it.toDouble(),
                                windKnot = windSliderValue.toInt()
                            )
                        },
                        valueRange = 0.5f..4.5f,
                        colors = SliderDefaults.colors(
                            thumbColor = OceanBluePrimary,
                            activeTrackColor = OceanBluePrimary
                        )
                    )
                }
            }

            Spacer(modifier = Modifier.height(12.dp))

            // Wind Speed Slider
            Card(
                modifier = Modifier.fillMaxWidth(),
                shape = RoundedCornerShape(12.dp),
                colors = CardDefaults.cardColors(containerColor = OceanBluePrimary.copy(alpha = 0.05f))
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Row(
                        modifier = Modifier.fillMaxWidth(),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            Icon(Icons.Default.Air, contentDescription = null, tint = OceanBluePrimary)
                            Spacer(modifier = Modifier.width(8.dp))
                            Text(text = "Kecepatan Angin Pesisir", fontWeight = FontWeight.Bold)
                        }
                        Text(
                            text = "${windSliderValue.toInt()} Knot",
                            fontWeight = FontWeight.Bold,
                            color = OceanBluePrimary
                        )
                    }

                    Slider(
                        value = windSliderValue,
                        onValueChange = {
                            windSliderValue = it
                            viewModel.updateWeatherSimulation(
                                waveMeter = waveSliderValue.toDouble(),
                                windKnot = it.toInt()
                            )
                        },
                        valueRange = 5f..35f,
                        colors = SliderDefaults.colors(
                            thumbColor = OceanBluePrimary,
                            activeTrackColor = OceanBluePrimary
                        )
                    )
                }
            }

            Spacer(modifier = Modifier.height(20.dp))

            // Map Representation
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(160.dp)
                    .clip(RoundedCornerShape(16.dp))
                    .background(OceanDark),
                contentAlignment = Alignment.Center
            ) {
                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(
                        imageVector = Icons.Default.Navigation,
                        contentDescription = "Peta Laut",
                        tint = currentStatusColor,
                        modifier = Modifier.size(40.dp)
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        text = "RADAR ZONA PERAIRAN SUMATERA BARAT",
                        color = Color.White,
                        fontWeight = FontWeight.Bold,
                        fontSize = 13.sp
                    )
                    Text(
                        text = "Koordinat: 0.9492° S, 100.3543° E (Padang)",
                        color = Color.White.copy(alpha = 0.7f),
                        fontSize = 11.sp
                    )
                }
            }
        }
    }
}
