import 'package:flutter_bloc/flutter_bloc.dart';

mixin PasswordVisibilityMixin<T> on Cubit<T> {
  /// For single visibility state
  bool _isVisible = true;

  bool get isVisible => _isVisible;

  void togglePasswordVisibility({required T passwordVisibilityState}) {
    _isVisible = !_isVisible;
    emit(passwordVisibilityState);
  }

  /// For multiple visibility states
  final Map<String, bool> visibilityStates = {};

  bool isVisibleFor(String key) => visibilityStates[key] ?? true;

  void togglePasswordVisibilityFor({required String key, required T passwordVisibilityState}) {
    visibilityStates[key] = !(isVisibleFor(key));
    emit(passwordVisibilityState);
  }
}
