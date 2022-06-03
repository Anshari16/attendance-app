import 'dart:io';

import 'package:absen/models/absen_model.dart';
import 'package:absen/pages/work.dart';
import 'package:absen/services/absen_controller.dart';
import 'package:absen/services/absen_repository.dart';
import 'package:absen/services/absen_service.dart';
import 'package:absen/theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EarlyGo extends StatefulWidget {
  const EarlyGo({Key? key}) : super(key: key);

  @override
  State<EarlyGo> createState() => _EarlyGoState();
}

class _EarlyGoState extends State<EarlyGo> {
  // ignore: prefer_typing_uninitialized_variables
  var name;
  var absenController = AbsenController(AbsenRepository());
  TextEditingController txtDesc = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
    });
  }

  Future setAbsenPulang(String id) async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    String stringURL = 'http://192.168.99.6:8000/api/update-absen/$id';
    var url = Uri.parse(stringURL);
    var response = await http.put(url,
    headers: 
    {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: image != null ? {
      'image': image,
      'end_work_info': txtDesc.text
    } :
    {
      'end_work_info': txtDesc.text
    });
    
    if (response.statusCode == 200) {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.success,
       title: 'Absen Pulang',
       text: 'Berhasil...!',
       onConfirmBtnTap: (){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder: (context) => const WorkPage()), (route) => false);
      },
       backgroundColor: Colors.white
      );
    } else {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.info,
       title: 'Absen Pulang',
       text: 'Anda Sudah Absen',
       backgroundColor: Colors.white);
    }
  }

  Future getCamera() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      Navigator.pop(context);
    }
  }

  Future _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Pilih', style: blackTextStyle.copyWith(
          fontSize: 18
        ),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              const Divider(height: 1, color: Colors.black,),
              ListTile(
                onTap: (){
                  getImage();
                },
                title: const Text('Gallery'),
                leading: const Icon(Icons.account_box),
              ),
              const Divider(height: 1, color: Colors.black,),
              ListTile(
                onTap: (){
                  getCamera();
                },
                title: const Text('Kamera'),
                leading: const Icon(Icons.camera),
              ),
            ],
          ),
        ),
      );
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

          return ListView.separated(
            itemBuilder: (context, index){
              var absen = snapshot.data?[index];
              DateTime? sw = absen!.start_work;
              DateTime? ew = absen.end_work;
              DateTime? dt = absen.date;
              DateTime? edc = absen.user!.end_work_user;
              String startWork = sw != null ? DateFormat.Hms().format(sw) : '--:--:--';
              String endWork = ew != null ? DateFormat.Hms().format(ew) : '--:--:--';
              String date = DateFormat.yMMMMd('en_US').format(dt!);

              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50, left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (){
              
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
                            child: Text('Input Bukti', style: whiteTextStyle.copyWith(
                              fontSize: 18
                            ),),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('$date', style: whiteTextStyle.copyWith(
                                fontSize: 18
                              ),),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: 360,
                          height: 560,
                          margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 15),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text('Mohon Upload Bukti Keterangan', style: blackTextStyle.copyWith(
                                    fontSize: 18
                                  ),)
                                  ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5) ,
                                    child: IconButton(
                                      icon: const Icon(Icons.camera_alt_outlined),
                                      color: Colors.blueGrey,
                                      iconSize: 80, 
                                      onPressed: () {  
                                        _showChoiceDialog(context);
                                      },
                                      ),
                                  ),
                                  Text('Tap here to upload', style: greyTextStyle.copyWith(
                                    fontSize: 13
                                   ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    height: 250,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: const Color(0xffC4C4C4)
                                    ),
                                    child: _imageFile != null ? Image.file(
                                      _imageFile!,
                                      fit: BoxFit.cover,
                                    ) : const Center(
                                      child: const Icon(Icons.image_sharp),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: 300,
                                    child:  TextFormField(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: txtDesc,
                                      decoration: InputDecoration(
                                        hintText: 'Masukan Keterangan',
                                        contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32)
                                        )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: SizedBox(
                                      width: 300,
                                      height: 50,
                                      child: ElevatedButton.icon(
                                        onPressed: (){
                                          setAbsenPulang(absen.id.toString());
                                        }, 
                                        icon: const Icon(Icons.send), 
                                        label: Text('Submit', style: whiteTextStyle.copyWith(
                                          fontSize: 16
                                        ),),

                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15)
                                            )
                                          ),
                                          backgroundColor: MaterialStateProperty.all(Colors.red)
                                        ),
                                      
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50,)
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
