import 'dart:convert';
import 'dart:io';

/// Sorts i18n JSON files alphabetically by key (case-insensitive).
///
/// Usage:
///   dart run tool/sort_i18n.dart [directory]
///
/// Defaults to `assets/i18n` relative to the project root.
void main(List<String> args) {
  final directory = Directory(args.isNotEmpty ? args[0] : 'assets/i18n');

  if (!directory.existsSync()) {
    stderr.writeln('Directory not found: ${directory.path}');
    exit(1);
  }

  final files = directory
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.json'))
      .toList();

  if (files.isEmpty) {
    stderr.writeln('No JSON files found in ${directory.path}');
    exit(1);
  }

  for (final file in files) {
    final contents = file.readAsStringSync();
    final decoded = jsonDecode(contents);
    if (decoded is! Map<String, dynamic>) {
      stdout.writeln('Skipping file (not a translations map): ${file.path}');
      continue;
    }

    stdout.writeln('Sorting file: ${file.path}');

    final translations = decoded;
    final keys = translations.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    const encoder = JsonEncoder.withIndent('  ');
    final sorted = encoder.convert({
      for (final key in keys) key: translations[key],
    });
    file.writeAsStringSync('$sorted\n');
  }
}
