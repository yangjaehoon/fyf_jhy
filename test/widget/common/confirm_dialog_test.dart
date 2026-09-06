import 'package:feple/common/common.dart';
import 'package:feple/common/theme/custom_theme.dart';
import 'package:feple/common/theme/custom_theme_holder.dart';
import 'package:feple/common/util/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<bool?> pumpAndShow(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();

    bool? result;
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('ko'), Locale('en')],
        startLocale: const Locale('ko'),
        fallbackLocale: const Locale('ko'),
        path: 'assets/translations',
        useOnlyLangCode: true,
        child: CustomThemeHolder(
          theme: CustomTheme.light,
          changeTheme: (_) {},
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    result = await showConfirmDialog(
                      context,
                      title: '삭제하시겠습니까?',
                      content: '되돌릴 수 없습니다',
                      confirmLabel: '삭제',
                    );
                  },
                  child: const Text('열기'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('열기'));
    await tester.pumpAndSettle();
    return result;
  }

  group('showConfirmDialog', () {
    testWidgets('제목/본문/확인 라벨을 보여준다', (tester) async {
      await pumpAndShow(tester);

      expect(find.text('삭제하시겠습니까?'), findsOneWidget);
      expect(find.text('되돌릴 수 없습니다'), findsOneWidget);
      expect(find.text('삭제'), findsOneWidget);
    });

    testWidgets('취소를 탭하면 false를 반환한다', (tester) async {
      await pumpAndShow(tester);

      await tester.tap(find.text('cancel'.tr()));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('확인을 탭하면 true를 반환한다', (tester) async {
      bool? result;
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ko'), Locale('en')],
          startLocale: const Locale('ko'),
          fallbackLocale: const Locale('ko'),
          path: 'assets/translations',
          useOnlyLangCode: true,
          child: CustomThemeHolder(
            theme: CustomTheme.light,
            changeTheme: (_) {},
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () async {
                      result = await showConfirmDialog(
                        context,
                        title: '삭제하시겠습니까?',
                        content: '되돌릴 수 없습니다',
                        confirmLabel: '삭제',
                      );
                    },
                    child: const Text('열기'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('열기'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('삭제'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('확인 버튼을 두 번 연속 탭해도 다이얼로그만 닫히고 아래 화면은 남는다',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ko'), Locale('en')],
          startLocale: const Locale('ko'),
          fallbackLocale: const Locale('ko'),
          path: 'assets/translations',
          useOnlyLangCode: true,
          child: CustomThemeHolder(
            theme: CustomTheme.light,
            changeTheme: (_) {},
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => Scaffold(
                          body: Builder(
                            builder: (inner) => TextButton(
                              key: const Key('open'),
                              onPressed: () => showConfirmDialog(
                                inner,
                                title: '삭제하시겠습니까?',
                                content: '되돌릴 수 없습니다',
                                confirmLabel: '삭제',
                                confirmKey: const Key('confirm'),
                              ),
                              child: const Text('아래 화면'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('이동'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('이동'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('open')));
      await tester.pumpAndSettle();

      // adaptive 다이얼로그라 타입(AlertDialog/CupertinoAlertDialog) 대신 확인
      // 버튼 키로 열림 여부를 본다.
      expect(find.byKey(const Key('confirm')), findsOneWidget);

      // 종료 애니메이션 동안 이어진 두 번째 탭이 아래 화면(open 버튼)을 pop하면 안 된다.
      await tester.tap(find.byKey(const Key('confirm')));
      await tester.tap(find.byKey(const Key('confirm')), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('confirm')), findsNothing);
      expect(find.byKey(const Key('open')), findsOneWidget);
    });

    testWidgets('destructive 여부에 따라 확인 버튼 색이 달라진다', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await EasyLocalization.ensureInitialized();

      late Color errorColor;
      late Color activateColor;

      await tester.pumpWidget(
        EasyLocalization(
          supportedLocales: const [Locale('ko'), Locale('en')],
          startLocale: const Locale('ko'),
          fallbackLocale: const Locale('ko'),
          path: 'assets/translations',
          useOnlyLangCode: true,
          child: CustomThemeHolder(
            theme: CustomTheme.light,
            changeTheme: (_) {},
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    errorColor = context.appColors.error;
                    activateColor = context.appColors.activate;
                    return Column(
                      children: [
                        TextButton(
                          key: const Key('open-destructive'),
                          onPressed: () => showConfirmDialog(
                            context,
                            title: 't',
                            content: 'c',
                            confirmLabel: '삭제',
                            confirmKey: const Key('confirm'),
                          ),
                          child: const Text('destructive'),
                        ),
                        TextButton(
                          key: const Key('open-safe'),
                          onPressed: () => showConfirmDialog(
                            context,
                            title: 't',
                            content: 'c',
                            confirmLabel: '로그인',
                            destructive: false,
                            confirmKey: const Key('confirm'),
                          ),
                          child: const Text('safe'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      Color confirmColor() => tester
          .widget<Text>(
            find.descendant(
              of: find.byKey(const Key('confirm')),
              matching: find.byType(Text),
            ),
          )
          .style!
          .color!;

      await tester.tap(find.byKey(const Key('open-destructive')));
      await tester.pumpAndSettle();
      expect(confirmColor(), errorColor);
      await tester.tap(find.text('cancel'.tr()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('open-safe')));
      await tester.pumpAndSettle();
      expect(confirmColor(), activateColor);
    });
  });
}
