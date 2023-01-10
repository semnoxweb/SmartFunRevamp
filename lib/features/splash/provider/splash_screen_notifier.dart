import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:semnox/core/domain/use_cases/splash_screen/authenticate_base_url_use_case.dart';
import 'package:semnox/core/domain/use_cases/splash_screen/get_base_url_use_case.dart';
import 'package:semnox/di/injection_container.dart';

part 'splash_screen_state.dart';
part 'splash_screen_notifier.freezed.dart';

final splashScreenProvider = StateNotifierProvider<SplashScreenNotifier, SplashScreenState>(
  (ref) => SplashScreenNotifier(
    sl.get(),
    sl.get(),
  ),
);

class SplashScreenNotifier extends StateNotifier<SplashScreenState> {
  SplashScreenNotifier(this._getBaseURL, this._authenticateBaseURLUseCase) : super(const _Initial());

  final GetBaseURLUseCase _getBaseURL;
  final AuthenticateBaseURLUseCase _authenticateBaseURLUseCase;

  void getBaseUrl() async {
    final response = await _getBaseURL();
    response.fold(
      (l) => Logger().e(l.message),
      (r) => Logger().d(r),
    );
  }

  void authenticateBaseURL() async {
    final response = await _authenticateBaseURLUseCase();
    response.fold(
      (l) => state = _Error(l.message),
      (r) {
        authenticateApi(r);
      },
    );
  }
}