import 'package:absen/theme.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckLocPage extends StatefulWidget {
  const CheckLocPage({ Key? key }) : super(key: key);

  @override
  State<CheckLocPage> createState() => _CheckLocPageState();
}

class _CheckLocPageState extends State<CheckLocPage> {
  var locationMessage = '';
  var distance = '';
  var statusZona = '';
  late String latitude;
  late String longitude;
  late String dis;

  void getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    SharedPreferences pref = await SharedPreferences.getInstance();
    var latOffices = pref.getString('latitudes');
    var longOffices = pref.getString('longitudes');
    var latOffice = double.parse(latOffices!);
    var longOffice = double.parse(longOffices!);

    var lat = position.latitude;
    var long = position.longitude;

    latitude = '$lat';
    longitude = '$long';

    double distanceInMeters = Geolocator.distanceBetween(lat, long, latOffice, longOffice);
    var f = NumberFormat("###.0#", "en_US");
    var distances = f.format(distanceInMeters);

    setState(() {
      distance = 'Radius: $distances meter';
    });
    
    if (distanceInMeters <= 500) {
      setState(() {
        statusZona = 'Anda Berada dalam jangkauan absensi';
      });
    } else {
      setState(() {
        statusZona = 'Anda Berada diluar jangkauan absensi';
      });
    } 
    
  }

  _getAddressFromLatLng() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var latOffice = pref.getDouble('latitude');
    var longOffice = pref.getDouble('longitude');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latOffice!,
        longOffice!
      );

      Placemark place = placemarks[0];

      setState(() {
        locationMessage = "${place.subLocality}, ${place.subAdministrativeArea}, ${place.administrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffD00000),
      body: Center(
        child: Container(
          width: 350,
          height: 350,
          margin: const EdgeInsets.only(top: 20, right: 20 ,left: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(statusZona, style: blackTextStyle.copyWith(
                  fontSize: 15
                ),),
                const SizedBox(height: 10,),
                const Icon(Icons.location_pin),
                const SizedBox(height: 10,),
                Text(locationMessage, style: greyTextStyle.copyWith(
                  fontSize: 14
                ),),
                const SizedBox(height: 10,),
                Text(distance, style: greyTextStyle.copyWith(
                  fontSize: 15
                ),),
                const SizedBox(height: 50,),
                statusZona == 'Anda Berada dalam jangkauan absensi' ?
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(280, 40),
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    onPressed: (){
                      Navigator.popAndPushNamed(context, '/work');
                    },
                    child: Text('Absen', style: whiteTextStyle.copyWith(
                      fontSize: 18
                    ),),
                  ),
                )
                :
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(280, 40),
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                    onPressed: (){
                      getCurrentLocation();
                      _getAddressFromLatLng();
                    },
                    child: Text('Cek Lokasi', style: whiteTextStyle.copyWith(
                      fontSize: 18
                    ),),
                  ),
                ),
              ],
            ),
          )
      ),
    )
  );
  }
}