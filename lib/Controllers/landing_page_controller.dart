import 'package:get/get_state_manager/get_state_manager.dart';
import '../Screens/Main_Pages/home_page.dart';
import '../widgets/widgets.dart';

import '../Screens/Main_Pages/booked_lorries.dart';
import '../Screens/Main_Pages/my_loads.dart';
import '../Screens/Main_Pages/profile.dart';

class LandingPageController extends GetxController implements GetxService {
  int selectPageIndex = 0;

  DateTime? lastBackPressed;

  Future popScopeBack(context) async{
    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
      now.difference(lastBackPressed!) > Duration(seconds: 2)) {
      lastBackPressed = now;
      snakbar("Press back again to exit", context);
      return false;
    }
    return true;
  }

  setSelectPage(int value) {
    selectPageIndex = value;
    update();
  }

  List bottomItems = [
    "Home",
    "My Loads",
    "Booked Lorries",
    "Profile",
  ];

  List bottomItemsIcons = [
    "assets/icons/ic_home_bottom.svg",
    "assets/icons/ic_myloads_bottom.svg",
    "assets/icons/ic_bookedlorries_bottom.svg",
    "assets/icons/ic_user_bottom.svg",
  ];

  List pages = [
    const HomePage(),
    const MyLoads(),
    const BookedLorries(),
    const Profile(),
  ];
}
