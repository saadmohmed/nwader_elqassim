import 'dart:ffi';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:nwader/home_screen/myorders.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';
import 'add_address.dart';
import 'package:async/async.dart';

class AddOrder extends StatefulWidget {
  final String total;
  const AddOrder(
      {Key? key,
        required this.total,
      })
      : super(key: key);
  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? animationController;

  Animation<double>? topBarAnimation;

  final storage = new FlutterSecureStorage();
  ApiProvider _api = new ApiProvider();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;

  dynamic _state = '';
  bool status = true;
  int quantity = 0;
  bool is_sluted = false;
  bool alive = false;
  bool covered = false;
  bool without_c = false;
  double address_opacity = 1;
  double payment_opacity = 1;
  double note_opacity = 1;

  Icon arrow_down = Icon( Icons.arrow_downward_sharp , color: AppTheme.white,);
  Icon arrow_up = Icon( Icons.arrow_upward_sharp , color: AppTheme.white);

  String? payment_method = '1';
  String? address ;
  String? note = '';
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  _fetchData() {
    return this._memoizer.runOnce(() async {
      await Future.delayed(Duration(seconds: 2));
      return await _api.getUserAddress();
    });
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text('تأكيد الطلب' ,    style: GoogleFonts.getFont(
            AppTheme.fontName,
            textStyle: TextStyle(
              fontFamily: AppTheme.fontName,
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppTheme.green,
            ),
          ), ),
          leading:   GestureDetector(
            onTap: () async {
              _key.currentState!.openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
              Image.asset('assets/icons/menu-icon.png'),
            ),
          ),
          actions: [

            GestureDetector(
              onTap: () async {
                Navigator.pop(context,true);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_sharp  , color: AppTheme.green,),
              ),
            ),
          ],
        ),

        drawer: DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: Container(
          child: LoaderOverlay(

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
              child: Column(
                children: <Widget>[
                  //to give space from top

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (address_opacity == 0) {
                                address_opacity = 1;
                              } else {
                                address_opacity = 0;
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: AppTheme.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/truck.png'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "التوصيل",
                                    style: GoogleFonts.getFont(
                                      AppTheme.fontName,
                                      textStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.9,
                                  ),
                                address_opacity == 1 ? arrow_down : arrow_up
                                ],
                              ),
                            ),
                          ),
                        ),
                        //page content here
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Visibility(
                              visible: address_opacity == 1 ? true : false,
                              child: Opacity(
                                opacity: address_opacity,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
                                    color: AppTheme.background_c,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             GestureDetector(
                                               onTap: ()async{
                                                 context.loaderOverlay.show();
                                                 dynamic p = await getUserCurrentLocation();
                                                 dynamic areas = await _api.getAreas();
                                                 if(areas['status'] == true){
                                                   context.loaderOverlay.hide();
                                                   Navigator.pushReplacement(
                                                     context,
                                                     MaterialPageRoute(
                                                         builder: (context) => AddAddress(lat: p.latitude,lng: p.longitude,govs:areas['govs'])),
                                                   );
                                                 }


                                               },
                                               child: Row(
                                                 children: [
                                                   Icon(Icons.add , color: AppTheme.green,),
                                                   Text('اضافة عنوان جديد'),
                                                 ],
                                               ),
                                             ),
                                           ],
                                         ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height/3,
                                      child: SingleChildScrollView(
                                          child: FutureBuilder(
                                              future: _fetchData(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  dynamic data = snapshot.data;
                                                  print(data);
                                                  return Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: List.generate(
                                                      data.length,
                                                      (index) {
                                                    int    saved = data[index]['saved'];
                                                     return    saved == 1
                                                            ?  Row(
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width / 15,
                                                              child: Flexible(
                                                                child: Radio<
                                                                    String>(
                                                                    value: '${data[index]["id"]}',
                                                                    groupValue: address,
                                                                    // TRY THIS: Try setting the toggleable value to false and
                                                                    // see how that changes the behavior of the widget.
                                                                    toggleable: true,
                                                                    onChanged: (
                                                                        String? value) {
                                                                      setState(() {
                                                                        address =
                                                                            value;
                                                                      });
                                                                    }),),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery
                                                                  .of(context)
                                                                  .size
                                                                  .width / 1.6,

                                                              child: Flexible(
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                          '${data[index]["address_name"]} '),
                                                                      Text(
                                                                          '${data[index]["address_text"]} ')
                                                                    ],
                                                                  )),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                dynamic d = await _api
                                                                    .delete_user_address(
                                                                    data[index]['id']
                                                                        .toString());

                                                                dynamic total = 0;

                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => AddOrder(
                                                                        total: total.toString(),
                                                                      )),
                                                                );
                                                              },
                                                              child: SizedBox(
                                                                width: MediaQuery
                                                                    .of(context)
                                                                    .size
                                                                    .width / 5,

                                                                child: Icon(
                                                                  Icons.delete,
                                                                  color: AppTheme
                                                                      .green,),
                                                              ),
                                                            )


                                                          ],
                                                        )
                                                            :  SizedBox();
                                                      }),
                                                  );
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              }),
                                        ),
                                    )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (payment_opacity == 0) {
                                payment_opacity = 1;
                              } else {
                                payment_opacity = 0;
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: AppTheme.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/debit-card.png'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "طريقة الدفع",
                                    style: GoogleFonts.getFont(
                                      AppTheme.fontName,
                                      textStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.2,
                                  ),
                                  payment_opacity == 1 ? arrow_down : arrow_up

                                ],
                              ),
                            ),
                          ),
                        ),
                        //page content here
                        SizedBox(
                          height: 20,
                        ),
            SizedBox(
              height: MediaQuery.of(context).size.height/11,
              child: SingleChildScrollView(
                          child: Visibility(
                            visible: payment_opacity == 1 ? true : false,
                            child: Opacity(
                              opacity: payment_opacity,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppTheme.background_c,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Radio<String>(
                                          value: '2',
                                          groupValue: payment_method,
                                          // TRY THIS: Try setting the toggleable value to false and
                                          // see how that changes the behavior of the widget.
                                          toggleable: true,
                                          onChanged: (String? value) {
                                            setState(() {
                                              payment_method = value;
                                            });
                                          }),
                                      Text(
                                        'الدفع بالبطاقه',
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                      Radio<String>(
                                          value: '1',
                                          groupValue: payment_method,
                                          // TRY THIS: Try setting the toggleable value to false and
                                          // see how that changes the behavior of the widget.
                                          toggleable: true,
                                          onChanged: (String? value) {
                                            setState(() {
                                              payment_method = value;
                                            });
                                          }),
                                      Text(
                                        'الدفع عند الاستلام',
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: AppTheme.darkText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
            ),
                        SizedBox(
                          height: 20,
                        ),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (note_opacity == 0) {
                                note_opacity = 1;
                              } else {
                                note_opacity = 0;
                              }
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: AppTheme.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Image.asset('assets/icons/edit.png'),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "اضافة ملاحظات ",
                                    style: GoogleFonts.getFont(
                                      AppTheme.fontName,
                                      textStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppTheme.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 2.8,
                                  ),
                                  note_opacity == 1 ? arrow_down : arrow_up

                                ],
                              ),
                            ),
                          ),
                        ),
                        //page content here
                        SizedBox(
                          height: 20,
                        ),

                        Visibility(
                          visible: note_opacity == 1 ? true : false,
                          child: Opacity(
                            opacity: note_opacity,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                color: AppTheme.background_c,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:  Column(
                                  children: <Widget>[
                                    Card(
                                        color: AppTheme.white,
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: TextField(
                                            maxLines: 8, //or null
                                            decoration: InputDecoration.collapsed(hintText: "اضف ملاحظاتك"),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.loaderOverlay.show();

                      dynamic data = await _api.add_order(address, payment_method, widget.total);

                      if(data['status'] == true){
                         context.loaderOverlay.hide();

                         Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context) => MyOrders()),
                         );
                       }else{
                         context.loaderOverlay.hide();
                         SnackBar snackBar = SnackBar(
                           content: Text('${data["response_message"]} ${data['errors'][0]['error']}'),
                         );
                         ScaffoldMessenger.of(context).showSnackBar(snackBar);

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
                            "تاكيد الطلب",
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class ProductSlider extends StatelessWidget {
  final List<Ad> ads;
  const ProductSlider({Key? key, required this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int _current = 0;
    final CarouselController _controller = CarouselController();

    return CarouselSlider(
        carouselController: _controller,
        options: CarouselOptions(
          height: 200.0,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 2.0,
          viewportFraction: 1.0,
        ),
        items: ads.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://nwader.com.sa/uploads/1603132197_911704661.jpg"),
                        fit: BoxFit.cover),
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset("assets/icons/wish-red-icon.png"),
                    ),
                  ));
            },
          );
        }).toList());
  }
}

class DropItem {
  late String key;
  late Row item;
  DropItem({required this.key, required this.item});
}
