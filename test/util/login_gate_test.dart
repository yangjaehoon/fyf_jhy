import 'package:easy_localization/easy_localization.dart';
import 'package:feple/common/theme/custom_theme.dart';
import 'package:feple/common/theme/custom_theme_holder.dart';
import 'package:feple/common/util/login_gate.dart';
import 'package:feple/login/s_login.dart';
import 'package:feple/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockUserProvider extends Mock implements UserProvider {}

void main() {
  late MockUserProvider userProvider;
  bool? ensureLoggedInResult;

  final confirmButton = find.byKey(const Key('login_gate_confirm'));

  Future<void> pump(WidgetTester tester, {required int? currentUserId}) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
    userProvider = MockUserProvider();
    when(() => userProvider.currentUserId).thenReturn(currentUserId);
    ensureLoggedInResult = null;

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ko'), Locale('en')],
        startLocale: const Locale('ko'),
        fallbackLocale: const Locale('ko'),
        path: 'assets/translations',
        useOnlyLangCode: true,
        child: ChangeNotifierProvider<UserProvider>.value(
          value: userProvider,
          child: CustomThemeHolder(
            theme: CustomTheme.light,
            changeTheme: (_) {},
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () async {
                      ensureLoggedInResult = await ensureLoggedIn(context);
                    },
                    child: const Text('tap'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  group('ensureLoggedIn', () {
    testWidgets('로그인 상태면 확인 다이얼로그도 로그인 화면도 열지 않고 true를 반환한다',
        (tester) async {
      await pump(tester, currentUserId: 1);

      await tester.tap(find.text('tap'));
      await tester.pump();

      expect(confirmButton, findsNothing);
      expect(find.byType(LoginScreen), findsNothing);
      expect(ensureLoggedInResult, isTrue);
    });

    testWidgets('비로그인이면 확인 다이얼로그를 먼저 띄우고, 로그인 화면은 바로 열지 않는다',
        (tester) async {
      await pump(tester, currentUserId: null);

      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();

      expect(confirmButton, findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
      expect(ensureLoggedInResult, isNull);
    });

    testWidgets('다이얼로그에서 로그인을 누르면 로그인 화면을 열고, 성공 후 true를 반환한다',
        (tester) async {
      await pump(tester, currentUserId: null);

      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(ensureLoggedInResult, isNull);

      // 로그인 성공 시 s_login.dart의 _completeLogin이 Navigator.pop(context, true)로
      // 닫는 것과 동일한 상황을 재현한다.
      Navigator.of(tester.element(find.byType(LoginScreen)), rootNavigator: true)
          .pop(true);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsNothing);
      expect(ensureLoggedInResult, isTrue);
    });

    testWidgets('다이얼로그에서 취소하면 로그인 화면을 열지 않고 false를 반환한다',
        (tester) async {
      await pump(tester, currentUserId: null);

      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('cancel'.tr()));
      await tester.pumpAndSettle();

      expect(confirmButton, findsNothing);
      expect(find.byType(LoginScreen), findsNothing);
      expect(ensureLoggedInResult, isFalse);
    });

    testWidgets('로그인 화면에서 로그인 없이 뒤로 가면 false를 반환한다', (tester) async {
      await pump(tester, currentUserId: null);

      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);

      Navigator.of(tester.element(find.byType(LoginScreen)), rootNavigator: true)
          .pop();
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsNothing);
      expect(ensureLoggedInResult, isFalse);
    });

    testWidgets('연속으로 두 번 탭해도 확인 다이얼로그는 하나만 열린다', (tester) async {
      await pump(tester, currentUserId: null);

      // 첫 탭으로 이미 다이얼로그가 떠서 버튼이 가려진 채로 두 번째 탭이
      // 곧바로 이어져도, 다이얼로그가 또 열리지는 않아야 한다.
      await tester.tap(find.text('tap'));
      await tester.tap(find.text('tap'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('다이얼로그의 로그인 버튼을 두 번 탭해도 로그인 화면은 하나만 열린다',
        (tester) async {
      await pump(tester, currentUserId: null);

      await tester.tap(find.text('tap'));
      await tester.pumpAndSettle();

      // 종료 애니메이션 동안 이어진 두 번째 탭이 아래 화면을 pop하거나
      // 로그인 화면을 두 번 push하지 않아야 한다.
      await tester.tap(confirmButton);
      await tester.tap(confirmButton, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
