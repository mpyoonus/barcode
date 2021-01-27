import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return new _MyHomePageState();
  }
}


class _MyHomePageState extends State<ProductList> {

  String Barcode = "Barcode";
  String ProductName = "ProductName";
  String Descriptions = "Descriptions";
  String Cost = "         Cost:00.00";
  String SellingPrice = "Selling Price:00.00";
  String Mrp = "          MRP:00.00";
  String Offer = "        Offer:00%";
  String ItemWise = "    Item Wise:00.00";


  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();

      final response =
      await http.get('http://192.168.1.10:8080/EbosBarcode/api/getProductDetailsByBarcode.php?barcode='+qrResult);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        final body = json.decode(response.body);


        //print(queryData);


        setState(() {
          if(body!="NoMessage") {
            Barcode = body['barcode'];
            ProductName = body['iName'];
            Descriptions = "no descriptions";
            Cost = "         Cost:" + body['avgCost'];
            SellingPrice = "Selling Price:" + body['salePrice'];
            Mrp = "          MRP:" + body['mrp'];
            Offer = "        Offer:" + body['Perc'] + "%";
            ItemWise = "    Item Wise:" + body['ClsStk'];
          }
          else
          {
            Barcode = "Barcode";
            ProductName = "ProductName";
            Descriptions = "Descriptions";
            Cost = "         Cost:00.00";
            SellingPrice = "Selling Price:00.00";
            Mrp = "          MRP:00.000";
            Offer = "        Offer:00%";
            ItemWise = "    Item Wise:00.00";
          }

        });

        print(body['ProductName']);

      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }

      setState(() {
        Barcode = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          Barcode = "Camera permission was denied";
        });
      } else {
        setState(() {
          Barcode = "NetWork not available";
        });
      }
    } on FormatException {
      setState(() {
        Barcode = "Barcode not Exists";
      });
    } catch (ex) {
      setState(() {
        Barcode = "Unknown Error $ex";
      });
    }



    //***************

    var client = new http.Client();
    try {
      print(await client.get('http://192.168.43.85:8080/EbosBarcode/api/getProductDetailsByBarcode.php?barcode=101012'));
    }
    finally {
      client.close();
    }

    //**********




  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.12),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 0, top: 15),
          child: Align(
            alignment: Alignment.topCenter,
            child: (Text(
              Barcode,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Oswald",
                  fontSize: 18.0),
            )),
          ),
        ),
        //actions: <Widget>[Container(child: Image.asset('assets/actions.png'))],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[


            // Main Body

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ProductName,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Oswald",
                              fontSize: 33.0,
                              fontStyle: FontStyle.normal),
                        ),
                        Text(
                          Descriptions,
                          style: TextStyle(
                              color: const Color(0xffefefef),
                              fontWeight: FontWeight.w300,
                              fontFamily: "Oswald-Extra",
                              fontSize: 12.0,
                              fontStyle: FontStyle.normal),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        Container(
                          width: 115,
                          height: 0.8,
                          color: Colors.amber,
                        )
                      ],
                    )),
                SizedBox(
                  height: 50.0,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[

                          InkWell(
                              onTap: () {},
                              child: Container(
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    Cost,
                                    style: const TextStyle(
                                        color: const Color(0xff0c0a0b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Oswald",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(215, 214, 214, 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                              )),
                          SizedBox(
                            height: 20,
                          ),InkWell(
                              onTap: () {},
                              child: Container(
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    SellingPrice,
                                    style: const TextStyle(
                                        color: const Color(0xff0c0a0b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Oswald",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(215, 214, 214, 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                              )),
                          SizedBox(
                            height: 20,
                          ),InkWell(
                              onTap: () {},
                              child: Container(
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    Mrp,
                                    style: const TextStyle(
                                        color: const Color(0xff0c0a0b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Oswald",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(215, 214, 214, 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                              )),
                          SizedBox(
                            height: 20,
                          ),InkWell(
                              onTap: () {},
                              child: Container(
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    Offer,
                                    style: const TextStyle(
                                        color: const Color(0xff0c0a0b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Oswald",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
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
                          InkWell(
                              onTap: () {},
                              child: Container(
                                height: 42,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    ItemWise,
                                    style: const TextStyle(
                                        color: const Color(0xff0c0a0b),
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Oswald",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(215, 214, 214, 1),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0))),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 30.0, top: 50, bottom: 45),
                      child: Container(
                          width: 195.5,
                          height: 355,
                          child: /*Image.asset(
                            "assets/juice.png",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )*/Text(//it just used for identify the image place
                            "",
                            style: const TextStyle(
                                color: const Color(0xff0c0a0b),
                                fontWeight: FontWeight.w600,
                                fontFamily: "Oswald",
                                fontStyle: FontStyle.normal,
                                fontSize: 16.0),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),

              ],
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.camera_alt),
        label: Text("Scan"),
        onPressed: _scanQR,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );

  }
}