part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  // state de autorizar notificaciones
  final AuthorizationStatus status;
  // crear modelo de notificacions
  final List<PushMessage> notifications;
  // state del path
  final String path;

  const NotificationsState({
    this.status = AuthorizationStatus.authorized,
    this.notifications = const [],
    this.path = '/'
  });

  // siempre usar un copyWith del objeto a devolver
  // agregar todas las variables opcionales
  NotificationsState copyWith({
    AuthorizationStatus? status,
    List<PushMessage>? notifications,
    String? path
  }) =>
      NotificationsState(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        path: path ?? this.path,
      );

  @override
  List<Object> get props => [status, notifications, path];
}
