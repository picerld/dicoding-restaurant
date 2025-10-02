import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:restaurant_app/data/local/notification_service.dart';
import 'notification_service_test.mocks.dart';

@GenerateMocks([FlutterLocalNotificationsPlugin])
void main() {
  late MockFlutterLocalNotificationsPlugin mockPlugin;

  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  setUp(() {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    NotificationService.testPlugin = mockPlugin;

    NotificationService.getRandomRestaurantOverride = () async => {
      'name': 'Mock Resto',
      'city': 'Jakarta',
      'rating': 4.5,
    };
  });

  group('NotificationService Test (Mocked)', () {
    test('scheduleDailyAt11 memanggil zonedSchedule', () async {
      await NotificationService.scheduleDailyAt11();
      verify(mockPlugin.zonedSchedule(
        1100,
        any,
        any,
        any,
        any,
        androidScheduleMode: anyNamed('androidScheduleMode'),
        matchDateTimeComponents: anyNamed('matchDateTimeComponents'),
        payload: anyNamed('payload'),
      )).called(1);
    });

    test('showInstantNotification memanggil show', () async {
      await NotificationService.showInstantNotification();
      verify(mockPlugin.show(
        999,
        any,
        any,
        any,
      )).called(1);
    });

    test('cancelDaily memanggil cancel', () async {
      await NotificationService.cancelDaily();
      verify(mockPlugin.cancel(1100)).called(1);
    });
  });
}
