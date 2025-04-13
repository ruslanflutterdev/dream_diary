import 'package:dream_diary/widgets/sleep_quality_selector.dart';
import 'package:flutter/material.dart';
import '../models/sleep_entry.dart';

class AddSleepEntryScreen extends StatefulWidget {
  const AddSleepEntryScreen({Key? key}) : super(key: key);

  @override
  _AddSleepEntryScreenState createState() => _AddSleepEntryScreenState();
}

class _AddSleepEntryScreenState extends State<AddSleepEntryScreen> {
  DateTime? sleepTime;
  DateTime? wakeTime;
  int sleepQuality = 3;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dreamController = TextEditingController();

  void _pickDateTime({required bool isSleepTime}) async {
    final DateTime now = DateTime.now();
    final DateTime picked =
        await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now.subtract(Duration(days: 1)),
          lastDate: now.add(Duration(days: 1)),
        ) ??
        now;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (pickedTime != null) {
      final selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      setState(() {
        if (isSleepTime) {
          sleepTime = selectedDateTime;
        } else {
          wakeTime = selectedDateTime;
        }
      });
    }
  }

  bool _isValidEntry() {
    if (sleepTime == null ||
        wakeTime == null ||
        sleepTime!.isAfter(wakeTime!)) {
      return false;
    }
    if (wakeTime!.difference(sleepTime!).inDays > 0) {
      return false;
    }
    return true;
  }

  void _saveEntry() {
    if (_isValidEntry()) {
      final newEntry = SleepEntry(
        sleepTime: sleepTime!,
        wakeTime: wakeTime!,
        sleepQuality: sleepQuality,
        note: noteController.text,
      );
      Navigator.pop(context, newEntry);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверные данные! Проверьте время.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Добавить запись сна')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Время отхода ко сну'),
              trailing: Text(
                sleepTime != null
                    ? '${sleepTime!.hour}:${sleepTime!.minute}'
                    : 'Не выбрано',
              ),
              onTap: () => _pickDateTime(isSleepTime: true),
            ),
            ListTile(
              title: Text('Время пробуждения'),
              trailing: Text(
                wakeTime != null
                    ? '${wakeTime!.hour}:${wakeTime!.minute}'
                    : 'Не выбрано',
              ),
              onTap: () => _pickDateTime(isSleepTime: false),
            ),
            SizedBox(height: 20),
            Text(
              'Качество сна',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SleepQualitySelector(
              currentQuality: sleepQuality,
              onQualityChanged: (newQuality) {
                setState(() {
                  sleepQuality = newQuality;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Заметки о сне:'),
            TextField(
              controller: noteController,
              decoration: InputDecoration(hintText: 'Запишите заметки'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            Text('Ваши сны:'),
            TextField(
              controller: dreamController,
              decoration: InputDecoration(hintText: 'Запишите свои сны'),
              maxLines: 5,
            ),
            Spacer(),
            ElevatedButton(onPressed: _saveEntry, child: Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}
