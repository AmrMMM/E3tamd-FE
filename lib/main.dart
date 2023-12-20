// ignore_for_file: library_private_types_in_public_api

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/implementations/notification_handler.dart';
import 'package:e3tmed/screens/agent_phase/auth/agent_forgotpassword_screen.dart';
import 'package:e3tmed/screens/agent_phase/auth/agent_login_screen.dart';
import 'package:e3tmed/screens/agent_phase/home/agent_home_screen.dart';
import 'package:e3tmed/screens/agent_phase/notification/agent_notification_screen.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_details_screen.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_screen.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_status.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_summary_screen.dart';
import 'package:e3tmed/screens/agent_phase/profile/agent_changepassword_screen.dart';
import 'package:e3tmed/screens/agent_phase/profile/agent_profile_screen.dart';
import 'package:e3tmed/screens/agent_phase/request/agent_request_screen.dart';
import 'package:e3tmed/screens/end_user_phase/auth/complete_register_screen.dart';
import 'package:e3tmed/screens/end_user_phase/auth/forgot_password.dart';
import 'package:e3tmed/screens/end_user_phase/auth/main_login_screen.dart';
import 'package:e3tmed/screens/end_user_phase/auth/register_screen.dart';
import 'package:e3tmed/screens/end_user_phase/auth/verify_username_screen.dart';
import 'package:e3tmed/screens/end_user_phase/intro/intro_screens.dart';
import 'package:e3tmed/screens/end_user_phase/intro/login_screen.dart';
import 'package:e3tmed/screens/end_user_phase/intro/splash_screen.dart';
import 'package:e3tmed/screens/end_user_phase/navhost/nav_host_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setDependencies();
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@drawable/logo_colored");
  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestSoundPermission: true,
  );
  InitializationSettings initializationSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );
  await notificationsPlugin.initialize(initializationSettings);
  var handler = NotificationHandler();
  // handler.initNotification();
  handler.initializeService();
  runApp(const RestartWidget(child: MyApp()));
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  final backgroundColor = const Color.fromRGBO(18, 0, 66, 1);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: backgroundColor));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'E3tmed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
                    useMaterial3: false,

          primaryColor: const Color.fromRGBO(18, 0, 66, 1),
          appBarTheme: AppBarTheme(
              backgroundColor: backgroundColor,
              centerTitle: true,
              titleTextStyle:
                  const TextStyle(color: Colors.white, fontSize: 16)),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: "Jenine"),
            bodyMedium: TextStyle(
                color: Colors.black, fontSize: 20, fontFamily: "Almarai"),
            displayLarge: TextStyle(
                fontFamily: "Jenine", fontSize: 60, color: Colors.white),
            displayMedium: TextStyle(
                fontFamily: "Jenine", fontSize: 30, color: Colors.white),
            displaySmall: TextStyle(
                fontFamily: "Jenine", fontSize: 30, color: Colors.yellow),
          ),
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(secondary: const Color.fromRGBO(43, 162, 129, 1))
              .copyWith(background: backgroundColor)),
      routes: {
        '/': (context) => SplashScreen(context),
        //End-user screens
        '/introScreen': (context) => IntroScreen(context),
        '/login': (context) => LoginSignUpScreen(context),
        '/mainLogin': (context) => MainLoginScreen(context),
        '/register': (context) => RegisterScreen(context),
        '/completeRegister': (context) => CompleteRegisterScreen(context),
        '/verifyUsername': (context) => VerifyUsernameScreen(context),
        '/forgotPassword': (context) => ForgotPasswordScreen(context),
        '/home': (context) => NavHostScreen(context),
        //Agent Screens
        "/aLoginScreen": (context) => AgentLoginScreen(context),
        "/aForgotPassword": (context) => AgentForgotPasswordScreen(context),
        "/aHomeScreen": (context) => AgentHomeScreen(context),
        "/aRequestScreen": (context) => AgentRequestScreen(context),
        "/aProfileScreen": (context) => AgentProfileScreen(context),
        "/aNotificationScreen": (context) => AgentNotificationScreen(context),
        "/aChangePasswordScreen": (context) =>
            AgentChangePasswordScreen(context),
        "/aOrderScreen": (context) => AgentOrderScreen(context),
        "/aOrderDetailsScreen": (context) => AgentOrderDetailsScreen(context),
        "/aOrderSummaryScreen": (context) => AgentOrderSummaryScreen(context),
        "/aOrderStatusScreen": (context) => AgentOrderStatusScreen(context),
      },
    );
  }
}
