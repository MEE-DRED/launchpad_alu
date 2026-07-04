import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/error/failure.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/app_primary_button.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/chip_input_field.dart';
import '../data/models/opportunity.dart';
import 'opportunity_controllers.dart';
import 'opportunity_providers.dart';

class CreateOpportunityScreen extends ConsumerStatefulWidget {
  const CreateOpportunityScreen({super.key, this.opportunityId});

  final String? opportunityId;

  @override
  ConsumerState<CreateOpportunityScreen> createState() =>
      _CreateOpportunityScreenState();
}

class _CreateOpportunityScreenState
    extends ConsumerState<CreateOpportunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _openingsController = TextEditingController(text: '1');
  final _responsibilitiesController = TextEditingController();
  final _benefitsController = TextEditingController();
  List<String> _skills = [];
  InternshipType _type = InternshipType.internship;
  WorkMode _workMode = WorkMode.remote;
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    if (widget.opportunityId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExisting());
    }
  }

  void _loadExisting() {
    final opp = ref.read(opportunityProvider(widget.opportunityId!)).value;
    if (opp == null || _titleController.text.isNotEmpty) return;
    _titleController.text = opp.title;
    _descriptionController.text = opp.description;
    _durationController.text = opp.duration;
    _openingsController.text = opp.openings.toString();
    _responsibilitiesController.text = opp.responsibilities;
    _benefitsController.text = opp.benefits;
    _skills = List.from(opp.skillsRequired);
    _type = opp.internshipType;
    _workMode = opp.workMode;
    _deadline = opp.deadline;
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _openingsController.dispose();
    _responsibilitiesController.dispose();
    _benefitsController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _deadline,
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skills.isEmpty) {
      AppSnackbar.error(context, 'Add at least one required skill.');
      return;
    }

    final existing = widget.opportunityId != null
        ? ref.read(opportunityProvider(widget.opportunityId!)).value
        : null;

    final id = await ref.read(opportunityFormControllerProvider.notifier).save(
          existing: existing,
          title: _titleController.text,
          description: _descriptionController.text,
          skillsRequired: _skills,
          duration: _durationController.text,
          internshipType: _type,
          workMode: _workMode,
          deadline: _deadline,
          openings: int.parse(_openingsController.text.trim()),
          responsibilities: _responsibilitiesController.text,
          benefits: _benefitsController.text,
        );

    if (!mounted) return;
    final state = ref.read(opportunityFormControllerProvider);
    state.whenOrNull(
      error: (error, _) {
        AppSnackbar.error(
          context,
          error is Failure ? error.message : 'Could not save opportunity.',
        );
      },
    );
    if (id != null && mounted) {
      AppSnackbar.success(context, 'Opportunity saved.');
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(opportunityFormControllerProvider).isLoading;
    final isEditing = widget.opportunityId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit opportunity' : 'Post opportunity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppTextField(
              controller: _titleController,
              label: 'Title',
              validator: (v) => Validators.required(v, field: 'Title'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 4,
              validator: (v) => Validators.required(v, field: 'Description'),
            ),
            const SizedBox(height: 16),
            ChipInputField(
              label: 'Skills required',
              values: _skills,
              onChanged: (values) => setState(() => _skills = values),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _durationController,
              label: 'Duration',
              hint: 'e.g. 3 months',
              validator: (v) => Validators.required(v, field: 'Duration'),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<InternshipType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Internship type'),
              items: InternshipType.values
                  .map((t) =>
                      DropdownMenuItem(value: t, child: Text(t.label)))
                  .toList(),
              onChanged: (v) => setState(() => _type = v ?? _type),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WorkMode>(
              initialValue: _workMode,
              decoration: const InputDecoration(labelText: 'Work mode'),
              items: WorkMode.values
                  .map((m) =>
                      DropdownMenuItem(value: m, child: Text(m.label)))
                  .toList(),
              onChanged: (v) => setState(() => _workMode = v ?? _workMode),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Application deadline'),
              subtitle: Text(DateFormat.yMMMd().format(_deadline)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDeadline,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _openingsController,
              label: 'Number of openings',
              keyboardType: TextInputType.number,
              validator: (v) => Validators.positiveInt(v, field: 'openings'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _responsibilitiesController,
              label: 'Responsibilities',
              maxLines: 4,
              validator: (v) =>
                  Validators.required(v, field: 'Responsibilities'),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _benefitsController,
              label: 'Benefits',
              maxLines: 3,
              validator: (v) => Validators.required(v, field: 'Benefits'),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: isEditing ? 'Save changes' : 'Publish opportunity',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
