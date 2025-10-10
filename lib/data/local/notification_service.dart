import 'dart:math';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
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

  static Future<bool> requestNotificationPermission() async {
    PermissionStatus notificationStatus = await Permission.notification.status;

    if (notificationStatus.isDenied) {
      debugPrint("⚠️ Izin notifikasi ditolak, meminta izin...");
      notificationStatus = await Permission.notification.request();
    }

    if (notificationStatus.isDenied) {
      debugPrint("❌ User menolak izin notifikasi");
      return false;
    }

    if (notificationStatus.isPermanentlyDenied) {
      debugPrint("🚫 Izin notifikasi diblokir permanen, buka Settings...");
      await openAppSettings();
      return false;
    }

    PermissionStatus alarmStatus = await Permission.scheduleExactAlarm.status;

    if (alarmStatus.isDenied) {
      debugPrint("⚠️ Izin exact alarm ditolak, meminta izin...");
      alarmStatus = await Permission.scheduleExactAlarm.request();
    }

    if (alarmStatus.isPermanentlyDenied) {
      debugPrint("🚫 Izin exact alarm diblokir, buka Settings...");
      await openAppSettings();
      return false;
    }

    debugPrint("✅ Semua izin notifikasi diberikan");
    return notificationStatus.isGranted;
  }

  static Future<bool> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    debugPrint("✅ Notifikasi diinisialisasi dengan timezone: Asia/Jakarta");

    final hasPermission = await requestNotificationPermission();
    debugPrint(hasPermission
        ? "✅ Izin notifikasi berhasil diminta saat init"
        : "⚠️ Izin notifikasi tidak diberikan saat init");

    return hasPermission;
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
      debugPrint("❌ Error fetching restaurant: $e");
    }
    return null;
  }

  static Future<void> scheduleDailyAt11() async {
    final hasPermission = await requestNotificationPermission();
    if (!hasPermission) {
      debugPrint("❌ Tidak bisa menjadwalkan notifikasi: izin ditolak");
      return;
    }

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        'Daily Reminder',
        channelDescription: 'Jam Makan Siang Tiba!!',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _plugin.zonedSchedule(
      1100,
      "Restoran Favoritmu",
      "Ayo cari restoran favoritmu 🍽️",
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_11',
    );

    debugPrint("📅 Daily 11:00 notification scheduled at $scheduled");
  }

  static Future<void> cancelDaily() async {
    await _plugin.cancel(1100);
    debugPrint("❌ Daily reminder dibatalkan");
  }

  static Future<bool> showInstantNotification() async {
    final hasPermission = await requestNotificationPermission();
    if (!hasPermission) {
      debugPrint("❌ Tidak bisa menampilkan notifikasi: izin ditolak");
      return false;
    }

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

    debugPrint("🔔 Notifikasi instan ditampilkan");
    return true;
  }

  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
}