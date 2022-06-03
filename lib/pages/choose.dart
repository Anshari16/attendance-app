import 'package:absen/pages/check_loc.dart';
import 'package:absen/pages/not_work.dart';
import 'package:absen/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePage extends StatefulWidget {
  const ChoosePage({Key? key}) : super(key: key);


  @override
  State<ChoosePage> createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {

var name;
var access;

getName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    name = pref.getString('name');
  });
}

getAccess() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  setState(() {
    access = pref.getString('access_by');
  });
}

@override
  void initState() {
    getName();
    getAccess();
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
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100000),
                    child: CachedNetworkImage(
                      imageUrl: "http://via.placeholder.com/350x150",
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                )
              ),
              const SizedBox(height: 20,),
              Column(
                children: [
                  Center(
                    child: Text('Hi... ${name}', style: whiteTextStyle.copyWith(
                      fontSize: 16
                    ),),
                  ),
                  Center(
                    child: Text('Akses dari ${access}', style: whiteTextStyle.copyWith(
                      fontSize: 16
                    ),),
                  ),
                ],
              ),
              Center(
                child: Container(
                  width: 350,
                  height: 270,
                  margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Center(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('Apa aktivitas anda hari ini?', style: blackTextStyle.copyWith(
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
                           Navigator.pushNamed(context, '/check-loc');
                         },
                         child: Text('Masuk Kerja', style: whiteTextStyle.copyWith(
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
                             builder: (context) => NotWorkPage()));
                         },
                         child: Text('Tidak Masuk Kerja', style: whiteTextStyle.copyWith(
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
                             builder: (context) => CheckLocPage()));
                         },
                         child: Text('Status', style: whiteTextStyle.copyWith(
                           fontSize: 18
                         ),),
                       ),
                       const SizedBox(height: 15,),
                       
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}