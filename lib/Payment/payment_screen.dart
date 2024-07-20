/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  String cash_amount = '';
  Map<int, int> cashDenominations = {
    500: 0,
    200: 0,
    100: 0,
    50: 0,
    20: 0,
    10: 0,
  };

  int totalAmount = 0;


  void _calculateTotalAmount() {
    int total = 0;
    cashDenominations.forEach((denomination, count) {
      total += denomination * count;
    });
    setState(() {
      totalAmount = total;
    });
  }

  Future<void> _submitPayment() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://5a92-2402-a00-400-187d-4e6-4fce-42d8-b7ab.ngrok-free.app/api/api/payment/'),
    );

    // Add cash denominations and other data as fields
    request.fields['customer_name'] = 'jay bhai';
    request.fields['cash_denomination_500'] = cashDenominations[500].toString();
    // Add other cash denominations similarly...
    request.fields['cash_total'] = totalAmount.toStringAsFixed(2);
    request.fields['rokda_name'] = cash_amount;


    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Payment submitted successfully');
        // Navigate to the next screen upon successful payment submission
        // Navigator.push(context, MaterialPageRoute(builder: (context) => NextScreen()));
      } else {
        print('Failed to submit payment: ${response.body}');
        // Handle failure scenario
      }
    } catch (error) {
      print('Error submitting payment: $error');
      // Handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cash Denominations:'),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: cashDenominations.keys.map((denomination) {
                  return Row(
                    children: [
                      Text('Rs $denomination: '),
                      SizedBox(width: 8.0),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              cashDenominations[denomination] = int.tryParse(value) ?? 0;
                            });
                            _calculateTotalAmount();
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),

              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Container(
                child: TextField(
                  decoration: InputDecoration(labelText: 'Rokda'),
                  onChanged: (value) {
                    setState(() {
                      cash_amount = value;
                    });
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
*/
