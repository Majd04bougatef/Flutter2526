import 'package:flutter/material.dart';
import 'package:myapp/Screens/bottom_nav_screen.dart';
import 'package:myapp/Screens/cart_screen.dart';
import 'package:myapp/Screens/details_screen.dart';
import 'package:myapp/Screens/home_screen.dart';
import 'package:myapp/Screens/library_screen.dart';
import 'package:myapp/Screens/login_screen.dart';
import 'package:myapp/Screens/tabbar_screen.dart';
import 'package:myapp/Services/favorite_service.dart';
import 'package:myapp/Services/cart_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for favorites
  await FavoriteService.init();
  
  // Initialize SQLite for cart
  await CartService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
      ),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        LibraryScreen.routeName: (context) => LibraryScreen(),
        DetailsScreen.routeName: (context) => DetailsScreen(),
        BottomNavScreen.routeName: (context) => BottomNavScreen(),
        TabbarScreen.routeName: (context) => TabbarScreen(),
        CartScreen.routeName: (context) => const CartScreen(),
      },
      //initialRoute: TabbarScreen.routeName,
      //home: HomeScreen(),
    );
  }
}
