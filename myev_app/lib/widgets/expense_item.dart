import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.displayTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  expense.subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            expense.formattedAmount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    if (expense.category == ExpenseCategory.charging && expense.locationType != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: expense.locationType!.backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          expense.locationType!.icon,
          color: expense.locationType!.iconColor,
          size: 24,
        ),
      );
    } else if (expense.category == ExpenseCategory.maintenance) {
      return Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFFFCDD2),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.build,
          color: Color(0xFFD32F2F),
          size: 24,
        ),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.receipt_long,
          color: Colors.grey[600],
          size: 24,
        ),
      );
    }
  }
}
