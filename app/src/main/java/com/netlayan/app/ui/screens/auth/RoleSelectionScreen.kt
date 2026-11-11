package com.netlayan.app.ui.screens.auth

import androidx.compose.foundation.Image
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Anchor
import androidx.compose.material.icons.filled.PhonelinkRing
import androidx.compose.material.icons.filled.Sailing
import androidx.compose.material.icons.filled.Storefront
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.netlayan.app.model.UserRole
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary
import com.netlayan.app.ui.theme.SandyGold

@Composable
fun RoleSelectionScreen(
    onSelectRole: (UserRole) -> Unit
) {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .background(OceanBluePrimary)
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Box(
            modifier = Modifier
                .size(100.dp)
                .clip(CircleShape)
                .background(Color.White.copy(alpha = 0.2f)),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = Icons.Default.Anchor,
                contentDescription = null,
                tint = Color.White,
                modifier = Modifier.size(60.dp)
            )
        }

        Spacer(modifier = Modifier.height(16.dp))

        Text(
            text = "NETLAYAN",
            color = Color.White,
            fontWeight = FontWeight.ExtraBold,
            fontSize = 32.sp
        )

        Text(
            text = "Digitalisasi Hasil Tangkapan & Cuaca Laut",
            color = Color.White.copy(alpha = 0.8f),
            fontSize = 14.sp,
            textAlign = TextAlign.Center
        )

        Spacer(modifier = Modifier.height(28.dp))

        Text(
            text = "PILIH PERAN ANDA UNTUK MASUK",
            color = SandyGold,
            fontWeight = FontWeight.Bold,
            fontSize = 13.sp,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        RoleOptionCard(
            title = "SAYA SEBAGAI NELAYAN",
            description = "Upload foto hasil tangkapan, navigasi cuaca laut interaktif, & kelola pesanan",
            icon = Icons.Default.Sailing,
            accentColor = OceanBlueSecondary,
            onClick = { onSelectRole(UserRole.NELAYAN) }
        )

        Spacer(modifier = Modifier.height(12.dp))

        RoleOptionCard(
            title = "SAYA SEBAGAI PEMBELI / SWALAYAN",
            description = "Beli ikan segar dari nelayan Padang, opsi kirim luar kota, & bayar QRIS",
            icon = Icons.Default.Storefront,
            accentColor = SandyGold,
            onClick = { onSelectRole(UserRole.PEMBELI) }
        )

        Spacer(modifier = Modifier.height(12.dp))

        RoleOptionCard(
            title = "SAYA SEBAGAI KEMENTERIAN PERDAGANGAN",
            description = "Pantau distribusi pangan, harga komoditas ikan, & laporan logistik kargo",
            icon = Icons.Default.Storefront,
            accentColor = Color(0xFF2A9D8F),
            onClick = { onSelectRole(UserRole.KEMENTERIAN_PERDAGANGAN) }
        )
    }
}

@Composable
private fun RoleOptionCard(
    title: String,
    description: String,
    icon: ImageVector,
    accentColor: Color,
    onClick: () -> Unit
) {
    Card(
        onClick = onClick,
        modifier = Modifier.fillMaxWidth(),
        shape = RoundedCornerShape(16.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
        elevation = CardDefaults.cardElevation(defaultElevation = 6.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Box(
                modifier = Modifier
                    .size(46.dp)
                    .clip(CircleShape)
                    .background(accentColor.copy(alpha = 0.2f)),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    imageVector = icon,
                    contentDescription = null,
                    tint = accentColor,
                    modifier = Modifier.size(24.dp)
                )
            }

            Spacer(modifier = Modifier.width(16.dp))

            Column(modifier = Modifier.weight(1f)) {
                Text(
                    text = title,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp,
                    color = OceanBluePrimary
                )
                Spacer(modifier = Modifier.height(2.dp))
                Text(
                    text = description,
                    fontSize = 11.sp,
                    color = Color.Gray,
                    lineHeight = 15.sp
                )
            }
        }
    }
}
