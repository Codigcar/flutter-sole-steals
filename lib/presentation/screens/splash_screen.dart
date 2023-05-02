import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // context.watch<NotificationsBloc>().
    // final path = context.watch<NotificationsBloc>().state.path;
    _splash();
  }

  void _splash() async {
    await Future.delayed(const Duration(milliseconds: 2800));
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
