// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:solesteals/config/router/app_router.dart';
import 'package:solesteals/presentation/blocs/notifications/notifications_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _allowNotifications());
    // _splash();
  }

  Future<void> _allowNotifications() async {
    PermissionStatus permissionStatus = await Permission.notification.request();
    if (permissionStatus == PermissionStatus.denied) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Allow app to send you notifications ?'),
            content: const Text(
                'You need to allow notifications permissions in the app settings to receive notifications.'),
            actions: <Widget>[
              // if user deny again, we do nothing
              TextButton(
                onPressed: () {
                  _splash();
                  Navigator.pop(context);
                },
                child: const Text('Don\'t allow'),
              ),

              // if user is agree, you can redirect him to the app parameters :)
              TextButton(
                onPressed: () {
                  openAppSettings();
                  _splash();
                  Navigator.pop(context);
                },
                child: const Text('Allow'),
              ),
            ],
          );
        },
      );

      // _splash();
    }
    log('[NOTIFICATIONS]: $permissionStatus');
  }

  void _splash() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    final path = BlocProvider.of<NotificationsBloc>(context).state.path;
    print('[DATA]: $path');
    if (path != "/") return;
    appRouter.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/splash.gif');
  }
}
