import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../opportunities/presentation/opportunity_providers.dart';
import 'application_controllers.dart';

class ApplyScreen extends ConsumerStatefulWidget {
  const ApplyScreen({super.key, required this.opportunityId});

  final String opportunityId;

  @override
  ConsumerState<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends ConsumerState<ApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _coverLetterController = TextEditingController();
  final _portfolioController = TextEditingController();
  PlatformFile? _resumeFile;

  @override
  void dispose() {
    _coverLetterController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _resumeFile = result.files.first);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final opp = ref.read(opportunityProvider(widget.opportunityId)).value;
    if (opp == null) return;

    final id = await ref.read(applyControllerProvider.notifier).submit(
          opportunityId: opp.id,
          opportunityTitle: opp.title,
          startupId: opp.startupId,
          startupName: opp.startupName,
          coverLetter: _coverLetterController.text.trim().isEmpty
              ? null
              : _coverLetterController.text.trim(),
          portfolioUrl: _portfolioController.text.trim().isEmpty
              ? null
              : _portfolioController.text.trim(),
          resumeFile: _resumeFile,
        );

    if (!mounted) return;
    final state = ref.read(applyControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        AppSnackbar.error(
          context,
          error is Failure ? error.message : 'Application failed.',
        );
      },
    );
    if (id != null && mounted) {
      AppSnackbar.success(context, 'Application submitted!');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final oppAsync = ref.watch(opportunityProvider(widget.opportunityId));
    final isLoading = ref.watch(applyControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Apply')),
      body: oppAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text('Could not load opportunity')),
        data: (opp) {
          if (opp == null) {
            return const Center(child: Text('Opportunity not found'));
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  opp.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text('at ${opp.startupName}'),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _coverLetterController,
                  label: 'Cover letter (optional)',
                  maxLines: 6,
                  hint: 'Tell the startup why you are a great fit...',
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _portfolioController,
                  label: 'Portfolio URL (optional)',
                  keyboardType: TextInputType.url,
                  validator: Validators.url,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Upload resume (optional)'),
                  subtitle: Text(_resumeFile?.name ?? 'PDF or Word document'),
                  trailing: const Icon(Icons.upload_file_outlined),
                  onTap: _pickResume,
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: 'Submit application',
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
