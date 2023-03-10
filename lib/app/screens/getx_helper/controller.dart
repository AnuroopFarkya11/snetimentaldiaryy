
import 'dart:developer';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:snetimentaldiary/app/screens/getx_helper/state.dart';
import 'package:snetimentaldiary/app/services/firebase.dart';

import '../../models/notion_model/notion_model.dart';

class HomePageController extends GetxController {
  final state = HomePageState();
  HomePageController();
  var isLoading = true.obs;
  final RefreshController refreshController = RefreshController(initialRefresh: true);


  @override
  Future<void> onInit() async {
    await getAllRecentNotions();
    super.onInit();

  }

  onRefresh(){
    getAllRecentNotions().then((_) =>
        refreshController.refreshCompleted(resetFooterState: true)
    );
  }

  void onLoading(){
    // asyncLoadData().then((_) =>
    refreshController.loadComplete();
    // );
  }

  getAllRecentNotions() async {
    isLoading.value = true;
    state.notionsList.clear();
    log('This is the notion');
    var res = await FirebaseFireStore.to.getAllRecentNotions();
    log('This is the notion');
    for(var notion in res.docs){
      state.notionsList.add(NotionModel.fromJson(notion.data() as Map<String, dynamic>));
      log('This is the notion: ${notion.data()}');
    }
    isLoading.value = false;
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}