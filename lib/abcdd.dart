/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DeliveryGet {
  final int id;
  final String username;
  final String transportName;
  final String panelBrand;
  final int size404053;
  final int size40406;
  final int size60406;
  final int pvcPipe;
  final int ekit;
  final int bfc;
  final int boxKit;

  DeliveryGet({
    required this.id,
    required this.username,
    required this.transportName,
    required this.panelBrand,
    required this.size404053,
    required this.size40406,
    required this.size60406,
    required this.pvcPipe,
    required this.ekit,
    required this.bfc,
    required this.boxKit,
  });

  factory DeliveryGet.fromJson(Map<String, dynamic> json) {
    return DeliveryGet(
      id: json['id'],
      username: json['username'],
      transportName: json['transport_name'],
      panelBrand: json['panel_brand'],
      size404053: json['size_40_40_53'] ?? 0, // Provide a default value if null
      size40406: json['size_40_40_6'] ?? 0,
      size60406: json['size_60_40_6'] ?? 0,
      pvcPipe: json['pvc_pipe'] ?? 0,
      ekit: json['ekit'] ?? 0,
      bfc: json['bfc'] ?? 0,
      boxKit: json['box_kit'] ?? 0,
    );
  }
}

class YourWidget extends StatefulWidget {
  final String username;

  YourWidget({required this.username});

  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  late List<DeliveryGet> _deliveries = [];

  @override
  void initState() {
    super.initState();
    _fetchDeliveryData();
  }

  Future<void> _fetchDeliveryData() async {
    final url = Uri.parse('https://avirat-energy-backend.vercel.app/api/delivery_orders/${widget.username}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _deliveries = jsonData.map((data) => DeliveryGet.fromJson(data)).toList();
        });
      } else {
        // Handle error response
        print('Failed to load delivery data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network error
      print('Failed to load delivery data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Details'),
      ),
      body: _deliveries.isNotEmpty
          ? ListView.builder(
        itemCount: _deliveries.length,
        itemBuilder: (context, index) {
          final delivery = _deliveries[index];
          return Padding(
            padding:  EdgeInsets.all(14.0),
            child: Card(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transport Name : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.transportName}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(

                      children: [

                        TextSpan(
                          text: 'Username : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.username}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Panel Brand : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.panelBrand}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size 40x40x53 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.size404053}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size 40x40x6 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.size40406}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Size 60x40x6 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.size60406}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'PVC Pipe : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.pvcPipe}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ekit : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.ekit}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'BFC : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.bfc}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Box Kit : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: '${delivery.boxKit}\n\n',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

        },
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
*/
