import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:h4h/app.dart';
import 'package:h4h/providers/event_form_provider.dart';
import 'package:h4h/models/event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // create a new custom class in db by using:
  //  flutter packages pub run build_runner build
  Hive.registerAdapter(EventAdapter());

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => EventFormProvider())],
      child: const MyApp()));
}
