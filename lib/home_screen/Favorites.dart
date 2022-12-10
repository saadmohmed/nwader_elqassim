import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader/home_screen/product_details.dart';
import 'package:quantity_input/quantity_input.dart';
import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';
import '../models/meals_list_data.dart';
import 'meals_list_view.dart';

class Favorites extends StatefulWidget {

  const Favorites({Key? key, this.animationController})
      : super(key: key);

  final AnimationController? animationController;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> with TickerProviderStateMixin {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
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
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key:_key,
        appBar: AppBar(
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: Text('المفضلة' ,    style: GoogleFonts.getFont(
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              //to give space fsrom top
              SizedBox(
                height: 10,
              ),

              //page content here
              FutureBuilder(
                  future: _api.get_user_favorite(),
                  builder: (context, snapshot) {

                    if (snapshot.hasData) {
                      dynamic data = snapshot.data;
                      print(data);
                      int i = 0;
                      return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 2,
                              runSpacing: 2,
                              children: data['products'].map<Widget>((e) {
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: widget.animationController!,
                                        curve: Interval((1 / 9) * i, 1.0,
                                            curve: Curves.fastOutSlowIn)));i++;

                                return GestureDetector(
                                  onTap: () async {


                                    ApiProvider _api = new ApiProvider();
                                    dynamic config = await _api.get_config();
                                    if(config['status'] == true){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProductDetails(
                                              animationController: widget.animationController,
                                              id: e["id"],config: config,
                                            )),
                                      );
                                    }
                                  },
                                  child: MealsView(
                                    animationController: widget.animationController,
                                    animation: animation,
                                    mealsListData: MealsListData(

                                        imagePath: e['image_url'],
                                        titleTxt: e['name'],
                                        kacl: e['price'],
                                        short_desc: e['available_weights'].toString(),
                                        startColor: '#FFFFFF',
                                        endColor: '#FFFFFF',
                                        isFav: e['in_favorite'].toString(),
                                        id: e['id'].toString()),
                                  ),
                                );
                              }).toList(),
                            ),
                          ));
                    } else {
                      return Center(
                        child: Center(child: Text('المفضلة فارغة',style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppTheme.green,
                          ),
                        ),),),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        Container(
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
                        Scaffold.of(context).openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset('assets/icons/menu-icon.png'),
                      ),
                    ),

                    SizedBox(
                      width: 300,
                      child:                     Center(child: Text('المقضلة')),

                    ),
                    SizedBox(
                      height: 38,
                      width: 38,
                      child: Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
class MealsView extends StatelessWidget {
  const MealsView(
      {Key? key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 170,
              height:250,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(mealsListData!.imagePath),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    right: 10,
                    child: Container(
                      child: Text(
                        mealsListData!.titleTxt,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppTheme.darkerText,
                          ),
                        ), ),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    right: 10,
                    child: Container(
                      child: Text(
                        mealsListData!.short_desc,
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppTheme.darkerText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  mealsListData?.kacl != 0
                      ? Positioned(
                    top: 200,
                    right: 10,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            mealsListData!.kacl.toString(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                color: AppTheme.green,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 4, bottom: 3),
                            child: Text(
                              'ر.س',
                              style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: AppTheme.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container(),
                  mealsListData!.isFav == '1'
                      ? Positioned(
                    top: 10,
                    left: 15,
                    child: Container(
                      child:
                      Image.asset('assets/icons/wish-red-icon.png'),
                    ),
                  )
                      : Positioned(
                    top: 10,
                    left: 15,
                    child: Container(
                      width: 20,
                      height: 20,
                      child: Image.asset('assets/icons/wish-icon.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
