import 'package:feple/common/common.dart';
import 'package:feple/common/constant/app_dimensions.dart';
import 'package:feple/common/util/app_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 프로젝트 공통 확인 다이얼로그. [로그인]을 누르면 `true`, [취소]/배리어/뒤로가기는
/// `false`. 확인 버튼은 기본적으로 파괴적 동작을 뜻하는 에러 색을 쓰고,
/// [confirmColor]로 비파괴적 동작(예: 로그인 유도)에 맞는 색을 지정할 수 있다.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
  Color? confirmColor,
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
            style: TextStyle(color: confirmColor ?? ctx.appColors.error),
          ),
        ),
      ],
    ),
  ) ?? false;
}

// 종료 애니메이션(animXFast) 동안 버튼을 다시 탭하면 이미 pop 중인 다이얼로그가
// 아니라 그 아래 화면이 pop돼버린다 — 다이얼로그가 최상단일 때만 닫는다.
void _popOnce(BuildContext ctx, bool result) {
  if (ModalRoute.of(ctx)?.isCurrent ?? false) Navigator.pop(ctx, result);
}
