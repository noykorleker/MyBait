import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybait/Services/firebase_helper.dart';
import 'package:mybait/Services/validator_helper.dart';
import 'package:mybait/models/payment.dart';
import 'package:mybait/widgets/custom_Button.dart';

import '../../widgets/custom_popupMenuButton.dart';
import '../../widgets/custom_toast.dart';

class EditPaymentScreen extends StatefulWidget {
  static const routeName = '/edit-payment';

  const EditPaymentScreen({super.key});

  @override
  State<EditPaymentScreen> createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  var customToast = CustomToast();
  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  var _editedPayment = Payment(
    id: null,
    title: '',
    paymentType: 'repair',
    amount: 0,
    createdBy: FirebaseAuth.instance.currentUser!.displayName,
    dateTime: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment'),
        actions: const [
          CustomPopupMenuButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title is Empty, Please Enter a Title';
                    }
                    if (ValidatorHelper.containsOnlyNumbers(value)) {
                      return 'Title Must Containt Characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedPayment = Payment(
                      id: _editedPayment.id,
                      title: value,
                      paymentType: _editedPayment.paymentType,
                      amount: _editedPayment.amount,
                      createdBy: _editedPayment.createdBy,
                      dateTime: _editedPayment.dateTime,
                    );
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Cost'),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_amountFocusNode);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Cost is Empty, Please Enter a Cost';
                    }
                    else if (!ValidatorHelper.containsOnlyNumbers(value)) {
                      return 'Please Enter a Cost (Numbers Only)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedPayment = Payment(
                      id: _editedPayment.id,
                      title: _editedPayment.title,
                      paymentType: _editedPayment.paymentType,
                      amount: int.parse(value!),
                      createdBy: _editedPayment.createdBy,
                      dateTime: _editedPayment.dateTime,
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 45,
                  width: 170,
                  child: customButton(
                    title: 'Add Expense',
                    buttonColor: Colors.blue,
                    icon: Icons.attach_money_sharp,
                    onClick: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!
                            .save(); // saves all onSaved in each textFormField
                            addExpense(context, _editedPayment);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addExpense(BuildContext context, Payment newExpense) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // saves all onSaved in each textFormField
      String buildingID = await FirebaseHelper.fetchBuildingID();
      var now = DateTime.now();
      var currentYear = now.year;
      var currentMonth = now.month;
      final DocumentSnapshot buildingDoc = await FirebaseFirestore.instance
          .collection('Buildings')
          .doc(buildingID)
          .get();

      // Access the array field by its name
      final List<dynamic> arrayField = buildingDoc.get('tenants');

      // Convert the dynamic list to a list of strings
      final List<String> tenants = List<String>.from(arrayField);
      for (var tenantID in tenants) {
        if (newExpense.title!.isNotEmpty) {
          print(newExpense.title);
          var documentReference = await FirebaseFirestore.instance
              .collection('users')
              .doc(tenantID)
              .collection('payments')
              .doc(currentYear.toString())
              .collection('Maintenance Payments')
              .add({
            'title': newExpense.title,
            'paymentType': newExpense.paymentType,
            'amount': newExpense.amount,
            'isPaid': false,
            'createdBy': newExpense.createdBy,
            'timestamp': newExpense.dateTime,
            'monthNumber': currentMonth,
          });
        } else {
          await customToast.showCustomToast(
              'Payment Title is Empty!', Colors.white, Colors.red);
        }
      }
      await customToast.showCustomToast(
          'Added New Expense 💲', Colors.white, Colors.green);
      Navigator.pop(context);
    }
  }
}
