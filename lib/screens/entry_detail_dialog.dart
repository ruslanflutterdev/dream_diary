import 'package:flutter/material.dart';
import '../models/sleep_entry.dart';
import 'add_sleep_entry_screen.dart';

class EntryDetailDialog extends StatelessWidget {
  final SleepEntry entry;
  final VoidCallback onDelete;
  final Function(SleepEntry) onEdit;

  const EntryDetailDialog({
    super.key,
    required this.entry,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Информация о сне'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Время сна: ${entry.sleepTime}'),
          Text('Время пробуждения: ${entry.wakeTime}'),
          Text('Качество сна: ${entry.sleepQuality}/5'),
          SizedBox(height: 10),
          Text('Заметки:'),
          Text(entry.note),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Закрыть'),
        ),
        TextButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSleepEntryScreen()),
            );
            if (result != null && result is SleepEntry) {
              onEdit(result);
              Navigator.pop(context, true);
            }
          },
          child: Text('Редактировать'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: Text('Удалить'),
        ),
      ],
    );
  }
}
