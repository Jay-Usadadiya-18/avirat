/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarcodeGet extends StatefulWidget {
  final String username;

  BarcodeGet({required this.username});

  @override
  _BarcodeGetState createState() => _BarcodeGetState();
}

class _BarcodeGetState extends State<BarcodeGet> {
  late List<Barcodegettt> _barcodes = [];
  late List<Barcodegettt> _filteredBarcodes = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBarcodeData();
  }

  Future<void> _fetchBarcodeData() async {
    final url = Uri.parse(
        'https://avirat-energy-backend.vercel.app/api/barcodes/${widget.username}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _barcodes =
              jsonData.map((data) => Barcodegettt.fromJson(data)).toList();
          _filteredBarcodes = _barcodes;
        });
      } else {
        print('Failed to load barcode data: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to load barcode data: $error');
    }
  }

  Future<void> _deleteBarcode(int id) async {
    final deleteUrl = Uri.parse('https://avirat-energy-backend.vercel.app/api/barcodes/$id/');
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
        print('Failed to delete barcode after redirect: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to delete barcode after redirect: $error');
    }
  }

  void _filterBarcodes(String query) {
    setState(() {
      _filteredBarcodes = _barcodes
          .where((barcode) =>
          barcode.description!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barcode Details'),

      ),
      body: _filteredBarcodes.isNotEmpty
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
                    int? id = int.tryParse(barcode.id.toString());
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
    );
  }
}

class _BarcodeSearchDelegate extends SearchDelegate<String> {
  final Function(String) _onSearch;

  _BarcodeSearchDelegate(this._onSearch);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          _onSearch('');
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
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

  final num? id;
  final num? code;
  final String? description;
  final String? username;
}
*/
