import 'package:dream_diary/models/sleep_entry.dart';
import 'package:dream_diary/services/storage_service.dart';
import 'package:flutter/material.dart';

import 'add_sleep_entry_screen.dart';

class SleepEntriesScreen extends StatefulWidget {
  const SleepEntriesScreen({super.key});

  @override
  State<SleepEntriesScreen> createState() => _SleepEntriesScreenState();
}

class _SleepEntriesScreenState extends State<SleepEntriesScreen> {
  final StorageService _storageService = StorageService();
  List<SleepEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final loaded = await _storageService.loadEntries();
    setState(() {
      entries = loaded;
    });
  }

  void _save() {
    _storageService.saveEntries(entries);
  }

  void addEntry(SleepEntry entry) {
    setState(() {
      entries.add(entry);
    });
    _save();
  }

  String formatDateTime(DateTime dateTime) {
    final date =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    final time =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return '${hours}ч ${minutes}м';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Дневник сна')),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          return ListTile(
            title: Text(
              'Сон: ${formatDateTime(entry.sleepTime)} — ${formatDateTime(entry.wakeTime)}',
            ),
            subtitle: Text(
              'Качество: ${entry.sleepQuality}/5\n'
              '${entry.note}\n'
              'Длительность: ${formatDuration(entry.duration)}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newEntry = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSleepEntryScreen()),
          );
          if (newEntry != null && newEntry is SleepEntry) {
            addEntry(newEntry);
          }
        },
      ),
    );
  }
}
