import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solesteals/config/local_notifications/local_notifications.dart';

import 'package:solesteals/config/router/app_router.dart';
import 'package:solesteals/config/theme/app_theme.dart';
import 'package:solesteals/presentation/blocs/notifications/notifications_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // TODO: inicializar push notifications
  await NotificationsBloc.initializeFCM();
  //TODO: inicializar local notifications
  await LocalNotifications.initializeLocalNotifications();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (_) => NotificationsBloc(
                showLocalNotification: LocalNotifications.showLocalNotification,
                requestLocalNotificationPermission:
                    LocalNotifications.requestPermissionLocalNotifications,
              )),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      // TODO! `HandleNotificationInteractions` envuelve todo el App dentro de este
      builder: (context, child) =>
          HandleNotificationInteractions(child: child!),
    );
  }
}

// Para cuando hace click en la notificacion en background
// la interacion en primer plano lo maneja `onDidReceiveNotificationResponse`
class HandleNotificationInteractions extends StatefulWidget {
  final Widget child;
  const HandleNotificationInteractions({super.key, required this.child});

  @override
  State<HandleNotificationInteractions> createState() =>
      _HandleNotificationInteractionsState();
}

class _HandleNotificationInteractionsState
    extends State<HandleNotificationInteractions> {
  // It is assumed that all messages contain a data field with the key 'type'
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    // TODO! llama a la funcion `handleRemoteMessage` del bloc
    // context.read<NotificationsBloc>().handleRemoteMessage(message);

    // TODO! redirige a la pantalla
    final path = message.data['path'];
    print('_handleMessage: ${path}');
    context.read<NotificationsBloc>().add(NotificationPathChanged(path));
    appRouter.pushNamed('homeWithPath', params: {'path': path});
  }

  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    setupInteractedMessage();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
