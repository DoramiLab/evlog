import '../models/expense.dart';

class SampleData {
  static List<Expense> getExpenses() {
    return [
      // 12일 (오늘)
      Expense(
        id: '1',
        date: DateTime(2025, 1, 12),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: '차지비 | 우리집',
        amount: 12301,
        chargePercent: 56,
        chargeKwh: 4.1,
        locationType: ChargingLocationType.home,
      ),
      Expense(
        id: '2',
        date: DateTime(2025, 1, 12),
        category: ExpenseCategory.maintenance,
        title: '에어컨 필터 교환',
        subtitle: '테슬라 수원 서비스 센터',
        amount: 56000,
      ),
      Expense(
        id: '3',
        date: DateTime(2025, 1, 12),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: '슈퍼차저 판교',
        amount: 14087,
        chargePercent: 14,
        chargeKwh: 0.2,
        locationType: ChargingLocationType.supercharger,
      ),
      // 11일
      Expense(
        id: '4',
        date: DateTime(2025, 1, 11),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: 'SK일렉링크 | 회사',
        amount: 12301,
        chargePercent: 71,
        chargeKwh: 5.6,
        locationType: ChargingLocationType.workplace,
      ),
      Expense(
        id: '5',
        date: DateTime(2025, 1, 11),
        category: ExpenseCategory.other,
        title: '톨게이트',
        subtitle: '판교IC',
        amount: 500,
      ),
      // 8일
      Expense(
        id: '6',
        date: DateTime(2025, 1, 8),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: '차지비 | 우리집',
        amount: 12301,
        chargePercent: 56,
        chargeKwh: 4.1,
        locationType: ChargingLocationType.home,
      ),
      Expense(
        id: '7',
        date: DateTime(2025, 1, 8),
        category: ExpenseCategory.maintenance,
        title: '에어컨 필터 교환',
        subtitle: '테슬라 수원 서비스 센터',
        amount: 56000,
      ),
      // 3일
      Expense(
        id: '8',
        date: DateTime(2025, 1, 3),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: '슈퍼차저 강남',
        amount: 5900,
        chargePercent: 45,
        chargeKwh: 3.2,
        locationType: ChargingLocationType.supercharger,
      ),
      // 1일
      Expense(
        id: '9',
        date: DateTime(2025, 1, 1),
        category: ExpenseCategory.charging,
        title: '충전',
        subtitle: '차지비 | 우리집',
        amount: 12301,
        chargePercent: 80,
        chargeKwh: 6.5,
        locationType: ChargingLocationType.home,
      ),
    ];
  }

  static int getTotalExpense(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  static double getAverageEfficiency(List<Expense> expenses) {
    // 평균 전비 계산 (간단히 6.4로 고정)
    return 6.4;
  }

  static Map<DateTime, List<Expense>> groupByDate(List<Expense> expenses) {
    final Map<DateTime, List<Expense>> grouped = {};
    for (final expense in expenses) {
      final dateOnly = DateTime(expense.date.year, expense.date.month, expense.date.day);
      if (!grouped.containsKey(dateOnly)) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(expense);
    }
    return grouped;
  }

  static Map<DateTime, int> getDailyTotals(List<Expense> expenses) {
    final grouped = groupByDate(expenses);
    return grouped.map((date, list) => MapEntry(
      date,
      list.fold(0, (sum, e) => sum + e.amount),
    ));
  }
}
