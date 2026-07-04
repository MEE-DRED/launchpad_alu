import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import 'onboarding_controllers.dart';
import 'onboarding_options.dart';

class StartupOnboardingScreen extends ConsumerStatefulWidget {
  const StartupOnboardingScreen({super.key});

  @override
  ConsumerState<StartupOnboardingScreen> createState() =>
      _StartupOnboardingScreenState();
}

class _StartupOnboardingScreenState
    extends ConsumerState<StartupOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _founderController = TextEditingController();
  final _teamSizeController = TextEditingController(text: '1');
  final _websiteController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  String? _industry;
  XFile? _logo;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _founderController.dispose();
    _teamSizeController.dispose();
    _websiteController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (image != null) setState(() => _logo = image);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_industry == null) {
      AppSnackbar.error(context, 'Please select an industry.');
      return;
    }

    await ref.read(startupOnboardingControllerProvider.notifier).submit(
          name: _nameController.text,
          description: _descriptionController.text,
          industry: _industry!,
          teamSize: int.parse(_teamSizeController.text.trim()),
          founderName: _founderController.text,
          website: _websiteController.text.trim().isEmpty
              ? null
              : _websiteController.text.trim(),
          contactEmail: _contactEmailController.text.trim().isEmpty
              ? null
              : _contactEmailController.text.trim(),
          contactPhone: _contactPhoneController.text.trim().isEmpty
              ? null
              : _contactPhoneController.text.trim(),
          logo: _logo,
        );

    if (!mounted) return;
    final state = ref.read(startupOnboardingControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        final message = error is Failure
            ? error.message
            : 'Could not save startup profile. Try again.';
        AppSnackbar.error(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(startupOnboardingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Set up your startup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Build your startup profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Students will discover your opportunities through this profile.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _pickLogo,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    image: _logo != null
                        ? DecorationImage(
                            image: FileImage(File(_logo!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _logo == null
                      ? const Icon(Icons.add_a_photo_outlined,
                          size: 32, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _pickLogo,
                child: const Text('Upload logo'),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _nameController,
              label: 'Startup name',
              hint: 'Acme Labs',
              prefixIcon: const Icon(Icons.business_outlined),
              validator: (v) => Validators.required(v, field: 'Startup name'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'What problem does your startup solve?',
              maxLines: 4,
              validator: (v) => Validators.required(v, field: 'Description'),
            ),
            const SizedBox(height: 20),
            _DropdownField(
              label: 'Industry',
              value: _industry,
              items: OnboardingOptions.industries,
              onChanged: (v) => setState(() => _industry = v),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _teamSizeController,
              label: 'Team size',
              hint: '5',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.groups_outlined),
              validator: (v) => Validators.positiveInt(v, field: 'team size'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _founderController,
              label: 'Founder name',
              hint: 'John Smith',
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => Validators.required(v, field: 'Founder name'),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _websiteController,
              label: 'Website (optional)',
              hint: 'https://yourstartup.com',
              keyboardType: TextInputType.url,
              prefixIcon: const Icon(Icons.language_outlined),
              validator: Validators.url,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _contactEmailController,
              label: 'Contact email (optional)',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                return Validators.email(value);
              },
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _contactPhoneController,
              label: 'Contact phone (optional)',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            const SizedBox(height: 32),
            AppPrimaryButton(
              label: 'Complete setup',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(hintText: 'Select $label'),
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
