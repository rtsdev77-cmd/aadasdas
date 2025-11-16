import 'package:get/get.dart';
import '../Screens/Main_Pages/landing_page.dart';
import '../Screens/Main_Pages/notification.dart';
import '../Screens/Profile_Pages/contactus.dart';
import '../Screens/Profile_Pages/faq.dart';
import '../Screens/Profile_Pages/referfriend_screen.dart';
import '../Screens/Profile_Pages/review_screen.dart';
import '../Screens/create_newpassword_screen.dart';
import '../Screens/forgotpassword_screen.dart';
import '../Screens/login_screen.dart';
import '../Screens/onboarding_screens.dart';
import '../Screens/sing_up_screen.dart';
import '../Screens/Main_Pages/booked_lorries.dart';
import '../Screens/Main_Pages/my_loads.dart';
import '../Screens/Profile_Pages/add_wallet.dart';
import '../Screens/Profile_Pages/privacy_policy.dart';
import '../Screens/Profile_Pages/terms_condition.dart';
import '../Screens/Profile_Pages/wallet_screen.dart';
import '../Screens/Sub_Screen/find_lorry.dart';
import '../Screens/Sub_Screen/post_loads.dart';
import '../Screens/Sub_Screen/verify_identity.dart';

class Routes {
  static String splashScreen = '/';
  static String onBoardingScreens = '/onBoardingScreens';
  static String loginScreen = '/loginScreen';
  static String forgotpassword = '/forgotpassword';
  static String createNewPassword = '/createNewPassword';
  static String singUp = '/singUp';
  static String landingPage = '/landingPage';
  static String notification = '/Notification';
  static String myLoads = '/MyLoads';
  static String bookedLorries = '/BookedLorries';
  static String walletScreen = '/walletScreen';
  static String reviewScreen = '/reviewScreen';
  static String referFriend = '/referFriend';
  static String privacyPolicy = '/privacyPolicy';
  static String termsConditions = '/termsConditions';
  static String contactUs = '/contactUs';
  static String faq = '/faq';
  static String addWallet = '/addWallet';
  static String verifyIdentity = '/verifyIdentity';
  static String postLoads = '/postLoads';
  static String findLorry = '/findLorry';
}

final getPages = [
  GetPage(
    name: Routes.onBoardingScreens,
    page: () => const OnBoardingScreens(),
  ),
  GetPage(
    name: Routes.loginScreen,
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: Routes.forgotpassword,
    page: () => const ForgotPassword(),
  ),
  GetPage(
    name: Routes.createNewPassword,
    page: () => const CreateNewPassword(),
  ),
  GetPage(
    name: Routes.singUp,
    page: () => const SingUp(),
  ),
  GetPage(
    name: Routes.landingPage,
    page: () => const LandingPage(),
  ),
  GetPage(
    name: Routes.notification,
    page: () => const Notification(),
  ),
  GetPage(
    name: Routes.myLoads,
    page: () => const MyLoads(),
  ),
  GetPage(
    name: Routes.bookedLorries,
    page: () => const BookedLorries(),
  ),
  GetPage(
    name: Routes.walletScreen,
    page: () => const WalletScreen(),
  ),
  GetPage(
    name: Routes.reviewScreen,
    page: () => const ReviewScreen(),
  ),
  GetPage(
    name: Routes.referFriend,
    page: () => const ReferFriend(),
  ),
  GetPage(
    name: Routes.privacyPolicy,
    page: () => const PrivacyPolicy(),
  ),
  GetPage(
    name: Routes.termsConditions,
    page: () => const TermsConditions(),
  ),
  GetPage(
    name: Routes.contactUs,
    page: () => const ContactUs(),
  ),
  GetPage(
    name: Routes.faq,
    page: () => const Faq(),
  ),
  GetPage(
    name: Routes.addWallet,
    page: () => const AddWallet(),
  ),
  GetPage(
    name: Routes.verifyIdentity,
    page: () => const VerifyIdentity(),
  ),
  GetPage(
    name: Routes.postLoads,
    page: () => const PostLoads(),
  ),
  GetPage(
    name: Routes.findLorry,
    page: () => const FindLorry(),
  ),
];
