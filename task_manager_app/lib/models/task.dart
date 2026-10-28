class Task {
  final int id;
  final String title;
  final String? description;
  final String status; // "pending" | "completed"
  final String? dueDate; // "YYYY-MM-DD" or null
  final String createdAt;
  final String updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isCompleted => status == 'completed';

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      dueDate: json['due_date'] as String?, // snake_case from Laravel
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null && description!.isNotEmpty)
        'description': description,
      'status': status,
      if (dueDate != null) 'due_date': dueDate,
    };
  }

  Task copyWith({
    String? title,
    String? description,
    String? status,
    String? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

