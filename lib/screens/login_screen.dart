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
      } else if (role == UserRole.pembeli) {
        _nameController.text = 'Swalayan Grand Lucky';
        _emailController.text = 'grandlucky@swalayan.com';
        _cityController.text = 'Kota Bukittinggi';
        _addressController.text = 'Jl. Sudirman No. 45, Bukittinggi';
      } else if (role == UserRole.kementerianPerdagangan) {
        _nameController.text = 'Ibu Dra. Hj. Ratna Sari (Kemendag)';
        _emailController.text = 'kemendag@trade.go.id';
        _cityController.text = 'Jakarta Pusat';
        _addressController.text = 'Jl. M.I. Ridwan Rais No. 5';
      } else if (role == UserRole.kurirLogistik) {
        _nameController.text = 'Budi (Sopir Kargo Cold Chain)';
        _emailController.text = 'budi.logistik@netlayan.id';
        _cityController.text = 'Kota Padang';
        _addressController.text = 'Pool Truk Pendingin TPI Muara Padang';
      } else {
        _nameController.text = 'Kapten M. Ridwan (Syahbandar & Verifikator TPI)';
        _emailController.text = 'syahbandar.tpi@netlayan.id';
        _cityController.text = 'Kota Padang';
        _addressController.text = 'Kantor Syahbandar & TPI Muara Padang';
      }
    });
  }

  void _handleLogin() {
    final user = UserModel(
      id: _selectedRole == UserRole.nelayan 
          ? 'nelayan_01' 
          : (_selectedRole == UserRole.pembeli 
              ? 'pembeli_01' 
              : (_selectedRole == UserRole.kementerianPerdagangan 
                  ? 'kemendag_01' 
                  : (_selectedRole == UserRole.kurirLogistik ? 'kurir_01' : 'tpi_01'))),
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      city: _cityController.text.trim(),
      address: _addressController.text.trim(),
      portLocation: _selectedRole == UserRole.nelayan || _selectedRole == UserRole.kurirLogistik || _selectedRole == UserRole.petugasTpi ? _portController.text.trim() : null,
    );

    widget.store.setCurrentUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selamat datang, ${user.name}!'),
        backgroundColor: const Color(0xFF005B96),
      ),
    );
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final isNelayan = _selectedRole == UserRole.nelayan;
    final isPembeli = _selectedRole == UserRole.pembeli;
    final isKemendag = _selectedRole == UserRole.kementerianPerdagangan;
    final isKurir = _selectedRole == UserRole.kurirLogistik;
    final isTpi = _selectedRole == UserRole.petugasTpi;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FA),
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
                    color: const Color(0xFF005B96),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.3),
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
                    color: Color(0xFF005B96),
                  ),
                ),
                const Text(
                  'Koneksi Nelayan & Pembeli Hasil Tangkapan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF00A8CC),
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
                            color: Color(0xFF005B96),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Role Selector Switcher (5 Roles)
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.nelayan),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isNelayan ? const Color(0xFF005B96) : const Color(0xFFE0F7FA),
                                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.phishing,
                                        color: isNelayan ? Colors.white : const Color(0xFF005B96),
                                        size: 15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Nelayan',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isNelayan ? Colors.white : const Color(0xFF005B96),
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
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isPembeli ? const Color(0xFF005B96) : const Color(0xFFE0F7FA),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.storefront,
                                        color: isPembeli ? Colors.white : const Color(0xFF005B96),
                                        size: 15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Pembeli',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isPembeli ? Colors.white : const Color(0xFF005B96),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.kementerianPerdagangan),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isKemendag ? const Color(0xFF005B96) : const Color(0xFFE0F7FA),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.account_balance,
                                        color: isKemendag ? Colors.white : const Color(0xFF005B96),
                                        size: 15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Kemendag',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isKemendag ? Colors.white : const Color(0xFF005B96),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.kurirLogistik),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isKurir ? const Color(0xFF005B96) : const Color(0xFFE0F7FA),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_shipping,
                                        color: isKurir ? Colors.white : const Color(0xFF005B96),
                                        size: 15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Kurir',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isKurir ? Colors.white : const Color(0xFF005B96),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _switchRole(UserRole.petugasTpi),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isTpi ? const Color(0xFF005B96) : const Color(0xFFE0F7FA),
                                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified_user,
                                        color: isTpi ? Colors.white : const Color(0xFF005B96),
                                        size: 15,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Petugas TPI',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: isTpi ? Colors.white : const Color(0xFF005B96),
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
                            labelText: isNelayan ? 'Nama Lengkap Nelayan' : (isTpi ? 'Nama Petugas TPI' : 'Nama Pembeli / Swalayan'),
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF005B96)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Nomor WhatsApp / HP',
                            prefixIcon: const Icon(Icons.phone, color: Color(0xFF005B96)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'Kota / Kabupaten Domisili',
                            prefixIcon: const Icon(Icons.location_city, color: Color(0xFF005B96)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (isNelayan || isTpi) ...[
                          TextField(
                            controller: _portController,
                            decoration: InputDecoration(
                              labelText: 'Lokasi Pelabuhan / Dermaga TPI',
                              prefixIcon: const Icon(Icons.anchor, color: Color(0xFF005B96)),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        TextField(
                          controller: _addressController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            labelText: 'Alamat Lengkap Kantor / Dermaga',
                            prefixIcon: const Icon(Icons.map, color: Color(0xFF005B96)),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005B96),
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
                                'Masuk Sebagai ${_selectedRole.name.toUpperCase()}',
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
