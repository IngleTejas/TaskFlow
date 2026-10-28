import 'package:flutter/material.dart';

/// Reusable, polished form fields widget for creating and editing tasks.
class TaskFormFields extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String? selectedStatus;
  final String? selectedDueDate;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onDueDateChanged;
  final bool isEditMode;

  const TaskFormFields({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.selectedStatus,
    required this.selectedDueDate,
    required this.onStatusChanged,
    required this.onDueDateChanged,
    required this.isEditMode,
  });

  @override
  State<TaskFormFields> createState() => _TaskFormFieldsState();
}

class _TaskFormFieldsState extends State<TaskFormFields> {
  Future<void> _pickDate(BuildContext context) async {
    final initialDate = widget.selectedDueDate != null
        ? DateTime.tryParse(widget.selectedDueDate!) ?? DateTime.now()
        : DateTime.now().add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6366F1), // Indigo header/accent
              onPrimary: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final iso = picked.toIso8601String().substring(0, 10);
      widget.onDueDateChanged(iso);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title Input ───────────────────────────────────────────────────────
        _buildSectionHeader('Task Title', isRequired: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.titleController,
          maxLength: 255,
          textInputAction: TextInputAction.next,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'e.g. Design homepage hero section',
            prefixIcon: const Icon(Icons.edit_note_rounded, color: Color(0xFF6366F1)),
            counterStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task title';
            }
            if (value.trim().length > 255) {
              return 'Title must be 255 characters or fewer';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // ── Description Input ─────────────────────────────────────────────────
        _buildSectionHeader('Description', isRequired: false),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.descriptionController,
          maxLines: 4,
          style: const TextStyle(fontSize: 14),
          decoration: const InputDecoration(
            hintText: 'Add details, notes, or checklists...',
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: 58),
              child: Icon(Icons.notes_rounded, color: Color(0xFF64748B)),
            ),
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 20),

        // ── Due Date Picker ───────────────────────────────────────────────────
        _buildSectionHeader('Due Date', isRequired: false),
        const SizedBox(height: 8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _pickDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: Color(0xFF6366F1), size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.selectedDueDate ?? 'Select completion target date',
                    style: TextStyle(
                      fontSize: 14,
                      color: widget.selectedDueDate != null
                          ? const Color(0xFF0F172A)
                          : const Color(0xFF94A3B8),
                      fontWeight: widget.selectedDueDate != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                if (widget.selectedDueDate != null)
                  IconButton(
                    icon: const Icon(Icons.cancel_rounded, size: 18, color: Color(0xFF94A3B8)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => widget.onDueDateChanged(null),
                  )
                else
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFFCBD5E1)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ── Status Selector (Edit Mode) ───────────────────────────────────────
        if (widget.isEditMode) ...[
          _buildSectionHeader('Status', isRequired: true),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _StatusOptionButton(
                    title: 'Pending',
                    icon: Icons.hourglass_top_rounded,
                    isSelected: widget.selectedStatus == 'pending',
                    activeColor: const Color(0xFFF59E0B),
                    onTap: () => widget.onStatusChanged('pending'),
                  ),
                ),
                Expanded(
                  child: _StatusOptionButton(
                    title: 'Completed',
                    icon: Icons.check_circle_rounded,
                    isSelected: widget.selectedStatus == 'completed',
                    activeColor: const Color(0xFF10B981),
                    onTap: () => widget.onStatusChanged('completed'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, {required bool isRequired}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF475569),
            letterSpacing: 0.2,
          ),
        ),
        if (isRequired)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFEF4444),
            ),
          ),
      ],
    );
  }
}

class _StatusOptionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;

  const _StatusOptionButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? activeColor : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
