import 'package:absen/models/absen_model.dart';
import 'package:absen/pages/login.dart';
import 'package:absen/services/absen_controller.dart';
import 'package:absen/services/absen_repository.dart';
import 'package:absen/services/absen_service.dart';
import 'package:absen/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/standalone.dart' as tz;

class StatusPage extends StatefulWidget {
  const StatusPage({ Key? key }) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  var absenController = AbsenController(AbsenRepository());
  final myLoc = tz.getLocation('Asia/Singapore');
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
      body: FutureBuilder<List<Absen>>(
        future: absenController.fetchAbsenList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('error')
            );
          }
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Anda Belum Melakukan Absensi'),
            );
          }
          return ListView.separated(
            itemBuilder: (context, index){
              var absen = snapshot.data?[index];
              DateTime? sw = absen!.start_work;
              DateTime? ew = absen.end_work;
              DateTime? dt = absen.date;
              DateTime? edc = absen.user!.end_work_user;
              String? dc = absen.desc;
              DateTime now = tz.TZDateTime.now(myLoc);
              DateTime nowC = tz.TZDateTime.from(edc!, myLoc);
              DateTime nowD = now.subtract(const Duration(days: 1));
              String startWork = sw != null ? DateFormat.Hms().format(sw) : '--:--:--';
              String endWork = ew != null ? DateFormat.Hms().format(ew) : '--:--:--';
              String desc = dc ?? '';
              String date = DateFormat.yMMMMd('en_US').format(dt!);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (){
                              logout().then((value) => {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>const LoginPage()), (route) => false)
                              });
                            },
                            icon: const Icon(Icons.logout), 
                            label: Text('${absen.user!.name}', style: whiteTextStyle.copyWith(
                              fontSize: 16
                            ),),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xffD00000)
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            margin: const EdgeInsets.only(right: 25),
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('assets/logo.png'),
                                fit: BoxFit.fitHeight
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                            )
                          )
                        ],
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Dashoard', style: whiteTextStyle.copyWith(
                              fontSize: 18
                            ),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(date, style: whiteTextStyle.copyWith(
                                fontSize: 18
                              ),),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 360,
                          height: 160,
                          margin: const EdgeInsets.only(top: 20,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white
                          ),
                        ),
                        Container(
                          width: 320,
                          height: 120,
                          margin: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red[300],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(0, 3)
                              )
                            ]
                          ),
                          child: ListView(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Text('Absen Datang', style: whiteTextStyle.copyWith(
                                        fontSize: 18
                                      ),),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Text(startWork, style: whiteTextStyle.copyWith(
                                        fontSize: 18
                                      ),),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                margin: const EdgeInsets.only(right: 20, left: 20), 
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 15),
                                      child: Text('Absen Pulang', style: whiteTextStyle.copyWith(
                                        fontSize: 18
                                      ),),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Text(endWork, style: whiteTextStyle.copyWith(
                                        fontSize: 18
                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 30),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(desc, style: whiteTextStyle.copyWith(
                                    fontSize: 18
                                  ),),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.only(left: 25, top: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Menu Aksi', style: whiteTextStyle.copyWith(
                          fontSize: 18
                        ),),
                      ),
                    ),

                    Container(
                      width: 360,
                      height: 220,
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white
                      ),
                      child: ListView(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 20 ,left: 25, right: 25),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: (){
                                  
                                }, 
                                icon: const Icon(Icons.business_center_outlined), 
                                label: Text(absen.start_work != null ? 'Absen Datang Selesai' : 'Absen Datang', style: whiteTextStyle.copyWith(
                                  fontSize: 16
                                ),),

                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)
                                    )
                                  ),
                                  backgroundColor: absen.start_work != null ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.red)
                                ),
                                
                                ),
                            ),
                            
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 13 ,left: 25, right: 25),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: (){
                                  
                                  
                                }, 
                                icon: const Icon(Icons.business_center_outlined), 
                                label: Text(absen.end_work != null ? 'Absen Pulang Selesai' : 'Absen Pulang', style: whiteTextStyle.copyWith(
                                  fontSize: 16
                                ),),

                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)
                                    )
                                  ),
                                  backgroundColor: absen.end_work != null ? MaterialStateProperty.all(Colors.blue) : MaterialStateProperty.all(Colors.red)
                                ),
                                
                                ),
                            ),
                            
                          ),

                          Container(
                            margin: const EdgeInsets.only(top: 13 ,left: 25, right: 25),
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: (){

                                }, 
                                icon: const Icon(Icons.business_center_outlined), 
                                label: Text('Lainnya', style: whiteTextStyle.copyWith(
                                  fontSize: 16
                                ),),

                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18)
                                    )
                                  ),
                                  backgroundColor: MaterialStateProperty.all(Colors.red)
                                ),
                                
                                ),
                            ),
                            
                          )
                        ],
                      ),
                    )
                  ],
                ),

              );
            },
             separatorBuilder: (context, index){
              return const Divider(thickness: 0.5, height: 0.5,);
            }, 
            itemCount: snapshot.data?.length ?? 0
          );
        },
      )
    );
  }
}