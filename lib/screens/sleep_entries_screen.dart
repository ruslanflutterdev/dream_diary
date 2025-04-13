import 'package:dream_diary/models/sleep_entry.dart';
import 'package:dream_diary/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'add_sleep_entry_screen.dart';
import 'entry_detail_dialog.dart';

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

  void addOrUpdateEntry(SleepEntry entry, [int? index]) {
    setState(() {
      if (index == null) {
        entries.add(entry);
      } else {
        entries[index] = entry;
      }
    });
    _save();
  }

  void deleteEntry(int index) {
    setState(() {
      entries.removeAt(index);
    });
    _save();
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
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
              'Сон: ${formatDateTime(entry.sleepTime)} —\n${formatDateTime(entry.wakeTime)}',
            ),
            subtitle: Text(
              'Длительность: ${formatDuration(entry.duration)}\nКачество: ${entry.sleepQuality}/5',
            ),
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder:
                    (context) => EntryDetailDialog(
                      entry: entry,
                      onDelete: () => deleteEntry(index),
                      onEdit: (e) => addOrUpdateEntry(e, index),
                    ),
              );
              if (result == true) _save();
            },
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
            addOrUpdateEntry(newEntry);
          }
        },
      ),
    );
  }
}
