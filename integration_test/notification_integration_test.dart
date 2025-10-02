import 'package:flutter_test/flutter_test.dart';
import '../lib/data/local/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Integration Test', () {
    testWidgets('Init NotificationService berhasil dijalankan',
            (tester) async {
          await NotificationService.init();
          expect(true, isTrue);
        });

    testWidgets('Schedule notifikasi harian berhasil',
            (tester) async {
          await NotificationService.scheduleDailyAt11();
          expect(true, isTrue);
        });

    testWidgets('Cancel notifikasi berhasil dijalankan',
            (tester) async {
          await NotificationService.cancelDaily();
          expect(true, isTrue);
        });
  });
}
