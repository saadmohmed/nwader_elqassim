import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quantity_input/quantity_input.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import 'add_order.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late AnimationController? animationController;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  double total = 0;
  int total_product = 0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

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

  void addAllListData() async {
    const int count = 9;
    ApiProvider _api = new ApiProvider();

// add products
    var i = 0;
    listViews.add(FutureBuilder(
        future: _api.get_categoires(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final Animation<double> animation =
                Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / count) * i, 1.0,
                        curve: Curves.fastOutSlowIn)));
            animationController?.forward();
            i++;
            final data = snapshot.data as List;
            var quantity;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FadeTransition(
                  opacity: animation!,
                  child: Transform(
                    transform:
                        Matrix4.translationValues(10 * (1.0 - 0.8), 0.0, 0.0),
                    child: FutureBuilder(
                      future: _api.get_user_cart(),
          builder: (context, snapshot) {
          dynamic data = snapshot.data ;
          if(snapshot.hasData){
            if(data['products'] != null){
              return Column(
                  children: data['products'].map<Widget>((e) {
                    print(e['price']);
                    WidgetsBinding.instance.addPostFrameCallback((_){

                      setState(() {
                        // var price = int.parse(e['price']);
                        //
                        // total += 5 ;
                        // total_product += 1;
                      });
                    });

                    return   Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: AppTheme.background_c,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                      width: 100,
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(1)),
                                      ),
                                      child: Image.network(
                                          '${e["image_url"]}')),
                                  SizedBox(height: 10,),
                                  Container(
                                      width: 100,
                                      height: 35,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: AppTheme.orange,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            child: Text(
                                              'حذف من السلة',
                                              style: GoogleFonts.getFont(
                                                AppTheme.fontName,
                                                textStyle: TextStyle(
                                                  fontFamily:
                                                  AppTheme.fontName,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  fontSize: 12,
                                                  color: AppTheme.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,                                      children: [

                                  Text(
                                    textAlign:TextAlign.start,
                                    '${e["name"]}',
                                    style: GoogleFonts.getFont(
                                      AppTheme.fontName,
                                      textStyle: TextStyle(
                                        fontFamily: AppTheme.fontName,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: AppTheme.darkerText,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${e["available_weights"]}',
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        '${e["price"]} ر.س ',
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.orange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "مذبوح",
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 50,),
                                      Text(
                                        "التقطيع ارباع ",
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "مع التغليف",
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 50,),
                                      Text(
                                        " مسلوخ ",
                                        style: GoogleFonts.getFont(
                                          AppTheme.fontName,
                                          textStyle: TextStyle(
                                            fontFamily: AppTheme.fontName,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: AppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                      ),
                                      Container(
                                        color: AppTheme.green,
                                        child: QuantityInput(
                                          iconColor: AppTheme.orange,
                                          inputWidth: 50,
                                          buttonColor:AppTheme.white ,

                                          value: 1,
                                          onChanged: (String) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList()



              );
            }else{
               return Center(child: Text("السلة فارغة"),);
            }

          }else{
            return CircularProgressIndicator();
          }

                      },
                    ),
                  ),
                ),

                // child: Wrap(
                //     spacing: 2,
                //     runSpacing: 2,
                //     children: data.map((e) {
                //       final Animation<double> animation =
                //       Tween<double>(begin: 0.0, end: 1.0).animate(
                //           CurvedAnimation(
                //               parent: animationController!,
                //               curve: Interval((1 / count) * i, 1.0,
                //                   curve: Curves.fastOutSlowIn)));
                //       animationController?.forward();
                //       i++;
                //       return FadeTransition(
                //         opacity: animation!,
                //         child: Transform(
                //           transform: Matrix4.translationValues(
                //               10 * (1.0 - animation!.value), 0.0, 0.0),
                //
                //           child: Container(
                //               alignment: Alignment.center,
                //               height: 120,
                //               width: 150,
                //               padding: const EdgeInsets.symmetric(horizontal: 16),
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //
                //                 borderRadius: BorderRadius.circular(8.0),
                //                 border: Border.all(
                //                   width: 2,
                //                   color: AppTheme.green,
                //                 ),
                //               ),
                //               child: Column(
                //                 children: [
                //                   Image.network('${e["image_url"]}', width: 70,height: 70,),
                //                   Text('${e["name"]}' ,style: GoogleFonts.getFont(
                //                     AppTheme.fontName,
                //                     textStyle: TextStyle(
                //                       fontFamily: AppTheme.fontName,
                //                       fontWeight: FontWeight.w700,
                //                       fontSize: 12,
                //                       color: AppTheme.green,
                //                     ),
                //                   ),)
                //                 ],
                //               )
                //
                //           ),
                //         ),);
                //     }).toList()
                // ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.background,
      child: Scaffold(
        key:_key,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text('سلة المشتريات' ,    style: GoogleFonts.getFont(
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
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),

          Positioned(
                bottom: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddOrder()),
                    );
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
                          "اضافة طلب",
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
                )),
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              animationController?.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController!,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation!,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: AppTheme.grey.withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 0,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                print('opended');
                                Scaffold.of(context).openDrawer();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child:
                                    Image.asset('assets/icons/menu-icon.png'),
                              ),
                            ),
                            SizedBox(
                              width: 55,
                            ),
                            SizedBox(
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Text(
                                  'سلة المشتريات',
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
                              ),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: Icon(Icons.arrow_forward_sharp),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}