import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../data/sample_data.dart';
import '../widgets/expense_item.dart';
import '../widgets/category_filter.dart';
import '../widgets/view_toggle.dart';
import '../widgets/calendar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ViewMode _viewMode = ViewMode.list;
  Set<ExpenseCategory> _selectedCategories = {
    ExpenseCategory.charging,
    ExpenseCategory.maintenance,
  };
  DateTime _selectedMonth = DateTime(2025, 1);
  DateTime? _selectedDate;

  late List<Expense> _allExpenses;
  late List<Expense> _filteredExpenses;

  @override
  void initState() {
    super.initState();
    _allExpenses = SampleData.getExpenses();
    _filterExpenses();
  }

  void _filterExpenses() {
    setState(() {
      _filteredExpenses = _allExpenses.where((e) {
        if (_selectedCategories.isEmpty) return true;
        return _selectedCategories.contains(e.category);
      }).toList();
      _filteredExpenses.sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _toggleCategory(ExpenseCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filterExpenses();
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalExpense = SampleData.getTotalExpense(_filteredExpenses);
    final avgEfficiency = SampleData.getAverageEfficiency(_filteredExpenses);
    final groupedExpenses = SampleData.groupByDate(_filteredExpenses);
    final dailyTotals = SampleData.getDailyTotals(_filteredExpenses);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSummary(totalExpense, avgEfficiency),
            _buildControls(),
            Expanded(
              child: _viewMode == ViewMode.list
                  ? _buildListView(groupedExpenses)
                  : _buildCalendarView(dailyTotals, groupedExpenses),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'MyEV',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(int totalExpense, double avgEfficiency) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          // 월 선택
          Expanded(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeMonth(-1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 4),
                Column(
                  children: [
                    Text(
                      '${_selectedMonth.year}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${_selectedMonth.month}월',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeMonth(1),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          // 지출
          Expanded(
            child: Column(
              children: [
                Text(
                  '지출',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  _formatAmount(totalExpense),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // 평균 전비
          Expanded(
            child: Column(
              children: [
                Text(
                  '평균 전비',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: avgEfficiency.toStringAsFixed(1)),
                      const TextSpan(
                        text: ' km/kWh',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ViewToggle(
            currentMode: _viewMode,
            onChanged: (mode) => setState(() => _viewMode = mode),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CategoryFilter(
              selectedCategories: _selectedCategories,
              onToggle: _toggleCategory,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: IconButton(
              icon: const Icon(Icons.add, size: 20),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(Map<DateTime, List<Expense>> groupedExpenses) {
    final sortedDates = groupedExpenses.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final expenses = groupedExpenses[date]!;
        final dayTotal = expenses.fold(0, (sum, e) => sum + e.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date, dayTotal),
            ...expenses.map((e) => ExpenseItem(expense: e)),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date, int total) {
    final now = DateTime(2025, 1, 12);
    final isToday = date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;

    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    final weekday = weekdays[date.weekday - 1];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isToday ? '${date.day}일 오늘' : '${date.day}일 ${weekday}요일',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            _formatAmount(total),
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(
    Map<DateTime, int> dailyTotals,
    Map<DateTime, List<Expense>> groupedExpenses,
  ) {
    List<Expense> selectedDateExpenses = [];
    if (_selectedDate != null) {
      selectedDateExpenses = groupedExpenses[_selectedDate] ?? [];
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CalendarView(
            selectedMonth: _selectedMonth,
            selectedDate: _selectedDate,
            dailyTotals: dailyTotals,
            onDateSelected: (date) {
              setState(() => _selectedDate = date);
            },
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedDate != null) ...[
          _buildDateHeader(
            _selectedDate!,
            selectedDateExpenses.fold(0, (sum, e) => sum + e.amount),
          ),
          Expanded(
            child: ListView(
              children: selectedDateExpenses
                  .map((e) => ExpenseItem(expense: e))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }

  String _formatAmount(int amount) {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted원';
  }
}
