import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt selectedPageIndex = 0.obs;
  RxnInt selectedHallId = RxnInt();

  void selectPage(int index) {
    selectedPageIndex.value = index;
    clearSelection();
  }

  void selectHall(int id) {
    selectedHallId.value = id;
  }

  void clearSelection() {
    selectedHallId.value = null;
  }
}





