/*
import 'package:avirat_energy/get_customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:avirat_energy/BarCode/barcode_scanner_screen.dart';
import 'package:avirat_energy/MaterialConsumption/material_consumption.dart';
import 'package:avirat_energy/SignaturePad/signature_screen.dart';

import '../getdelivery.dart';

class DeliveryScreen extends StatefulWidget {
  final String username;
  DeliveryScreen({required this.username});
  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {

  String transportName = '';
  String? panelBrand;
  String nameD='';
  Map<String, bool> items = {
    '40*40*5.3': false,
    '40*40*6': false,
    '60*40*6': false,
    'PVC Pipe': false,
    'E Kit': false,
    'BFC': false,
    'Box Kit': false,
  };
  Map<String, String> itemValues = {
    '40*40*5.3': '',
    '40*40*6': '',
    '60*40*6': '',
    'PVC Pipe': '',
    'E Kit': '',
    'BFC': '',
    'Box Kit': '',
  };
  bool isLoading =false;
  Future<void> submitData() async {
    setState(() {
      isLoading = true; // Set loading state to true when submitting data
    });
    // Prepare data to be sent in the request
    Map<String, dynamic> postData = {
      'username': widget.username,
      'transport_name': transportName,
      'panel_brand': panelBrand,
      'name_d': nameD, // Added name_d to postData
      'size_40_40_53': itemValues['40*40*5.3'] ?? null,
      'size_40_40_6': itemValues['40*40*6'] ?? null,
      'size_60_40_6': itemValues['60*40*6'] ?? null,
      'pvc_pipe': itemValues['PVC Pipe'] ?? null,
      'ekit': itemValues['E Kit'] ?? null,
      'bfc': itemValues['BFC'] ?? null,
      'box_kit': itemValues['Box Kit'] ?? null,
    };

    // Make POST request
    try {
      var response = await http.post(
        Uri.parse('https://avirat-energy-backend.vercel.app/api/delivery-orders/'),
        body: postData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the next screen
        String defaultUsername = 'DefaultUsername';
        String selectedUsername = widget.username ?? defaultUsername;
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreenGet(username:selectedUsername,)));
      } else if (response.statusCode == 307) {
        // Extract the new URI from the response headers
        String? newUri = response.headers['location'];
        if (newUri != null) {
          // Make another request to the new URI
          var newResponse = await http.post(
            Uri.parse(newUri),
            body: postData,
          );
          // Check if the request to the new URI was successful
          if (newResponse.statusCode == 200 || newResponse.statusCode == 201) {
            // Navigate to the next screen
            String defaultUsername = 'DefaultUsername';
            String selectedUsername = widget.username ?? defaultUsername;
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreenGet(username: selectedUsername,)));
          } else {
            print('Failed to submit data to new URI: ${newResponse.statusCode}');
          }
        } else {
          print('New URI not found in response headers');
        }
      } else {
        print('Failed to submit data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting data: $e');}
    finally {
      setState(() {
        isLoading = false; // Set loading state to false when data submission is complete
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delivery',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            String defaultUsername = 'DefaultUsername';
            String selectedUsername = widget.username ?? defaultUsername;
            Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerMaster1(username: selectedUsername,)));
          },
        ),
        actions: [
           IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onPressed: () {
              String defaultUsername = 'DefaultUsername';
              String selectedUsername = widget.username ?? defaultUsername;
              Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreenGet(username: selectedUsername,)));
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField( // Added TextField for name_d
                onChanged: (value) {
                  setState(() {
                    nameD = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              TextField(
                onChanged: (value) {
                  setState(() {
                    transportName = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Transport Name'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              DropdownButtonFormField<String>(
                value: panelBrand,
                onChanged: (String? value) {
                  setState(() {
                    panelBrand = value;
                  });
                },
                items: [
                  'Adani',
                  'Waaree',
                  'Raaj',
                  'Redren',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Panel Brand'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Text('Items:'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.keys.map((item) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        title: Text(item),
                        value: items[item],
                        onChanged: (value) {
                          setState(() {
                            items[item] = value!;
                          });
                        },
                      ),
                      if (items[item] == true)
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              itemValues[item] = value;
                            });
                          },
                          decoration: InputDecoration(labelText: 'Enter value for $item'),
                        ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(

                      onPressed: () {
                        String defaultUsername = 'DefaultUsername';
                        String selectedUsername = widget.username ?? defaultUsername;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignatureScreen(username: selectedUsername,)));
                      },
                      child: Text('Customer Signature'),
                    ),
                  ),
               */
/*   SizedBox(width: MediaQuery.sizeOf(context).width / 50,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        String defaultUsername = 'DefaultUsername';
                        String selectedUsername = widget.username ?? defaultUsername;
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BarcodeScannerScreen(username: selectedUsername,)));
                      },
                      child: Text('Scanner'),
                    ),
                  ),*//*

                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 1,
                    child: ElevatedButton(


                      onPressed: () {
                        String defaultUsername = 'DefaultUsername';
                        String selectedUsername = widget.username ?? defaultUsername;
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Material_Screen(username: selectedUsername,))); },
                      child: Text(
                        'Material Consumption',

                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 50),

                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                      ),
                      onPressed: isLoading ? null : submitData, // Disable button when loading
                      child: isLoading
                          ? CircularProgressIndicator() // Show loading indicator when loading
                          : Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
