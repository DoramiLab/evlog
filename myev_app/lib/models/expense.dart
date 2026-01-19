import 'package:flutter/material.dart';

enum ExpenseCategory {
  charging, // 충전
  maintenance, // 정비
  other, // 기타
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get label {
    switch (this) {
      case ExpenseCategory.charging:
        return '충전';
      case ExpenseCategory.maintenance:
        return '정비';
      case ExpenseCategory.other:
        return '기타';
    }
  }

  IconData get icon {
    switch (this) {
      case ExpenseCategory.charging:
        return Icons.ev_station;
      case ExpenseCategory.maintenance:
        return Icons.build;
      case ExpenseCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.charging:
        return Colors.blue;
      case ExpenseCategory.maintenance:
        return Colors.red;
      case ExpenseCategory.other:
        return Colors.grey;
    }
  }
}

enum ChargingLocationType {
  home, // 집
  supercharger, // 슈퍼차저
  publicCharger, // 공용 충전소
  workplace, // 회사
}

extension ChargingLocationTypeExtension on ChargingLocationType {
  IconData get icon {
    switch (this) {
      case ChargingLocationType.home:
        return Icons.home;
      case ChargingLocationType.supercharger:
        return Icons.flash_on;
      case ChargingLocationType.publicCharger:
        return Icons.local_parking;
      case ChargingLocationType.workplace:
        return Icons.business;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ChargingLocationType.home:
        return const Color(0xFFFFE0B2);
      case ChargingLocationType.supercharger:
        return const Color(0xFFB3E5FC);
      case ChargingLocationType.publicCharger:
        return const Color(0xFFC8E6C9);
      case ChargingLocationType.workplace:
        return const Color(0xFFE1BEE7);
    }
  }

  Color get iconColor {
    switch (this) {
      case ChargingLocationType.home:
        return const Color(0xFFE65100);
      case ChargingLocationType.supercharger:
        return const Color(0xFF0277BD);
      case ChargingLocationType.publicCharger:
        return const Color(0xFF2E7D32);
      case ChargingLocationType.workplace:
        return const Color(0xFF6A1B9A);
    }
  }
}

class Expense {
  final String id;
  final DateTime date;
  final ExpenseCategory category;
  final String title;
  final String subtitle;
  final int amount; // 원 단위
  final double? chargePercent; // 충전 퍼센트
  final double? chargeKwh; // 충전량 kWh
  final ChargingLocationType? locationType;

  Expense({
    required this.id,
    required this.date,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.chargePercent,
    this.chargeKwh,
    this.locationType,
  });

  String get formattedAmount {
    final formatted = amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$formatted원';
  }

  String get displayTitle {
    if (category == ExpenseCategory.charging && chargePercent != null && chargeKwh != null) {
      return '${chargePercent!.toInt()}% (${chargeKwh!}kWh) 충전';
    }
    return title;
  }
}
