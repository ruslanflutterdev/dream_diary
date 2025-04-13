import 'package:flutter/material.dart';
import '../models/sleep_entry.dart';

class AddSleepEntryScreen extends StatefulWidget {
  const AddSleepEntryScreen({super.key});

  @override
  State<AddSleepEntryScreen> createState() => _AddSleepEntryScreenState();
}

class _AddSleepEntryScreenState extends State<AddSleepEntryScreen> {
  DateTime sleepTime = DateTime.now().subtract(Duration(hours: 8));
  DateTime wakeTime = DateTime.now();
  int sleepQuality = 3;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dreamController = TextEditingController();

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
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void saveEntry() {
    final duration = wakeTime.difference(sleepTime);
    if (wakeTime.isBefore(sleepTime)) {
      showError('Время пробуждения не может быть раньше времени сна.');
      return;
    }
    if (duration.inHours > 24) {
      showError('Время сна не может превышать 24 часа.');
      return;
    }

    Navigator.pop(
      context,
      SleepEntry(
        sleepTime: sleepTime,
        wakeTime: wakeTime,
        sleepQuality: sleepQuality,
        note: '${noteController.text}\nСны: ${dreamController.text}',
      ),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ОК'),
          )
        ],
      ),
    );
  }

  Widget buildQualityButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (i) {
        final rating = i + 1;
        final isSelected = rating == sleepQuality;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
            foregroundColor: isSelected ? Colors.white : Colors.black,
          ),
          onPressed: () {
            setState(() {
              sleepQuality = rating;
            });
          },
          child: Text('$rating'),
        );
      }),
    );
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
              onTap: () => pickDateTime(
                initialDate: sleepTime,
                onPicked: (dt) => setState(() => sleepTime = dt),
              ),
            ),
            ListTile(
              title: Text('Время пробуждения'),
              subtitle: Text(formatDateTime(wakeTime)),
              onTap: () => pickDateTime(
                initialDate: wakeTime,
                onPicked: (dt) => setState(() => wakeTime = dt),
              ),
            ),
            SizedBox(height: 20),
            Text('Качество сна:', style: TextStyle(fontSize: 16)),
            buildQualityButtons(),
            SizedBox(height: 20),
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Заметки',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            TextField(
              controller: dreamController,
              decoration: InputDecoration(
                labelText: 'Сны',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveEntry,
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}