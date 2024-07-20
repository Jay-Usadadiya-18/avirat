import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../getdelivery.dart';

class DeliveryScreen extends StatefulWidget {
  final String username;
  final DeliveryGet deliveryGet;

  DeliveryScreen({this.username, this.deliveryGet});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final TextEditingController transportName = TextEditingController();
  final TextEditingController nameD = TextEditingController();
  final TextEditingController panelBrand = TextEditingController();
  final TextEditingController size404053Controller = TextEditingController();
  final TextEditingController size40406Controller = TextEditingController();
  final TextEditingController size60406Controller = TextEditingController();
  final TextEditingController pvcPipeController = TextEditingController();
  final TextEditingController ekitController = TextEditingController();
  final TextEditingController bfcController = TextEditingController();
  final TextEditingController boxKitController = TextEditingController();

  bool size404053 = false;
  bool size40406 = false;
  bool size60406 = false;
  bool pvcPipe = false;
  bool ekit = false;
  bool bfc = false;
  bool boxKit = false;

  bool _isForUpdate;
  bool isLoading = false;

  Future<void> submitData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String username = sp.getString('UserName') ?? "";

    setState(() {
      isLoading = true; // Set loading state to true when submitting data
    });

    // Prepare data to be sent in the request
    Map<String, String> postData = {
      'username': username,
      'transport_name': transportName.text,
      'panel_brand': panelBrand.text,
      'name_d': nameD.text,
      'size_40_40_53':
          size404053Controller.text.isEmpty ? '0' : size404053Controller.text,
      'size_40_40_6':
          size40406Controller.text.isEmpty ? '0' : size40406Controller.text,
      'size_60_40_6':
          size60406Controller.text.isEmpty ? '0' : size60406Controller.text,
      'pvc_pipe': pvcPipeController.text.isEmpty ? '0' : pvcPipeController.text,
      'ekit': ekitController.text.isEmpty ? '0' : ekitController.text,
      'bfc': bfcController.text.isEmpty ? '0' : bfcController.text,
      'box_kit': boxKitController.text.isEmpty ? '0' : boxKitController.text,
    };

    // Determine if it's an update or creation
    String endpoint;
    bool isUpdate = _isForUpdate; // Adjust this condition as needed

    if (isUpdate) {
      // For update, use the PUT method and modify the endpoint accordingly
      endpoint =
          'https://avirat-energy-backend.vercel.app/api/delivery-orders/${widget.deliveryGet.id}/';
      postData['id'] =
          widget.deliveryGet.id.toString(); // Include ID for update
    } else {
      // For creation, use the POST method and the original endpoint
      endpoint =
          'https://avirat-energy-backend.vercel.app/api/delivery-orders/';
    }

    try {
      var response = isUpdate
          ? await http.put(Uri.parse(endpoint), body: postData)
          : await http.post(Uri.parse(endpoint), body: postData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the next screen on successful submission
        String selectedUsername = username;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryScreenGet(
              username: selectedUsername,
            ),
          ),
        );
      } else {
        print('Failed to submit data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error submitting data: $e');
    } finally {
      setState(() {
        isLoading =
            false; // Set loading state to false when data submission is complete
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _isForUpdate = widget.deliveryGet != null;
    if (_isForUpdate) {
      transportName.text = widget.deliveryGet.transportName;
      nameD.text = widget.deliveryGet.nameD;
      panelBrand.text = widget.deliveryGet.panelBrand;
      size404053Controller.text = widget.deliveryGet.size404053.toString();
      size40406Controller.text = widget.deliveryGet.size40406.toString();
      size60406Controller.text = widget.deliveryGet.size60406.toString();
      pvcPipeController.text = widget.deliveryGet.pvcPipe.toString();
      ekitController.text = widget.deliveryGet.ekit.toString();
      bfcController.text = widget.deliveryGet.bfc.toString();
      boxKitController.text = widget.deliveryGet.boxKit.toString();

      size404053 = widget.deliveryGet.size404053 > 0;
      size40406 = widget.deliveryGet.size40406 > 0;
      size60406 = widget.deliveryGet.size60406 > 0;
      pvcPipe = widget.deliveryGet.pvcPipe > 0;
      ekit = widget.deliveryGet.ekit > 0;
      bfc = widget.deliveryGet.bfc > 0;
      boxKit = widget.deliveryGet.boxKit > 0;
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DeliveryScreenGet()));
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameD,
                decoration: InputDecoration(labelText: 'Customer Name'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              TextField(
                controller: transportName,
                decoration: InputDecoration(labelText: 'Transport Name'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              DropdownButtonFormField<String>(
                value: panelBrand.text.isEmpty ? null : panelBrand.text,
                items: ['Adani', 'Waaree', 'Raaj', 'Redren']
                    .map((brand) => DropdownMenuItem(
                          child: Text(brand),
                          value: brand,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    panelBrand.text = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Panel Brand'),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Text("Items"),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: Text("40*40*5.3"),
                    value: size404053,
                    onChanged: (value) {
                      setState(() {
                        size404053 = value;
                      });
                    },
                  ),
                  if (size404053)
                    TextField(
                      controller: size404053Controller,
                      decoration: InputDecoration(
                        labelText: 'Enter value for 40*40*5.3',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("40*40*6"),
                    value: size40406,
                    onChanged: (value) {
                      setState(() {
                        size40406 = value;
                      });
                    },
                  ),
                  if (size40406)
                    TextField(
                      controller: size40406Controller,
                      decoration: InputDecoration(
                        labelText: 'Enter value for 40*40*6',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("60*40*6"),
                    value: size60406,
                    onChanged: (value) {
                      setState(() {
                        size60406 = value;
                      });
                    },
                  ),
                  if (size60406)
                    TextField(
                      controller: size60406Controller,
                      decoration: InputDecoration(
                        labelText: 'Enter value for 60*40*6',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("PVC Pipe"),
                    value: pvcPipe,
                    onChanged: (value) {
                      setState(() {
                        pvcPipe = value;
                      });
                    },
                  ),
                  if (pvcPipe)
                    TextField(
                      controller: pvcPipeController,
                      decoration: InputDecoration(
                        labelText: 'Enter value for PVC Pipe',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("E Kit"),
                    value: ekit,
                    onChanged: (value) {
                      setState(() {
                        ekit = value;
                      });
                    },
                  ),
                  if (ekit)
                    TextField(
                      controller: ekitController,
                      decoration: InputDecoration(
                        labelText: 'Enter value for E Kit',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("BFC"),
                    value: bfc,
                    onChanged: (value) {
                      setState(() {
                        bfc = value;
                      });
                    },
                  ),
                  if (bfc)
                    TextField(
                      controller: bfcController,
                      decoration: InputDecoration(
                        labelText: 'Enter value for BFC',
                      ),
                    ),
                  CheckboxListTile(
                    title: Text("Box Kit"),
                    value: boxKit,
                    onChanged: (value) {
                      setState(() {
                        boxKit = value;
                      });
                    },
                  ),
                  if (boxKit)
                    TextField(
                      controller: boxKitController,
                      decoration: InputDecoration(
                        labelText: 'Enter value for Box Kit',
                      ),
                    ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        String username = sp.getString('UserName') ?? "";

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignatureScreen(
                                      username: username,
                                    )));
                      },
                      child: Text('Customer Signature'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 50),*/
              Column(
                children: [
                  /*Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 1,
                    child: ElevatedButton(
                      onPressed: () {
                        String defaultUsername = 'DefaultUsername';
                        String selectedUsername =
                            widget.username ?? defaultUsername;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Material_Screen(
                                      username: selectedUsername,
                                    )));
                      },
                      child: Text(
                        'Material Consumption',
                      ),
                    ),
                  ),*/
                  SizedBox(height: MediaQuery.of(context).size.height / 50),
                  Container(
                    height: MediaQuery.of(context).size.height / 20,
                    width: MediaQuery.of(context).size.width / 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade400,
                      ),
                      onPressed: isLoading
                          ? null
                          : submitData, // Disable button when loading
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
