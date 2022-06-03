
import 'package:absen/models/absen_model.dart';
import 'package:absen/pages/choose.dart';
import 'package:absen/services/absen_controller.dart';
import 'package:absen/services/absen_repository.dart';
import 'package:absen/theme.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AjukanCutiPage extends StatefulWidget {
  const AjukanCutiPage({ Key? key }) : super(key: key);

  @override
  State<AjukanCutiPage> createState() => _AjukanCutiPageState();
}

class _AjukanCutiPageState extends State<AjukanCutiPage> {
   // ignore: prefer_typing_uninitialized_variables
  var name;
  var absenController = AbsenController(AbsenRepository());
  TextEditingController txtDesc = TextEditingController();
  TextEditingController txtSub = TextEditingController();
  TextEditingController txtKep = TextEditingController();
  final _picker = ImagePicker();
  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(2022, 11, 5),
    end: DateTime(2022, 11, 15)
  );

  void setAbsenDatang() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var id = pref.getInt('id').toString();
    String stringURL = 'http://10.0.2.2:8000/api/store';
    var url = Uri.parse(stringURL);
    var response = await http.post(url,
    body:
    {
      'user_id': id
    },
    headers: 
    {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.success,
       title: 'Absen Masuk',
       text: 'Berhasil...!',
       backgroundColor: Colors.white
      );
    } else {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.info,
       title: 'Absen Masuk',
       text: 'Anda Sudah Absen',
       backgroundColor: Colors.white);
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
      });

      Navigator.pop(context);
    }
  }

  Future getCamera() async {
    // ignore: deprecated_member_use
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
      });

      Navigator.pop(context);
    }
  }

  getName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
    });
  }

  void store() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = pref.getString('token');
    var id = pref.getInt('id').toString();
    String stringURL = 'http://10.0.2.2:8000/api/store-leave';
    var url = Uri.parse(stringURL);
    var response = await http.post(url,
    headers: 
    {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body:{
      'user_id': id,
      'user_sub': txtSub.text,
      'start_date': dateRange.start.toString(),
      'end_date': dateRange.end.toString(),
      'purpose': txtKep.text
    });
    
    if (response.statusCode == 200) {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.success,
       title: 'Pangajuan Cuti',
       text: 'Berhasil...!',
       onConfirmBtnTap: (){
        Navigator.push(context, MaterialPageRoute(
        builder: (context) => const ChoosePage()));
      },
       backgroundColor: Colors.white
      );
    } else {
      CoolAlert.show(
       context: context, 
       type: CoolAlertType.info,
       title: 'Pengajuan Cuti',
       text: 'Anda Sudah Melakukan Pengajuan',
       backgroundColor: Colors.white);
    }
  }


  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange, 
      firstDate: DateTime(1900), 
      lastDate: DateTime(2100)
    );
    if(newDateRange == null) return;

    setState(() {
      dateRange = newDateRange;
    });
  }

  @override
  void initState() {
    getName();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;

    return Scaffold(
      backgroundColor: const Color(0xffD00000),
      body: FutureBuilder<List<Absen>>(
        future: absenController.fetchAbsenList(),
         builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('error')
            );
          }
          
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
                          label: Text('$name', style: whiteTextStyle.copyWith(
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
                          child: Text('Pengajuan Cuti', style: whiteTextStyle.copyWith(
                            fontSize: 18
                          ),),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 25),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text('', style: whiteTextStyle.copyWith(
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
                        height: 370,
                        margin: const EdgeInsets.only(top: 20, right: 15, left: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10,),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text('Silahkan input tanggal cuti anda', style: blackTextStyle.copyWith(
                                  fontSize: 18
                                ),)
                                ),
                            ),
                            const SizedBox(height: 14,),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 30),
                                    Expanded(
                                      child: ElevatedButton(
                                        child: Text('${start.year}/${start.month}/${start.day}'),
                                        onPressed: (){
                                          pickDateRange();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12,),
                                    Expanded(
                                      child: ElevatedButton(
                                        child: Text('${end.year}/${end.month}/${end.day}'),
                                        onPressed: (){
                                          pickDateRange();
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Text(
                                  'Total: ${difference.inDays} hari', style: greyTextStyle.copyWith(
                                    fontSize: 24
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  margin: const EdgeInsets.only(left: 30, right: 30),
                                  child: TextFormField(
                                    controller: txtSub,
                                    decoration: InputDecoration(
                                      hintText: 'Masukan Pengganti',
                                      contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(32)
                                      )
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                Container(
                                  margin: const EdgeInsets.only(left: 30, right: 30),
                                  child: TextFormField(
                                    controller: txtKep,
                                    decoration: InputDecoration(
                                      hintText: 'Masukan Keperluan',
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
                                        store();
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
                  const SizedBox(height: 50,)
                ],
              ),

            );
          
         }
        )
      );
    }
  }