import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/sleep_entry.dart';

class StorageService {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/sleep_entries.json');
  }

  Future<List<SleepEntry>> loadEntries() async {
    final file = await _localFile;
    if (await file.exists()) {
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => SleepEntry.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> saveEntries(List<SleepEntry> entries) async {
    final file = await _localFile;
    final jsonString = json.encode(entries.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonString);
  }
}
