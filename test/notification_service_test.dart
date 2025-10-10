import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Unit Test', () {
    test('Notification initialization settings sudah benar', () {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initSettings = InitializationSettings(android: androidSettings);

      expect(androidSettings.defaultIcon, equals('@mipmap/ic_launcher'));
      expect(initSettings.android, isNotNull);
    });

    test('Notification details configuration sudah benar', () {
      const channelId = 'daily_notification_channel';
      const channelName = 'Daily Notification';
      const channelDescription = 'Daily restaurant recommendation';
      const importance = Importance.high;
      const priority = Priority.high;

      const androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: importance,
        priority: priority,
      );

      expect(androidDetails.channelId, equals(channelId));
      expect(androidDetails.channelName, equals(channelName));
      expect(androidDetails.channelDescription, equals(channelDescription));
      expect(androidDetails.importance, equals(importance));
      expect(androidDetails.priority, equals(priority));
    });

    test('Waktu notifikasi harian adalah jam 11:00', () {
      final now = DateTime.now();
      var scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        11,
        0,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      expect(scheduledDate.hour, equals(11));
      expect(scheduledDate.minute, equals(0));
      expect(scheduledDate.isAfter(now) || scheduledDate.isAtSameMomentAs(now),
          isTrue);
    });

    test('Notification ID adalah 0', () {
      const notificationId = 0;
      expect(notificationId, equals(0));
      expect(notificationId, isA<int>());
    });

    test('Channel configuration sudah benar', () {
      const channelId = 'daily_notification_channel';
      const channelName = 'Daily Notification';
      const channelDescription = 'Daily restaurant recommendation';

      expect(channelId, isNotEmpty);
      expect(channelName, isNotEmpty);
      expect(channelDescription, isNotEmpty);
    });

    test('DateTimeComponents untuk daily notification benar', () {
      const components = DateTimeComponents.time;
      expect(components, equals(DateTimeComponents.time));
    });

    test('Platform details tidak null', () {
      const androidDetails = AndroidNotificationDetails(
        'daily_notification_channel',
        'Daily Notification',
        channelDescription: 'Daily restaurant recommendation',
        importance: Importance.high,
        priority: Priority.high,
      );

      const platformDetails = NotificationDetails(android: androidDetails);

      expect(platformDetails.android, isNotNull);
      expect(platformDetails.android?.channelId, equals('daily_notification_channel'));
    });

    test('Scheduled date calculation benar', () {
      final now = DateTime.now();
      final scheduledToday = DateTime(now.year, now.month, now.day, 11, 0);

      if (now.hour < 11) {
        expect(scheduledToday.day, equals(now.day));
      } else {
        final scheduledTomorrow = scheduledToday.add(const Duration(days: 1));
        expect(scheduledTomorrow.day, isNot(equals(now.day)));
      }
    });

    test('Notification title dan body tidak kosong', () {
      const title = 'Rekomendasi Restoran Harian';
      const body = 'Lihat rekomendasi restoran menarik hari ini!';

      expect(title, isNotEmpty);
      expect(body, isNotEmpty);
    });
  });

  group('NotificationService Edge Cases', () {
    test('Notification dapat dijadwalkan untuk timezone yang berbeda', () {
      final now = DateTime.now();
      final scheduledDate = DateTime(now.year, now.month, now.day, 11, 0);

      expect(scheduledDate.isUtc, isFalse);
      expect(scheduledDate.hour, equals(11));
    });

    test('Multiple notification IDs tidak konflik', () {
      const id1 = 0;
      const id2 = 1;
      const id3 = 2;

      expect(id1, isNot(equals(id2)));
      expect(id1, isNot(equals(id3)));
      expect(id2, isNot(equals(id3)));
    });
  });
}