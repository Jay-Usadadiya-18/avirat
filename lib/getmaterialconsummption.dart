import 'dart:convert';

import 'package:avirat_energy/MaterialConsumption/material_consumption.dart';
import 'package:avirat_energy/get_customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Materialgetaa {
  Materialgetaa({
    required this.id,
    required this.something1,
    required this.something2,
    required this.something3,
    required this.picPipe,
    required this.basePlate,
    required this.autoRoad,
    required this.pcCable,
    required this.acCable,
    required this.laCable,
    required this.username,
    required this.nameM,
  });

  num id;
  num something1;
  num something2;
  num something3;
  num picPipe;
  num basePlate;
  num autoRoad;
  num pcCable;
  num acCable;
  num laCable;
  String username;
  String nameM;

  factory Materialgetaa.fromJson(Map<String, dynamic> json) {
    return Materialgetaa(
      id: json['id'],
      something1: json['_40_40_53'] ?? 0,
      something2: json['_40_40_6'] ?? 0,
      something3: json['_60_40_6'] ?? 0,
      picPipe: json['pic_pipe'] ?? 0,
      basePlate: json['base_plate'] ?? 0,
      autoRoad: json['auto_road'] ?? 0,
      pcCable: json['pc_cable'] ?? 0,
      acCable: json['ac_cable'] ?? 0,
      laCable: json['la_cable'] ?? 0,
      username: json['username'],
      nameM: json['name_m'],
    );
  }
}

class MaterialScreen extends StatefulWidget {
  final String? username;

  MaterialScreen({this.username});

  @override
  _MaterialScreenState createState() => _MaterialScreenState();
}

class _MaterialScreenState extends State<MaterialScreen> {
  List<Materialgetaa> _materials = [];
  List<Materialgetaa> _filteredMaterials = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMaterials();
  }

  Future<void> _fetchMaterials() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String? username = sp.getString('UserName') ?? "";

    final url = Uri.parse(
        'https://avirat-energy-backend.vercel.app/api/materials/${username}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _materials =
              jsonData.map((data) => Materialgetaa.fromJson(data)).toList();
          _filteredMaterials = List.from(_materials);
          _isLoading = false;
        });
      } else {
        print('Failed to load materials data: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to load materials data: $error');
    }
  }

  void _filterMaterials(String query) {
    setState(() {
      _filteredMaterials = _materials
          .where((material) =>
              material.nameM.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> _deleteMaterial(BuildContext context, num id) async {
    if (id == null) {
      print('Material id is null.');
      return;
    }

    final url = Uri.parse(
        'https://avirat-energy-backend.vercel.app/api/materials/$id/');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 204) {
        setState(() {
          _materials.removeWhere((material) => material.id == id);
          _filteredMaterials.removeWhere((material) => material.id == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Material deleted successfully from screen and API'),
          ),
        );
      } else if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          await _handleRedirect(context, id, redirectUrl);
        } else {
          print('Redirect URL not found');
        }
      } else {
        print('Failed to delete material: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete material'),
          ),
        );
      }
    } catch (error) {
      print('Failed to delete material: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete material'),
        ),
      );
    }
  }

  Future<void> _handleRedirect(
      BuildContext context, num id, String redirectUrl) async {
    try {
      final response = await http.delete(Uri.parse(redirectUrl));

      if (response.statusCode == 204) {
        setState(() {
          _materials.removeWhere((material) => material.id == id);
          _filteredMaterials.removeWhere((material) => material.id == id);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Material deleted successfully from screen and API'),
          ),
        );
      } else {
        print('Failed to delete material: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete material'),
          ),
        );
      }
    } catch (error) {
      print('Failed to delete material: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete material'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigate to the desired screen when back button is pressed
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerMaster1()),
        );
        // Returning false to prevent the default back button behavior
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Material Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green.shade400,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerMaster1()));
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
                  hintText: 'Search by username...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterMaterials,
              ),
            ),
            Expanded(
              child: _isLoading // Check if loading
                  ? Center(
                      child:
                          CircularProgressIndicator()) // Show loading indicator
                  : _filteredMaterials.isNotEmpty
                      ? ListView.builder(
                          itemCount: _filteredMaterials.length,
                          itemBuilder: (context, index) {
                            final material = _filteredMaterials[index];
                            return Card(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Username : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.username,
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Customer Name : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.nameM,
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "40*40*5.3 ft : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.something1.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "40*40*6 ft : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.something2.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "60*40*6 ft : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.something3.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Pvc Pipe : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.picPipe.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Base Plate : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.basePlate.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Auto Road : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.autoRoad.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "PC Cable : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.pcCable.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "AC Cable : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.acCable.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "LA Cable : ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          material.laCable.toString(),
                                          style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Material_Screen(
                                                            materialgetaa:
                                                                material)));
                                          },
                                          child: Text('Update'),
                                        ),
                                        SizedBox(width: 8.0),
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title:
                                                    Text('Delete Confirmation'),
                                                content: Text(
                                                    'Are you sure you want to delete this material?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _deleteMaterial(
                                                          context,
                                                          material
                                                              .id); // Pass the context here
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Delete'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No data found'),
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              String? username = sp.getString('UserName') ?? "";

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Material_Screen(username: username)),
              );
            },
            child: Icon(Icons.add)),
      ),
    );
  }
}
