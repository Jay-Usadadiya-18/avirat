import 'dart:io';

import 'package:avirat_energy/get_customer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerMasterUpdate extends StatefulWidget {
  final String? username;
  final PostModel? postModel;
  const CustomerMasterUpdate({Key? key, this.username, this.postModel})
      : super(key: key);

  @override
  State<CustomerMasterUpdate> createState() => _CustomerMasterUpdateState();
}

class _CustomerMasterUpdateState extends State<CustomerMasterUpdate> {
  bool _loading = false;
  PostModel? _editPostModel;
  bool? _isForUpdate;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _isForUpdate = widget.postModel != null;
    if (_isForUpdate!) {
      _customerName.text = widget.postModel!.name;
      _mobileNumber.text = widget.postModel!.mobileNumber;
      _panelBrand.text = widget.postModel!.panelBrand;
      _inverterBrand.text = widget.postModel!.inverterBrand;
      _panelWatt.text = widget.postModel!.panelWatt.toString();
      _panelQuality.text = widget.postModel!.panelQuality;
      cash_amount.text = widget.postModel!.cashAmount;

      denominationControllers[500]!.text =
          widget.postModel!.cashDenomination500?.toString() ?? "";
      denominationControllers[200]!.text =
          widget.postModel!.cashDenomination200?.toString() ?? "";
      denominationControllers[100]!.text =
          widget.postModel!.cashDenomination100?.toString() ?? "";
      denominationControllers[50]!.text =
          widget.postModel!.cashDenomination50?.toString() ?? "";
      denominationControllers[20]!.text =
          widget.postModel!.cashDenomination20?.toString() ?? "";
      denominationControllers[10]!.text =
          widget.postModel!.cashDenomination10?.toString() ?? "";

      totalAmount.text = widget.postModel!.cashTotal;

      _lightBillUrl = widget.postModel!.lightBillImage;
      _panCardUrl = widget.postModel!.panCardImage;
      _passbookUrl = widget.postModel!.passbookImage;
      _uipImageUrl = widget.postModel!.uipImage;
      _chequeImageUrl = widget.postModel!.chequeImage;
      _sitePhotoUrl = widget.postModel!.sitePhoto;
    }
  }

  TextEditingController _customerName = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _panelBrand = TextEditingController();
  TextEditingController _inverterBrand = TextEditingController();
  TextEditingController _panelWatt = TextEditingController();
  TextEditingController _panelQuality = TextEditingController();
  TextEditingController cash_amount = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  Map<int, TextEditingController> denominationControllers = {
    500: TextEditingController(text: '0'),
    200: TextEditingController(text: '0'),
    100: TextEditingController(text: '0'),
    50: TextEditingController(text: '0'),
    20: TextEditingController(text: '0'),
    10: TextEditingController(text: '0'),
  };

  String? _lightBillUrl = "";
  String? _panCardUrl = "";
  String? _passbookUrl = "";
  String? _uipImageUrl = "";
  String? _chequeImageUrl = "";
  String? _sitePhotoUrl = "";

  File? _lightBill;
  File? _panCard;
  File? _passbook;
  File? _uipImage;
  File? _chequeImage;
  File? _sitephoto;
  String? _errorText;

  //int totalAmount = 0;

  void _calculateTotalAmount() {
    int total = 0;
    denominationControllers.forEach((denomination, controller) {
      int count = int.tryParse(controller.text) ?? 0;
      total += denomination * count;
    });
    setState(() {
      totalAmount.text = total.toString();
    });
  }

  Future<void> _submitForm() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String username = sp.getString('UserName') ?? "";

    setState(() {
      _loading = true;
    });

    if (_validateForm()) {
      bool isUpdating = widget.postModel != null;
      String url = isUpdating
          ? 'https://avirat-energy-backend.vercel.app/api/customer/${widget.postModel!.id}'
          : 'https://avirat-energy-backend.vercel.app/api/customer/';

      var request = http.MultipartRequest(
        isUpdating ? 'PUT' : 'POST',
        Uri.parse(url),
      );

      request.fields['name'] = _customerName.text;
      request.fields['mobile_number'] = _mobileNumber.text;
      request.fields['panel_brand'] = _panelBrand.text;
      request.fields['inverter_brand'] = _inverterBrand.text;
      request.fields['panel_watt'] = _panelWatt.text;
      request.fields['panel_quality'] = _panelQuality.text;
      request.fields['cash_denomination_500'] =
          denominationControllers[500]!.text;
      request.fields['cash_denomination_200'] =
          denominationControllers[200]!.text;
      request.fields['cash_denomination_100'] =
          denominationControllers[100]!.text;
      request.fields['cash_denomination_50'] =
          denominationControllers[50]!.text;
      request.fields['cash_denomination_20'] =
          denominationControllers[20]!.text;
      request.fields['cash_denomination_10'] =
          denominationControllers[10]!.text;
      request.fields['cash_total'] = totalAmount.text;
      request.fields['cash_amount'] = cash_amount.text;
      request.fields['username'] = username;

      try {
        var response = await request.send();
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${await response.stream.bytesToString()}');
        if (response.statusCode == 301) {
          // Handle redirect
          String? newUrl = response.headers['location'];
          request = http.MultipartRequest(
            isUpdating ? 'PUT' : 'POST',
            Uri.parse("https://avirat-energy-backend.vercel.app" + newUrl!),
          );
          request.fields.addAll({
            'name': _customerName.text,
            'mobile_number': _mobileNumber.text,
            'panel_brand': _panelBrand.text,
            'inverter_brand': _inverterBrand.text,
            'panel_watt': _panelWatt.text,
            'panel_quality': _panelQuality.text,
            'cash_denomination_500': denominationControllers[500]!.text,
            'cash_denomination_200': denominationControllers[200]!.text,
            'cash_denomination_100': denominationControllers[100]!.text,
            'cash_denomination_50': denominationControllers[50]!.text,
            'cash_denomination_20': denominationControllers[20]!.text,
            'cash_denomination_10': denominationControllers[10]!.text,
            'cash_total': totalAmount.text,
            'cash_amount': cash_amount.text,
            'username': username,
          });

          /*  if (_lightBill != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'light_bill_image',
              _lightBill.path,
            ));
          }
          if (_panCard != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'pan_card_image',
              _panCard.path,
            ));
          }
          if (_passbook != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'passbook_image',
              _passbook.path,
            ));
          }
          if (_uipImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'uip_image',
              _uipImage.path,
            ));
          }
          if (_chequeImage != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'cheque_image',
              _chequeImage.path,
            ));
          }
          if (_sitephoto != null) {
            request.files.add(await http.MultipartFile.fromPath(
              'site_photo',
              _sitephoto.path,
            ));
          }
*/
          response = await request.send();
        }

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('Form submitted successfully');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerMaster1(username: username)),
          );
        } else {
          print('Failed to submit form');
        }
      } catch (error) {
        print('Error submitting form: $error');
      } finally {
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
        _errorText = 'Please fill in all fields.';
      });
    }
  }

  bool _validateForm() {
    if (_customerName.text.isEmpty ||
        _mobileNumber.text.isEmpty ||
        _panelBrand.text.isEmpty ||
        _inverterBrand.text.isEmpty ||
        _panelWatt.text.isEmpty ||
        _panelQuality.text.isEmpty) {
      setState(() {
        _errorText = 'Please fill in all fields and select all photos';
      });
      return false;
    }
    return true;
  }

  Future<void> _pickLightBill() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _lightBill = File(pickedFile.path);
        _lightBillUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

  Future<void> _pickPanCard() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _panCard = File(pickedFile.path);
        _panCardUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

  Future<void> _pickPassbook() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _passbook = File(pickedFile.path);
        _passbookUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

  Future<void> _pickUIPImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uipImage = File(pickedFile.path);
        _uipImageUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

  Future<void> _pickChequeImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _chequeImage = File(pickedFile.path);
        _chequeImageUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

  Future<void> _pickSiteImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _sitephoto = File(pickedFile.path);
        _sitePhotoUrl = null; // Clear the URL if a new file is picked
      });
    }
  }

/*  Future<void> _pickLightBill() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _lightBill = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickPanCard() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _panCard = File(result.files.single.path);
      });
    }
  }

  Future<void> _pickPassbook() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      setState(() {
        _passbook = File(result.files.single.path);
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
  }*/

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
              controller: _customerName,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            TextField(
              controller: _mobileNumber,
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            TextField(
              controller: _panelQuality,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Panel Quality'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<String>(
              value: _panelBrand.text.isNotEmpty ? _panelBrand.text : null,
              items: ['Adani', 'Waaree', 'Raaj', 'Redren']
                  .map((brand) => DropdownMenuItem(
                        child: Text(brand),
                        value: brand,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _panelBrand.text = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Panel Brand'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<String>(
              value:
                  _inverterBrand.text.isNotEmpty ? _inverterBrand.text : null,
              items: ['Deye', 'PVblink', 'Solis', 'Polycab']
                  .map((brand) => DropdownMenuItem(
                        child: Text(brand),
                        value: brand,
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _inverterBrand.text = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Inverter Brand'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            DropdownButtonFormField<int>(
              value: _panelWatt.text.isNotEmpty
                  ? int.parse(_panelWatt.text)
                  : null,
              items: ['535', '545', '540', '555', '565', '575']
                  .map((watt) => DropdownMenuItem(
                        child: Text(watt),
                        value: int.parse(watt),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _panelWatt.text = value.toString();
                });
              },
              decoration: InputDecoration(labelText: 'Panel Watt'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Text('Cash Denominations:'),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: denominationControllers.keys.map((denomination) {
                TextEditingController? controller =
                    denominationControllers[denomination];
                return Row(
                  children: [
                    Text('Rs $denomination: '),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Flexible(
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _calculateTotalAmount();
                        },
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          hintText: 'Enter amount',
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Text(
              'Total Cash Denomination: Rs' + totalAmount.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              child: TextField(
                controller: cash_amount,
                decoration: InputDecoration(labelText: 'Rokda Name'),
              ),
            ),
            _lightBillUrl != ""
                ? _buildImagePicker('Light Bill Image', _lightBill,
                    _lightBillUrl, _pickLightBill)
                : Container(),
            _panCardUrl != ""
                ? _buildImagePicker(
                    'Pan Card Image', _panCard, _panCardUrl, _pickPanCard)
                : Container(),
            _passbookUrl != ""
                ? _buildImagePicker(
                    'Passbook Image', _passbook, _passbookUrl, _pickPassbook)
                : Container(),
            _uipImageUrl != ""
                ? _buildImagePicker(
                    'UIP Image', _uipImage, _uipImageUrl, _pickUIPImage)
                : Container(),
            _chequeImageUrl != ""
                ? _buildImagePicker('Cheque Image', _chequeImage!,
                    _chequeImageUrl!, _pickChequeImage)
                : Container(),
            _sitePhotoUrl != ""
                ? _buildImagePicker(
                    'Site Photo', _sitephoto, _sitePhotoUrl, _pickSiteImage)
                : Container(),

            /* SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: _lightBill != null
                  ? Image.file(_lightBill, fit: BoxFit.cover)
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
                  ? Image.file(_panCard, fit: BoxFit.cover)
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
                  ? Image.file(_passbook, fit: BoxFit.cover)
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
                  ? Image.file(_sitephoto, fit: BoxFit.cover)
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
                  ? Image.file(_uipImage, fit: BoxFit.cover)
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
                  ? Image.file(_chequeImage, fit: BoxFit.cover)
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
            ),*/
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

  Widget _buildImagePicker(
    String label,
    File? imageFile,
    String? imageUrl,
    void Function()? onPickImage, // Changed Function? to void Function()?
  ) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: double.infinity,
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: imageFile != null
              ? Image.file(imageFile, fit: BoxFit.cover)
              : imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        'No photo selected',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
        ),
        ElevatedButton(
          onPressed: onPickImage != null
              ? () => onPickImage()
              : null, // Null check added here
          child: Text(label),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 50),
      ],
    );
  }
}
