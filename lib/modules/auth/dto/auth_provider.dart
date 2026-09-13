/// Identity providers configured in Keycloak; [idpHint] is passed as
/// `kc_idp_hint` so Keycloak skips its own login page.
enum AuthProvider {
  google('google', 'auth.continueWithGoogle'),
  facebook('facebook', 'auth.continueWithFacebook');

  const AuthProvider(this.idpHint, this.labelKey);

  final String idpHint;
  final String labelKey;
}
