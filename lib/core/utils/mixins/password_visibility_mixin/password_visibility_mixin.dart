import 'package:flutter_bloc/flutter_bloc.dart';

mixin PasswordVisibilityMixin<T> on Cubit<T> {
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  void togglePasswordVisibility({required T passwordVisibilityState}) {
    _isVisible = !_isVisible;
    emit(passwordVisibilityState);
  }
}