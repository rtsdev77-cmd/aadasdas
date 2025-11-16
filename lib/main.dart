import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AppConstData/routes.dart';
import 'AppConstData/setlocallanguage.dart';
import 'AppConstData/string_file.dart';
import 'Screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Permission.phone.request();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MyApp(
      prefs: prefs,
    )
  );
}

class MyApp extends StatelessWidget {
  final SharedPreferences _prefs;
  const MyApp({super.key, required SharedPreferences prefs})
      : _prefs = prefs;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleModel(_prefs),
      child: Consumer<LocaleModel>(
        builder: (context, localeModel, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Movers',
            initialRoute: Routes.splashScreen,
            getPages: getPages,
            translations: AppTranslations(),
            locale: localeModel.locale,
            theme: ThemeData(
              useMaterial3: false,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              dividerColor: Colors.transparent,
              fontFamily: "urbani_regular",
              primaryColor: const Color(0xff1347FF),
              colorScheme: ColorScheme.fromSwatch().copyWith(
                primary: const Color(0xff194BFB),
              ),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

