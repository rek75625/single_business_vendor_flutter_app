import 'package:equatable/equatable.dart';

enum TicketStatus {
  open,
  inProgress,
  resolved,
  closed;

  String get displayName {
    switch (this) {
      case TicketStatus.open:
        return 'Open';
      case TicketStatus.inProgress:
        return 'In Progress';
      case TicketStatus.resolved:
        return 'Resolved';
      case TicketStatus.closed:
        return 'Closed';
    }
  }
}

class TicketMessage extends Equatable {
  final String sender;
  final String text;
  final DateTime timestamp;
  final bool isSupport;

  const TicketMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isSupport = false,
  });

  @override
  List<Object?> get props => [sender, text, timestamp, isSupport];
}

class SupportTicket extends Equatable {
  final String id;
  final String subject;
  final String description;
  final TicketStatus status;
  final List<TicketMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupportTicket({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  SupportTicket copyWith({
    String? id,
    String? subject,
    String? description,
    TicketStatus? status,
    List<TicketMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, subject, description, status, messages, createdAt, updatedAt];
}
