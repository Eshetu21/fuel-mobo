abstract class UserEvent {}

class GetUserByIdEvent extends UserEvent {
  final String userId;

  GetUserByIdEvent({required this.userId});
}

