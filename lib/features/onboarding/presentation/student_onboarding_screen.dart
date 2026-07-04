import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/chip_input_field.dart';
import 'onboarding_controllers.dart';
import 'onboarding_options.dart';

class StudentOnboardingScreen extends ConsumerStatefulWidget {
  const StudentOnboardingScreen({super.key});

  @override
  ConsumerState<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

class _StudentOnboardingScreenState
    extends ConsumerState<StudentOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _linkedInController = TextEditingController();

  String? _program;
  String? _year;
  List<String> _skills = [];
  List<String> _interests = [];
  XFile? _profileImage;
  PlatformFile? _cvFile;

  @override
  void dispose() {
    _fullNameController.dispose();
    _portfolioController.dispose();
    _linkedInController.dispose();
    super.dispose();
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (image != null) setState(() => _profileImage = image);
  }

  Future<void> _pickCv() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _cvFile = result.files.first);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_program == null || _year == null) {
      AppSnackbar.error(context, 'Please select your program and year.');
      return;
    }
    if (_skills.isEmpty) {
      AppSnackbar.error(context, 'Add at least one skill.');
      return;
    }

    await ref.read(studentOnboardingControllerProvider.notifier).submit(
          fullName: _fullNameController.text,
          program: _program!,
          year: _year!,
          skills: _skills,
          interests: _interests,
          portfolioUrl: _portfolioController.text.trim().isEmpty
              ? null
              : _portfolioController.text.trim(),
          linkedInUrl: _linkedInController.text.trim().isEmpty
              ? null
              : _linkedInController.text.trim(),
          profileImage: _profileImage,
          cvFile: _cvFile,
        );

    if (!mounted) return;
    final state = ref.read(studentOnboardingControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        final message = error is Failure
            ? error.message
            : 'Could not save profile. Try again.';
        AppSnackbar.error(context, message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(studentOnboardingControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Tell startups about yourself',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This helps match you with the right opportunities.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _pickProfileImage,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  backgroundImage: _profileImage != null
                      ? FileImage(File(_profileImage!.path))
                      : null,
                  child: _profileImage == null
                      ? const Icon(Icons.camera_alt_outlined,
                          size: 32, color: AppColors.primary)
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _pickProfileImage,
                child: const Text('Add profile photo'),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _fullNameController,
              label: 'Full name',
              hint: 'Jane Doe',
              prefixIcon: const Icon(Icons.person_outline),
              validator: (v) => Validators.required(v, field: 'Full name'),
            ),
            const SizedBox(height: 20),
            _DropdownField(
              label: 'Program',
              value: _program,
              items: OnboardingOptions.programs,
              onChanged: (v) => setState(() => _program = v),
            ),
            const SizedBox(height: 20),
            _DropdownField(
              label: 'Year',
              value: _year,
              items: OnboardingOptions.years,
              onChanged: (v) => setState(() => _year = v),
            ),
            const SizedBox(height: 20),
            ChipInputField(
              label: 'Skills',
              values: _skills,
              onChanged: (values) => setState(() => _skills = values),
              hint: 'e.g. Flutter, Marketing',
            ),
            const SizedBox(height: 20),
            ChipInputField(
              label: 'Interests',
              values: _interests,
              onChanged: (values) => setState(() => _interests = values),
              hint: 'e.g. FinTech, EdTech',
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _portfolioController,
              label: 'Portfolio URL (optional)',
              hint: 'https://yourportfolio.com',
              keyboardType: TextInputType.url,
              prefixIcon: const Icon(Icons.link_outlined),
              validator: Validators.url,
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _linkedInController,
              label: 'LinkedIn URL (optional)',
              hint: 'https://linkedin.com/in/you',
              keyboardType: TextInputType.url,
              prefixIcon: const Icon(Icons.work_outline),
              validator: Validators.url,
            ),
            const SizedBox(height: 20),
            _FilePickerTile(
              label: 'Upload CV',
              fileName: _cvFile?.name,
              onTap: _pickCv,
            ),
            const SizedBox(height: 32),
            AppPrimaryButton(
              label: 'Complete profile',
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

class _FilePickerTile extends StatelessWidget {
  const _FilePickerTile({
    required this.label,
    required this.onTap,
    this.fileName,
  });

  final String label;
  final String? fileName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.upload_file_outlined, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    fileName ?? 'PDF or Word document',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
