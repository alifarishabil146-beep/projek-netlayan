import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'models/netlayan_models.dart';
import 'providers/netlayan_store.dart';
import 'screens/kemendag_dashboard.dart';
import 'screens/kurir_dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/nelayan_dashboard.dart';
import 'screens/pembeli_dashboard.dart';
import 'screens/tpi_dashboard.dart';
import 'theme/netlayan_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
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
      theme: NetlayanTheme.getThemeForRole(_store.currentUser?.role),
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
