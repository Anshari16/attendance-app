import 'package:absen/pages/dinas.dart';
import 'package:absen/pages/izin.dart';
import 'package:absen/pages/sakit.dart';
import 'package:absen/theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotWorkPage extends StatefulWidget {
  const NotWorkPage({ Key? key }) : super(key: key);

  @override
  State<NotWorkPage> createState() => _NotWorkPageState();
}

class _NotWorkPageState extends State<NotWorkPage> {
  var name;

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
    });
  }

  @override
  void initState() {
    getName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD00000),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(
                    top: 70
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Colors.white
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: Text('Hi... $name', style: whiteTextStyle.copyWith(
                  fontSize: 16
                ),),
              ),
              Center(
                child: Container(
                  width: 350,
                  height: 330,
                  margin: const EdgeInsets.only(top: 20,right: 20, left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Center(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('Pilih alasan', style: blackTextStyle.copyWith(
                              fontSize: 18
                            ),),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15,),
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           fixedSize: const Size(280, 50),
                           primary: Colors.red,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(30)
                           )
                         ),
                         onPressed: (){
                           Navigator.push(context, MaterialPageRoute(
                             builder: (context) => const DinasPage()));
                         },
                         child: Text('Dinas', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                       const SizedBox(height: 15,),
                       ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           fixedSize: const Size(280, 50),
                           primary: Colors.red,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(30)
                           )
                         ),
                         onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                             builder: (context) => const SakitPage()));
                         },
                         child: Text('Sakit', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                       const SizedBox(height: 15,),
                       ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           fixedSize: const Size(280, 50),
                           primary: Colors.red,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(30)
                           )
                         ),
                         onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                             builder: (context) => const IzinPage()));
                         },
                         child: Text('Izin', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                       const SizedBox(height: 15,),
                       ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           fixedSize: const Size(280, 50),
                           primary: Colors.red,
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(30)
                           )
                         ),
                         onPressed: (){
                           CoolAlert.show(
                             context: context, 
                             type: CoolAlertType.confirm,
                             title: 'Apakah Cuti Sudah Di Ajukan?',
                             onConfirmBtnTap: (){
                               Navigator.popAndPushNamed(context, '/cuti');
                             },
                             confirmBtnText: 'Sudah',
                             confirmBtnTextStyle: whiteTextStyle.copyWith(fontSize: 15),
                             onCancelBtnTap: (){
                               Navigator.popAndPushNamed(context, '/ajukan-cuti');
                             },
                             cancelBtnText: 'Belum',
                             cancelBtnTextStyle: blackTextStyle.copyWith(fontSize: 15)
                           );
                         },
                         child: Text('Cuti', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50,)
            ],
          ),
        ),
      )
    );
  }
}