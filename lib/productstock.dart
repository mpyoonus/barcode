import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:share/share.dart';

class ProductStock extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<ProductStock> {
  final descriptionTextController = TextEditingController();
  final txtBarcodeTextController = TextEditingController();
  final txtResultTextController = TextEditingController();
  bool _validate = false;
  bool _validateBarcode=false;

  String strBarcode = "Barcode";
  String strResultQure = "";


  Future _scanQR() async {

    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        strBarcode = qrResult;
        txtBarcodeTextController.text=strBarcode;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          strBarcode = "Camera permission was denied";
        });
      } else {
        setState(() {
          strBarcode = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        strBarcode = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        strBarcode = "Unknown Error $ex";
      });
    }


  }

  share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share(txtResultTextController.text,
        subject: "barcode",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("Product Stock"),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {},
                child: Container(
                  height: 42,
                  width: double.infinity,
                  child: Center(
                    child: TextFormField(
                      enabled: false,
                          decoration: InputDecoration(
                        enabledBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(25.0),

                        ),
                        errorText:  _validateBarcode ? 'Value Can\'t Be Empty' : null,
                        hintText: "Please scan barcode" ),
                    controller: txtBarcodeTextController,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(215, 214, 214, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(25.0))),
                )),
            SizedBox(
              height: 20,
            ),
            TextFormField(

              decoration: InputDecoration(
                  enabledBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 3.0),
                    borderRadius: BorderRadius.circular(25.0),

                  ),
                  suffixIcon: IconButton(
                    onPressed: () => descriptionTextController.clear(),
                    icon: Icon(Icons.clear),
                  ),
                  errorText:  _validate ? 'Value Can\'t Be Empty' : null,
                  hintText: "New Quantity" ),
              keyboardType: TextInputType.number,
              controller: descriptionTextController,

            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                    setState(() {
                      if(descriptionTextController.text.isEmpty || txtBarcodeTextController.text.isEmpty) {
                        if (descriptionTextController.text.isEmpty)
                          _validate = true;
                        if (txtBarcodeTextController.text.isEmpty)
                          _validateBarcode = true;
                      }
                      else {
                        _validate = false;
                        _validateBarcode = false;
                        if(strResultQure.length>1) {
                          strResultQure +=
                              ",\n" + strBarcode + "," +
                                  descriptionTextController.text;
                        }
                        else
                          {
                            strResultQure =
                                strBarcode + "," +
                                    descriptionTextController.text;
                          }
                        txtResultTextController.text=strResultQure;
                      }
                    });
                },
                child: Text('Add'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                expands: false,
                decoration: InputDecoration(
                    enabled: false,
                    hintText: "Added Details",
                    border: OutlineInputBorder(), fillColor: Colors.black),

                controller: txtResultTextController,
                maxLines: 5,
                maxLengthEnforced: false,

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0, vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  share(context);
                },
                child: Text('Share'),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  bool isNumeric(String s) {
    try {
      return double.parse(s) != null;
    } catch (e) {
      return false;
    }
  }
}




