import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:challengesrollitemheader/data/data.dart';
import 'package:challengesrollitemheader/model/models.dart';
import 'package:flutter/material.dart';

class SliverScrollController extends GetxController {
  //!List of product
  late List<ProductCategory> listCategory;
  //!value of offset
  late List<double> listOffsetItemHeader = [];
  //!header notifier
  var headerNotifier = MyHeader().obs;
  //!offset global key
  var globalOffsetValue = 0.0.obs;
  //!indicator if we are going down or up in the application
  var goingDown = false.obs;
  //! value to do the validations of the top icons
  var valueScroll = ValueNotifier<double>(0);
  //! to move top items in sliver
  late ScrollController scrollControllerItemHeader;
  //!to have overall control of scrolling
  late ScrollController scrollControllerGlobally;
  //!value indicate if the header is visible
  RxBool visibleHeader = false.obs;

  void loadDataRandom() {
    var productsTwo = [...products];
    var productsThree = [...products];
    var productsfour = [...products];
    productsTwo.shuffle();
    productsThree.shuffle();
    productsfour.shuffle();
    listCategory = [
      ProductCategory(category: 'Picked For You', products: products),
      ProductCategory(category: 'Common Order', products: productsTwo),
      ProductCategory(category: 'Vip Order', products: productsThree),
      ProductCategory(category: 'Hot Order ', products: productsfour)
    ];
  }

  @override
  void onInit() {
    loadDataRandom();
    listOffsetItemHeader =
        List.generate(listCategory.length, (index) => index.toDouble());
    //! get value of index in double  catecories
    scrollControllerGlobally = ScrollController();
    //! scroll controller for all page
    scrollControllerItemHeader = ScrollController();

    scrollControllerGlobally.addListener(_listenToScrollChange);
    headerNotifier.listen((value) {
      listenHeaderNotifier();
    });
    visibleHeader.listen((vlue) {
      listVisibleHeader();
    });

    super.onInit();
  }

//! check if the header is visible of not .. if the header is not
  listVisibleHeader() {
    if (visibleHeader.value) {
      headerNotifier.value = MyHeader(index: 0, visible: false);
      return headerNotifier.value;
    }
  }

//? if index of  category item=the index of the header and the header visibility is true  make scroll to that index wit animation
  listenHeaderNotifier() {
    if (visibleHeader.value == true) {
      for (var i = 0; i < listCategory.length; i++) {
        if (headerNotifier.value.index == i &&
            headerNotifier.value.visible == true) {
          return scrollAnimationHorizontal(index: i);
        }
      }
    }
  }

//? if the index of the header and  the value is visible  make an scroll animation that header index
  void scrollAnimationHorizontal({required int index}) {
    if (headerNotifier.value.index == index &&
        headerNotifier.value.visible == true) {
      scrollControllerItemHeader.animateTo(
          listOffsetItemHeader[headerNotifier.value.index!] - 16,
          duration: const Duration(milliseconds: 500),
          curve: goingDown.value ? Curves.bounceInOut : Curves.fastOutSlowIn);
    }
  }

//? check if user scrool down or up--------------------------------
  void _listenToScrollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
    if (scrollControllerGlobally.position.userScrollDirection ==
        ScrollDirection.reverse) {
      goingDown.value = true;
    } else {
      goingDown.value = false;
    }
  }

  void refreshHeader(
    int index,
    bool visible, {
    int? lastIndex,
  }) {
    final headerValue = headerNotifier.value;
    final headerTitle = headerValue.index;
    final headerVisible = headerValue.visible;
    if (headerTitle != index || lastIndex != null || headerVisible != visible) {
      Future.microtask(() {
        if (!visible && lastIndex != null) {
          headerNotifier.value = MyHeader(visible: true, index: lastIndex);
        } else {
          headerNotifier.value = MyHeader(visible: visible, index: index);
        }
      });
    }
  }

  @override
  void dispose() {
    scrollControllerItemHeader.dispose();
    scrollControllerGlobally.dispose();
    super.dispose();
  }
}
