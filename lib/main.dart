import 'package:absen/pages/access.dart';
import 'package:absen/pages/ajukan_cuti.dart';
import 'package:absen/pages/check_loc.dart';
import 'package:absen/pages/choose.dart';
import 'package:absen/pages/cuti.dart';
import 'package:absen/pages/dinas.dart';
import 'package:absen/pages/early_go.dart';
import 'package:absen/pages/izin.dart';
import 'package:absen/pages/login.dart';
import 'package:absen/pages/login_public.dart';
import 'package:absen/pages/not_work.dart';
import 'package:absen/pages/sakit.dart';
import 'package:absen/pages/work.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const AccessPage(),
        '/login-local': (context) => const LoginPage(),
        '/login-public': (context) => const LoginPublicPage(),
        '/choose': (context) => const ChoosePage(),
        '/work': (context) => const WorkPage(),
        '/not-work': (context) => const NotWorkPage(),
        '/dinas': (context) => const DinasPage(),
        '/sakit':(context) => const SakitPage(),
        '/izin': (context) => const IzinPage(),
        '/cuti': (context) => const CutiPage(),
        '/ajukan-cuti':(context) => const AjukanCutiPage(),
        '/check-loc':(context) => const CheckLocPage(),
        '/early-go': (context) => const EarlyGo()
      },
    )
  );
}