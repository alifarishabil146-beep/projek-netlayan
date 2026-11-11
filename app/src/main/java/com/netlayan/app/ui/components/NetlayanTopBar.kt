package com.netlayan.app.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Anchor
import androidx.compose.material.icons.filled.ShoppingCart
import androidx.compose.material3.Badge
import androidx.compose.material3.BadgedBox
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.netlayan.app.model.UserRole
import com.netlayan.app.ui.theme.OceanBluePrimary
import com.netlayan.app.ui.theme.OceanBlueSecondary

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun NetlayanTopBar(
    title: String,
    userRole: UserRole? = null,
    cartItemCount: Int = 0,
    canNavigateBack: Boolean = false,
    onNavigateBack: () -> Unit = {},
    onCartClick: () -> Unit = {}
) {
    TopAppBar(
        title = {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(
                    imageVector = Icons.Default.Anchor,
                    contentDescription = "Netlayan Logo",
                    tint = Color.White,
                    modifier = Modifier.size(24.dp)
                )
                Spacer(modifier = Modifier.width(8.dp))
                Text(
                    text = title,
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 18.sp
                )
                if (userRole != null) {
                    Spacer(modifier = Modifier.width(10.dp))
                    Box(
                        modifier = Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .background(
                                when (userRole) {
                                    UserRole.NELAYAN -> OceanBlueSecondary
                                    UserRole.PEMBELI -> Color(0xFFF4A261)
                                    UserRole.KEMENTERIAN_PERDAGANGAN -> Color(0xFF2A9D8F)
                                }
                            )
                            .padding(horizontal = 8.dp, vertical = 2.dp)
                    ) {
                        Text(
                            text = when (userRole) {
                                UserRole.NELAYAN -> "NELAYAN"
                                UserRole.PEMBELI -> "PEMBELI"
                                UserRole.KEMENTERIAN_PERDAGANGAN -> "KEMENDAG"
                            },
                            color = Color.White,
                            fontSize = 10.sp,
                            fontWeight = FontWeight.Bold
                        )
                    }
                }
            }
        },
        navigationIcon = {
            if (canNavigateBack) {
                IconButton(onClick = onNavigateBack) {
                    Icon(
                        imageVector = Icons.AutoMirrored.Filled.ArrowBack,
                        contentDescription = "Kembali",
                        tint = Color.White
                    )
                }
            }
        },
        actions = {
            if (userRole == UserRole.PEMBELI || userRole == UserRole.KEMENTERIAN_PERDAGANGAN) {
                IconButton(onClick = onCartClick) {
                    BadgedBox(
                        badge = {
                            if (cartItemCount > 0) {
                                Badge(containerColor = MaterialTheme.colorScheme.tertiary) {
                                    Text(
                                        text = cartItemCount.toString(),
                                        color = Color.Black,
                                        fontWeight = FontWeight.Bold
                                    )
                                }
                            }
                        }
                    ) {
                        Icon(
                            imageVector = Icons.Default.ShoppingCart,
                            contentDescription = "Keranjang Belanja",
                            tint = Color.White
                        )
                    }
                }
            }
        },
        colors = TopAppBarDefaults.topAppBarColors(
            containerColor = OceanBluePrimary
        )
    )
}
