import 'package:feple/common/common.dart';
import 'package:feple/common/constant/app_dimensions.dart';
import 'package:feple/common/util/app_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 프로젝트 공통 확인 다이얼로그. 확인 버튼([confirmLabel])을 누르면 `true`,
/// [취소]·배리어·뒤로가기는 `false`.
///
/// 확인 버튼은 기본적으로 파괴적 동작을 뜻하는 에러 색을 쓴다. 로그인 유도처럼
/// 비파괴적 동작이면 [destructive]를 `false`로 넘겨 강조 색(activate)을 쓴다.
/// [confirmKey]는 테스트에서 확인 버튼을 특정하기 위한 키.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
  bool destructive = true,
  Key? confirmKey,
}) async {
  return await showDialog<bool>(
    context: context,
    animationStyle: const AnimationStyle(
      duration: AppDimens.animFast,
      reverseDuration: AppDimens.animXFast,
    ),
    builder: (ctx) => buildAppAlertDialog(
      ctx,
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => _popOnce(ctx, false),
          child: Text('cancel'.tr()),
        ),
        TextButton(
          key: confirmKey,
          onPressed: () {
            unawaited(HapticFeedback.mediumImpact());
            _popOnce(ctx, true);
          },
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: destructive
                  ? ctx.appColors.error
                  : ctx.appColors.activate,
            ),
          ),
        ),
      ],
    ),
  ) ?? false;
}

// 종료 애니메이션(animXFast) 동안 버튼을 다시 탭하면 이미 pop이 시작된
// 다이얼로그가 아니라 그 아래 화면이 pop돼버린다 — 다이얼로그가 최상단일 때만
// 닫는다. 취소·확인 양쪽, 그리고 배리어 탭과 버튼 탭이 겹치는 경우까지 커버.
void _popOnce(BuildContext ctx, bool result) {
  if (ModalRoute.of(ctx)?.isCurrent ?? false) Navigator.pop(ctx, result);
}
