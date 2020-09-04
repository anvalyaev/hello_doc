import 'package:flutter/foundation.dart';

import 'notification_base.dart';
import '../entities/index.dart';
import '../accessor.dart';

// @immutable
// class IntervalItem {
//   final Duration start;
//   final Duration end;
//   final DateTime localCreationDate;
//   final DayTimeIntervalId id;
//   IntervalItem(this.start, this.end, this.localCreationDate, this.id);
// }

@immutable
class DayItem {
  final String name;
  final bool active;
  final int number;
  final bool addIntervalAvailable;
  final List<DayTimeInterval> intervals;
  DayItem(this.name, this.active, this.intervals, this.number,
      this.addIntervalAvailable);
}

class ScheduleNotifier extends NotificationBase {
  static const Map<int, String> weekdayNames = {
    1: "Понедельник",
    2: "Вторник",
    3: "Среда",
    4: "Четверг",
    5: "Пятница",
    6: "Суббота",
    7: "Воскресение",
  };

  List<DayItem> model;

  bool whenNotify(EntityBase entity, IAccessor accessor) {
    if (!(entity is ISchedule)) return false;
    return true;
  }

  void grabData(EntityBase entity, IAccessor accessor) {
    if (!(entity is ISchedule)) return;
    List<DayItem> newModel = [];
    ISchedule schedule = entity;
    for (int i = 1; i <= 7; i++) {
      var intervals = schedule.itemsbyWeekday(i);
      if (intervals.isEmpty) {
        newModel.add(DayItem(weekdayNames[i], false, [], i, true));
      } else {
        List<DayTimeInterval> intervalItems =
            List<DayTimeInterval>.from(intervals);
        intervalItems.sort((a, b) {
          return a.localCreationDate.compareTo(b.localCreationDate);
        });
        newModel.add(DayItem(weekdayNames[i], true, intervalItems, i, true));
      }
    }
    newModel.sort((a, b) {
      return a.number.compareTo(b.number);
    });
    model = newModel;
  }
}