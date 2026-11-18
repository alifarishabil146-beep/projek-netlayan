import 'package:flutter/material.dart';
import 'models/netlayan_models.dart';
import 'providers/netlayan_store.dart';
import 'screens/kemendag_dashboard.dart';
import 'screens/kurir_dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/nelayan_dashboard.dart';
import 'screens/pembeli_dashboard.dart';
import 'screens/tpi_dashboard.dart';

void main() {
  runApp(const NetlayanApp());
}

class NetlayanApp extends StatefulWidget {
  const NetlayanApp({super.key});

  @override
  State<NetlayanApp> createState() => _NetlayanAppState();
}

class _NetlayanAppState extends State<NetlayanApp> {
  final NetlayanStore _store = NetlayanStore();
  bool _isLoggedIn = true; // Default logged-in for instant preview

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NETLAYAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF005B96),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005B96),
          primary: const Color(0xFF005B96),
          secondary: const Color(0xFF00A8CC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8FA),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: AnimatedBuilder(
        animation: _store,
        builder: (context, _) {
          if (!_isLoggedIn || _store.currentUser == null) {
            return LoginScreen(
              store: _store,
              onLoginSuccess: () {
                setState(() {
                  _isLoggedIn = true;
                });
              },
            );
          }

          if (_store.currentUser!.role == UserRole.nelayan) {
            return NelayanDashboard(
              store: _store,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                });
              },
            );
          } else if (_store.currentUser!.role == UserRole.kementerianPerdagangan) {
            return KemendagDashboard(
              store: _store,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                });
              },
            );
          } else if (_store.currentUser!.role == UserRole.kurirLogistik) {
            return KurirDashboard(
              store: _store,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                });
              },
            );
          } else if (_store.currentUser!.role == UserRole.petugasTpi) {
            return TpiDashboard(
              store: _store,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                });
              },
            );
          } else {
            return PembeliDashboard(
              store: _store,
              onLogout: () {
                setState(() {
                  _isLoggedIn = false;
                });
              },
            );
          }
        },
      ),
    );
  }
}

