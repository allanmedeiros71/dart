import 'package:test/test.dart';
import 'package:assincronismo/screens/account_screen.dart';

void main() {
  group('AccountScreen initialization', () {
    late AccountScreen accountScreen;

    setUp(() {
      accountScreen = AccountScreen();
    });

    test('should create AccountScreen instance', () {
      expect(accountScreen, isA<AccountScreen>());
    });

    test('should initialize stream without errors', () {
      expect(() => accountScreen.initializeStream(), returnsNormally);
    });

    // Note: We can't easily test runChatbot() directly as it involves stdin/stdout
    // and runs an infinite loop. Such functionality is better tested through
    // integration tests or by refactoring the code to be more testable.
  });
}
