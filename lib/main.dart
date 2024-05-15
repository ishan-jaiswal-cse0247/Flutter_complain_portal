import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'models/complaint.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/auth_service.dart';

void main() async {
  //Init Hive
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ComplaintAdapter());
  await Hive.openBox<User>('users');
  await Hive.openBox<Complaint>('complaints');

  // Run App
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'Flutter Hive Auth',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        debugShowCheckedModeBanner: false, // remove debud badge
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            return auth.isAuthenticated ? DashboardScreen() : LoginScreen();
          },
        ),
      ),
    );
  }
}
