import 'package:csn_inspecao/providers/area_provider.dart';
import 'package:csn_inspecao/providers/gerencia_provider.dart';
import 'package:csn_inspecao/providers/inspection_provider.dart';
import 'package:csn_inspecao/providers/usuario_provider.dart';
import 'package:csn_inspecao/utils/AppRoutes.dart';
import 'package:csn_inspecao/views/inspection_form_screen.dart';
import 'package:csn_inspecao/views/inspection_screen.dart';
import 'package:csn_inspecao/views/items_form_screen.dart';
import 'package:csn_inspecao/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MaterialColor mycolor = const MaterialColor(
    0xFF003087,
    <int, Color>{
      50: Color(0xFF003087),
      100: Color(0xFF003087),
      200: Color(0xFF003087),
      300: Color(0xFF003087),
      400: Color(0xFF003087),
      500: Color(0xFF003087),
      600: Color(0xFF003087),
      700: Color(0xFF003087),
      800: Color(0xFF003087),
      900: Color(0xFF003087),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InspectionsProvider()),
        ChangeNotifierProvider(create: (_) => GerenciaProvider()),
        ChangeNotifierProvider(create: (_) => AreaProvider()),
        ChangeNotifierProvider(create: (_) => UsuarioProvider()),
        ChangeNotifierProvider(create: (_) => AreaProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: mycolor)
              .copyWith(secondary: Colors.purple),
        ),
        title: "CSN INSPEÇÕES",
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.LOGIN_HOME: (_) => const LoginScreen(),
          AppRoutes.INSPECTION_OVERVIEW_SCRENN: (_) =>  const InspectionScreen(),
          AppRoutes.INSPECTION_FORM_SCREEN: (_) =>  InspectionFormScreen(),
          AppRoutes.ITEM_FORM_SCREEN: (_) =>  ItemFormScreen(),
        },
      ),
    );
  }
}
