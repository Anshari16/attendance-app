import 'dart:async';

import 'package:absen/pages/login.dart';
import 'package:absen/pages/login_public.dart';
import 'package:absen/theme.dart';
import 'package:flutter/material.dart';

class AccessPage extends StatefulWidget {
  const AccessPage({Key? key}) : super(key: key);

  @override
  State<AccessPage> createState() => _AccessPageState();
}

class _AccessPageState extends State<AccessPage> {
  TextEditingController txtUser = TextEditingController();
  TextEditingController txtPass = TextEditingController();

  bool loading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD00000),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            children: [
              Container(
                  width: 420,
                  height: 300,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)),
                    color: Colors.red,
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              margin: const EdgeInsets.only(top: 100),
                              child: Center(
                                child: SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: Image.asset('assets/logo.png'),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 350,
                height: 210,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: const Color(0xffF9EEEE),
                    borderRadius: BorderRadius.circular(30)),
                child: Form(
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Anda ingin akses darimana?',
                          style: blackTextStyle.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            _loginLocal();
                          },
                          child: Text(
                            'Local',
                            style: whiteTextStyle.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            _loginPublic();
                          },
                          child: Text(
                            'Public',
                            style: whiteTextStyle.copyWith(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future _loginPublic() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPublicPage()));
  }

  Future _loginLocal() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
