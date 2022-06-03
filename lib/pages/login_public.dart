
import 'dart:async';

import 'package:absen/models/login_model.dart';
import 'package:absen/theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPublicPage extends StatefulWidget {
  const LoginPublicPage({ Key? key }) : super(key: key);

  @override
  State<LoginPublicPage> createState() => _LoginPublicPageState();
}

class _LoginPublicPageState extends State<LoginPublicPage> {
  
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
                   bottomRight: Radius.circular(100)
                 ),
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
                         const SizedBox(height: 10,)
                       ],
                     ),
                   ),
                 ],
                 
               )
             ),
             const SizedBox(height: 20,),
             Container(
               width: 350,
               height: 270,
               margin: EdgeInsets.only(left: 20, right: 20),
               decoration: BoxDecoration(
                 color: const Color(0xffF9EEEE),
                 borderRadius: BorderRadius.circular(30)
               ),
               child: Form(
                 child: ListView(
                   children: [
                     const SizedBox(height: 10,),
                     Center(
                       child: Text('Silahkan Masuk Terlebih Dahulu', style: blackTextStyle.copyWith(
                         fontSize: 16
                       ),),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: txtUser,
                          decoration: InputDecoration(
                            hintText: 'Masukan NIK',
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: TextFormField(
                          obscureText: true,
                          controller: txtPass,
                          decoration: InputDecoration(
                            hintText: 'Masukan Kata Sandi',
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                       margin: const EdgeInsets.only(left: 20, right: 20),
                       child: ElevatedButton(
                         style: ButtonStyle(
                           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                             RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(18)
                             )
                           ),
                           backgroundColor: MaterialStateProperty.all(Colors.red)
                         ),
                         onPressed: () {
                           _doLogin();
                        },
                         child: Text('Masuk', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                      ),
                   ],
                 ),
               ),
             ),
             SizedBox(height: 50,)
           ],
         ),
       ),
      ),
    );
  }

  Future _doLogin() async {
   if (txtUser.text.isEmpty || txtPass.text.isEmpty) {
     CoolAlert.show(
      context: context, 
      type: CoolAlertType.error,
      title: 'Maaf...',
      text: 'Data anda salah',
      backgroundColor: Colors.white
    );
    return;
   } 
   final response = await http.post(Uri.parse("https://bskp.co.id/bskp_attendance/public/api/login-public"), 
   body:
   {
     'nik' : txtUser.text.toString(),
     'password': txtPass.text.toString()
   }, 
   headers: 
   {
     'Accept': 'application/json'
   });
   if (response.statusCode == 200) {
     final loginModel = loginModelFromJson(response.body);
     print(loginModel);
     var name = loginModel.data!.user.name;
     var token = loginModel.data!.token;
     var id = loginModel.data!.user.id;
     var latitude = loginModel.data!.user.latitude;
     var longitude = loginModel.data!.user.longitude;
     var accessBy = loginModel.data!.user.accessBy;
     SharedPreferences pref = await SharedPreferences.getInstance();
     pref.setString('name', name!); 
     pref.setString('token', token);
     pref.setInt('id', id!);
     pref.setString('latitudes', latitude!);
     pref.setString('longitudes', longitude!);
     pref.setString('access_by', accessBy!);
     
     LoadingAnimationWidget.bouncingBall(color: Colors.white, size: 200);

     Navigator.pushNamed(context, '/choose');
     CoolAlert.show(
       context: context, 
       type: CoolAlertType.success,
       title: 'Selamat',
       text: 'Anda berhasil masuk',
       backgroundColor: Colors.white);
   } else {
     CoolAlert.show(
      context: context, 
      type: CoolAlertType.error,
      title: 'Maaf...',
      text: 'Data anda salah',
      backgroundColor: Colors.white
    );
   }
  }

}