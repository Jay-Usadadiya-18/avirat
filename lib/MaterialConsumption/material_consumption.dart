import 'package:avirat_energy/getmaterialconsummption.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Material_Screen extends StatefulWidget {
  final String? username;
  final Materialgetaa? materialgetaa;
  Material_Screen({this.username, this.materialgetaa});
  @override
  _Material_ScreenState createState() => _Material_ScreenState();
}

class _Material_ScreenState extends State<Material_Screen> {
  TextEditingController _customerNameController = TextEditingController();
  TextEditingController _size1Controller = TextEditingController();
  TextEditingController _size2Controller = TextEditingController();
  TextEditingController _size3Controller = TextEditingController();
  TextEditingController _pvcController = TextEditingController();
  TextEditingController _basePlateController = TextEditingController();
  TextEditingController _autoroadController = TextEditingController();
  TextEditingController _pcCablesController = TextEditingController();
  TextEditingController _acCablesController = TextEditingController();
  TextEditingController _laCablesController = TextEditingController();
  bool isLoading = false;
  bool? _isForUpdate;

  Future<void> sendDataToAPI() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String username = sp.getString('UserName') ?? "";

    setState(() {
      isLoading = true;
    });

    final Map<String, dynamic> requestData = {
      'username': username,
      'name_m': _customerNameController.text,
      '_40_40_53': _size1Controller.text,
      '_40_40_6': _size2Controller.text,
      '_60_40_6': _size3Controller.text,
      'pic_pipe': _pvcController.text,
      'base_plate': _basePlateController.text,
      'auto_road': _autoroadController.text,
      'pc_cable': _pcCablesController.text,
      'ac_cable': _acCablesController.text,
      'la_cable': _laCablesController.text,
    };

    // Determine if it's an update or creation
    String endpoint;
    bool? isUpdate = _isForUpdate; // Adjust this condition as needed

    if (isUpdate!) {
      // For update, use the PUT method and modify the endpoint accordingly
      endpoint =
          'https://avirat-energy-backend.vercel.app/api/materials/${widget.materialgetaa!.id}/';
      requestData['id'] =
          widget.materialgetaa!.id.toString(); // Include ID for update
    } else {
      // For creation, use the POST method and the original endpoint
      endpoint = 'https://avirat-energy-backend.vercel.app/api/materials/';
    }

    try {
      var response = isUpdate
          ? await http.put(Uri.parse(endpoint), body: requestData)
          : await http.post(Uri.parse(endpoint), body: requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigate to the next screen on successful submission
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MaterialScreen(
              username: username,
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
    // TODO: implement initState
    super.initState();

    _isForUpdate = widget.materialgetaa != null;
    if (_isForUpdate!) {
      _customerNameController.text = widget.materialgetaa!.nameM;
      _size1Controller.text = widget.materialgetaa!.something1.toString();
      _size2Controller.text = widget.materialgetaa!.something2.toString();
      _size3Controller.text = widget.materialgetaa!.something3.toString();
      _pvcController.text = widget.materialgetaa!.picPipe.toString();
      _basePlateController.text = widget.materialgetaa!.basePlate.toString();
      _autoroadController.text = widget.materialgetaa!.autoRoad.toString();
      _pcCablesController.text = widget.materialgetaa!.pcCable.toString();
      _acCablesController.text = widget.materialgetaa!.acCable.toString();
      _laCablesController.text = widget.materialgetaa!.laCable.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Material Consumption',
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
                MaterialPageRoute(builder: (context) => MaterialScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            _buildTextField(
                controller: _size1Controller, label: '40*40*5.3 ft'),
            _buildTextField(controller: _size2Controller, label: '40*40*6 ft'),
            _buildTextField(controller: _size3Controller, label: '60*40*6 ft'),
            _buildTextField(controller: _pvcController, label: 'PVC Pipe'),
            _buildTextField(
                controller: _basePlateController, label: 'Base Plate'),
            _buildTextField(controller: _autoroadController, label: 'Autoroad'),
            _buildTextField(
                controller: _pcCablesController, label: 'DC Cables'),
            _buildTextField(
                controller: _acCablesController, label: 'AC Cables/E Cables'),
            _buildTextField(
                controller: _laCablesController, label: 'LA Cables'),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
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
                              builder: (context) => BarcodeScannerScreen(
                                    username: username,
                                  )));
                    },
                    child: Text('Scanner'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),*/
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        await sendDataToAPI();
                      },
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({TextEditingController? controller, String? label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 40,
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label),
        ),
      ],
    );
  }
}
