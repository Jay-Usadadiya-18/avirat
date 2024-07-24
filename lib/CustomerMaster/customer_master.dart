import 'dart:io';

import 'package:avirat_energy/get_customer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerMaster extends StatefulWidget {
  final String? username;
  const CustomerMaster({Key? key, this.username}) : super(key: key);

  @override
  State<CustomerMaster> createState() => _CustomerMasterState();
}

class _CustomerMasterState extends State<CustomerMaster> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  String _customerName = '';
  String _mobileNumber = '';
  String? _panelBrand;
  String? _inverterBrand;
  String? _panelWatt;
  String _panelQuality = '';
  String cash_amount = '';

  File? _lightBill;
  File? _panCard;
  File? _passbook;
  File? _uipImage;
  File? _chequeImage;
  File? _sitephoto;
  String? _errorText;
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

  Future<void> _submitForm() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String username = sp.getString('UserName') ?? "";

    setState(() {
      _loading = true;
    });
    if (_validateForm()) {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://avirat-energy-backend.vercel.app/api/customer/'), // Update with your actual endpoint
      );

      // Add form fields
      request.fields['name'] = _customerName;
      request.fields['mobile_number'] = _mobileNumber;
      request.fields['panel_brand'] = _panelBrand!;
      request.fields['inverter_brand'] = _inverterBrand!;
      request.fields['panel_watt'] = _panelWatt!;
      request.fields['panel_quality'] = _panelQuality;
      request.fields['cash_denomination_500'] =
          cashDenominations[500].toString();
      // Add other cash denominations similarly...
      request.fields['cash_total'] = totalAmount.toStringAsFixed(2);
      request.fields['cash_amount'] = cash_amount;
      request.fields['username'] = username;

      // Add image files
      if (_lightBill != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'light_bill_image',
          _lightBill!.path,
        ));
      }
      if (_panCard != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'pan_card_image',
          _panCard!.path,
        ));
      }
      if (_passbook != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'passbook_image',
          _passbook!.path,
        ));
      }
      if (_uipImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'uip_image',
          _uipImage!.path,
        ));
      }
      if (_chequeImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'cheque_image',
          _chequeImage!.path,
        ));
      }
      if (_sitephoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'site_photo',
          _sitephoto!.path,
        ));
      }

      try {
        // Send the request
        var response = await request.send();

        // Check the response
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${await response.stream.bytesToString()}');
        if (response.statusCode == 201) {
          print('Form submitted successfully');
          // Navigate to PaymentScreen or any other screen upon successful submission
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerMaster1(username: username)),
          );
        } else {
          print('Failed to submit form: ${response.reasonPhrase}');
          setState(() {
            _errorText = 'Failed to submit form: ${response.reasonPhrase}';
          });
        }
      } catch (e) {
        print('Error submitting form: $e');
        setState(() {
          _errorText = 'Error submitting form: $e';
        });
      }
      setState(() {
        _loading = false;
      });
    } else {
      // If form validation fails, hide loading indicator
      setState(() {
        _loading = false;
      });
    }
  }

  bool _validateForm() {
    if (_customerName.isEmpty ||
        _mobileNumber.isEmpty ||
        _panelBrand == null ||
        _inverterBrand == null ||
        _panelWatt == null ||
        _panelQuality.isEmpty ||
        _lightBill == null ||
        _panCard == null ||
        _passbook == null) {
      setState(() {
        _errorText = 'Please fill in all fields and select all photos';
      });
      return false;
    }
    return true;
  }

  Future<void> _pickLightBill() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _lightBill = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPanCard() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _panCard = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickPassbook() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _passbook = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickUIPImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uipImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickChequeImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _chequeImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickSiteImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _sitephoto = File(pickedFile.path);
      });
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CustomerMaster1()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Customer Name'),
              onChanged: (value) {
                setState(() {
                  _customerName = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            TextField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                setState(() {
                  _mobileNumber = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Panel Quality'),
              onChanged: (value) {
                setState(() {
                  _panelQuality = value;
                });
              },
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<String>(
              value: _panelBrand,
              items: ['Adani', 'Waaree', 'Raaj', 'Redren']
                  .map((brand) => DropdownMenuItem(
                        child: Text(brand),
                        value: brand,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _panelBrand = value;
                });
              },
              decoration: InputDecoration(labelText: 'Panel Brand'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<String>(
              value: _inverterBrand,
              items: ['Deye', 'PVblink', 'Solis', 'Polycab']
                  .map((brand) => DropdownMenuItem(
                        child: Text(brand),
                        value: brand,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _inverterBrand = value;
                });
              },
              decoration: InputDecoration(labelText: 'Inverter Brand'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<int>(
              value: _panelWatt != null ? int.parse(_panelWatt!) : null,
              items: ['535', '545', '540', '555', '565', '575']
                  .map((watt) => DropdownMenuItem(
                        child: Text(watt),
                        value: int.parse(watt),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _panelWatt = value.toString();
                });
              },
              decoration: InputDecoration(labelText: 'Panel Watt'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Text('Cash Denominations:'),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cashDenominations.keys.map((denomination) {
                return Row(
                  children: [
                    Text('Rs $denomination: '),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Flexible(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            cashDenominations[denomination] =
                                int.tryParse(value) ?? 0;
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
            Text(
              'Total Cash Denomination: Rs $totalAmount',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: TextField(
                decoration: InputDecoration(labelText: 'Rokda Name'),
                onChanged: (value) {
                  setState(() {
                    cash_amount = value;
                  });
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _lightBill != null
                  ? Image.file(_lightBill!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickLightBill,
              child: Text('Pick Light Bill Photo'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _panCard != null
                  ? Image.file(_panCard!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickPanCard,
              child: Text('Pick Pan Card Photo'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _passbook != null
                  ? Image.file(_passbook!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickPassbook,
              child: Text('Pick Passbook/Cheque Photo'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _sitephoto != null
                  ? Image.file(_sitephoto!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickSiteImage,
              child: Text('Pick Site Image'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _uipImage != null
                  ? Image.file(_uipImage!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickUIPImage,
              child: Text('Pick UIP Image'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _chequeImage != null
                  ? Image.file(_chequeImage!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            ElevatedButton(
              onPressed: _pickChequeImage,
              child: Text('Pick Cheque Image'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            ElevatedButton(
              onPressed: _loading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
              ),
              child: _loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
            if (_errorText != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  _errorText!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
