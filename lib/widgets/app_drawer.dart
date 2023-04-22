import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/screens/MANAGER/managing_fault_screen.dart';
import 'package:mybait/screens/TENANT/payment_screen.dart';
import 'package:provider/provider.dart';

import '../screens/login_screen.dart';
import '../screens/MANAGER/overview_manager_screen.dart';
import '../screens/TENANT/overview_tenant_screen.dart';
import '../screens/reports_screen.dart';

class AppDrawer extends StatefulWidget {
  static const routeName = '/drawer';

  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  User? user = FirebaseAuth.instance.currentUser;

  var _userType = '';

  _fetchUserType() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      setState(() {
        _userType = value.data()!['userType'];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _userType = '';
  }

  Widget userDrawerToShow(BuildContext context) {
    if (_userType == 'MANAGER') {
      return Column(
        children: [
          AppBar(
            title: const Text('What you like to do?'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OverviewManagerScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.error_outline),
            title: const Text('Managing Fault'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ManagingFaultScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: const Text('Cash Register'),
            onTap: () {
              // todo: implement Cash Register Page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.report_gmailerrorred),
            title: const Text('Reports'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ReportsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('Information'),
            onTap: () {
              // todo: implement Information Page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure, do you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop(
                            true); // dismisses only the dialog and returns true
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      },
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(
                            false); // dismisses only the dialog and returns false
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    }
    return Column(
      children: [
        AppBar(
          title: const Text('What you like to do? 🤔'),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(OverviewTenantScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.report_gmailerrorred),
          title: const Text('Reports'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(ReportsScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.payment_outlined),
          title: const Text('Payment'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(PaymentScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Information'),
          onTap: () {
            // todo: implement Information Page
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure, do you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop(
                          true); // dismisses only the dialog and returns true
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(
                          false); // dismisses only the dialog and returns false
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _fetchUserType();
    return Drawer(child: userDrawerToShow(context));
  }
}
