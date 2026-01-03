import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/welcome_screen.dart';
import './screens/login_screen.dart';
import 'network/mqtt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        // Create MQTT client only when HomePage is accessed
        if (settings.name == HomePage.id) {
          return MaterialPageRoute(
            builder: (context) => HomePage(mqttClient: MQTTClientWrapper()),
          );
        }
        return null;
      },
    );
  }
}
