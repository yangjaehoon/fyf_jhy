import 'package:feple/common/common.dart';
import 'package:feple/common/util/confirm_dialog.dart';
import 'package:feple/login/s_login.dart';
import 'package:feple/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 로그인 유도(확인 다이얼로그 + 로그인 화면)는 루트 네비게이터 기준 앱 전체에
// 하나만 진행돼야 한다 — 위젯별 상태가 아니라 모듈 전역 가드. 좋아요/팔로우
// 버튼을 빠르게 연속 탭하는 등 앞선 호출이 끝나기 전에 다시 불려도 이 플래그로
// 다이얼로그·화면이 겹쳐 뜨는 것을 막는다. pop을 기다리지 않고 다음 프레임에
// 바로 풀어준다 — 그 프레임부터는 다이얼로그/화면이 원래 버튼을 덮어 재탭이
// 불가능하고, dismiss 없이 트리가 교체되는 경우에도 가드가 영구히 막히지 않도록.
bool _loginFlowActive = false;

/// 로그인 화면을 루트 네비게이터에 push한다. 게스트 유도 지점 여러 곳에서
/// 반복되던 코드 — 항상 이 헬퍼를 쓴다.
///
/// 로그인에 성공해 화면이 닫히면(`s_login.dart`의 `_completeLogin`) `true`를
/// 반환한다. 사용자가 로그인 없이 뒤로 가면, 또는 이미 다른 호출로 로그인
/// 유도가 진행 중이면 `false`.
Future<bool> openLoginScreen(BuildContext context) async {
  if (_loginFlowActive) return false;
  _loginFlowActive = true;
  final pushed = Navigator.of(context, rootNavigator: true).push<bool>(
    MaterialPageRoute(builder: (_) => const LoginScreen()),
  );
  WidgetsBinding.instance.addPostFrameCallback((_) => _loginFlowActive = false);
  final loggedIn = await pushed;
  return loggedIn ?? false;
}

/// 로그인이 필요한 동작 앞에 둔다.
///
/// 로그인 상태면 `true`를 즉시 반환한다. 비로그인이면 먼저 "로그인이 필요해요"
/// 확인 다이얼로그를 띄우고, 사용자가 [로그인]을 누른 경우에만 로그인 화면을
/// 연다 — 게스트가 무심코 누른 버튼에 맥락 없이 로그인 화면이 덮이는 것을 막는다.
/// 로그인에 성공하면 `true`를 반환해 호출부가 원래 하려던 동작을 곧바로 이어서
/// 실행할 수 있게 한다(의도 보존). [취소]하거나 로그인 없이 뒤로 가면 `false`.
/// 호출부는 `if (!await ensureLoggedIn(context)) return;` 형태로 쓴다.
Future<bool> ensureLoggedIn(BuildContext context) async {
  if (context.read<UserProvider>().currentUserId != null) return true;
  if (_loginFlowActive) return false;

  _loginFlowActive = true;
  WidgetsBinding.instance.addPostFrameCallback((_) => _loginFlowActive = false);

  final confirmed = await showConfirmDialog(
    context,
    title: 'login_required_title'.tr(),
    content: 'login_required'.tr(),
    confirmLabel: 'login'.tr(),
    confirmColor: context.appColors.activate,
    confirmKey: const Key('login_gate_confirm'),
  );
  if (!confirmed || !context.mounted) return false;

  return openLoginScreen(context);
}
