/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class PostModel {
  final int id;
  final String username;
  final String name;
  final String mobileNumber;
  final String panelBrand;
  final String panelQuality;
  final String inverterBrand;
  final int panelWatt;
  final String lightBillImage;
  final String passbookImage;
  final String panCardImage;
  final String uipImage; // New image field
  final String chequeImage; // New image field
  final String cashAmount;
  final int cashDenomination500;
  final int cashDenomination200;
  final int cashDenomination100;
  final int cashDenomination50;
  final int cashDenomination20;
  final int cashDenomination10;
  final String cashTotal;

  PostModel({
    required this.id,
    required this.username,
    required this.name,
    required this.mobileNumber,
    required this.panelBrand,
    required this.panelQuality,
    required this.inverterBrand,
    required this.panelWatt,
    required this.lightBillImage,
    required this.passbookImage,
    required this.panCardImage,
    required this.uipImage,
    required this.chequeImage,
    required this.cashAmount,
    required this.cashDenomination500,
    required this.cashDenomination200,
    required this.cashDenomination100,
    required this.cashDenomination50,
    required this.cashDenomination20,
    required this.cashDenomination10,
    required this.cashTotal,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      panelBrand: json['panel_brand'] ?? '',
      panelQuality: json['panel_quality'] ?? '',
      inverterBrand: json['inverter_brand'] ?? '',
      panelWatt: json['panel_watt'] ?? 0,
      lightBillImage: json['light_bill_image'] ?? '',
      passbookImage: json['passbook_image'] ?? '',
      panCardImage: json['pan_card_image'] ?? '',
      uipImage: json['uip_image'] ?? '',
      chequeImage: json['cheque_image'] ?? '',
      cashAmount: json['cash_amount'] ?? '',
      cashDenomination500: json['cash_denomination_500'] ?? 0,
      cashDenomination200: json['cash_denomination_200'] ?? 0,
      cashDenomination100: json['cash_denomination_100'] ?? 0,
      cashDenomination50: json['cash_denomination_50'] ?? 0,
      cashDenomination20: json['cash_denomination_20'] ?? 0,
      cashDenomination10: json['cash_denomination_10'] ?? 0,
      cashTotal: json['cash_total'] ?? '',
    );
  }
}

class CustomerMaster1 extends StatefulWidget {
  final String username;

  const CustomerMaster1({Key? key, required this.username}) : super(key: key);

  @override
  State<CustomerMaster1> createState() => _CustomerMaster1State();
}

class _CustomerMaster1State extends State<CustomerMaster1> {
  List<PostModel> _allPosts = [];
  List<PostModel> _searchResult = []; // Initialize as an empty list
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = Uri.parse('https://avirat-energy-backend.vercel.app /api/customers/${widget.username}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        _allPosts = jsonData.map((item) => PostModel.fromJson(item)).toList();
        _searchResult.addAll(_allPosts);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildImageWidget(BuildContext context, String imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImage(imageUrl: imageUrl),
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: 'https://avirat-energy-backend.vercel.app /api$imageUrl',
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  void _searchOperation(String searchText) {
    _searchResult.clear();
    if (searchText.isNotEmpty) {
      _allPosts.forEach((post) {
        if (post.name.toLowerCase().contains(searchText.toLowerCase()) ||
            post.mobileNumber.toLowerCase().contains(searchText.toLowerCase()) ||
            post.panelBrand.toLowerCase().contains(searchText.toLowerCase()) ||
            post.panelQuality.toLowerCase().contains(searchText.toLowerCase()) ||
            post.inverterBrand.toLowerCase().contains(searchText.toLowerCase()) ||
            post.panelWatt.toString().contains(searchText) ||
            post.cashAmount.toLowerCase().contains(searchText.toLowerCase()) ||
            post.cashTotal.toLowerCase().contains(searchText.toLowerCase()) ||
            post.cashDenomination500.toString().contains(searchText) ||
            post.cashDenomination200.toString().contains(searchText) ||
            post.cashDenomination100.toString().contains(searchText) ||
            post.cashDenomination50.toString().contains(searchText) ||
            post.cashDenomination20.toString().contains(searchText) ||
            post.cashDenomination10.toString().contains(searchText)) {
          _searchResult.add(post);
        }
      });
    } else {
      _searchResult.addAll(_allPosts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Information',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade400,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _searchResult.map((post) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer Name: ${post.name}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text('Mobile Number: ${post.mobileNumber}'),
                    SizedBox(height: 8.0),
                    Text('Panel Brand: ${post.panelBrand}'),
                    SizedBox(height: 8.0),
                    Text('Panel Quality: ${post.panelQuality}'),
                    SizedBox(height: 8.0),
                    Text('Inverter Brand: ${post.inverterBrand}'),
                    SizedBox(height: 8.0),
                    Text('Panel Watt: ${post.panelWatt}'),
                    SizedBox(height: 8.0),
                    Text('Light Bill Image: ${post.lightBillImage}'),
                    SizedBox(height: 8.0),
                    _buildImageWidget(context, post.lightBillImage),
                    SizedBox(height: 8.0),
                    Text('Passbook Image: ${post.passbookImage}'),
                    SizedBox(height: 8.0),
                    _buildImageWidget(context, post.passbookImage),
                    SizedBox(height: 8.0),
                    Text('Pan Card Image: ${post.panCardImage}'),
                    SizedBox(height: 8.0),
                    _buildImageWidget(context, post.panCardImage),
                    SizedBox(height: 8.0),
                    Text('UIP Image: ${post.uipImage}'),
                    SizedBox(height: 8.0),
                    _buildImageWidget(context, post.uipImage),
                    SizedBox(height: 8.0),
                    Text('Cheque Image: ${post.chequeImage}'),
                    SizedBox(height: 8.0),
                    _buildImageWidget(context, post.chequeImage),
                    SizedBox(height: 8.0),
                    Text('Cash Amount: ${post.cashAmount}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 500: ${post.cashDenomination500}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 200: ${post.cashDenomination200}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 100: ${post.cashDenomination100}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 50: ${post.cashDenomination50}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 20: ${post.cashDenomination20}'),
                    SizedBox(height: 8.0),
                    Text('Cash Denomination 10: ${post.cashDenomination10}'),
                    SizedBox(height: 8.0),
                    Text('Cash Total: ${post.cashTotal}'),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: Implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _CustomerMaster1State state = context.findAncestorStateOfType<_CustomerMaster1State>()!;
    state._searchOperation(query);
    return ListView.builder(
      itemCount: state._searchResult.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(state._searchResult[index].name),
          onTap: () {
            // Show results for selected suggestion
          },
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(
            'https://avirat-energy-backend.vercel.app /api$imageUrl',
          ),
        ),
      ),
    );
  }
}

}*/
