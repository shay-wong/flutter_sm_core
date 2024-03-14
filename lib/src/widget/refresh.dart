import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sm_core/generated/locales.g.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../utils/network/api.dart';
import 'text.dart';

typedef MRefreshRequest = void Function(APIPageableLoader loader);

class MRefresh extends StatelessWidget {
  final MRefreshRequest? onRequest;
  final MRefreshRequest? onLoading;
  final MRefreshRequest? onRefresh;
  final Widget child;
  final ScrollController? scrollController;
  final Widget? footer;
  final APIPageableLoader loader;
  final Color textColor;
  final Color color;

  MRefresh({
    super.key,
    required this.child,
    APIPageableLoader? loader,
    this.footer,
    this.scrollController,
    this.onRequest,
    this.onRefresh,
    this.onLoading,
    this.textColor = Colors.grey,
    this.color = Colors.grey,
  }) : loader = loader ?? APIPageableLoader();

  @override
  Widget build(BuildContext context) {
    // !!!: ListView一定要作为SmartRefresher的child,不能与其分开,
    // https://github.com/peng8350/flutter_pulltorefresh/blob/master/README_CN.md
    return SmartRefresher(
      enablePullDown: onRequest != null || onRefresh != null,
      enablePullUp: onRequest != null || onLoading != null,
      header: WaterDropHeader(
        idleIcon: const Icon(
          Icons.autorenew,
          size: 15,
          color: Colors.white,
        ),
        waterDropColor: color,
        complete: _text(LocaleKeys.refresh_complete.tr),
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          if (footer != null) {
            return footer!;
          }
          Widget body;
          switch (mode) {
            case LoadStatus.idle:
              body = _text(LocaleKeys.refresh_pull_up_to_load.tr);
              break;
            case LoadStatus.loading:
              body = const CupertinoActivityIndicator();
              break;
            case LoadStatus.canLoading:
              body = _text(LocaleKeys.refresh_release_to_load_more.tr);
              break;
            case LoadStatus.failed:
              body = _text(LocaleKeys.refresh_failed_click_retry.tr);
              break;
            case LoadStatus.noMore:
              body = _text(LocaleKeys.refresh_no_more_data.tr);
              break;
            default:
              body = _text("");
          }
          return SizedBox(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: () => (onRequest ?? onRefresh)?.call(loader..isRefresh = true),
      onLoading: () => (onRequest ?? onLoading)?.call(loader..isRefresh = false),
      controller: loader.controller,
      scrollController: scrollController,
      child: child,
    );
  }

  Widget _text(String? data) => MText(
        data,
        fontSize: 12,
        color: textColor,
      );
}
