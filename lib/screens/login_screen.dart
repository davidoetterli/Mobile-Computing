import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String? _accessToken;
  String? _idToken;
  String? _refreshToken;

  // Konfiguration der Authentifizierung
  final String _clientId = 'backend-service';
  final String _redirectUrl = 'ch.hftm.blogapp:/oauthredirect';
  final String _issuer = 'http://10.0.2.2:8180';
  final String _discoveryUrl = 'http://10.0.2.2:8180/.well-known/openid-configuration';

  Future<void> _login() async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          discoveryUrl: _discoveryUrl,
          scopes: ['openid', 'profile', 'email', 'offline_access'],
        ),
      );

      if (result != null) {
        setState(() {
          _accessToken = result.accessToken;
          _idToken = result.idToken;
          _refreshToken = result.refreshToken;
        });

        // Speichere Tokens sicher
        await _secureStorage.write(key: 'access_token', value: _accessToken);
        await _secureStorage.write(key: 'id_token', value: _idToken);
        await _secureStorage.write(key: 'refresh_token', value: _refreshToken);
      }
    } catch (e) {
      print('Login failed: $e');
    }
  }

  Future<void> _logout() async {
    setState(() {
      _accessToken = null;
      _idToken = null;
      _refreshToken = null;
    });

    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'id_token');
    await _secureStorage.delete(key: 'refresh_token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter AppAuth Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_accessToken != null) ...[
              const Text('Login successful!'),
              const SizedBox(height: 20),
              Text('Access Token: $_accessToken'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _logout,
                child: const Text('LOGOUT'),
              ),
            ] else ...[
              const Text('Please login'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('LOGIN'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}