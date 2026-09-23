import 'dart:convert';

/// Minimal JWT payload decoder (no signature verification — the tokens come
/// straight from our own auth flow and are only used to read display claims).
class JwtDecoder {
  static Map<String, dynamic>? payload(String? token) {
    if (token == null) return null;
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
