enum CSSCursor {
  pointer('pointer'),
  grab('grab'),
  defaultCursor(
    'default',
  ), // 'default' is a keyword in Dart, so we use an alias
  help('help'),
  wait('wait'),
  notAllowed('not-allowed');

  // The exact string value used in CSS
  final String value;

  const CSSCursor(this.value);
}
