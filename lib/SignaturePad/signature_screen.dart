import 'package:avirat_energy/get_customer.dart';
import 'package:flutter/material.dart';

class SignatureScreen extends StatefulWidget {
  final String username;

  const SignatureScreen({Key key, this.username}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  List<List<Offset>> _strokes = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerMaster1()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Signature Pad',
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
        body: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset position = renderBox.globalToLocal(details.globalPosition);

            setState(() {
              _addPoint(position);
            });
          },
          onPanEnd: (DragEndDetails details) {
            _strokes.add([]);
          },
          child: CustomPaint(
            painter: SignaturePainter(_strokes),
            size: Size.infinite,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _clearSignature,
          tooltip: 'Clear Signature',
          child: Icon(Icons.clear),
        ),
      ),
    );
  }

  void _addPoint(Offset position) {
    if (_strokes.isEmpty || _strokes.last.isEmpty) {
      _strokes.add([]);
    }
    _strokes.last.add(position);
  }

  void _clearSignature() {
    setState(() {
      _strokes.clear();
    });
  }
}

class SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;

  SignaturePainter(this.strokes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (var stroke in strokes) {
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(stroke[i], stroke[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
