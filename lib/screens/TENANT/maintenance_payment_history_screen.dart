import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MaintenancePaymentHistoryScreen extends StatelessWidget {
  static const routeName = '/MaintenancePaymentHistory';

  const MaintenancePaymentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var currentYear = now.year;
    return Scaffold(
       appBar: AppBar(
        title: const Text(
          'Payment History',
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('payments')
            .doc(currentYear.toString())
            .collection('Maintenance Payments')
            .where('isPaid', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            var paymentDocuments = snapshot.data!.docs;
            return paymentDocuments.isEmpty
                ? const Center(
                    child: Text(
                    'No History ☺️',
                    style: TextStyle(fontSize: 36)
                  ))
                : ListView.builder(
                    itemCount: paymentDocuments.length,
                    padding: const EdgeInsets.all(5),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.greenAccent[400],
                              foregroundColor: Colors.white,
                              child: paymentDocuments[index]['paymentType'] ==
                                      'month'
                                  ? const Icon(Icons.calendar_month)
                                  : const Icon(Icons.construction_outlined)),
                          title: Text(paymentDocuments[index]['title']),
                          trailing: const Icon(Icons.done),
                        ),
                      );
                    });
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    'No history\nhave a good day 🙏🏻',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}