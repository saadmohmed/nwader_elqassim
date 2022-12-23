import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader/CONSTANT.dart';
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
  ApiProvider _api = new ApiProvider();

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  double total = 0;
  int total_product = 0;
  int quantity = 1;

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
        body: Container(
          child: FutureBuilder(
    future: _api.get_user_cart(),
    builder: (context, snapshot) {
    dynamic data = snapshot.data;
    if(snapshot.hasData){
      return Stack(
        children: <Widget>[
          data['products'].length > 0 ? getMainListViewUI(data) : Center(child:Text('السلة فارغة')),

          data['products'].length > 0 ?   Positioned(
              bottom: 55,
              left:1,
              right: 1,
              child: GestureDetector(
                onTap: () {
                  dynamic total = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOrder(total: total.toString(),)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: AppTheme.orange_c,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('عدد المنتجات في السلة',  style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.darkText,
                                ),
                              ),) ,
                              SizedBox(width: MediaQuery.of(context).size.width / 3,),
                              Text(total_product.toString(),  style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: AppTheme.darkText,
                                ),
                              ),)

                            ],
                          ),
                          Row(
                            children: [
                              Text('اجمالي السعر',  style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppTheme.darkText,
                                ),
                              ),) ,
                              SizedBox(width: MediaQuery.of(context).size.width / 2.6,),

                              Text('${total.toString()} ',  style: GoogleFonts.getFont(
                                AppTheme.fontName,
                                textStyle: TextStyle(
                                  fontFamily: AppTheme.fontName,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: AppTheme.darkText,
                                ),
                              ),)

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )) :SizedBox(),
          data['products'].length > 0 ?   Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  dynamic total = 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddOrder(total: total.toString(),)),
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
              )):SizedBox(),
        ],
      );

    }else{
      return Center(child: CircularProgressIndicator());
    }
            }
          ),
        ),
      ),
    );
  }

  Widget getMainListViewUI(data) {
    const int count = 9;

// add products
    var i = 0;
    listViews = [];
    final Animation<double> animation =
    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: Interval((1 / count) * i, 1.0,
            curve: Curves.fastOutSlowIn)));
    animationController?.forward();
    i++;
    total = 0;
    total_product = 0;
    listViews.add( Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FadeTransition(
          opacity: animation!,
          child: Transform(
            transform:
            Matrix4.translationValues(10 * (1.0 - 0.8), 0.0, 0.0),
            child: Column(
                children: data['products'].map<Widget>((e) {
                  total = total + e["vprice"] * e["quantity"];
                  total_product =total_product +1;


                  return   CartProductBody( data: e,);
                }).toList()



            ),
          ),
        ),


      ),
    ));


    listViews.add(SizedBox(height: 130,));
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,

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
class CartProductBody extends StatefulWidget {
  final dynamic data;
  const CartProductBody(
      {Key? key,
        required this.data})
      : super(key: key);
  @override
  State<CartProductBody> createState() => _CartProductBodyState();
}

class _CartProductBodyState extends State<CartProductBody> {
  @override
  int quantity = 1;
  ApiProvider _api = new ApiProvider();

  Widget build(BuildContext context) {
    quantity = widget.data['quantity'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
                            BASE_URL+'/uploads/${widget.data["image"]}')),
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
                            child: GestureDetector(
                              onTap: ()async{
                                await  _api.add_to_cart(widget.data["id"].toString(), widget.data["is_slaughtered"].toString(),widget.data["cover_type_id"].toString() ,widget.data["cut_type_id"].toString() ,0,widget.data["product_variant_id"].toString() );
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Cart()),
                                // );
                                setState(() {
                                  widget.data;
                                });
                              },

                              child: Text(
                                'حذف من السلة',
                                style: GoogleFonts.getFont(
                                  AppTheme.fontName,
                                  textStyle: TextStyle(
                                    fontFamily:
                                    AppTheme.fontName,
                                    fontWeight:
                                    FontWeight.w300,
                                    fontSize: 9,
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
                      '${widget.data["name_ar"]}',
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
                          '${widget.data["weight"]} - ${widget.data["weight_to"]}',
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
                          '${widget.data["vprice"]} ر.س ',
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
                            decoration: InputDecoration(

                            ),
                            iconColor: AppTheme.orange,
                            inputWidth: 40,
                            buttonColor:AppTheme.white ,

                            value: quantity,
                            onChanged: (quantity) async {
                              await  _api.add_to_cart(widget.data["id"].toString(), widget.data["is_slaughtered"].toString(),widget.data["cover_type_id"].toString() ,widget.data["cut_type_id"].toString() ,quantity,widget.data["product_variant_id"].toString() );
                              setState(() {

                              });
                            },
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
      ),
    );
  }
}

