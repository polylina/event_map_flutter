// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:crypto/crypto.dart';

void redirectToUrl(String url) {
  html.window.location.href = url;
}

Map<String, String> getWebQueryParams() {
  final uri = Uri.parse(html.window.location.href);
  return uri.queryParameters;
}

void clearWebQueryParams() {
  final uri = Uri.parse(html.window.location.href);
  final cleanUri = uri.removeFragment().replace(queryParameters: {});
  html.window.history.replaceState(null, '', cleanUri.toString());
}

({String codeVerifier, String codeChallenge}) getChallenges() {
  final randomBytes = List<int>.generate(
    32,
    (_) => Random.secure().nextInt(256),
  );
  final codeVerifier = base64Url.encode(randomBytes).replaceAll('=', '');
  final challengeBytes = sha256.convert(utf8.encode(codeVerifier)).bytes;
  final codeChallenge = base64Url.encode(challengeBytes).replaceAll('=', '');
  return (codeVerifier: codeVerifier, codeChallenge: codeChallenge);
}
