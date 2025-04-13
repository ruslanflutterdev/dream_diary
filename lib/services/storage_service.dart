import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/sleep_entry.dart';

class StorageService {

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/sleep_entries.json');
  }

  Future<List<SleepEntry>> loadEntries() async {
    final file = await _getLocalFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final List decoded = jsonDecode(content);
      return decoded.map((e) => SleepEntry.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveEntries(List<SleepEntry> entries) async {
    final file = await _getLocalFile();
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await file.writeAsString(encoded);
  }
}