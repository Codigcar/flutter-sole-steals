// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:solesteals/presentation/blocs/notifications/notifications_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String path;
  const HomeScreen({super.key, required this.path});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => verifyNotifications());
    context.read<NotificationsBloc>().requestPermission();
  }

  Future<void> verifyNotifications() async {
    PermissionStatus permissionStatus = await Permission.notification.request();

    if (permissionStatus == PermissionStatus.granted) {
      return;
    } else {
      showDialog(
        context: context,
        builder: (context) {
          if (Platform.isAndroid) {
            return AlertDialog(
              title: const Text('Allow app to send you notifications?'),
              content: const Text(
                  'You need to allow notifications permissions in the app settings to receive notifications.'),
              actions: <Widget>[
                // if user deny again, we do nothing
                TextButton(
                  onPressed: () {
                    context.pop(context);
                  },
                  child: const Text('Don\'t allow',
                      style: TextStyle(color: Colors.red)),
                ),

                // if user is agree, you can redirect him to the app parameters :)
                TextButton(
                  onPressed: () {
                    openAppSettings();
                    context.pop(context);
                  },
                  child:
                      const Text('Allow', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          }

          return CupertinoAlertDialog(
            title: const Text('Allow app to send you notifications?'),
            content: const Text(
                'You need to allow notifications permissions in the app settings to receive notifications.'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Don\'t allow', style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  context.pop(context);
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Allow', style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  openAppSettings();
                  context.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
    log('[NOTIFICATIONS]: $permissionStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
            child: InAppWebView(
          initialUrlRequest: URLRequest(
              url: Uri.parse('https://www.solesteals.com${widget.path}')),
          initialOptions: InAppWebViewGroupOptions(
            ios: IOSInAppWebViewOptions(disallowOverScroll: true),
          ),
        )),
      ),
    );
  }
}
