
import 'package:flutter/material.dart';
import 'package:nwader/auth_screen/Login.dart';
import 'package:nwader/home_screen/Favorites.dart';
import 'package:nwader/home_screen/products.dart';
import '../Services/ApiManager.dart';
import '../app_theme.dart';
import '../bottom_navigation_view/bottom_bar.dart';
import '../common/Slider.dart';
import '../custom_drawer/Drawer.dart';
import '../model/Ad.dart';
import '../models/meals_list_data.dart';
import '../models/tabIcon_data.dart';
import '../ui_view/title_view.dart';
import 'meals_list_view.dart';
import 'notifications.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  late AnimationController animationController ;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  @override
  void initState() {
    animationController   = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
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
    listViews.add(FutureBuilder(
        future: _api.ads(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomeSlider(
              ads: snapshot.data as List<Ad>,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }));
listViews.add(SizedBox(height: 40,));
    listViews.add(FutureBuilder(
        future: _api.cat_wtith_products(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List;

            return Column(
              children: List.generate(
                  data.length,
                  (index) => Column(
                        children: [
                          TitleView(
                            id :      data[index]['cat']['id'] ,
                            titleTxt: '${data[index]['cat']['name']}',
                            subTxt: 'عرض الكل',
                            animation: Tween<double>(begin: 0.0, end: 1.0)
                                .animate(CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * 2, 1.0,
                                        curve: Curves.fastOutSlowIn))),
                            animationController: animationController!,
                          ),
                          MealsListView(
                            mealslist: List.generate(
                                data[index]['products'].length,
                                (index1) => MealsListData(
                                      imagePath: data[index]['products'][index1]
                                          ['image_url'],
                                      titleTxt: data[index]['products'][index1]
                                          ['name'],
                                      kacl: data[index]['products'][index1]
                                          ['price'],
                                      short_desc: data[index]['products']
                                              [index1]['available_weights']
                                          .toString(),
                                      startColor: '#FFFFFF',
                                      endColor: '#FFFFFF',
                                      isFav: data[index]['products'][index1]
                                              ['in_favorite']
                                          .toString(),
                                  id: data[index]['products'][index1]
                                  ['id'].toString()
                                    )),
                            mainScreenAnimation:
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * 3, 1.0,
                                            curve: Curves.fastOutSlowIn))),
                            mainScreenAnimationController:
                               animationController,
                          )
                        ],
                      )),
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
ApiProvider _api = new ApiProvider();
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
          title: Text('' , ),
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
              onTap: () async{
                dynamic check_auth =await _api.getName();
                if(check_auth != null){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Favorites(animationController: animationController,)),
                  );
                }else{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                }


              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                Image.asset('assets/icons/wish-icon.png'),
              ),
            ),
            GestureDetector(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications()),
                );
                },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                Image.asset('assets/icons/alert-icon.png'),
              ),
            ),
          ],
        ),
        drawer: DrawerWidget(),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),

bottomBar(animationController, context),
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
              top:  24,
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


}
