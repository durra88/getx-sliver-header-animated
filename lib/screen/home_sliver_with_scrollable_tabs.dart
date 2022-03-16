import 'package:challengesrollitemheader/widget/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/silver_controller.dart';

class HomeSliverWithTab extends StatelessWidget {
  HomeSliverWithTab({Key? key}) : super(key: key);
  final controller = Get.put(SliverScrollController());

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Scrollbar(
        radius: const Radius.circular(8),
        notificationPredicate: (scroll) {
          controller.valueScroll.value = scroll.metrics.extentInside;
          return true;
        },
        child: GetX<SliverScrollController>(builder: (controller) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: controller.scrollControllerGlobally,
            slivers: <Widget>[
              _FlexibleSpaceBarHeader(
                  valueScroll: controller.globalOffsetValue.value,
                  controller: controller),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: _HeaderSliver(controller: controller)),
              for (var i = 0; i < controller.listCategory.length; i++) ...[
                SliverPersistentHeader(
                  delegate: MyHeaderTitle(
                    controller.listCategory[i].category,
                    ((visible) => controller.refreshHeader(i, visible,
                        lastIndex: i > 0 ? i - 1 : null)),
                  ),
                ),
                SliverBodyItems(listItem: controller.listCategory[i].products)
              ]
            ],
          );
        }),
      ),
    );
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader(
      {Key? key, required this.valueScroll, required this.controller})
      : super(key: key);
  final double valueScroll;
  final SliverScrollController controller;
  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      stretch: true,
      expandedHeight: 240,
      pinned: valueScroll < 90 ? true : false,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          stretchModes: const [StretchMode.zoomBackground],
          background: Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundSliver(),
              Positioned(
                right: 10,
                top: (sizeHeight + 20) - controller.valueScroll.value,
                child: const Icon(
                  Icons.favorite,
                  size: 30,
                ),
              ),
              Positioned(
                left: 10,
                top: (sizeHeight + 20) - controller.valueScroll.value,
                child: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

const _maxHeaderExtent = 120.0;

class _HeaderSliver extends SliverPersistentHeaderDelegate {
  _HeaderSliver({required this.controller});
  final SliverScrollController controller;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    // controller.visibleHeader.value = true;
    if (percent > 0.1) {
      controller.visibleHeader.value = true;
    } else {
      controller.visibleHeader.value = false;
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                        opacity: percent > 0.1 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      AnimatedSlide(
                        duration: const Duration(microseconds: 300),
                        offset: Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                        curve: Curves.easeIn,
                        child: const Text(
                          "Durra Restaurant",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: percent > 0.0
                          ? ListItemHeaderSliver(controller: controller)
                          : const SliverHeaderData()),
                )
              ],
            ),
          ),
        ),
        if (percent > 0.1)
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: percent > 0.1
                      ? Container(
                          height: 0.5,
                          color: Colors.blue,
                        )
                      : null))
      ],
    );
  }

  @override
  double get maxExtent => _maxHeaderExtent;

  @override
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
