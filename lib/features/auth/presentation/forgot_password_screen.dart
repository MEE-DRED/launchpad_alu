import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/auth_scaffold.dart';
import 'auth_controllers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(forgotPasswordControllerProvider.notifier)
        .sendResetEmail(_emailController.text);

    if (!mounted) return;
    final state = ref.read(forgotPasswordControllerProvider);
    state.whenOrNull(
      data: (_) {
        setState(() => _emailSent = true);
        AppSnackbar.success(
          context,
          'Password reset email sent. Check your inbox.',
        );
      },
      error: (error, _) {
        final message = error is Failure
            ? error.message
            : 'Could not send reset email. Try again.';
        AppSnackbar.error(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forgotPasswordControllerProvider).isLoading;

    return AuthScaffold(
      title: 'Reset password',
      subtitle: _emailSent
          ? 'We sent a reset link to ${_emailController.text.trim()}.'
          : 'Enter your email and we will send you a reset link.',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_emailSent) ...[
              AppTextField(
                controller: _emailController,
                label: 'Email',
                hint: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: Validators.email,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: 28),
              AppPrimaryButton(
                label: 'Send reset link',
                isLoading: isLoading,
                onPressed: _submit,
              ),
            ] else
              AppPrimaryButton(
                label: 'Back to sign in',
                onPressed: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}
