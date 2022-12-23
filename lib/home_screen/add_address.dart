import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nwader/home_screen/add_order.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';

class AddAddress extends StatefulWidget {
  late double lat;
  late final double lng;
  final dynamic govs;

  AddAddress(
      {Key? key, required this.lat, required this.govs, required this.lng})
      : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController address = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController fullAddress = TextEditingController();
  TextEditingController build_number = TextEditingController();
  TextEditingController block = TextEditingController();
  TextEditingController flat = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
// on below line we have specified camera position

// on below line we have created the list of markers
  final List<Marker> _markers = <Marker>[
    // Marker(
    //   markerId: MarkerId("2"),
    //   position: LatLng(40.9026913, 50.0667077),
    //   infoWindow: InfoWindow(
    //     title: 'My Current Location',
    //   ),
    // )
  ];

// created method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  dynamic _cit = '12';

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId("2"),
        position: LatLng(widget.lat, widget.lng),
        infoWindow: InfoWindow(
          title: 'مكاني',
        ),
      ));
    });
    super.initState();
  }

  ApiProvider _api = new ApiProvider();
  final _formKey = GlobalKey<FormState>();
  bool marker_change = false;
  late double lat = 0.0;
  late double lng = 0.0;
  dynamic _selectedValue;
  dynamic _selectedValueArea;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          'اضافة عنوان جدبد',
          style: GoogleFonts.getFont(
            AppTheme.fontName,
            textStyle: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppTheme.green,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () async {
            _key.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset('assets/icons/menu-icon.png'),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              Navigator.pop(context, true);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_sharp,
                color: AppTheme.green,
              ),
            ),
          ),
        ],
      ),
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitCubeGrid(
            color: AppTheme.green,
            size: 50.0,
          ),
        ),
        overlayOpacity: 0.5,
        overlayWholeScreen: false,
        overlayHeight: MediaQuery.of(context).size.width,
        overlayWidth: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    Container(
                        child: Column(
                      children: [
                        addressField(size),
                        streetField(size),
                        fullAddressField(size),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: blockAddressField(size),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: buildnumberAddressField(size),
                            )
                          ],
                        ),
                        faltAddressField(size),
                        FutureBuilder(
                            future: _api.getAreas(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                print(snapshot.data);
                                dynamic data = snapshot.data;

                                List<DropItem> countryList = [];
                                List<DropItem> areaList = [];
                                int index = 0;
                                int i = 0;

                                data["govs"].forEach((element) {
                                  if (element['id'].toString() ==
                                      _cit.toString()) {
                                    element['areas'].forEach((element2) {
                                      areaList.add(DropItem(
                                        key: element2["id"].toString(),
                                        item: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                  style: GoogleFonts.getFont(
                                                    AppTheme.fontName,
                                                    textStyle: TextStyle(
                                                      fontFamily:
                                                          AppTheme.fontName,
                                                      fontWeight: FontWeight.w700,
                                                      fontSize: 16,
                                                      color: AppTheme.nearlyBlack,
                                                    ),
                                                  ),
                                                  '${element2["name"]}'),
                                            ),
                                          ],
                                        ),
                                      ));
                                    });

                                    print(element['id'].toString() +
                                        ' => ' +
                                        _cit.toString() +
                                        ' at index' +
                                        i.toString());

                                    index = i;
                                  } else {
                                    if (i == 0) {
                                      element['areas'].forEach((element2) {
                                        areaList.add(DropItem(
                                          key: element2["id"].toString(),
                                          item: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    style: GoogleFonts.getFont(
                                                      AppTheme.fontName,
                                                      textStyle: TextStyle(
                                                        fontFamily:
                                                            AppTheme.fontName,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                        color:
                                                            AppTheme.nearlyBlack,
                                                      ),
                                                    ),
                                                    '${element2["name"]}'),
                                              ),
                                            ],
                                          ),
                                        ));
                                      });
                                    }
                                    i++;
                                  }
                                  countryList.add(DropItem(
                                    key: element["id"].toString(),
                                    item: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              style: GoogleFonts.getFont(
                                                AppTheme.fontName,
                                                textStyle: TextStyle(
                                                  fontFamily: AppTheme.fontName,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: AppTheme.nearlyBlack,
                                                ),
                                              ),
                                              '${element["name"]}'),
                                        ),
                                      ],
                                    ),
                                  ));
                                });

                                _selectedValue = countryList[index];
                                _selectedValueArea = areaList.first;

                                return Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width / 2,
                                        child: Container(
                                          child: DropdownButton<DropItem>(
                                            // isDense: true,
                                            isExpanded: true,
                                            value: _selectedValue,
                                            icon: Icon(Icons.keyboard_arrow_down),
                                            iconSize: 30,
                                            elevation: 20,
                                            style: TextStyle(color: Colors.black),

                                            onChanged: (DropItem? newValue) {
                                              setState(() {
                                                _selectedValue = newValue;
                                                print(newValue?.key);
                                                _cit = '${_selectedValue?.key}';
                                              });
                                            },
                                            items: countryList
                                                .map<DropdownMenuItem<DropItem>>(
                                                    (DropItem value) {
                                              return DropdownMenuItem<DropItem>(
                                                value: value,
                                                child: value.item,
                                              );
                                            }).toList(),
                                          ),
                                        )),
                                    areaList.length > 0
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            child: Container(
                                              child: DropdownButton<DropItem>(
                                                // isDense: true,
                                                isExpanded: true,
                                                value: _selectedValueArea,
                                                icon: Icon(
                                                    Icons.keyboard_arrow_down),
                                                iconSize: 30,
                                                elevation: 20,
                                                style: TextStyle(
                                                    color: Colors.black),

                                                onChanged: (DropItem? newValue) {
                                                  setState(() {
                                                    _selectedValueArea = newValue;
                                                    print(newValue?.key);
                                                  });
                                                },
                                                items: areaList.map<
                                                        DropdownMenuItem<
                                                            DropItem>>(
                                                    (DropItem value) {
                                                  return DropdownMenuItem<
                                                      DropItem>(
                                                    value: value,
                                                    child: value.item,
                                                  );
                                                }).toList(),
                                              ),
                                            ))
                                        : SizedBox(),
                                  ],
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                      ],
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: SafeArea(
                        // on below line creating google maps
                        child: GoogleMap(
                          // on below line setting camera position
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.lat, widget.lng),
                            zoom: 14.4746,
                          ),
                          // on below line we are setting markers on the map
                          markers: Set<Marker>.of(_markers),
                          // on below line specifying map type.
                          mapType: MapType.normal,
                          // on below line setting user location enabled.
                          // myLocationEnabled: true,
                          // on below line setting compass enabled.
                          compassEnabled: true,
                          onTap: (LatLng) async {
                            // specified current users location
                            CameraPosition cameraPosition = new CameraPosition(
                              target: LatLng,
                              zoom: 14,
                            );

                            final GoogleMapController controller =
                                await _controller.future;
                            controller.animateCamera(
                                CameraUpdate.newCameraPosition(cameraPosition));
                            setState(() {
                              _markers.clear();
                              _markers.add(Marker(
                                markerId: MarkerId("2"),
                                position: LatLng,
                                infoWindow: InfoWindow(
                                  title: 'مكاني',
                                ),
                              ));
                              lat = LatLng.latitude;
                              lng = LatLng.longitude;
                              marker_change = true;
                            });
                          },
                          // on below line specifying controller on map complete.
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: GestureDetector(
                        onTap: () async {
                          context.loaderOverlay.show();

                          if (_formKey.currentState!.validate()) {
                            lat =    lat != 0 ? lat :widget.lat;
                            lng =  lng != 0 ? lat :widget.lng;



                            dynamic data = await _api.add_to_address(
                                address.text,
                                _selectedValueArea.key,
                                _selectedValue.key,
                                block.text,
                                street.text,
                                build_number.text,
                                lat.toString(),
                                lng.toString(),
                                fullAddress.text,
                                flat.text);
                            print(data);
                            if (data['status'] == true) {
                              context.loaderOverlay.hide();
                              dynamic total = 0;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddOrder(
                                          total: total.toString(),
                                        )),
                              );
                            } else {
                              context.loaderOverlay.hide();
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                            color: AppTheme.green,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                "اضافة عنوان",
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily: AppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: AppTheme.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      // on pressing floating action button the camera will take to user current location
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            setState(() {
              // marker added for current users location
              // widget.lat = value.latitude;
              // widget.lng = value.longitude;
              marker_change = true;
              lat = value.latitude;
              lng = value.longitude;

              _markers.add(Marker(
                markerId: MarkerId("2"),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(
                  title: 'مكاني',
                ),
              ));
            });
            // specified current users location
            CameraPosition cameraPosition = new CameraPosition(
              target: LatLng(value.latitude, value.longitude),
              zoom: 14,
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
          });
        },
        child: Icon(Icons.location_on),
      ),
    );
  }

  Widget addressField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: address,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم العنوان';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اسنم العنوان',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget streetField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: street,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم الشارع';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اسنم الشارع',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget fullAddressField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: fullAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم العنوان بالتفاصيل';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اسنم العنوان بالتفاصيل',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget blockAddressField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: block,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم المربع ';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اكتب اسم المربع ',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget buildnumberAddressField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: build_number,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب   رقم البناية';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اكتب   رقم البناية',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget faltAddressField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 15,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: flat,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب   رقم الشقه';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppTheme.darkText,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'اكتب   رقم الشقه',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
}

class DropItem {
  late String key;
  late Row item;
  DropItem({required this.key, required this.item});
}
