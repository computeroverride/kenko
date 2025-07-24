import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class LogMoodPage extends StatefulWidget {
  const LogMoodPage({super.key});

  @override
  State<LogMoodPage> createState() => _LogMoodPageState();
}

class _LogMoodPageState extends State<LogMoodPage> {
  Map<DateTime, String> moodLog = {};
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  Color? getMoodColor(DateTime day) {
    final mood = moodLog[DateTime(day.year, day.month, day.day)];
    switch (mood) {
      case 'happy':
        return Colors.yellow;
      case 'neutral':
        return Colors.grey;
      case 'sad':
        return Colors.blue;
      default:
        return null;
    }
  }

  void _selectMood(DateTime day) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Select Your Mood"),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.sentiment_very_dissatisfied, color: Colors.blue),
              onPressed: () {
                setState(() {
                  moodLog[DateTime(day.year, day.month, day.day)] = 'sad';
                });
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.sentiment_neutral, color: Colors.grey),
              onPressed: () {
                setState(() {
                  moodLog[DateTime(day.year, day.month, day.day)] = 'neutral';
                });
                Navigator.pop(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.sentiment_very_satisfied, color: Colors.yellow),
              onPressed: () {
                setState(() {
                  moodLog[DateTime(day.year, day.month, day.day)] = 'happy';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
        backgroundColor: const Color.fromRGBO(192, 204, 218, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDay, day),
            onDaySelected: (selected, focused) {
              setState(() {
                selectedDay = selected;
                focusedDay = focused;
              });
              _selectMood(selected);
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, _) {
                final color = getMoodColor(day);
                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
              todayBuilder: (context, day, _) {
                final color = getMoodColor(day) ?? Colors.orange;
                return Container(
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  alignment: Alignment.center,
                  child: Text('${day.day}'),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("Tap any day to log your mood"),
        ],
      ),
    );
  }
}
