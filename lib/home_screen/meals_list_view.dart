
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader/Services/ApiManager.dart';
import 'package:nwader/auth_screen/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app_theme.dart';
import '../models/meals_list_data.dart';
import 'product_details.dart';

class MealsListView extends StatefulWidget {
  final List<MealsListData> mealslist;

  const MealsListView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      required this.mealslist})
      : super(key: key);
  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
              height: 260,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: widget.mealslist.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = widget.mealslist.length > 10
                      ? 10
                      : widget.mealslist.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController!,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return GestureDetector(
                    onTap: () async {
                      ApiProvider _api = new ApiProvider();
                      dynamic config = await _api.get_config();
                      if(config['status'] == true){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductDetails(
                                animationController: animationController,
                                id: widget.mealslist[index].id,config: config,
                              )),
                        );
                      }

                    },
                    child: MealsView(
                      mealsListData: widget.mealslist[index],
                      animation: animation,
                      animationController: animationController!,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatefulWidget {
  const MealsView(
      {Key? key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData? mealsListData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  @override
  State<MealsView> createState() => _MealViewState();
}

class _MealViewState extends State<MealsView> {
  ApiProvider _api = new ApiProvider();
  String  favorite = '';

  @override
  void initState() {
    super.initState();

favorite = widget.mealsListData!.isFav;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation!.value), 0.0, 0.0),
            child: SizedBox(
              width: 170,
              child: Stack(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.mealsListData!.imagePath),
                          fit: BoxFit.cover),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    right: 10,
                    child: Container(
                      child: Text(
                        widget.mealsListData!.titleTxt,
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
                    top: 185,
                    right: 10,
                    child: Container(
                      child: Text(
                        widget.mealsListData!.short_desc,
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
                  widget.mealsListData?.kacl != 0
                      ? Positioned(
                    top: 200,
                    right: 10,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            widget.mealsListData!.kacl.toString(),
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
                  favorite == '1'
                      ? Positioned(
                    top: 10,
                    left: 15,
                    child: GestureDetector(
                      onTap: ()async{
                        dynamic token = await _api.get_token();
                        if(token == null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        }
                        dynamic data = await _api.add_to_favorite(widget.mealsListData!.id.toString());
                        if(data['status'] == true){

                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "",
                            desc:data['response_message']!,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  'متابعة',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                          setState(() {
                            if(favorite == '1'){
                              favorite = '0';

                            }else{
                              favorite = '1';

                            }
                          });
                        }
                      },
                      child: Container(
                        child:
                        Image.asset('assets/icons/wish-red-icon.png'),
                      ),
                    ),
                  )
                      : Positioned(
                    top: 10,
                    left: 15,
                    child: GestureDetector(
                      onTap: ()async{
                        dynamic token = await _api.get_token();
                        if(token == null){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()),
                          );
                        }
                        dynamic data = await _api.add_to_favorite(widget.mealsListData!.id.toString());
                        if(data['status'] == true){

                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: "",
                            desc:data['response_message']!,
                            buttons: [
                              DialogButton(
                                child: Text(
                                  'متابعة',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                          setState(() {
                            if(favorite == '1'){
                              favorite = '0';

                            }else{
                              favorite = '1';

                            }
                          });
                        }

                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        child: Image.asset('assets/icons/wish-icon.png'),
                      ),
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

