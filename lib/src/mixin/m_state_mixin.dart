import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../generated/locales.g.dart';
import '../models/error.dart';
import '../utils/screen_adaptive.dart';

extension _Empty on Object {
  bool _isEmpty() {
    final val = this;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.trim().isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

class MCustomStatus<T> extends MGetStatus<T> {
  @override
  List get props => [];
}

typedef MErrorCallback<T> = void Function(T error);
typedef MVoidCallback = void Function();
typedef MValueChanged<T> = void Function(T value);

extension MStateExt<T> on MStateMixin<T> {
  Widget mobx(
    NotifierBuilder<T?> widget, {
    Widget? Function(MError? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Observer(builder: (_) {
      if (status.isLoading) {
        return onLoading ?? const Center(child: CircularProgressIndicator());
      } else if (status.isError) {
        return onError != null
            ? onError(status.error) ?? const SizedBox.shrink()
            : Center(child: Text('${LocaleKeys.state_error_tips}: ${status.errorMsg}'));
      } else if (status.isEmpty) {
        return onEmpty ?? const SizedBox.shrink(); // Also can be widget(null); but is risky
      } else if (status.isSuccess) {
        return widget(value);
      } else if (status.isCustom) {
        return onCustom?.call(_) ?? const SizedBox.shrink(); // Also can be widget(null); but is risky
      }
      return widget(value);
    });
  }

  void check(T dataSource) {
    if ((dataSource == null || dataSource._isEmpty())) {
      status = MGetStatus<T>.empty();
    } else {
      status = MGetStatus<T>.success(dataSource);
    }
  }
}

extension MStatusDataExt<T> on MGetStatus<T> {
  bool get isLoading => this is MLoadingStatus;
  bool get isSuccess => this is MSuccessStatus;
  bool get isError => this is MErrorStatus;
  bool get isEmpty => this is MEmptyStatus;
  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;
  MError get error {
    final isError = this is MErrorStatus;
    if (isError) {
      final err = this as MErrorStatus;
      if (err.error != null) {
        if (err.error is String) {
          return MError.error(message: err.error as String);
        } else if (err.error is MError) {
          return err.error;
        }
      }
    }

    return MError.error();
  }

  String? get errorMsg {
    return error.message;
  }

  T? get data {
    if (this is MSuccessStatus<T>) {
      final success = this as MSuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}

class MEmptyStatus<T> extends MGetStatus<T> {
  @override
  List get props => [];
}

class MErrorStatus<T, S> extends MGetStatus<T> {
  const MErrorStatus([this.error]);

  final S? error;

  @override
  List get props => [error];
}

abstract class MGetStatus<T> with Equality {
  const MGetStatus();

  factory MGetStatus.custom() => MCustomStatus<T>();

  factory MGetStatus.empty() => MEmptyStatus<T>();

  factory MGetStatus.error(dynamic message) => MErrorStatus<T, dynamic>(message);

  factory MGetStatus.loading() => MLoadingStatus<T>();

  factory MGetStatus.success(T data) => MSuccessStatus<T>(data);
}

class MLoadingStatus<T> extends MGetStatus<T> {
  @override
  List get props => [];
}

mixin MStateMixin<T> on ListNotifier {
  @protected
  Future<T> Function()? _body;

  final _isLoaded = false.obs;

  @protected
  MError? _error;

  @protected
  T? _initialData;

  @protected
  bool _useEmpty = true;

  MGetStatus<T>? _status;
  T? _value;

  T get state => value;
  MGetStatus<T> get status {
    reportRead();
    return _status ??= _status = MGetStatus.loading();
  }

  @protected
  T get value {
    reportRead();
    return _value as T;
  }

  @protected
  void change(MGetStatus<T> status) {
    if (status != this.status) {
      this.status = status;
    }
  }

  get isLoaded => _isLoaded.value;

  set isLoaded(val) => _isLoaded.value = val;

  Widget loading(
    NotifierBuilder<T?> widget, {
    Widget? Function(MError? error)? onError,
    Widget? onLoading,
    double? loadingIndicatorSize,
    AlignmentGeometry? alignment,
    Widget? onEmpty,
    String? emptyText,
    WidgetBuilder? onCustom,
    bool showLoading = true,
    bool showError = true,
    bool showEmpty = true,
    bool isStateless = false,
  }) {
    showLoading = isStateless ? false : showLoading;
    showError = isStateless ? false : showError;
    showEmpty = isStateless ? false : showEmpty;
    return mobx(
      widget,
      onError: showError ? onError ?? _onError : (error) => Container(),
      onLoading: showLoading
          ? onLoading ??
              _onLoadingIndicator(
                size: loadingIndicatorSize,
                alignment: alignment,
              )
          : Container(),
      onEmpty: showEmpty
          ? onEmpty ??
              _onEmpty(
                emptyText: emptyText,
              )
          : Container(),
      onCustom: onCustom,
    );
  }

  void onLoading(
    Future<T> Function() body, {
    T? initialData,
    String? errorMessage,
    MError? error,
    bool useEmpty = true,
  }) {
    _body = body;
    _initialData = initialData;
    _error = errorMessage != null ? MError(message: errorMessage) : error;
    _useEmpty = useEmpty;
    _onLoading(body, initialData: initialData, error: _error, useEmpty: useEmpty);
  }

  void onReload() {
    if (_body != null) {
      this._onLoading(
        () => _body!.call(),
        initialData: _initialData,
        error: _error,
        useEmpty: _useEmpty,
      );
    }
  }

  set status(MGetStatus<T> newStatus) {
    if (newStatus == status) return;
    _status = newStatus;
    if (newStatus is MSuccessStatus<T>) {
      _value = newStatus.data;
    }
    refresh();
  }

  @protected
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  Widget? _onEmpty({String? emptyText}) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.now_widgets_rounded,
              color: const Color(0xFFAAA9B5),
              size: 100.aw,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8).aw,
              child: Text(
                emptyText ?? LocaleKeys.no_data.tr,
                style: TextStyle(
                  fontSize: 14.asp,
                  color: const Color(0xFFAAA9B5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

  @protected
  Widget _onError(MError? error) {
    // TODO: 更换错误Icon
    Widget icon = Icon(
      Icons.error,
      color: Colors.red,
      size: 50.aw,
    );

    if (error?.code == MErrorCode.noNetwork.code) {
      icon = Icon(
        Icons.wifi_off,
        color: Colors.red,
        size: 50.aw,
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8).aw,
            child: Text(
              '${error ?? LocaleKeys.state_error_tips.tr}',
              style: TextStyle(
                fontSize: 14.asp,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ElevatedButton(
            onPressed: onReload,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10).aw,
            ),
            child: Text(
              LocaleKeys.reload.tr,
              style: const TextStyle(color: Colors.white),
              strutStyle: const StrutStyle(forceStrutHeight: true),
            ),
          )
        ],
      ),
    );
  }

  @protected
  void _onLoading(
    Future<T> Function() body, {
    T? initialData,
    MError? error,
    bool useEmpty = true,
  }) {
    status = MGetStatus<T>.loading();
    final compute = body;
    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && (initialData == null || initialData._isEmpty()) && useEmpty) {
        status = MGetStatus<T>.empty();
      } else {
        status = MGetStatus<T>.success(newValue ?? initialData!);
      }
      refresh();
    }, onError: (err) {
      status = MGetStatus.error(error ?? err);
      refresh();
    });
  }

  @protected
  Widget? _onLoadingIndicator({
    double? size,
    AlignmentGeometry? alignment,
  }) =>
      Align(
        alignment: alignment ?? Alignment.center,
        child: LoadingAnimationWidget.fourRotatingDots(
          color: Get.theme.primaryColor,
          size: size ?? 40.aw.maximum(60),
        ),
      );
}

class MSuccessStatus<T> extends MGetStatus<T> {
  const MSuccessStatus(this.data);

  final T data;

  @override
  List get props => [data];
}
