package com.netlayan.app.ui.screens.auth

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Email
import androidx.compose.material.icons.filled.Lock
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.netlayan.app.model.UserRole
import com.netlayan.app.ui.theme.OceanBluePrimary

@Composable
fun LoginScreen(
    initialRole: UserRole,
    onLoginSuccess: (UserRole) -> Unit,
    onNavigateRegister: (UserRole) -> Unit
) {
    var email by remember {
        mutableStateOf(
            when (initialRole) {
                UserRole.NELAYAN -> "pakhrul@netlayan.com"
                UserRole.PEMBELI -> "swalayan@bintang.com"
                UserRole.KEMENTERIAN_PERDAGANGAN -> "kemendag@ri.go.id"
            }
        )
    }
    var password by remember { mutableStateOf("123456") }
    var selectedRole by remember { mutableStateOf(initialRole) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Spacer(modifier = Modifier.height(40.dp))

        Text(
            text = "Masuk ke NETLAYAN",
            fontWeight = FontWeight.Bold,
            fontSize = 26.sp,
            color = OceanBluePrimary
        )

        Text(
            text = "Silakan masuk untuk mengakses fitur aplikasi",
            fontSize = 13.sp,
            color = Color.Gray,
            modifier = Modifier.padding(top = 4.dp, bottom = 24.dp)
        )

        // Role Selector Radio
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .background(OceanBluePrimary.copy(alpha = 0.08f), shape = RoundedCornerShape(12.dp))
                .padding(4.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.weight(1f)
            ) {
                RadioButton(
                    selected = selectedRole == UserRole.NELAYAN,
                    onClick = {
                        selectedRole = UserRole.NELAYAN
                        email = "pakhrul@netlayan.com"
                    }
                )
                Text(text = "Nelayan", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
            }

            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.weight(1f)
            ) {
                RadioButton(
                    selected = selectedRole == UserRole.PEMBELI,
                    onClick = {
                        selectedRole = UserRole.PEMBELI
                        email = "swalayan@bintang.com"
                    }
                )
                Text(text = "Pembeli", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
            }

            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.weight(1f)
            ) {
                RadioButton(
                    selected = selectedRole == UserRole.KEMENTERIAN_PERDAGANGAN,
                    onClick = {
                        selectedRole = UserRole.KEMENTERIAN_PERDAGANGAN
                        email = "kemendag@ri.go.id"
                    }
                )
                Text(text = "Kemendag", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        OutlinedTextField(
            value = email,
            onValueChange = { email = it },
            label = { Text("Email / No. Telepon") },
            leadingIcon = { Icon(Icons.Default.Email, contentDescription = null) },
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp)
        )

        Spacer(modifier = Modifier.height(12.dp))

        OutlinedTextField(
            value = password,
            onValueChange = { password = it },
            label = { Text("Kata Sandi") },
            leadingIcon = { Icon(Icons.Default.Lock, contentDescription = null) },
            visualTransformation = PasswordVisualTransformation(),
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp)
        )

        Spacer(modifier = Modifier.height(28.dp))

        Button(
            onClick = { onLoginSuccess(selectedRole) },
            modifier = Modifier
                .fillMaxWidth()
                .height(50.dp),
            shape = RoundedCornerShape(12.dp),
            colors = ButtonDefaults.buttonColors(containerColor = OceanBluePrimary)
        ) {
            Text(text = "MASUK SEKARANG", fontWeight = FontWeight.Bold, fontSize = 16.sp)
        }

        Spacer(modifier = Modifier.height(16.dp))

        TextButton(onClick = { onNavigateRegister(selectedRole) }) {
            Text(
                text = "Belum punya akun? Daftar Sekarang",
                color = OceanBluePrimary,
                fontWeight = FontWeight.SemiBold
            )
        }
    }
}
