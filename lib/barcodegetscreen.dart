import 'dart:convert';

import 'package:avirat_energy/BarCode/barcode_scanner_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BarcodeGet extends StatefulWidget {
  final String username;

  BarcodeGet({this.username});

  @override
  _BarcodeGetState createState() => _BarcodeGetState();
}

class _BarcodeGetState extends State<BarcodeGet> {
  List<Barcodegettt> _barcodes = [];
  List<Barcodegettt> _filteredBarcodes = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchBarcodeData();
  }

  Future<void> _fetchBarcodeData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String username = sp.getString('UserName') ?? "";

    final url = Uri.parse(
        'https://avirat-energy-backend.vercel.app/api/barcodes/${username}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _barcodes =
              jsonData.map((data) => Barcodegettt.fromJson(data)).toList();
          _filteredBarcodes = _barcodes;
          _isLoading = false;
        });
      } else {
        print('Failed to load barcode data: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to load barcode data: $error');
    }
  }

  Future<void> _deleteBarcode(int id) async {
    final deleteUrl =
        Uri.parse('https://avirat-energy-backend.vercel.app/api/barcodes/$id/');
    try {
      final response = await http.delete(deleteUrl);
      if (response.statusCode == 204) {
        setState(() {
          _barcodes.removeWhere((barcode) => barcode.id == id);
          _filteredBarcodes.removeWhere((barcode) => barcode.id == id);
        });
      } else if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          await _handleRedirect(id, redirectUrl);
        } else {
          print('Redirect URL not found');
        }
      } else {
        print('Failed to delete barcode: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete barcode: $error');
    }
  }

  Future<void> _handleRedirect(int id, String redirectUrl) async {
    try {
      final response = await http.delete(Uri.parse(redirectUrl));
      if (response.statusCode == 204) {
        setState(() {
          _barcodes.removeWhere((barcode) => barcode.id == id);
          _filteredBarcodes.removeWhere((barcode) => barcode.id == id);
        });
      } else {
        print(
            'Failed to delete barcode after redirect: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete barcode after redirect: $error');
    }
  }

  void _filterBarcodes(String query) {
    setState(() {
      _filteredBarcodes = _barcodes
          .where((barcode) =>
              barcode.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Barcode Details',
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
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BarcodeScannerScreen(
                          username: selectedUsername,
                        )));
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by description...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterBarcodes,
            ),
          ),
          Expanded(
            child: _isLoading // Check if loading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator
                : _filteredBarcodes.isNotEmpty
                    ? ListView.builder(
                        itemCount: _filteredBarcodes.length,
                        itemBuilder: (context, index) {
                          final barcode = _filteredBarcodes[index];
                          return Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Card(
                              child: ListTile(
                                title: Text('ID: ${barcode.id}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Code: ${barcode.code}'),
                                    Text('Description: ${barcode.description}'),
                                    Text('Username: ${barcode.username}'),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    int id =
                                        int.tryParse(barcode.id.toString());
                                    if (id != null) {
                                      _deleteBarcode(id);
                                    } else {
                                      print('Invalid barcode ID');
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text('No barcodes found'),
                      ),
          ),
        ],
      ),
    );
  }
}

class Barcodegettt {
  Barcodegettt({
    this.id,
    this.code,
    this.description,
    this.username,
  });

  factory Barcodegettt.fromJson(Map<String, dynamic> json) {
    return Barcodegettt(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      username: json['username'],
    );
  }

  final num id;
  final num code;
  final String description;
  final String username;
}
