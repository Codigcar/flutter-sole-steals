import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:solesteals/config/local_notifications/local_notifications.dart';

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
    context.read<NotificationsBloc>().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    // context.select((NotificationsBloc bloc) => bloc.state.status);
    // final path = BlocProvider.of<NotificationsBloc>(context).state.path;
    // print('[PATH]: ${path}');

    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
            child: InAppWebView(
          initialUrlRequest:
              URLRequest(url: Uri.parse('https://www.solesteals.com${widget.path}')),
          initialOptions: InAppWebViewGroupOptions(
            ios: IOSInAppWebViewOptions(disallowOverScroll: true),
          ),
        )),
      ),
    );
  }
}
