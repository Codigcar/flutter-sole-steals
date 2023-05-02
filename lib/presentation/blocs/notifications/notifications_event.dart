part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

// Cambiar status autorizacion
class NotificationsStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;
  NotificationsStatusChanged(this.status);
}

// NotificationReceived #PushMessage
class NotificationReceived extends NotificationsEvent {
  final PushMessage pushMessage;
  NotificationReceived(this.pushMessage);
}

// cambiar path
class NotificationPathChanged extends NotificationsEvent {
  final String path;
  NotificationPathChanged(this.path);
}
