import 'package:flutter/material.dart';
import '../models/expense.dart';

class CategoryFilter extends StatelessWidget {
  final Set<ExpenseCategory> selectedCategories;
  final Function(ExpenseCategory) onToggle;

  const CategoryFilter({
    super.key,
    required this.selectedCategories,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildFilterChip(ExpenseCategory.charging),
        const SizedBox(width: 8),
        _buildFilterChip(ExpenseCategory.maintenance),
        const SizedBox(width: 8),
        _buildFilterChip(ExpenseCategory.other),
      ],
    );
  }

  Widget _buildFilterChip(ExpenseCategory category) {
    final isSelected = selectedCategories.contains(category);
    return GestureDetector(
      onTap: () => onToggle(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.grey[300]!,
          ),
        ),
        child: Text(
          category.label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
