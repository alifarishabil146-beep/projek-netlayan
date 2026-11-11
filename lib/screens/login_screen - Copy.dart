import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class LoginScreen extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.store,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.nelayan;
  final _nameController = TextEditingController(text: 'Pak Syamsul');
  final _emailController = TextEditingController(text: 'syamsul@netlayan.id');
  final _phoneController = TextEditingController(text: '081267890123');
  final _cityController = TextEditingController(text: 'Kota Padang');
  final _addressController = TextEditingController(text: 'Jl. Dermaga TPI Muara Padang No. 12');
  final _portController = TextEditingController(text: 'Pelabuhan Muara Padang');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _switchRole(UserRole role) {
    setState(() {
      _selectedRole = role;
      if (role == UserRole.nelayan) {
        _nameController.text = 'Pak Syamsul (Nelayan)';
        _emailController.text = 'syamsul@netlayan.id';
        _cityController.text = 'Kota Padang';
        _addressController.text = 'Jl. Dermaga TPI Muara Padang No. 12';
      } else {
        _nameController.text = 'Swalayan Grand Lucky';
        _emailController.text = 'grandlucky@swalayan.com';
        _cityController.text = 'Kota Bukittinggi';
        _addressController.text = 'Jl. Sudirman No. 45, Bukittinggi';
      }
    });
  }

  void _handleLogin() {
    final user = UserModel(
      id: _selectedRole == UserRole.nelayan ? 'nelayan_01' : 'pembeli_01',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      portLocation: _selectedRole == UserRole.nelayan ? _portController.text.trim() : null,
    );

    widget.store.setCurrentUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selamat datang, ${user.name}! (Role: ${user.role == UserRole.nelayan ? 'Nelayan' : 'Pembeli/Swalayan'})'),
        backgroundColor: const Color(0xFFE91E63),
      ),
    );
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isNelayan = _selectedRole == UserRole.nelayan;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo & Title
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.sailing,
                    size: 54,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'NETLAYAN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color(0xFFE91E63),
                  ),
                ),
                const Text(
                  'Koneksi Nelayan & Pembeli Hasil Tangkapan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFAD1457),
                  ),
                ),
                const SizedBox(height: 32),

                // Card Container
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Pilih Peran Akun',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF880E4F),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Role Selector Switcher
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.nelayan),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isNelayan ? const Color(0xFFE91E63) : const Color(0xFFFCE4EC),
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.phishing,
                                        color: isNelayan ? Colors.white : const Color(0xFFC2185B),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Nelayan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isNelayan ? Colors.white : const Color(0xFFC2185B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.pembeli),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !isNelayan ? const Color(0xFFEC407A) : const Color(0xFFFCE4EC),
                                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.storefront,
                                        color: !isNelayan ? Colors.white : const Color(0xFFC2185B),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Pembeli / Swalayan',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: !isNelayan ? Colors.white : const Color(0xFFC2185B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Input Fields
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: isNelayan ? 'Nama Lengkap Nelayan' : 'Nama Pembeli / Nama Swalayan',
                            prefixIcon: const Icon(Icons.person, color: Color(0xFFE91E63)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Nomor WhatsApp / HP',
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFFE91E63)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: isNelayan ? 'Kota / Kabupaten Domisili' : 'Kota Tujuan Pengiriman (Bisa Luar Kota)',
                            prefixIcon: const Icon(Icons.location_city, color: Color(0xFFE91E63)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (isNelayan) ...[
                          TextField(
                            controller: _portController,
                            decoration: InputDecoration(
                              labelText: 'Lokasi Pelabuhan / Dermaga Tangkapan',
                              prefixIcon: const Icon(Icons.anchor, color: Color(0xFFE91E63)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Alamat Lengkap',
                            prefixIcon: const Icon(Icons.map, color: Color(0xFFE91E63)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isNelayan ? const Color(0xFFE91E63) : const Color(0xFFEC407A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isNelayan ? 'Masuk Sbg Nelayan' : 'Masuk Sbg Pembeli',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
