import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final Map<DateTime, int> dailyTotals;
  final Function(DateTime) onDateSelected;

  const CalendarView({
    super.key,
    required this.selectedMonth,
    required this.selectedDate,
    required this.dailyTotals,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildWeekdayHeader(),
        const SizedBox(height: 8),
        _buildCalendarGrid(),
      ],
    );
  }

  Widget _buildWeekdayHeader() {
    const weekdays = ['일', '월', '화', '수', '목', '금', '토'];
    return Row(
      children: weekdays.map((day) {
        Color color = Colors.grey[600]!;
        if (day == '일') color = Colors.red[400]!;
        if (day == '토') color = Colors.blue[400]!;
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    final lastDayOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    final List<Widget> rows = [];
    List<Widget> currentRow = [];

    // 첫 주 빈 칸
    for (int i = 0; i < firstWeekday; i++) {
      currentRow.add(const Expanded(child: SizedBox()));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(selectedMonth.year, selectedMonth.month, day);
      final isSelected = selectedDate != null &&
          selectedDate!.year == date.year &&
          selectedDate!.month == date.month &&
          selectedDate!.day == date.day;
      final total = dailyTotals[date];
      final weekday = date.weekday;

      currentRow.add(
        Expanded(
          child: _buildDayCell(day, isSelected, total, weekday),
        ),
      );

      if (currentRow.length == 7) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(children: currentRow),
          ),
        );
        currentRow = [];
      }
    }

    // 마지막 주 빈 칸
    if (currentRow.isNotEmpty) {
      while (currentRow.length < 7) {
        currentRow.add(const Expanded(child: SizedBox()));
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(children: currentRow),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(int day, bool isSelected, int? total, int weekday) {
    final date = DateTime(selectedMonth.year, selectedMonth.month, day);

    Color textColor = Colors.black;
    if (weekday == 7) textColor = Colors.red[400]!;
    if (weekday == 6) textColor = Colors.blue[400]!;

    return GestureDetector(
      onTap: () => onDateSelected(date),
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF1565C0),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
            if (total != null)
              Text(
                _formatAmount(total),
                style: TextStyle(
                  color: isSelected ? Colors.white70 : const Color(0xFF1565C0),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
