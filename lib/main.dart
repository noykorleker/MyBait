import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mybait/screens/MANAGER/edit_payment_screen.dart';
import 'package:mybait/screens/MANAGER/managing_payment_screen.dart';
import 'package:mybait/screens/TENANT/maintenance_payment_screen.dart';
import 'package:mybait/screens/TENANT/payment_screen.dart';
import 'package:mybait/screens/create_building_screen.dart';
import 'package:mybait/screens/edit_report_screen.dart';
import 'package:mybait/screens/forgot_password_screen.dart';
import 'package:mybait/screens/join_building_screen.dart';
import 'package:mybait/screens/login_screen.dart';
import 'package:mybait/screens/MANAGER/managing_report_screen.dart';
import 'package:mybait/screens/MANAGER/overview_manager_screen.dart';
import 'package:mybait/screens/TENANT/overview_tenant_screen.dart';
import 'package:mybait/screens/TENANT/home_committee_payment_history_screen.dart';
import 'package:mybait/screens/TENANT/home_committee_payment_screen.dart';
import 'package:mybait/screens/register_screen.dart';
import 'package:mybait/screens/reports_screen.dart';
import 'package:mybait/screens/splash_screen.dart';
import 'package:mybait/screens/welcome_screen.dart';
import 'package:mybait/widgets/app_drawer.dart';

import 'screens/TENANT/maintenance_payment_history_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> checkUserType(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((userDoc) {
        if (userDoc.exists) {
          if (userDoc.data()!.containsKey('userType')) {
            final String userType = userDoc.get('userType');
            if (userType == 'MANAGER') {
              // Navigate to manager screen
              Navigator.pushReplacementNamed(
                  context, OverviewManagerScreen.routeName);
            } else {
              if (userDoc.data()!.containsKey('buildingID') && userDoc.data()!.containsKey('apartmentNumber')) {
                // Navigate to tenant user screen
                Navigator.pushReplacementNamed(
                    context, OverviewTenantScreen.routeName);
              } else {
                // Navigate to welcom screen
                Navigator.pushReplacementNamed(
                    context, WelcomeScreen.routeName);
              }
            }
          }
        } else {
          // Navigate to login screen
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
      });
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBait',
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            }
            if (userSnapshot.hasData) {
              checkUserType(context);
            }
            return const LoginScreen();
          }),
      routes: {
        OverviewManagerScreen.routeName: (context) => OverviewManagerScreen(),
        OverviewTenantScreen.routeName: (context) => OverviewTenantScreen(),
        EditReportScreen.routeName: (context) => EditReportScreen(),
        ManagingReportScreen.routeName: (context) => ManagingReportScreen(),
        ReportsScreen.routeName: (context) => ReportsScreen(),
        SplashScreen.routeName: (context) => SplashScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        AppDrawer.routeName: (context) => AppDrawer(),
        HomeCommitteePaymentScreen.routeName: (context) => HomeCommitteePaymentScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        HomeCommitteePaymentHistoryScreen.routeName: (context) => HomeCommitteePaymentHistoryScreen(),
        WelcomeScreen.routeName: (context) => const WelcomeScreen(),
        CreateBuildingScreen.routeName: (context) => CreateBuildingScreen(),
        JoinBuildingScreen.routeName: (context) => const JoinBuildingScreen(),
        ForgotPasswordScreen.routeName: (context) =>
            const ForgotPasswordScreen(),
        PaymentScreen.routeName: (context) => const PaymentScreen(),
        MaintenancePaymentScreen.routeName:(context) => MaintenancePaymentScreen(),
        MaintenancePaymentHistoryScreen.routeName:(context) => MaintenancePaymentHistoryScreen(),
        ManagingPaymentScreen.routeName:(context) => ManagingPaymentScreen(),
        EditPaymentScreen.routeName:(context) => EditPaymentScreen(),
      },
    );
  }
}
