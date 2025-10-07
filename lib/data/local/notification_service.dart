import 'dart:math';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'daily_reminder_channel';

  @visibleForTesting
  static set testPlugin(FlutterLocalNotificationsPlugin plugin) {
    _plugin = plugin;
  }

  static Future<Map<String, dynamic>?> Function()? _getRandomRestaurantOverride;
  @visibleForTesting
  static set getRandomRestaurantOverride(
    Future<Map<String, dynamic>?> Function()? callback,
  ) {
    _getRandomRestaurantOverride = callback;
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      if (!result.isGranted) openAppSettings();
    }
  }

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    final String localTimeZone = await FlutterNativeTimezone.getLocalTimezone();

    tz.setLocalLocation(tz.getLocation(localTimeZone));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    debugPrint("✅ Notifikasi diinisialisasi dengan timezone: $localTimeZone");
  }

  static Future<Map<String, dynamic>?> _getRandomRestaurant() async {
    if (_getRandomRestaurantOverride != null) {
      return await _getRandomRestaurantOverride!();
    }

    try {
      final response = await http.get(
        Uri.parse("https://restaurant-api.dicoding.dev/list"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List restos = data['restaurants'];
        if (restos.isNotEmpty) {
          return restos[Random().nextInt(restos.length)];
        }
      }
    } catch (e) {
      print("Error fetching restaurant: $e");
    }
    return null;
  }

  static Future<void> scheduleDailyAt11() async {
    final resto = await _getRandomRestaurant();

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        'Daily Reminder',
        channelDescription: 'Pengingat restoran harian',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduled.isBefore(now))
      scheduled = scheduled.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      1100,
      resto?['name'] ?? "Restoran Favoritmu",
      resto != null
          ? "${resto['city']} • Rating: ${resto['rating']}"
          : "Ayo cari restoran favoritmu 🍽️",
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: null,
    );
  }

  static Future<void> cancelDaily() async => await _plugin.cancel(1100);

  static Future<void> showInstantNotification() async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        'Test Notification',
        channelDescription: 'Notifikasi pengujian',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      999,
      'Notifikasi Uji Coba',
      'Ini contoh notifikasi langsung 🔔',
      details,
    );
  }
}
