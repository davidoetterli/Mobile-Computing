import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KeycloakAuthService {
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  final String _clientId = 'backend-service';
  final String _redirectUri = 'com.hftm.blogapp:/oauth2redirect';
  final String _issuer = 'http://10.0.2.2:8180/realms/blog';
  final String _discoveryUrl = 'http://10.0.2.2:8180/realms/blog/.well-known/openid-configuration';
  String? _accessToken;

  Future<void> login() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUri,
          discoveryUrl: _discoveryUrl,
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (result != null) {
        _accessToken = result.accessToken;
        print('Access Token: $_accessToken');
        // Weiterverarbeitung des Tokens, z.B. Speichern oder Verwendung in API-Calls
      }
    } catch (e) {
      print('Login-Fehler: $e');
    }
  }

  Future<void> fetchSecureData() async {
    if (_accessToken == null) {
      print('Kein Access Token vorhanden');
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8180/api/secure-endpoint'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('Daten: ${response.body}');
    } else {
      print('Fehler: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    // Hier könntest du die Abmeldung implementieren, z.B. durch das Löschen des Access Tokens
    _accessToken = null;
    print('Abgemeldet');
  }

  String? getAccessToken() {
    return _accessToken;
  }
}
