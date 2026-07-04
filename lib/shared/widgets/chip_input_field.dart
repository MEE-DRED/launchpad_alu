import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Input for adding/removing string tags (skills, interests, etc.).
class ChipInputField extends StatefulWidget {
  const ChipInputField({
    super.key,
    required this.label,
    required this.values,
    required this.onChanged,
    this.hint = 'Type and press add',
  });

  final String label;
  final List<String> values;
  final ValueChanged<List<String>> onChanged;
  final String hint;

  @override
  State<ChipInputField> createState() => _ChipInputFieldState();
}

class _ChipInputFieldState extends State<ChipInputField> {
  final _controller = TextEditingController();

  void _addValue() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    if (widget.values.contains(value)) {
      _controller.clear();
      return;
    }
    widget.onChanged([...widget.values, value]);
    _controller.clear();
  }

  void _removeValue(String value) {
    widget.onChanged(widget.values.where((v) => v != value).toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addValue(),
                decoration: InputDecoration(hintText: widget.hint),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _addValue,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        if (widget.values.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.values
                .map(
                  (value) => Chip(
                    label: Text(value),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => _removeValue(value),
                    backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                    side: BorderSide.none,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
