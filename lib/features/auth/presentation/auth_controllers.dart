import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import 'auth_providers.dart';

/// Handles email/password sign-in.
class LoginController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authRepositoryProvider);
      if (auth == null) throw Failures.network;
      await auth.signIn(email: email, password: password);
    });
  }
}

final loginControllerProvider =
    AsyncNotifierProvider<LoginController, void>(LoginController.new);

/// Handles registration with role selection and initial Firestore user doc.
class RegisterController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> register({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authRepositoryProvider);
      final userRepo = ref.read(userRepositoryProvider);
      if (auth == null || userRepo == null) throw Failures.network;

      final user = await auth.register(email: email, password: password);
      await userRepo.createUser(
        uid: user.uid,
        email: email,
        role: role,
      );
    });
  }
}

final registerControllerProvider =
    AsyncNotifierProvider<RegisterController, void>(RegisterController.new);

/// Sends a password reset email.
class ForgotPasswordController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> sendResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authRepositoryProvider);
      if (auth == null) throw Failures.network;
      await auth.sendPasswordReset(email);
    });
  }
}

final forgotPasswordControllerProvider =
    AsyncNotifierProvider<ForgotPasswordController, void>(
  ForgotPasswordController.new,
);
