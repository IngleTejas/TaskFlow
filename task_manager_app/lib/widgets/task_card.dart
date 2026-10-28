import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';

/// Modern, elevated Task Card with status chips, completion toggle, and clean aesthetics.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('EEE, MMM d').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  bool _isOverdue(String? isoDate) {
    if (isoDate == null || task.isCompleted) return false;
    try {
      final dt = DateTime.parse(isoDate);
      final today = DateTime.now();
      final dateOnly = DateTime(today.year, today.month, today.day);
      return dt.isBefore(dateOnly);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final completed = task.isCompleted;
    final overdue = _isOverdue(task.dueDate);
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: completed
              ? const Color(0xFFF1F5F9)
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onEdit,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Animated-feel Completion Checkbox ──────────────────────────
                GestureDetector(
                  onTap: onToggleComplete,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(top: 2),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: completed
                          ? const Color(0xFF10B981) // Emerald green
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: completed
                            ? const Color(0xFF10B981)
                            : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                    ),
                    child: completed
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 14),

                // ── Task Details ───────────────────────────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          decoration: completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: completed
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF0F172A),
                        ),
                      ),

                      // Description preview
                      if (task.description != null &&
                          task.description!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                            color: completed
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      // Metadata chips (Status & Due Date)
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _StatusBadge(completed: completed),
                          if (task.dueDate != null)
                            _DueDateBadge(
                              dateText: _formatDate(task.dueDate!),
                              isOverdue: overdue,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Delete Action ──────────────────────────────────────────────
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: const Color(0xFF94A3B8),
                  hoverColor: const Color(0xFFFEE2E2),
                  tooltip: 'Delete task',
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool completed;
  const _StatusBadge({required this.completed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: completed
            ? const Color(0xFFECFDF5) // Emerald 50
            : const Color(0xFFFFFBEB), // Amber 50
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: completed
                  ? const Color(0xFF10B981)
                  : const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            completed ? 'Completed' : 'Pending',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: completed
                  ? const Color(0xFF047857) // Emerald 700
                  : const Color(0xFFB45309), // Amber 700
            ),
          ),
        ],
      ),
    );
  }
}

class _DueDateBadge extends StatelessWidget {
  final String dateText;
  final bool isOverdue;

  const _DueDateBadge({
    required this.dateText,
    required this.isOverdue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOverdue ? const Color(0xFFFEF2F2) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOverdue ? Icons.warning_amber_rounded : Icons.calendar_today_rounded,
            size: 12,
            color: isOverdue ? const Color(0xFFEF4444) : const Color(0xFF64748B),
          ),
          const SizedBox(width: 4),
          Text(
            dateText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOverdue ? const Color(0xFFDC2626) : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}
