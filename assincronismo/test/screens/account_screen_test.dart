import 'package:assincronismo/models/account.dart';
import 'package:assincronismo/screens/account_screen.dart';
import 'package:assincronismo/services/account_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateNiceMocks([MockSpec<AccountService>()])
import 'account_screen_test.mocks.dart';

void main() {
  late AccountScreen accountScreen;
  late MockAccountService mockAccountService;

  setUp(() {
    mockAccountService = MockAccountService();
    accountScreen = AccountScreen(accountService: mockAccountService);
  });

  group('AccountScreen', () {
    test('getAllAccounts should fetch and display accounts', () async {
      final accounts = [
        Account(id: '1', name: 'John', lastName: 'Doe', balance: 100.0),
        Account(id: '2', name: 'Jane', lastName: 'Smith', balance: 200.0),
      ];

      when(mockAccountService.getAll()).thenAnswer((_) async => accounts);
      when(mockAccountService.streamInfos).thenAnswer(
        (_) => Stream.fromIterable(['Test stream info']),
      );

      await accountScreen.getAllAccounts();
      verify(mockAccountService.getAll()).called(1);
    });

    test('getAccountById should fetch and display a single account', () async {
      final account = Account(
        id: '1',
        name: 'John',
        lastName: 'Doe',
        balance: 100.0,
      );

      when(mockAccountService.getAccountById('1'))
          .thenAnswer((_) async => account);

      when(mockAccountService.streamInfos).thenAnswer(
        (_) => Stream.fromIterable(['Test stream info']),
      );

      await accountScreen.getAccountById();
      verify(mockAccountService.getAccountById(any)).called(1);
    });

    test('updateAccount should update an existing account', () async {
      final account = Account(
        id: '1',
        name: 'John',
        lastName: 'Doe',
        balance: 100.0,
      );

      when(mockAccountService.getAccountById('1'))
          .thenAnswer((_) async => account);
      when(mockAccountService.updateAccount(any))
          .thenAnswer((_) async => true);
      when(mockAccountService.streamInfos).thenAnswer(
        (_) => Stream.fromIterable(['Test stream info']),
      );

      await accountScreen.updateAccount();
      verify(mockAccountService.getAccountById(any)).called(1);
      verify(mockAccountService.updateAccount(any)).called(1);
    });

    test('deleteAccount should delete an existing account', () async {
      when(mockAccountService.deleteAccount('1'))
          .thenAnswer((_) async => true);
      when(mockAccountService.streamInfos).thenAnswer(
        (_) => Stream.fromIterable(['Test stream info']),
      );

      await accountScreen.deleteAccount();
      verify(mockAccountService.deleteAccount(any)).called(1);
    });

    test('initializeStream should set up stream listener', () {
      when(mockAccountService.streamInfos).thenAnswer(
        (_) => Stream.fromIterable(['Test stream info']),
      );

      accountScreen.initializeStream();
      verify(mockAccountService.streamInfos).called(1);
    });
  });
}
