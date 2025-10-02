import 'package:flutter/foundation.dart';
import 'package:restaurant_app/data/local/notification_service.dart';
import 'package:restaurant_app/data/local/shared_prefs_service.dart';

class ReminderProvider extends ChangeNotifier {
  bool _enabled = false;
  bool get enabled => _enabled;

  Future<void> load() async {
    _enabled = await SharedPrefsService.getDailyReminder();
    if (_enabled) {
      await NotificationService.scheduleDailyAt11();
    }
    notifyListeners();
  }

  Future<void> enable() async {
    _enabled = true;
    await SharedPrefsService.setDailyReminder(true);
    await NotificationService.scheduleDailyAt11();
    notifyListeners();
  }

  Future<void> disable() async {
    _enabled = false;
    await SharedPrefsService.setDailyReminder(false);
    await NotificationService.cancelDaily();
    notifyListeners();
  }
}
