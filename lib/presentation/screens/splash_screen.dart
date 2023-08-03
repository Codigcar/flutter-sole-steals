// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    // Future.microtask(() => _allowNotifications());
    Future.microtask(() => _splash());
    // _splash();
  }

  Future<void> _allowNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('isFirstTime', true);
    bool? isFirstTime = prefs.getBool('isFirstTime');
    log(isFirstTime.toString());

    if (isFirstTime!) {
      log("Enrta aquí∫");
      prefs.setBool('isFirstTime', false);
      return;
    }
  }

  void _splash() async {
    await Future.delayed(const Duration(milliseconds: 2800));
    final path = BlocProvider.of<NotificationsBloc>(context).state.path;
    await _allowNotifications();
    print('[DATA]: $path');
    if (path != "/") return;
    appRouter.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/splash.gif');
  }
}
