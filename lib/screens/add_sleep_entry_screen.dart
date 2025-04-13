import 'package:flutter/material.dart';

import '../models/sleep_entry.dart';

class AddSleepEntryScreen extends StatefulWidget {
  const AddSleepEntryScreen({super.key});

  @override
  State<AddSleepEntryScreen> createState() => _AddSleepEntryScreenState();
}

class _AddSleepEntryScreenState extends State<AddSleepEntryScreen> {
  DateTime sleepTime = DateTime.now().subtract(const Duration(hours: 8));
  DateTime wakeTime = DateTime.now();
  int sleepQuality = 3;
  final TextEditingController noteController = TextEditingController();

  Future<void> pickDateTime({
    required DateTime initialDate,
    required Function(DateTime) onPicked,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (time == null) return;

    onPicked(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  String formatDateTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить запись')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              title: Text('Время сна'),
              subtitle: Text(formatDateTime(sleepTime)),
              onTap:
                  () => pickDateTime(
                    initialDate: sleepTime,
                    onPicked: (dt) => setState(() => sleepTime = dt),
                  ),
            ),
            ListTile(
              title: Text('Время пробуждения'),
              subtitle: Text(formatDateTime(wakeTime)),
              onTap:
                  () => pickDateTime(
                    initialDate: wakeTime,
                    onPicked: (dt) => setState(() => wakeTime = dt),
                  ),
            ),
            SizedBox(height: 20),
            Text('Качество сна: $sleepQuality / 5'),
            Slider(
              value: sleepQuality.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: sleepQuality.toString(),
              onChanged:
                  (value) => setState(() => sleepQuality = value.toInt()),
            ),
            SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Заметки'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  SleepEntry(
                    sleepTime: sleepTime,
                    wakeTime: wakeTime,
                    sleepQuality: sleepQuality,
                    note: noteController.text,
                  ),
                );
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
