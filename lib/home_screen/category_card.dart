
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models/meals_list_data.dart';

class CategoryCard extends StatefulWidget {
  final List<CategoriesListData> mealslist;

  const CategoryCard(
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

class _MealsListViewState extends State<CategoryCard>
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
         child: Wrap(
           children: [
         ListView.builder(
               padding: const EdgeInsets.only(
                   top: 0, bottom: 0, right: 16, left: 16),
               itemCount: widget.mealslist.length,
               scrollDirection: Axis.vertical,
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
         return  Container(
           width: 150,
           height: 200,
           child: MealsView(
                     mealsListData: widget.mealslist[index],
                     animation: animation,
                     animationController: animationController!,
                   ),
         );
         },
         )
           ],
         ),
            // child: Container(
            //   height: 150,
            //   width: 150,
            //   child: ListView.builder(
            //     padding: const EdgeInsets.only(
            //         top: 0, bottom: 0, right: 16, left: 16),
            //     itemCount: widget.mealslist.length,
            //     scrollDirection: Axis.vertical,
            //     itemBuilder: (BuildContext context, int index) {
            //       final int count = widget.mealslist.length > 10
            //           ? 10
            //           : widget.mealslist.length;
            //       final Animation<double> animation =
            //       Tween<double>(begin: 0.0, end: 1.0).animate(
            //           CurvedAnimation(
            //               parent: animationController!,
            //               curve: Interval((1 / count) * index, 1.0,
            //                   curve: Curves.fastOutSlowIn)));
            //       animationController?.forward();
            //
            //       return MealsView(
            //         mealsListData: widget.mealslist[index],
            //         animation: animation,
            //         animationController: animationController!,
            //       );
            //     },
            //   ),
            // ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key? key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final CategoriesListData ? mealsListData;
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
              child: Container(
                  alignment: Alignment.center,
                  height: 150,
                  width: 170,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 2,
                      color: AppTheme.green,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.network('${mealsListData?.imagePath}', width: 50,height: 50,),
                      Text('${mealsListData?.titleTxt}')
                    ],
                  )

              ),
            ),
          ),
        );
      },
    );
  }
}
